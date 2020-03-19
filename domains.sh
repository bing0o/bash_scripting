#!/bin/bash
#
# script for subdomain enumeration using 4 of the best tools with some APIs:
#   * findomain: https://github.com/Edu4rdSHL/findomain
#   * SubFinder: https://github.com/projectdiscovery/subfinder
#   * Amass: https://github.com/OWASP/Amass
#   * AssetFinder: https://github.com/tomnomnom/assetfinder
#

Progrm=${0##*/}

# Support tput(1) for portability, if found, else use ANSI escape sequences.
if type -fP tput &> /dev/null; then
	bold=`tput bold`;        underlined=`tput smul`;     red=`tput setaf 1`
	blue=`tput setaf 4`;     end=`tput cnorm`;           green=`tput setaf 2`
	#grey=`tput setaf 7`
else
   bold='\e[1m';           underlined='\e[4m';         red='\e[31m'
   green='\e[32m';         blue='\e[34m';              end='\e[0m'
   #grey='\e[90m'
fi

while read; do
	printf "$blue$bold%s$end\n" "$REPLY"
done <<-'EOF'
	 ____                        _       _____
	|  _ \\  ___  _ __ ___   __ _(_)_ __ | ____|_ __  _   _ _ __ ___
	| | | |/ _ \\| '_ ` _ \\ / _` | | '_ \\|  _| | '_ \\| | | | '_ ` _ \\
	| |_| | (_) | | | | | | (_| | | | | | |___| | | | |_| | | | | | |
	|____/ \\___/|_| |_| |_|\\__,_|_|_| |_|_____|_| |_|\\__,_|_| |_| |_|
	                    By: bing0o @hack1lab
EOF

Usage(){
	while read; do
		printf "$blue%s$end\n" "$REPLY" 1>&2
	done <<-EOF
		#Synopsis:
		  $Progrm [OPTS]

		#Options:
		  -h, --help               - Display this help information.
		  -d, --domain D           - Enumerate the D domain.
		  -e, --exclude F          - Comma-separated excluded functions.
		  -k, --keep               - Keep temporary result files of each tool.
		  -o, --output FILE        - Save final results to FILE.
		  -u, --use F              - Comma-separated used functions.

		#Functions:
		  Wayback, CRT, Bufferover, Findomain, Subfinder, Amass, Assetfinder

		#Examples:
		  Use specific functions:
		    $Progrm -d hackerone.com -u Findomain,Wayback,Subfinder
		  Exclude specific functions:
		    $Progrm -d hackerone.com -e Amass,Assetfinder
		  Use all functions:
		    $Progrm -d hackerone.com
	EOF

	exit 1
}

# Uniq-ify & count arguments, redirect to temporary file, then show result.
UniqCount(){ # Usage: [TEMP_FILE] [SORTED_LIST]
	TmpFile=$1; shift

	declare -a DomsArr=("$@")
	declare -i Count=0
	for Domain in "${DomsArr[@]}"; {
		[ "$Old" = "$Domain" ] && continue
		printf '%s\n' "$Domain"
		Old=$Domain
		Count+=1
	} > "$TmpFile"

	printf "$green[*] Results:$end %'d\n" "$Count"

	unset TmpFile Domain DomsArr Old
}

Wayback() {
	printf "$bold[+] WayBackMachine$end\n"
	curl -sk "http://web.archive.org/cdx/search/cdx?url=*."\
		"$domain&output=txt&fl=original&collapse=urlkey&page=" |
		awk -F/ '{gsub(/:.*/, "", $3); print $3}' | sort -u > tmp-wayback
	printf "$green[*] Results:$end %s\n" "$(wc -l tmp-wayback)"
}

CRT() {
	URL="https://crt.sh/?q=%.$domain&output=json&exclude=expired"

	printf "$bold\n[+] Crt.sh$end\n"

	DomsArr=(`
		awk '
			BEGIN {
				RS = "\":\""
				FS = "\",\""
			}

			/,"id":/ {
				gsub(/\\\n/, " ")
				gsub(/\*\./, "")
				Domains[$1]++
			}

			END {
				Sorted = asorti(Domains)
				for(Iter = 1; Iter <= Sorted; Iter++){
					printf("%s ", Domains[Iter])
				}
			}
		' <<< "$(curl -sk "$URL")"
	`)

	UniqCount tmp-crt "${DomsArr[@]}"
}

Bufferover() {
	URL="https://dns.bufferover.run/dns?q=.$domain"

	printf "$bold\n[+] BufferOver$end"

	DomsArr=(`
		awk '
			BEGIN {
				FS=","
				RS="\""
			}

			/'"$domain"'/ {
				Doms[$2]++
			}

			END {
				Sorted = asorti(Doms)
				for(Dom in Doms){
					print(Doms[Dom])
				}
			}
		' <<< "$(curl -s "$URL")"
	`)

	UniqCount tmp-bufferover "${DomsArr[@]}"
}

Findomain() {
	printf "$bold\n[+] Findomain$end"
	findomain -t $domain -u tmp-findomain &>/dev/null
	printf "$green[*] Results:$end %s\n" "$(wc -l tmp-findomain)"
}

Subfinder() {
	printf "$bold\n[+] SubFinder$end"
	subfinder -silent -d $domain 1> tmp-subfinder 2>/dev/null
	printf "$green[*] Results:$end %s\n" "$(wc -l tmp-subfinder)"
}

Amass() {
	printf "$bold\n[+] Amass$end\n"
	amass enum -norecursive -noalts -d $domain 1> tmp-amass 2>/dev/null
	printf "$green[*] Results:$end %s\n" "$(wc -l tmp-amass)"
}

Assetfinder() {
	printf "$bold\n[+] Assetfinder$end\n"
	assetfinder --subs-only $domain > tmp-assetfinder
	printf "$green[*] Results:$end %s\n" "$(wc -l tmp-assetfinder)"
}

domain=False
use=False
exclude=False
delete=True
out=False

list=(Wayback CRT Bufferover Findomain Subfinder Amass Assetfinder)

while [ -n "$1" ]; do
	case $1 in
		-d|--domain)
			domain=$2
			shift ;;
		-u|--use)
			use=$2
			lu=${use//,/ }
			for i in $lu; do
				if [[ ! " ${list[@]} " =~ " ${i} " ]]; then
					printf "$red$underlined[-] Unknown Function: $i$end\n" 1>&2
					Usage
				fi
			done
			shift ;;
		-e|--exclude)
			exclude=$2
			le=${exclude//,/ }
			for i in $le; do
				if [[ ! " ${list[@]} " =~ " ${i} " ]]; then
					printf "$red$underlined[-] Unknown Function: $i$end\n" 1>&2
					Usage
				fi
			done
			shift ;;
		-o|--output)
			out=$2
			shift ;;
		-k|--keep)
			delete=False
			shift ;;
		-h|--help)
			Usage ;;
		*)
			printf "[-] Unknown Option: $1\n"
			Usage ;;
	esac
	shift
done

if [ $domain == False ]; then
	printf "$red[-] Argument -d/--domain is Required$end\n" 1>&2
	Usage
fi

if [ $use == False ] && [ $exclude == False ]; then
	Wayback
	CRT
	Bufferover
	Findomain
	Subfinder
	Amass
	Assetfinder
fi

if ! [ $use == False -a $exclude == False ]; then
	printf "$underlined$red[!] You can use only one Option:"\
		"-e/--exclude OR -u/--use$end\n" 1>&2

	Usage
fi

if [ $use != False ]; then
	for i in $lu; do
		$i
	done
fi

if [ $exclude != False ]; then
	for i in ${list[@]}; do
		[[ " ${le[@]} " =~ " ${i} " ]] && continue

		$i
	done
fi

[ $out == False ] && out="alldomains-$domain"
sort -u tmp-* > $out
printf "$green$bold$underlined\n[+] The Final Results:$end %s\n\n" "$(wc -l $out)"

[ $delete == True ] && rm tmp-*
