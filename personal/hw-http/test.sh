#!/usr/bin/env bash
#
# test_httpserver.sh — Comprehensive test suite for the CS 162 HTTP server
# ============================================================================
#
# Usage:
#   ./test_httpserver.sh                    # Run all tests on all compiled servers
#   ./test_httpserver.sh httpserver         # Test only the basic single-threaded server
#   ./test_httpserver.sh --verbose          # Show full curl output for failures
#   ./test_httpserver.sh --port 9000        # Use a custom port
#
# Requires: curl, bash 4+, and compiled server binaries in the same directory.
#
# Tests cover:
#   - Basic GET (200 OK, Content-Type, Content-Length)
#   - Missing files (404 Not Found)
#   - Directory listing (no index.html present)
#   - Root path serving index.html
#   - Content-Length accuracy vs. actual file size
#   - MIME type detection (.html, .png, .jpg, .txt)
#   - Path traversal protection (403 Forbidden)
#   - Concurrent request handling (smoke test)

(make clean && make) >> /dev/null

pkill -9 httpserver; pkill -9 forkserver; pkill -9 threadserver

set -o pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────────────────────
PORT="${PORT:-8765}"
HOST="127.0.0.1"
BASE_URL="http://${HOST}:${PORT}"
SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
WWW_DIR="${SERVER_DIR}/www"
VERBOSE=false
TIMEOUT=5           # max seconds to wait for server startup

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Global counters
TOTAL=0
PASSED=0
FAILED=0

# Server PID for cleanup
SERVER_PID=""

# ──────────────────────────────────────────────────────────────────────────────
# Cleanup — kill the running server and free the port
# ──────────────────────────────────────────────────────────────────────────────

# kill_port_process <port> — find and kill whatever is holding <port>.
# No-op if the port is already free.
kill_port_process() {
    local port="$1"
    local pid=""

    pid=$(lsof -ti "TCP:${port}" 2>/dev/null || true)
    if [[ -z "$pid" ]] && command -v fuser &>/dev/null; then
        pid=$(fuser "${port}/tcp" 2>/dev/null || true)
    fi
    if [[ -n "$pid" ]]; then
        kill -9 $pid 2>/dev/null || true
        sleep 0.3
    fi
}

cleanup() {
    if [[ -n "$SERVER_PID" ]] && kill -0 "$SERVER_PID" 2>/dev/null; then
        kill "$SERVER_PID" 2>/dev/null
        wait "$SERVER_PID" 2>/dev/null
    fi
    kill_port_process "$PORT"
}
trap cleanup EXIT INT TERM

# ──────────────────────────────────────────────────────────────────────────────
# Server lifecycle helpers
# ──────────────────────────────────────────────────────────────────────────────

# start_server <binary> <mode> <mode_arg>
#   binary    — e.g. "httpserver", "forkserver", "threadserver"
#   mode      — "--files" or "--proxy"
#   mode_arg  — directory path or proxy hostname:port
start_server() {
    local server_bin="$1"
    local mode="$2"
    local mode_arg="$3"

    cleanup  # ensure nothing is already on the port

    echo -e "${CYAN}Starting ${BOLD}${server_bin}${NC}${CYAN}...${NC}"

    if [[ "$server_bin" == "poolserver" ]]; then
        "${SERVER_DIR}/${server_bin}" "$mode" "$mode_arg" \
            --port "$PORT" --num-threads 4 &
    else
        "${SERVER_DIR}/${server_bin}" "$mode" "$mode_arg" \
            --port "$PORT" &
    fi
    SERVER_PID=$!

    # Poll until the server is accepting connections.
    # File mode: a 1s-per-attempt timeout is plenty. Proxy mode: the poll
    # itself triggers a full proxied request, and a proxy that doesn't close
    # the client connection will hold curl until its timeout — so we give
    # proxy polls a longer per-attempt timeout to avoid mistaking "slow to
    # finish" for "not started".
    local poll_timeout=1
    [[ "$mode" == "--proxy" ]] && poll_timeout=3
    local waited=0
    while ! curl -s --max-time "$poll_timeout" "${BASE_URL}/" > /dev/null 2>&1; do
        sleep 0.2
        waited=$((waited + 1))
        if [[ $waited -gt $((TIMEOUT * 5)) ]]; then
            echo -e "${RED}ERROR: Server failed to start within ${TIMEOUT}s${NC}"
            return 1
        fi
    done
    echo -e "  ${GREEN}Server PID ${SERVER_PID} is ready.${NC}"
    return 0
}

