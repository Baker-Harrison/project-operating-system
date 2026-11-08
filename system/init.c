#include <stdio.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/utsname.h>

int main(void)
{
    struct utsname kernel;

    mount("proc", "/proc", "proc", 0, NULL);
    mount("sysfs", "/sys", "sysfs", 0, NULL);
    mount("devtmpfs", "/dev", "devtmpfs", 0, NULL);
    uname(&kernel);

    printf("\n\n    project-operating-system\n");
    printf("    running on Linux %s\n\n", kernel.release);
    fflush(stdout);

    for (;;)
        pause();
}
