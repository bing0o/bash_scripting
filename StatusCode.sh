#!/bin/bash
#
# bash script to check for status code, size, redirected url, for a list of domains or ips
#

PRG=${0##*/}
VERSION="2020-03-22"

Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
		\r$PRG:\t\t - Tool reads a list of Domanis or IPs and gives you: status code, size and redirected link.
		\r
		\rOptions:
		\r      -l, --list         - List of Domains or IPs.
		\r      -t, --Threads      - Threads number (Default: 5).
		\r      -o, --output       - The output file to save the results.
		\r      -h, --help         - Displays this Informations and Exit.
		\r      -v, --version      - Displays The Version
		\rExample:
		\r      $PRG -l domains.txt -t 20 -f status.txt
		\r

	EOF
}

list=False
threads=5
out="False"

while [ -n "$1" ]; do
	case $1 in
		-l|--list)
				list=$2
				shift ;;
		-t|--threads)
				threads=$2
				shift ;;
		-o|--output)
				out=$2
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

[ "$list" == False ] && { printf "[!] Argument -l/--list is Required!\n"; Usage; exit 1; }

mycurl(){
	res=$(curl -sk $1 --connect-timeout 10 -w '%{http_code},%{url_effective},%{size_download},%{redirect_url}\n' -o /dev/null)
	status=$(echo $res | awk -F, '{print $1}')
	site=$(echo $res | awk -F, '{print $2}')
	size=$(echo $res | awk -F, '{print $3}')
	redirect=$(echo $res | awk -F, '{print $4}')
	out=$2
	
	if [[ "$status" == "2"* ]]; then 
		cstatus="\e[32m$status\e[0m"
	elif [[ "$status" == "3"* ]]; then
		cstatus="\e[34m$status\e[0m"
	elif [[ "$status" == "4"* ]]; then
		cstatus="\e[31m$status\e[0m"
	else
		cstatus="$status"
	fi
	echo -e "$cstatus,$site,$size,$redirect"
	[ $out != False ] && echo "$status,$site,$size,$redirect" >> $out

}

main(){
	cat $list | xargs -I{} -P $threads bash -c "mycurl {} $out"
}

export -f mycurl
main
