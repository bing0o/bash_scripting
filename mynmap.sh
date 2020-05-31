#!/bin/bash
#
# Simple bash script to run nmap against a list of hosts or IPs
#


PRG=${0##*/}
VERSION="2020-05-25"

Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
		\r$PRG:\t\t - run nmap against a list of hosts or IPs.
		\r
		\rOptions:
		\r      -l, --list         - List of Domains or IPs.
		\r      -o, --output       - The output Directory to save the results.
		\r      -p, --ports        - List of Ports (Default:20 ports).
                \r                         (7001,9200,6443,2379,10250,10255,2082,2087,2095,2096,3000,8000,8001,8008,8080,8083,81,8443,8834,8888)
		\r      -h, --help         - Displays this Informations and Exit.
		\r      -v, --version      - Displays The Version
		\rExample:
		\r      $PRG -l domains.txt -t 20 -o status.txt
		\r

	EOF
}


list=False
out=nmap-results
ports="7001,9200,6443,2379,10250,10255,2082,2087,2095,2096,3000,8000,8001,8008,8080,8083,81,8443,8834,8888"

while [ -n "$1" ]; do
	case $1 in
		-l|--list)
				[ -z "$2" ] && { printf "[-] -l/--list needs a File (list of Domains or IPs)\n"; exit 1; }
				list=$2
				shift ;;
		-o|--output)
				[ -z "$2" ] && { printf "[-] -o/--output needs a Directory to write the results to.\n"; exit 1; }
				out=$2
				shift ;;
		-p|--ports)
				[ -z "$2" ] && { printf "[-] -p/--ports, ports e.g(80,443,8080,8443)\n"; exit 1; }
				ports=$2
				shift ;;
		-h|--help)
				Usage
				exit ;;
		-v|--version)
				printf "$VERSION\n"
				exit ;;
		*)
				printf "[-] Error: Unknown Options: $1\n"
				Usage; exit 1 ;;
	esac
	shift
done


Main() {
	all=$(wc -l < $list)
	count=1
	while read host
	do
		printf "[$count/$all]"
		printf "                   \r"
		nmap $host -Pn -p $ports -oN $out/$host -T4 &>/dev/null
		let count+=1
	done < $list
}


[ "$list" == False ] && { 
	printf "[!] Argument -l/--list is Required!\n" 
	Usage 
	exit 1
	} || {
		[ -d "$out" ] || mkdir $out
		Main
	}
