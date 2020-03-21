#!/bin/bash
#cito M:755 O:0 G:0 T:/usr/local/bin/crypto
#----------------------------------------------------------------------------------
# A Bourne POSIX shell script acting as a wrapper for another written in Python, -
# called 'crypto.py', available with the following:
#
#   wget https://raw.githubusercontent.com/bing0o/Python-Scripts/master/crypto.py
#   chmod 755 crypto.py; chown 0:0 crypto.py
#   sudo mv crypto.py /usr/local/bin/crypto
#
# If you have Cito (https://github.com/terminalforlife/Extra):
#
#   sudo cito -r bing0o Python-Scripts master crypto.py
#
# WARNING: Change the default password!
#----------------------------------------------------------------------------------
#set -x
#CurVer='2019-12-13'
CurVer='2020-03-21'
Progrm=${0##*/}

Err(){
	printf "ERROR: %s\n" "$2" 1>&2
	[ $1 -gt 0 ] && exit $1
}

Domain='https://github.com'

Usage(){
	while read -r CurLine; do
		printf "%b\n" "$CurLine"
	done <<-EOF
		\r            ENCALL ($CurVer)
		\r            Originally written by bing0o <bingo.noip@gmail.com>
		\r            Revised by terminalforlife <terminalforlife@yahoo.com>

		\r            A simple Bourne POSIX wrapper for Python script Crypto.

		\rSYNTAX:     $Progrm [OPTS] [FILE_1 [FILE_2] ...]

		\rOPTS:       --help|-h|-?            - Displays this help information.
		\r            --version|-v            - Output only the version datestamp.
		\r            --encrypt|-e            - Encrypts one or more files.
		\r            --decrypt|-d            - Decrypts one or more files.
		\r            --password|-p STR       - Where STR is the password to use.
		\r            --depth|-t INT          - Where INT is the Number of depth(Default:1).

		\rSITE:       $Domain/bing0o/bash_scripting
		\r            $Domain/bing0o/Python-Scripts
	EOF
}

Password='P4ssw@rD'

if [ $# -eq 0 ]; then
	Usage; exit 1
fi

num=1

while [ "$1" ]; do
	case $1 in
		--encrypt|-e)
			Action='-e'
			Actioning='Encrypting' ;;
			#shift ;;
		--decrypt|-d)
			Action='-d'
			Actioning='Decrypting' ;;
			#shift ;;
		--password|-p)
			shift
			if [ -z "$1" ]; then
				Err 1 "Password mising for the '--password|-p' option."
			else
				Password=$1
			fi ;;
		-t|--depth)
			num=$2
			shift ;;
		--help|-h|-\?)
			Usage; exit 0 ;;
		--version|-v)
			printf "%s\n" "$CurVer"; exit 0 ;;
		*)
			Usage; exit 1 ;;
	esac
	shift
done

if ! command -v crypto 1> /dev/null 2>&1; then
	Err 1 "Dependency 'crypto' not met."
fi

list=()
path="."

for i in $(seq 1 $num); do
	path=$path"/*"
	for i in $path; do
		if [ "$Action" = '-e' ]; then
			[ "${i##*.}" = 'hacklab' ] && continue
		elif [ "$Action" = '-d' ]; then
			[ "${i##*.}" = 'hacklab' ] || continue
		fi
		[ -f "$i" ] && list+=("$i")
	done
done

c=1
all=${#list[@]}
for CurFile in "${list[@]}"; do
	printf "[+] %s: %s\n" "$Actioning ($c/$all)" "$CurFile"
	crypto "$Action" "$CurFile" -p "$Password" -x 1>/dev/null
	let c+=1
done

printf "[*] Done!\n"
