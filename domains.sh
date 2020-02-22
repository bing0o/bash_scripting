#!/bin/bash
#
# script for subdomain enumeration using 4 of the best tools:
#   * findomain: https://github.com/Edu4rdSHL/findomain
#   * SubFinder: https://github.com/projectdiscovery/subfinder
#   * Amass: https://github.com/OWASP/Amass
#   * AssetFinder: https://github.com/tomnomnom/assetfinder
#
[ -z $1 ] && { echo "[!] Usage: ./domains.sh <DOMAIN>"; exit 1; }

echo "[+] Findomain"
findomain -t $1 -o &>/dev/null
res=$(wc -l $1.txt)
echo "[*] Results: " $res

echo -e "\n[+] SubFinder"
subfinder -silent -d $1 1> tmp-subfinder 2>/dev/null
res=$(wc -l tmp-subfinder)
echo "[*] Results: " $res

echo -e "\n[+] Amass"
amass enum -norecursive -noalts -d $1 1> tmp-amass 2>/dev/null
res=$(wc -l tmp-amass)
echo "[*] Results: " $res

echo -e "\n[+] Assetfinder"
assetfinder --subs-only $1 > tmp-assetfinder
res=$(wc -l tmp-assetfinder)
echo "[*] Results: " $res


cat $1.txt tmp-* | sort -u > alldomains-$1
res=$(wc -l alldomains-$1)
echo -e "\n[+] The Final Results:" $res

#rm $1.txt tmp-*

