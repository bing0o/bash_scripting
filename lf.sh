#!/bin/sh
#
# just a Bourne POSIX shell script to list directories or files in the given path
#

Usage () {
	while read -r CurLine; do
		printf '%b\n' "$CurLine"
	done <<-EOF
		\r#Usage:
		\r        lf <d/f/L/p/S/b> <PATH Optional>
		\r        d        For Directories
		\r        f        For Files
		\r        L        For Symbolic Links
		\r        p        For Named Pipes
		\r        S        For Sockets
		\r        b        For Block Special Files
	EOF
}

case $1 in
	 [fdLpSb]) Type=$1 ;;
	*) Usage; exit 1 ;;
esac

for CurFile in ${2:-.}/.* ${2:-.}/* ; do
	case $CurFile in
		.|..|*/.|*/..) continue ;;
	esac

	[ -$Type "$CurFile" ] && printf '%s\n' "${CurFile#./}"
done
