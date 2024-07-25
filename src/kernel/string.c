#define size_t unsigned int
#define NULL (void *)0
#define null NULL

int _strlen(const char *buf) {
    if (buf == NULL) {
        return -1;
    }
    int count = 0;
    while (*buf != '\0') {
        buf++;
        count++;
    }
    return count;
}
