#include <stdio.h>
extern found();
extern int test_var;
int global_init = 10;
int global;
static int static_init = 1000;
static int static_var;
char *string = "test string";
int main() {
    found();
    printf("this is a format string: %d", test_var);
    return 0;
}