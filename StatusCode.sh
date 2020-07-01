#!/bin/bash
#
# bash script to check for status code, size, redirected url and the Title for a list of domains or ips
#

PRG=${0##*/}
VERSION="2020-03-24"

Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
		\r$PRG:\t\t - Tool reads a list of Domanis or IPs and gives you: status code, size, redirected link and the Title.
		\r
		\rOptions:
		\r      -l, --list         - List of Domains or IPs.
		\r      -t, --Threads      - Threads number (Default: 5).
		\r      -s, --status       - Display only The specified Status Code.
		\r      -o, --output       - The output file to save the results.
		\r      -p, --path         - To use a specific path ex(/robots.txt).
		\r      -n, --nocolor      - Displays the Status code without color.
		\r      -h, --help         - Displays this Informations and Exit.
		\r      -v, --version      - Displays The Version
		\rExample:
		\r      $PRG -l domains.txt -t 20 -o status.txt
		\r

	EOF
}

list=False
threads=5
status=False
out=False
color=True
path=False

while [ -n "$1" ]; do
	case $1 in
		-l|--list)
				[ -z "$2" ] && { printf "[-] -l/--list needs a File (list of Domains or IPs)\n"; exit 1; }
				list=$2
				shift ;;
		-t|--threads)
				[ -z "$2" ] && { printf "[-] -t/--threads needs a number of threads\n"; exit 1; }
				threads=$2
				shift ;;
		-s|--status)
				status=$2
				shift ;;
		-p|--path)
				[ -z "$2" ] && { printf "[-] -p/--path needs a path ex(/robots.txt)\n"; exit 1; }
				path=$2
				shift ;;
		-o|--output)
				[ -z "$2" ] && { printf "[-] -o/--output needs a file to write the results to.\n"; exit 1; }
				out=$2
				shift ;;
		-h|--help)
				Usage
				exit ;;
		-v|--version)
				printf "$VERSION\n"
				exit ;;
		-n|--nocolor)
				color=False;;
		*)
				printf "[-] Error: Unknown Options: $1\n"
				Usage; exit 1 ;;
	esac
	shift
done

mycurl(){
	path=$4
	status=$5
	if [[ "$path" == False ]]; then
		path="" 
	elif [[ "$path" != "/"* ]]; then
		path="/"$path
	fi
	result=$(curl -sk $1$path --connect-timeout 10 -w '%{http_code} %{url_effective} %{size_download} %{redirect_url}\n' -o /dev/null)
	title=$(curl --connect-timeout 10 $1$path -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)')
	out=$2
	if [[ "$3" == True ]]; then
		if [[ "$result" == "2"* ]]; then 
			cresult="\e[32m$result\e[0m"
		elif [[ "$result" == "3"* ]]; then
			cresult="\e[34m$result\e[0m"
		elif [[ "$result" == "4"* ]]; then
			cresult="\e[31m$result\e[0m"
		else
			cresult="$result"
		fi
	else
		cresult="$result"
	fi
	[[ "$status" == False ]] && echo -e "$cresult [$title]" && [ $out != False ] && echo "$result [$title]" >> $out || {
		[[ "$result" == "$status"* ]] && echo -e "$cresult [$title]"
		[ $out != False ] && echo "$result [$title]" >> $out
	}

}


main(){
	cat $list | xargs -I{} -P $threads bash -c "mycurl {} $out $color $path $status"
}

[ "$list" == False ] && { 
	printf "[!] Argument -l/--list is Required!\n" 
	Usage 
	exit 1
	} || { 
		export -f mycurl 
		main 
	}
 
