#!/bin/bash

[ -z "$1" ] && { printf "[!] file-share <FILE>\n" exit 1; }

curl -F "file=@$1" https://file.io -s | sed 's/,/\n/g' | awk '/link/{gsub(/"/," ",$0); print $NF}'
