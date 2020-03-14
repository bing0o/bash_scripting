#!/bin/bash
#
# enumnom.sh, Bash script to automate the Recon Process using tomnomnom's tools
# the installation

<<install

go get -u github.com/tomnomnom/assetfinder
go get -u github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/meg
go get -u github.com/tomnomnom/gf
cp -r ~/go/src/github.com/tomnomnom/gf/examples ~/.gf

install
#
#

[ -z $1 ] && read -p "[+] Domain: " domain || domain=$1

echo "[+] Start AssetFinder."
assetfinder -subs-only $domain > domains
results=$(wc -l domains)
echo "[=+] Results: " $results

echo -e "\n[+] Start HTTPRobe."
cat domains | httprobe > hosts
results=$(wc -l hosts)
echo "[=+] Results: " $results

echo -e "\n[+] Start Meg."
meg -d 1000 -v /

echo -e "\n[!] Changing The Directory To ./out"
cd out


# changed the name of `gf` to `gff` since I already have a linux tool called gf! 
echo -e "\n[*] The OutPut For aws-keys"
gff aws-keys

echo -e "\n[*] The OutPut For base64"
gff base64

echo -e "\n[*] The OutPut For cors"
gff cors

echo -e "\n[*] The OutPut For debug-pages"
gff debug-pages

echo -e "\n[*] The OutPut For firebase"
gff firebase

echo -e "\n[*] The OutPut For fw"
gff fw

echo -e "\n[*] The OutPut For go-functions"
gff go-functions

echo -e "\n[*] The OutPut For http-auth"
gff http-auth

echo -e "\n[*] The OutPut For ip"
gff ip

echo -e "\n[*] The OutPut For json-sec"
gff json-sec

#echo -e "\n[*] The OutPut For meg-headers"
#gff meg-headers

echo -e "\n[*] The OutPut For php-curl"
gff php-curl

echo -e "\n[*] The OutPut For php-errors"
gff php-errors

echo -e "\n[*] The OutPut For php-serialized"
gff php-serialized

echo -e "\n[*] The OutPut For php-sinks"
gff php-sinks

echo -e "\n[*] The OutPut For php-sources"
gff php-sources

echo -e "\n[*] The OutPut For s3-buckets"
gff s3-buckets

echo -e "\n[*] The OutPut For sec"
gff sec

echo -e "\n[*] The OutPut For servers"
gff servers

#echo -e "\n[*] The OutPut For strings"
#gff strings

echo -e "\n[*] The OutPut For takeovers"
gff takeovers

echo -e "\n[*] The OutPut For upload-fields"
gff upload-fields

#echo -e "\n[*] The OutPut For urls"
#gff urls

echo -e "\n[0] Done!"
