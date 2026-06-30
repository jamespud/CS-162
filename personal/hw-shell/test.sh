#!/bin/bash

(make clean && make) >> /dev/null

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  PASS"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $*"; }

# === 1. Built-in: pwd ==============================================
echo -n "Testing pwd"
SHELL_PWD=$(echo "pwd" | ./shell)
if [ "$SHELL_PWD" = "$PWD" ]; then pass; else fail "expected $PWD, got $SHELL_PWD"; fi

# === 2. Built-in: cd ===============================================
echo -n "Testing cd"
SHELL_CD=$(echo -e "cd /\npwd" | ./shell)
if [ "$SHELL_CD" = "/" ]; then pass; else fail "expected /, got $SHELL_CD"; fi

# === 3. Built-in: help (?) =========================================
echo -n "Testing help"
SHELL_HELP=$(echo "?" | ./shell)
if echo "$SHELL_HELP" | grep -q "show this help menu"; then pass; else fail "help menu not found"; fi

# === 4. Basic program execution (full path) ========================
echo -n "Testing basic command"
SHELL_LS=$(echo "/bin/ls" | ./shell)
REAL_LS=$(ls)
if [ "$SHELL_LS" = "$REAL_LS" ]; then pass; else fail "ls output mismatch"; fi

# === 5. PATH resolution (no full path) =============================
echo -n "Testing PATH resolution"
SHELL_ECHO=$(echo "echo hello" | ./shell)
if [ "$SHELL_ECHO" = "hello" ]; then pass; else fail "expected 'hello', got '$SHELL_ECHO'"; fi

# === 6. Input redirection (<) ======================================
echo -n "Testing input redirection"
echo "i love pintos and cs162" > test_redirection_in
SHELL_WC_IN=$(echo "/usr/bin/wc < test_redirection_in" | ./shell)
# wc output: " 1  5 24" (1 line, 5 words, ~24 chars)
WC_WORDS=$(echo "$SHELL_WC_IN" | awk '{print $2}')
if [ "$WC_WORDS" = "5" ]; then pass; else fail "expected 5 words, got $WC_WORDS"; fi

# === 7. Output redirection (>) =====================================
echo -n "Testing output redirection"
echo "/usr/bin/wc < test_redirection_in > test_redirection_out" | ./shell > /dev/null
if [ -f test_redirection_out ]; then
  WC_OUT=$(cat test_redirection_out | awk '{print $2}')
  if [ "$WC_OUT" = "5" ]; then pass; else fail "expected 5 words in file, got $WC_OUT"; fi
else
  fail "test_redirection_out not created"
fi

# === 8. Pipe (two commands) =========================================
echo -n "Testing pipe (2 commands)"
SHELL_PIPE=$(echo "/bin/echo hello world | /usr/bin/wc -w" | ./shell)
# wc -w output: "2" (possibly with leading spaces)
PIPE_WORDS=$(echo "$SHELL_PIPE" | tr -d ' ')
if [ "$PIPE_WORDS" = "2" ]; then pass; else fail "expected 2, got '$PIPE_WORDS'"; fi

# === 9. Pipe (three commands) ======================================
echo -n "Testing pipe (3 commands)"
SHELL_PIPE3=$(echo "/bin/echo a b c | /usr/bin/wc -w" | ./shell)
PIPE3_WORDS=$(echo "$SHELL_PIPE3" | tr -d ' ')
if [ "$PIPE3_WORDS" = "3" ]; then pass; else fail "expected 3, got '$PIPE3_WORDS'"; fi

# === 10. Pipe + redirection combined ================================
echo -n "Testing pipe with redirection"
echo "/bin/cat < test_redirection_in | /usr/bin/wc -w > test_pipe_redir_out" | ./shell > /dev/null
if [ -f test_pipe_redir_out ]; then
  PR_WORDS=$(cat test_pipe_redir_out | tr -d ' ')
  if [ "$PR_WORDS" = "5" ]; then pass; else fail "expected 5, got $PR_WORDS"; fi
else
  fail "test_pipe_redir_out not created"
fi

# === 11. Background process (&) =====================================
echo -n "Testing background process"
# Run sleep in background, verify shell returns immediately
START=$(date +%s)
echo "/bin/sleep 1 &" | ./shell > /dev/null
END=$(date +%s)
ELAPSED=$((END - START))
if [ "$ELAPSED" -lt 2 ]; then pass; else fail "background took ${ELAPSED}s (expected < 2s)"; fi

# === 12. wait built-in ==============================================
echo -n "Testing wait command"
# Start a short bg job, then wait
WAIT_OUT=$(echo -e "/bin/sleep 0 &\nwait" | ./shell 2>&1)
if echo "$WAIT_OUT" | grep -qE '\[[0-9]+\] [0-9]+'; then
  pass
else
  fail "wait did not show background job info"
fi

# === 13. Unknown command =============================================
echo -n "Testing unknown command"
UNK_OUT=$(echo "nonexistent_cmd_xyz" | ./shell 2>&1)
if echo "$UNK_OUT" | grep -qE "command not found|doesn't know"; then pass; else fail "expected error message, got '$UNK_OUT'"; fi

# === 14. Empty input =================================================
echo -n "Testing empty input"
EMPTY_OUT=$(echo "" | ./shell)
if [ -z "$EMPTY_OUT" ]; then
  pass
else
  fail "expected empty output, got '$EMPTY_OUT'"
fi

# === 15. Multiple pipes with PATH resolution ========================
echo -n "Testing pipe with PATH resolution"
MP_OUT=$(echo "echo hello | wc -w" | ./shell)
MP_WORDS=$(echo "$MP_OUT" | tr -d ' ')
if [ "$MP_WORDS" = "1" ]; then pass; else fail "expected 1, got '$MP_WORDS'"; fi

# ====================================================================
echo
echo "=============================="
echo "Results: $PASS passed, $FAIL failed"
echo "=============================="

# Cleanup
rm -f test_redirection_in test_redirection_out test_pipe_redir_out

if [ "$FAIL" -gt 0 ]; then exit 1; fi
