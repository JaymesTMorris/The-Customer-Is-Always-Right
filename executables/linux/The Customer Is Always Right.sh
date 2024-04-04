#!/bin/sh
echo -ne '\033c\033]0;The Customer Is Always Right\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/The Customer Is Always Right.x86_64" "$@"
