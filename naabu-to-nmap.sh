#!/bin/bash
#
# use naabu for full port scan then go deeper with each port using nmap
# https://github.com/projectdiscovery/naabu
#
[ -z "$1" ] && { printf "[!] Usage: ./naabu-to-nmap.sh <Naabu Results file>\n"; exit; }

[ -d "nmap-results" ] || mkdir "nmap-results"


E8080=False # Exclude port 8080 from the scan
E8443=False # Exclude port 8443 from the scan

C8080=$(cat $1 | grep ':8080$' | wc -l) # Count Port 8080
C8443=$(cat $1 | grep ':8443$' | wc -l) # Count Port 8443

Exclude=()

[[ ${C8080} -ge 20 ]] && Exclude+=("8080") #E8080=True
[[ ${C8443} -ge 20 ]] && Exclude+=("8443") #E8443=True

list=$(cat "$1" | cut -d ':' -f 1 | sort -u)

all=()

for i in ${list[@]}
do
	all+=("$i")
done

length=${#all[@]}

count=1
for IP in ${list[@]}
do
        printf "[+] [$count/$length] Scanning: ${IP} "
        printf "                                                     \r"
        ports=$(cat "$1" | sort -u | grep "^${IP}" | cut -d ":" -f 2)

	for i in ${Exclude[@]}
	do
		ports=${ports[@]/$i} # Delete The Excluded Port From The List of Ports
	done

        ports=$(echo $ports | tr ' ' ',' )
        nmap --script default,vuln -sV -T4 "$IP" -p "$ports" -oN "nmap-results/$IP" --open -Pn &>/dev/null # Run nmap scan with the (default and vuln) scripts.
        let count+=1
done
