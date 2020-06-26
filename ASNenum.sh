#!/bin/bash
#
# if the first argument is an IP, the response will be the ASNumber 
# if the first argument is an ASN, the response will be a list of CIDRS
#

[ -z "$1" ] && { printf "[!] Usage: ${0##*/} <IP/ASN>\n"; exit 1; }

IP() {
	curl -sk "https://api.hackertarget.com/aslookup/?q=$1" | awk '{gsub(/,/,"\n",$0); gsub(/\"/,"",$0); print "ASN: AS"$2 "\nCIDR: "$3 "\nORG: "$4}'
}

ASN() {
	curl -sk https://api.hackertarget.com/aslookup/\?q\=$1 | grep -v ","
}

if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	IP $1
else
	ASN $1
fi