# stop_server — kill the current server and wait for the port to be released
stop_server() {
    if [[ -n "$SERVER_PID" ]] && kill -0 "$SERVER_PID" 2>/dev/null; then
        kill "$SERVER_PID" 2>/dev/null
        wait "$SERVER_PID" 2>/dev/null
        echo -e "  ${YELLOW}Server ${SERVER_PID} stopped.${NC}"
    fi
    SERVER_PID=""
    # Aggressively free the port so the next server can start
    kill_port_process "$PORT"
    sleep 0.3
}

stop_upstream() {
    if [[ -n "$UPSTREAM_PID" ]] && kill -0 "$UPSTREAM_PID" 2>/dev/null; then
        kill "$UPSTREAM_PID" 2>/dev/null
        wait "$UPSTREAM_PID" 2>/dev/null
        echo -e "  ${YELLOW}Upstream ${UPSTREAM_PID} stopped.${NC}"
    fi
    UPSTREAM_PID=""
    kill_port_process "$UPSTREAM_PORT"
    sleep 0.3
}

# ──────────────────────────────────────────────────────────────────────────────
# Test runner — the core of the test framework
# ──────────────────────────────────────────────────────────────────────────────
#
# Usage: run_test "description" <expected_http_code> <path> [options]
#
# Options (all optional, order after <path> doesn't matter):
#   --expect-content-type <mime>       Verify the Content-Type response header
#   --expect-body-contains <string>    Verify the response body contains <string>
#   --expect-header-contains <string>  Verify response headers contain <string>
#   --not-body-contains <string>       Verify the response body does NOT contain
#   --expect-status-line <string>      Verify the raw status line (e.g. "HTTP/1.0 200")
#   --method <HTTP method>             Use a non-GET method (default: GET)
#   --custom-raw <request text>        Send a raw HTTP request via nc; bypasses
#                                      curl (use to trigger malformed-request
#                                      paths curl would never produce). <path>
#                                      is ignored for matching but still used
#                                      in the description.
#   --no-body-check                    Skip all body-content checks
#
# How it works:
#   1. Issues `curl -v -s -i <url>` (or `nc` for --custom-raw) to capture the
#      status line + headers + body
#   2. Extracts the HTTP status code from the first line
#   3. Runs each requested check and accumulates failure messages
#   4. Prints a PASS or FAIL line with optional verbose dump
run_test() {
    local desc="$1"
    local expected_code="$2"
    local path="$3"
    shift 3

    local want_content_type=""
    local want_body=""
    local not_body=""
    local want_header=""
    local want_status_line=""
    local method="GET"
    local custom_raw=""
    local path_as_is=false
    local check_body=true

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --expect-content-type)      want_content_type="$2"; shift 2 ;;
            --expect-body-contains)     want_body="$2";         shift 2 ;;
            --not-body-contains)        not_body="$2";          shift 2 ;;
            --expect-header-contains)   want_header="$2";       shift 2 ;;
            --expect-status-line)       want_status_line="$2";  shift 2 ;;
            --method)                   method="$2";            shift 2 ;;
            --custom-raw)               custom_raw="$2";        shift 2 ;;
            --path-as-is)               path_as_is=true;        shift   ;;
            --no-body-check)            check_body=false;       shift   ;;
            *)  shift ;;   # ignore unknown flags silently
        esac
    done

    TOTAL=$((TOTAL + 1))
    local url="${BASE_URL}${path}"

    # ── Issue the HTTP request ────────────────────────────────────────────
    # curl path: -s silent, -i includes response headers in stdout.
    # NOTE: do NOT use -v here — -v sends connection diagnostics to stderr
    # and `2>&1` would interleave them before the HTTP status line, breaking
    # the `head -1` parsing. For verbose debugging we dump $curl_out on
    # failure (see --verbose flag).
    # --path-as-is: stop curl from normalising "/../" → "/" client-side, so
    # the literal ".." reaches the server and actually exercises its 403
    # traversal-check branch.
    # custom-raw path: for requests curl structurally cannot produce (e.g. a
    # request-target with no leading slash). Implemented with bash /dev/tcp
    # in a SUBSHELL so fd redirections never leak into the test runner itself.
    # The caller MUST use bash $'...' ANSI-C quoting so the string already
    # contains real CR LF bytes.
    local curl_out http_code
    if [[ -n "$custom_raw" ]]; then
        # Run in a subshell: any exec/fd changes die with the subshell, so
        # the parent's stdout/stderr stay intact. We write the raw request to
        # the socket, then read the response with a 3s per-line timeout so a
        # hung server can't block the suite forever. The subshell's captured
        # stdout becomes $curl_out.
        curl_out="$(
            exec 3<>"/dev/tcp/${HOST}/${PORT}" 2>/dev/null || exit 0
            printf '%s' "$custom_raw" >&3
            # read -t 3: 3s timeout; -u 3: read from the socket fd.
            while IFS= read -t 3 -r -u 3 line; do
                printf '%s\n' "$line"
            done 2>/dev/null
            exec 3<&- 3>&- 2>/dev/null
        )"
    else
        local curl_args=(-s -i --max-time 5 -X "$method")
        $path_as_is && curl_args+=(--path-as-is)
        curl_out="$(curl "${curl_args[@]}" "$url")"
    fi
    http_code="$(echo "$curl_out" | head -1 | grep -oP 'HTTP/1\.[01] \K\d{3}')"

    local failures=""

    # ── 1. Check HTTP status code ─────────────────────────────────────────
    if [[ "$http_code" != "$expected_code" ]]; then
        if [[ -z "$http_code" ]]; then
            failures+="  [status] No HTTP response (connection failed or empty reply)\n"
        else
            failures+="  [status] Expected ${expected_code}, got ${http_code}\n"
        fi
    fi

    # ── 2. Check the raw status line (e.g. "HTTP/1.0 200") ───────────────
    if [[ -n "$want_status_line" ]]; then
        local first_line
        first_line="$(echo "$curl_out" | head -1 | tr -d '\r')"
        if [[ "$first_line" != *"$want_status_line"* ]]; then
            failures+="  [status-line] Expected '${want_status_line}', got '${first_line}'\n"
        fi
    fi

    # ── 2. Check Content-Type header ──────────────────────────────────────
    if [[ -n "$want_content_type" ]]; then
        local got_ct
        got_ct="$(echo "$curl_out" | grep -i '^Content-Type:' \
            | head -1 | tr -d '\r' | sed 's/.*:[[:space:]]*//')"
        if [[ "$got_ct" != *"$want_content_type"* ]]; then
            failures+="  [content-type] Expected '${want_content_type}', got '${got_ct}'\n"
        fi
    fi

    # ── 3. Check header contains a string ─────────────────────────────────
    if [[ -n "$want_header" ]]; then
        if ! echo "$curl_out" | grep -qiF "$want_header"; then
            failures+="  [header] Expected header matching: '${want_header}'\n"
        fi
    fi

    # ── 4. Check body contains a string ───────────────────────────────────
    if $check_body && [[ -n "$want_body" ]]; then
        if ! echo "$curl_out" | grep -qF "$want_body"; then
            failures+="  [body] Expected to contain: '${want_body}'\n"
        fi
    fi

    # ── 5. Check body does NOT contain a string ───────────────────────────
    if $check_body && [[ -n "$not_body" ]]; then
        if echo "$curl_out" | grep -qF "$not_body"; then
            failures+="  [body] Should NOT contain: '${not_body}'\n"
        fi
    fi

    # ── Report ────────────────────────────────────────────────────────────
    if [[ -z "$failures" ]]; then
        echo -e "  ${GREEN}PASS${NC} — ${desc} (HTTP ${http_code})"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} — ${desc}"
        echo -ne "$failures"
        FAILED=$((FAILED + 1))
        if $VERBOSE; then
            echo -e "  ${YELLOW}── curl output ──────────────────────────────${NC}"
            echo "$curl_out" | head -50 | sed 's/^/    /'
            echo -e "  ${YELLOW}──────────────────────────────────────────────${NC}"
        fi
    fi
}

