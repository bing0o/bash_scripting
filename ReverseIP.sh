#!/bin/bash
#
# Simple bash script for Reverse IP Lookup,
# To get all the domains hosted on the server
#
# Don't forget to put your API key in YOUR_API_KEY
#

PRG=${0##*/}

API_cred() {
	cmd=$(curl -sk "https://reverse-ip.whoisxmlapi.com/api/v1?apiKey=YOUR_API_KEY&ip=$ip" | sed 's/,/\n/g' | grep "name" | sed 's/.*:\|"//g')
	[ "$out" == False ] && printf "$cmd\n" || { printf "$cmd\n" | tee -a $out; }
}

API() {
	cmd=$(curl -sk "https://api.hackertarget.com/reverseiplookup/?q=$ip")
	[ "$out" == False ] && printf "$cmd\n" || { printf "$cmd\n" | tee -a $out; }
}

Usage() {
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
		\rOptions:
		\r       -t, --type        - Type of the API (Dafault: ht),
		\r                           wxa -> WhoisXmlApi, ht -> HackerTarget, all -> To use both
		\r       -i, --ip          - The Target IP.
		\r       -o, --output      - The OutPut File.
		\r       -l, --loop        - To use pipe e.g(cat ips.txt | $PRG -l)
		\rExample:
		\r       $PRG --type all --ip 8.8.8.8 --output hosts.txt
		\r       cat IPs.txt | $PRG --loop --output hosts.txt
	EOF
}

ip=False
type=ht
loop=False
out=False

while [ -n "$1" ]; do
	case $1 in 
		-t|--type)
			[ "$2" != "wxa" ] && [ "$2" != "ht" ] && [ "$2" != "all" ] && { printf "[!] -t/--type must be [wxa, ht, all], use -h for more information\n"; exit 1; }
			type=$2
			shift ;;
		-i|--ip)
			ip=$2
			shift ;;
		-l|--loop)
			loop=True ;;
		-o|--output)
			out=$2
			shift ;;
		*)
			Usage
			exit 1 ;;
	esac
	shift
done	

TYPE() {
	[ "$type" == all ] && { 
		API
		API_cred
	} || {
		[ type == wxa ]	&& API_cred || API
	}
}

[ "$ip" == False ] && [ "$loop" == False ] && { printf "[!] Arguments -i/--ip or -l/--loop are required!, Enter -h for more information!\n"; exit 1; }

[ "$ip" != False ] && {
	TYPE
} || {
	while read ip; do
		TYPE
	done
}

