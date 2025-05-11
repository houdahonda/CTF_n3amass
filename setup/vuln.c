// vuln.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    setuid(0); // escalate privileges
    system("/bin/bash");
    return 0;
}