# ──────────────────────────────────────────────────────────────────────────────
# Test suite functions — each runs a group of related tests
# ──────────────────────────────────────────────────────────────────────────────

test_basic_get() {
    echo -e "\n${CYAN}═══ Basic GET Requests ═══${NC}"

    # Existing file at root → 200 with correct Content-Type
    run_test "GET /index.html" 200 "/index.html" \
        --expect-status-line "HTTP/1.0 200" \
        --expect-content-type "text/html" \
        --expect-body-contains "CS 162 IS THE BEST" \
        --expect-header-contains "Content-Length:"

    # Existing file in a subdirectory
    run_test "GET /my_documents/contributors.txt" 200 "/my_documents/contributors.txt" \
        --expect-content-type "text/plain" \
        --expect-header-contains "Content-Length:"

    # Root path should serve index.html (it exists in www/)
    run_test "GET / (root serves index.html)" 200 "/" \
        --expect-content-type "text/html" \
        --expect-body-contains "WELCOME TO MY WEBSITE"
}

test_404_not_found() {
    echo -e "\n${CYAN}═══ 404 Not Found ═══${NC}"

    run_test "GET /nonexistent.html" 404 "/nonexistent.html"

    run_test "GET /nope/deep/file.txt" 404 "/nope/deep/file.txt"

    run_test "GET /my_documents/ghost.txt" 404 "/my_documents/ghost.txt"

    # A directory that does not exist should also 404 (stat fails → same branch)
    run_test "GET /no_such_dir/ (missing directory)" 404 "/no_such_dir/"
}

