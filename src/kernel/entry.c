#include "string.c"

void print(char *string) {
    volatile char *video = (volatile char *)0xB8000;
    int i = 0;
    int size = _strlen(string);

    // function failed
    if (size < 0) {
        return;
    }

    for (int j = 0; j < size; j++) {
        video[i] = string[j];
        i += 2;
    }
}

/* entry into Kernel */
void kernel_entry() {
    /*
    char str[17] = {'B', 'o', 'o', 't', 'e', 'd', ' ', 'u', 'p',
                    ' ', 'k', 'e', 'r', 'n', 'e', 'l', 0};
    */
    char *string = "Welcome to the potatOS kernel\nA";
    print(string);
}
