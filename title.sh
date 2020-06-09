#!/bin/bash
#
# bash script to check for the title of the page for domains or ips
#

PRG=${0##*/}
VERSION="2020-05-23"

Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
		\r$PRG:\t\t - Tool reads a list of Domanis or IPs and gives you: The Title of the page.
		\r
		\rOptions:
		\r      -l, --list         - List of Domains or IPs.
		\r      -t, --Threads      - Threads number (Default: 5).
		\r      -o, --output       - The output file to save the results.
		\r      -p, --path         - To use a specific path e.g(/robots.txt).
		\r      -h, --help         - Displays this Informations and Exit.
		\r      -v, --version      - Displays The Version
		\rExample:
		\r      $PRG -l domains.txt -t 20 -o titles.txt
		\r

	EOF
}

list=False
threads=5
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
	if [[ "$path" == False ]]; then
		path="" 
	elif [[ "$path" != "/"* ]]; then
		path="/"$path
	fi
	res=$(curl --connect-timeout 10 $1$path -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)') #curl -sk "$1$path" --connect-timeout 10 -w '%{http_code},%{url_effective},%{size_download},%{redirect_url}\n' -o /dev/null)
	out=$2
	title="\e[32m$res\e[0m"
	url="\e[34m$1\e[0m"
	echo -e "$url | $title"
	[ $out != False ] && echo "$res" >> $out

}


main(){
	cat $list | xargs -I{} -P $threads bash -c "mycurl '{}' $out $color $path"
}

[ "$list" == False ] && { 
	printf "[!] Argument -l/--list is Required!\n" 
	Usage 
	exit 1
	} || { 
		export -f mycurl 
		main 
	}
 