test_directory_listing() {
    echo -e "\n${CYAN}═══ Directory Listing ═══${NC}"

    # /my_documents/ has no index.html → should list directory contents
    run_test "GET /my_documents/ lists files" 200 "/my_documents/" \
        --expect-content-type "text/html" \
        --expect-body-contains "contributors.txt" \
        --expect-body-contains "credit.txt" \
        --expect-body-contains "WEB_SCALE.jpg" \
        --expect-body-contains "wholesome_facts.txt"

    # Directory listing must contain clickable links (<a href>)
    run_test "GET /my_documents/ has links" 200 "/my_documents/" \
        --expect-body-contains "a href"

    # Per the spec: "You may not assume that directory requests will have a
    # trailing slash." A request without the trailing slash must still work.
    run_test "GET /my_documents (no trailing slash)" 200 "/my_documents" \
        --expect-content-type "text/html" \
        --expect-body-contains "contributors.txt"

    # The spec requires a link to the parent directory in listings.
    run_test "GET /my_documents/ has parent link" 200 "/my_documents/" \
        --expect-body-contains ".."
}

test_content_length() {
    echo -e "\n${CYAN}═══ Content-Length Accuracy ═══${NC}"

    # contributors.txt is exactly 166 bytes
    run_test "Content-Length: 166 for contributors.txt" 200 "/my_documents/contributors.txt" \
        --expect-header-contains "Content-Length: 166"

    # credit.txt is exactly 425 bytes
    run_test "Content-Length: 425 for credit.txt" 200 "/my_documents/credit.txt" \
        --expect-header-contains "Content-Length: 425"
}

