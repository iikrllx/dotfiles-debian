#!/bin/sh
#
# Generate a C source file with a random name containing a basic program
# structure and a GDB script to start debugging from the main function.
#

uniq_name=$(echo $(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 8).c)

if [ ! -e "$uniq_name" ]; then
cat << EOF > "$uniq_name"
#include <time.h>
#include <stdio.h>
#include <ctype.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <dirent.h>
#include <limits.h>
#include <locale.h>
#include <stdbool.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char **argv, char **envp)
{

	return 0;
}
EOF
fi

cat << EOF > main.gdb
break main
run
EOF

ls "$uniq_name" main.gdb
