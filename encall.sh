#!/bin/sh
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

CurVer='2019-12-09'
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
		\r            Originally written by bing0o <your E-Mail here>
		\r            Revised by terminalforlife <terminalforlife@yahoo.com>

		\r            A simple Bourne POSIX wrapper for Python script Crypto.

		\rSYNTAX:     $Progrm [OPTS] [FILE_1 [FILE_2] ...]

		\rOPTS:       --help|-h|-?            - Displays this help information.
		\r            --version|-v            - Output only the version datestamp.
		\r            --encrypt|-e            - Encrypts one or more files.
		\r            --decrypt|-d            - Decrypts one or more files.
		\r            --password|-p STR       - Where STR is the password to use.

		\rSITE:       $Domain/bing0o/bash_scripting
		\r            $Domain/bing0o/Python-Scripts
	EOF
}

Password='P4ssw@rD'

while [ "$1" ]; do
	case $1 in
		--help|-h|-\?)
			Usage; exit 0 ;;
		--version|-v)
			printf "%s\n" "$CurVer"; exit 0 ;;
		--encrypt|-e)
			Action='-e'
			Actioning='Encrypting' ;;
		--decrypt|-d)
			Action='-d'
			Actioning='Decrypting' ;;
		--password|-p)
			shift

			if [ -z "$1" ]; then
				Err 1 "Password mising for the '--password|-p' option."
			else
				Password=$1
			fi ;;
		-*)
			Err 1 "Invalid argument(s) detected -- see: '$'" ;;
		*)
			break ;;
	esac
	shift
done

for CurFile in ./*; do
	[ -f "$CurFile" ] || continue

	# Ignore `*.hacklab` files if encrypting.
	if [ "$Action" = '-e' ]; then
		case $CurFile in
			*.hacklab) continue ;;
		esac
	fi

	printf "[+] %s: %s\n" "$Actioning" "$CurFile"
	crypto "$Action" "$CurFile" -p "$Password" -x 1> /dev/null
done

printf "[*] Done!\n"
