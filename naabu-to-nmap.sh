#!/bin/bash
#
# use naabu for full port scan then go deeper with each port using nmap
# https://github.com/projectdiscovery/naabu
#
[ -z "$1" ] && { printf "[!] Usage: ./mynmap.sh <Naabu Results file>\n"; exit; }

[ -d "nmap-results" ] || mkdir "nmap-results"

list=$(cat "$1" | cut -d ':' -f 1 | sort -u)

count=1
for IP in ${list[@]}
do
        printf "[+] Scanning ($count)"
        printf "                                        \r"
        ports=$(cat "$1" | grep "$IP" | cut -d ":" -f 2)
        ports=$(echo $ports | tr ' ' ',' ) #awk '{gsub(/\n/,",,",$0); print $0}')
        nmap -sV -T4 "$IP" -p "$ports" -oN "nmap-results/$IP" &>/dev/null
        let count+=1
done