# Large-file integrity: download the 70850-byte JPEG to disk and verify the
# actual received byte count matches. This catches a server that streams only
# part of a large file (e.g. a write() that returns early) even if the
# Content-Length header happens to be correct.
test_large_file_integrity() {
    echo -e "\n${CYAN}═══ Large File Integrity ═══${NC}"

    TOTAL=$((TOTAL + 1))
    local tmpfile
    tmpfile="$(mktemp)"
    local expected=70850

    # -s silent, --max-time guards against a hung connection
    curl -s --max-time 10 -o "$tmpfile" "${BASE_URL}/my_documents/WEB_SCALE.jpg" 2>/dev/null
    local got
    got="$(wc -c < "$tmpfile" | tr -d ' ')"
    rm -f "$tmpfile"

    if [[ "$got" == "$expected" ]]; then
        echo -e "  ${GREEN}PASS${NC} — WEB_SCALE.jpg downloaded intact (${got} bytes)"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} — WEB_SCALE.jpg: expected ${expected} bytes, got '${got}'"
        FAILED=$((FAILED + 1))
    fi
}

# Malformed requests: paths that do NOT start with '/' must yield 400.
# curl always normalizes the path to start with '/', so we send a raw request
# via bash /dev/tcp (no external nc needed) to actually exercise the
# `path[0] != '/'` branch in handle_files_request.
test_bad_requests() {
    echo -e "\n${CYAN}═══ Malformed Requests (400) ═══${NC}"

    # Path with no leading slash → the server should return 400.
    run_test "Raw GET with no leading slash → 400" 400 "/" \
        --custom-raw $'GET no-slash HTTP/1.0\r\n\r\n' \
        --no-body-check

    # Bare CR LF with no request line at all → http_request_parse returns
    # NULL → handle_files_request sends 400.
    run_test "Bare CRLF → 400" 400 "/" \
        --custom-raw $'\r\n' \
        --no-body-check
}

test_mime_types() {
    echo -e "\n${CYAN}═══ Content-Type (MIME) Headers ═══${NC}"

    run_test ".html → text/html"       200 "/index.html" \
        --expect-content-type "text/html"

    run_test ".png  → image/png"       200 "/my_documents/http-meme.png" \
        --expect-content-type "image/png"

    run_test ".jpg  → image/jpeg"      200 "/my_documents/WEB_SCALE.jpg" \
        --expect-content-type "image/jpeg"

    run_test ".txt  → text/plain"      200 "/my_documents/contributors.txt" \
        --expect-content-type "text/plain"
}

test_security() {
    echo -e "\n${CYAN}═══ Path Traversal Protection ═══${NC}"

    # --path-as-is stops curl from normalising "/../" → "/" on the client
    # side, so the literal ".." reaches the server and actually exercises
    # its 403 traversal-check branch. (Without it curl would send "/etc/passwd"
    # and we'd hit 404, falsely "passing" nothing.)
    run_test "GET /../etc/passwd" 403 "/../etc/passwd" \
        --path-as-is \
        --no-body-check

    run_test "GET /my_documents/../../../etc/hosts" 403 "/my_documents/../../../etc/hosts" \
        --path-as-is \
        --no-body-check

    run_test "GET /.." 403 "/.." \
        --path-as-is \
        --no-body-check
}

