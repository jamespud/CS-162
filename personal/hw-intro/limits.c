#include <stdio.h>
#include <sys/resource.h>

void print_limit(const char *name, int resource) {
    struct rlimit lim;
    if (getrlimit(resource, &lim) == -1) {
        perror("getrlimit failed");
        return;
    }

    printf("%s: ", name);
    if (lim.rlim_cur == RLIM_INFINITY) {
        printf("unlimited\n");
    } else {
        printf("%llu\n", (unsigned long long)lim.rlim_cur);
    }
}

int main() {
print_limit("Stack size", RLIMIT_STACK);
    print_limit("Process limit", RLIMIT_NPROC);
    print_limit("Max file descriptors", RLIMIT_NOFILE);
    
    return 0;
}
