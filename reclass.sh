#!/bin/bash
#
# bash script to rename all the files in the given path
#

[ "$1" == "-h" ] && { echo "#Usage:"; echo "reclass [-h] <Number> <Extension>"; exit; }

[ -z $1 ] && { read -p "[!] Do You Wanna Rename This Directory? [ $(pwd) ] [Ctrl-c to exit]: "; s=1; } || s=$1

for i in *; do
	[ -z $2 ] && e=$i || e=$2
	[ -f $i ] && [[ "$i" != "class"* ]] && { mv -n "$i" "class-$s.$e"; let s+=1; }
done

echo "[+] Done!"