test_concurrent_smoke() {
    echo -e "\n${CYAN}═══ Concurrency Smoke Test ═══${NC}"

    TOTAL=$((TOTAL + 1))

    # Fire 20 parallel requests; all must return 200
    local pids=()
    local tmpdir
    tmpdir="$(mktemp -d)"
    for i in $(seq 1 20); do
        (
            curl -s -o /dev/null -w "%{http_code}" \
                --max-time 5 "${BASE_URL}/index.html" > "${tmpdir}/r${i}"
        ) &
        pids+=($!)
    done
    for pid in "${pids[@]}"; do
        wait "$pid" 2>/dev/null || true
    done

    local bad=0
    for f in "${tmpdir}"/*; do
        local code
        code="$(cat "$f")"
        if [[ "$code" != "200" ]]; then
            bad=$((bad + 1))
        fi
    done
    rm -rf "$tmpdir"

    if [[ "$bad" -eq 0 ]]; then
        echo -e "  ${GREEN}PASS${NC} — 20 concurrent requests all returned 200"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} — ${bad}/20 concurrent requests failed"
        FAILED=$((FAILED + 1))
    fi
}

# ──────────────────────────────────────────────────────────────────────────────
# Run the full file-mode suite against one server binary
# ──────────────────────────────────────────────────────────────────────────────
run_file_mode_tests() {
    local server_bin="$1"

    echo ""
    echo -e "${YELLOW}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│  Testing: ${BOLD}${server_bin}${NC}${YELLOW} (file mode)${NC}"
    echo -e "${YELLOW}└──────────────────────────────────────────────────────────┘${NC}"

    if ! start_server "$server_bin" "--files" "$WWW_DIR"; then
        echo -e "${RED}  Skipping ${server_bin} — server failed to start${NC}"
        return 1
    fi

    test_basic_get
    test_404_not_found
    test_directory_listing
    test_content_length
    test_large_file_integrity
    test_mime_types
    test_security
    test_bad_requests
    test_concurrent_smoke

    stop_server
}

# ──────────────────────────────────────────────────────────────────────────────
# Proxy mode tests
# ──────────────────────────────────────────────────────────────────────────────
# Layout: we start an *upstream* httpserver serving www/ on PORT+1, then start
# the server-under-test in --proxy mode pointing at 127.0.0.1:PORT+1 on PORT.
# curl hits PORT; the proxy must transparently relay the request to the
# upstream and relay the response back.
#
# NOTE on the current implementation: handle_proxy_request() uses wait() on a
# pthread_t instead of pthread_join(), and proxy_handler() lacks a return. These
# are real bugs. The tests below use short timeouts so a hung proxy surfaces as
# a FAIL rather than blocking the suite — that's the point of testing it.

UPSTREAM_PID=""
UPSTREAM_PORT=""   # set by run_proxy_mode_tests

# start_upstream — launch a basic httpserver on PORT+1 to act as proxy target
start_upstream() {
    stop_upstream   # kill anything already on the upstream port
    UPSTREAM_PORT=$((PORT + 1))
    echo -e "${CYAN}Starting upstream httpserver on port ${UPSTREAM_PORT}...${NC}"
    "${SERVER_DIR}/httpserver" --files "$WWW_DIR" --port "$UPSTREAM_PORT" &
    UPSTREAM_PID=$!
    local waited=0
    while ! curl -s --max-time 1 "http://${HOST}:${UPSTREAM_PORT}/" > /dev/null 2>&1; do
        sleep 0.2
        waited=$((waited + 1))
        if [[ $waited -gt $((TIMEOUT * 5)) ]]; then
            echo -e "${RED}ERROR: Upstream server failed to start${NC}"
            return 1
        fi
    done
    echo -e "  ${GREEN}Upstream PID ${UPSTREAM_PID} ready on ${UPSTREAM_PORT}.${NC}"
    return 0
}

test_proxy_basic() {
    echo -e "\n${CYAN}═══ Proxy: Basic Relay ═══${NC}"

    # A proxied GET for index.html must return the upstream's content.
    run_test "Proxy GET /index.html" 200 "/index.html" \
        --expect-body-contains "CS 162 IS THE BEST"

    run_test "Proxy GET /my_documents/contributors.txt" 200 "/my_documents/contributors.txt" \
        --expect-body-contains "Contributors"
}

test_proxy_404() {
    echo -e "\n${CYAN}═══ Proxy: 404 Relay ═══${NC}"

    # The 404 originates at the upstream; the proxy must relay it unchanged.
    run_test "Proxy GET /nonexistent.html → 404" 404 "/nonexistent.html"
}

# run_proxy_mode_tests <binary>
run_proxy_mode_tests() {
    local server_bin="$1"

    echo ""
    echo -e "${YELLOW}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│  Testing: ${BOLD}${server_bin}${NC}${YELLOW} (proxy mode)${NC}"
    echo -e "${YELLOW}└──────────────────────────────────────────────────────────┘${NC}"

    if ! start_upstream; then
        echo -e "${RED}  Skipping proxy tests — upstream failed to start${NC}"
        return 1
    fi

    # Start the SUT in proxy mode pointing at the upstream.
    if ! start_server "$server_bin" "--proxy" "${HOST}:${UPSTREAM_PORT}"; then
        echo -e "${RED}  Skipping proxy tests — proxy server failed to start${NC}"
        stop_upstream
        return 1
    fi

    test_proxy_basic
    test_proxy_404

    stop_server
    stop_upstream
}

# Both cleanups in the trap so no process is left behind on Ctrl+C or exit.
trap 'cleanup; stop_upstream' EXIT INT TERM

# ──────────────────────────────────────────────────────────────────────────────
# Summary banner
# ──────────────────────────────────────────────────────────────────────────────
print_summary() {
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    if [[ $FAILED -eq 0 ]]; then
        echo -e "${GREEN}  All ${PASSED} tests passed.${NC}"
    else
        echo -e "${RED}  ${FAILED}/${TOTAL} tests FAILED${NC}"
        echo -e "${GREEN}  ${PASSED}/${TOTAL} tests passed${NC}"
    fi
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
}

# ──────────────────────────────────────────────────────────────────────────────
# Usage
# ──────────────────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Usage: $0 [OPTIONS] [SERVER ...]

Options:
  --verbose, -v     Show full curl output for each failed test
  --port PORT       Use a custom port (default: ${PORT})
  --help, -h        Show this help text

Servers (omit to test all compiled binaries):
  httpserver         Basic single-threaded server
  forkserver         Fork-per-request server
  threadserver       Thread-per-request server
  poolserver         Thread-pool server (--num-threads 4)

For each server, both file mode (--files www/) and proxy mode are tested.
In proxy mode, the script starts a second httpserver as the upstream on
PORT+1 and points the server-under-test at it via --proxy.

Examples:
  $0                            Test all compiled servers (file + proxy)
  $0 httpserver                 Test only the basic server
  $0 --verbose forkserver       Test forkserver, show failures in detail
  $0 --port 9000                Use port 9000 (upstream will use 9001)
EOF
}

# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────
main() {
    local servers=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --verbose|-v)   VERBOSE=true; shift ;;
            --port)         PORT="$2"; shift 2 ;;
            --help|-h)      usage; exit 0 ;;
            httpserver|forkserver|threadserver|poolserver)
                servers+=("$1"); shift ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                usage; exit 1 ;;
        esac
    done

    # If no specific server requested, test all available
    if [[ ${#servers[@]} -eq 0 ]]; then
        for bin in httpserver forkserver threadserver poolserver; do
            if [[ -x "${SERVER_DIR}/${bin}" ]]; then
                servers+=("$bin")
            fi
        done
    fi

    if [[ ${#servers[@]} -eq 0 ]]; then
        echo -e "${RED}No server binaries found. Run 'make' first.${NC}"
        exit 1
    fi

    # Title banner
    echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║  CS 162 HTTP Server Test Suite                            ${NC}"
    echo -e "${BOLD}${CYAN}║  Port: ${PORT}                                            ${NC}"
    echo -e "${BOLD}${CYAN}║  Servers: $(printf '%-50s' "${servers[*]}")               ${NC}"
    echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"

    for srv in "${servers[@]}"; do
        run_file_mode_tests "$srv"
        run_proxy_mode_tests "$srv"
    done

    print_summary
    return "$FAILED"
}

main "$@"
