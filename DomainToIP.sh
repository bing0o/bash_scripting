#!/bin/bash
#
# Simple bash script to get IP address From hostname
#

[ -z "$1" ] && { printf "[!] ${0##*/} <HOSTS>\n"; exit 1; }

NSL() {
	nslookup "$1" | grep -v "#53" | grep Address | awk '{print $2}'
}


while read host
do
	#printf "\n[+] Host: $host\n"
	NSL $host
done < "$1"
