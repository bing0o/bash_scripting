#!/bin/bash
#
# script for subdomain enumeration using 4 of the best tools with some APIs:
#   * findomain: https://github.com/Edu4rdSHL/findomain
#   * SubFinder: https://github.com/projectdiscovery/subfinder
#   * Amass: https://github.com/OWASP/Amass
#   * AssetFinder: https://github.com/tomnomnom/assetfinder
#
# a perl version is being developed by @terminalforlife 
# 	* https://github.com/terminalforlife/PerlProjects/tree/master/source/dominator
#

bold="\e[1m"
Underlined="\e[4m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
#grey="\e[90m"
end="\e[0m"

echo -e $blue$bold"
 ____                        _       _____                       
|  _ \  ___  _ __ ___   __ _(_)_ __ | ____|_ __  _   _ _ __ ___  
| | | |/ _ \| '_ \` _ \ / _\` | | '_ \|  _| | '_ \| | | | '_ \` _ \\
| |_| | (_) | | | | | | (_| | | | | | |___| | | | |_| | | | | | |
|____/ \___/|_| |_| |_|\__,_|_|_| |_|_____|_| |_|\__,_|_| |_| |_|
                    By: bing0o @hack1lab
"$end

Usage(){
	echo -e "$blue
#Options:
	-d, --domain\t Domain To Enumerate
	-u, --use\t Functions To Be Used ex(Findomain,Subfinder,...,etc)
	-e, --exclude\t Functions To Be Excluded ex(Findomain,Amass,...,etc)
	-o, --output\t The output file to save the Final Results (Default: alldomains-<TargetName>)
	-k, --keep\t To Keep the TMPs files (the results from each tool).

#Available Functions:
	wayback,crt,bufferover,Findomain,Subfinder,Amass,Assetfinder

#Example:
	To use a specific Functions:
		$0 -d hackerone.com -u Findomain,wayback,Subfinder
	To exclude a specific Functions:
		$0 -d hackerone.com -e Amass,Assetfinder
	To use all the Functions:
		$0 -d hackerone.com 
	"$end
	exit 1
}


wayback() { 
	echo -e $bold"[+] WayBackMachine"$end
	curl -sk "http://web.archive.org/cdx/search/cdx?url=*.$domain&output=txt&fl=original&collapse=urlkey&page=" | awk -F/ '{gsub(/:.*/, "", $3); print $3}' | sort -u > tmp-wayback
	echo -e $green"[*] Results:$end " $(wc -l tmp-wayback)	
}

crt() {
	echo -e $bold"\n[+] Crt.sh"$end
	curl -sk "https://crt.sh/?q=%.$domain&output=json&exclude=expired" | tr ',' '\n' | awk -F'"' '/name_value/ {gsub(/\*\./, "", $4); gsub(/\\n/,"\n",$4);print $4}' | sort -u > tmp-crt
	echo -e $green"[*] Results:$end " $(wc -l tmp-crt)	
}

bufferover() {
	echo -e $bold"\n[+] BufferOver"$end
	curl -s "https://dns.bufferover.run/dns?q=.$domain" | grep $domain | awk -F, '{gsub("\"", "", $2); print $2}' | sort -u > tmp-bufferover
	echo -e $green"[*] Results:$end " $(wc -l tmp-bufferover)	
}

Findomain() {
	echo -e $bold"\n[+] Findomain"$end
	findomain -t $domain -u tmp-findomain &>/dev/null
	echo -e $green"[*] Results:$end " $(wc -l tmp-findomain)
}

Subfinder() {
	echo -e $bold"\n[+] SubFinder"$end
	subfinder -silent -d $domain 1> tmp-subfinder 2>/dev/null
	echo -e $green"[*] Results:$end " $(wc -l tmp-subfinder)
}



Amass() {
	echo -e $bold"\n[+] Amass"$end
	amass enum -norecursive -noalts -d $domain 1> tmp-amass 2>/dev/null
	echo -e $green"[*] Results:$end " $(wc -l tmp-amass)
}

Assetfinder() {
	echo -e $bold"\n[+] Assetfinder"$end
	assetfinder --subs-only $domain > tmp-assetfinder
	echo -e $green"[*] Results:$end " $(wc -l tmp-assetfinder)
}

domain=False
use=False
exclude=False
delete=True
out=False

list=(
	wayback
	crt
	bufferover
	Findomain 
	Subfinder 
	Amass 
	Assetfinder
	)

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
					echo -e $red$Underlined"[-] Unknown Function: $i"$end
					Usage
				fi
			done
			shift ;;
		-e|--exclude)
			exclude=$2
			le=${exclude//,/ }
			for i in $le; do
				if [[ ! " ${list[@]} " =~ " ${i} " ]]; then
					echo -e $red$Underlined"[-] Unknown Function: $i"$end
					Usage
				fi
			done
			shift ;;
		-o|--output)
			out=$2
			shift ;;
		-k|--keep)
			delete=False
		-h|--help)
			Usage;;
		*)
			echo "[-] Unknown Option: $1"
			Usage;;
	esac
	shift
done

[ $domain == False ] && { echo -e $red"[-] Argument -d/--domain is Required"$end; Usage; }
[ $use == False ] && [ $exclude == False ] && { 
	wayback
	crt
	bufferover
	Findomain 
	Subfinder 
	Amass 
	Assetfinder
}

[ $use != False ] && [ $exclude != False ] && { echo -e $Underlined$red"[!] You can use only one Option: -e/--exclude OR -u/--use"$end; Usage; }

[ $use != False ] && { 
	for i in $lu; do
		$i
	done
}

[ $exclude != False ] && {
	for i in ${list[@]}; do
		if [[ " ${le[@]} " =~ " ${i} " ]]; then
			continue
		else
			$i
		fi
	done
}


[ $out == False ] && out="alldomains-$domain"
sort -u tmp-* > $out
echo -e $green$bold$Underlined"\n[+] The Final Results:$end $(wc -l $out)\n"

[ $delete == True ] && rm tmp-*
