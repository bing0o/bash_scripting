#!/bin/bash


end="\e[0m"
cyan="\e[36m"
purple="\e[35m"

read -p "[+] Enter Domain: " domain

# https://github.com/s0md3v/Photon
echo ""
echo -e $cyan"[*] Start Photon"$end # Mapping the target application
tmux split-window -h "photon '-u $domain -t 30 --wayback --dns --keys'; echo '[+] Done!'; read"
echo "[!] Running in New Tmux Pane!"
#echo "[+] Results: In $domain Folder"

# link: https://github.com/Edu4rdSHL/findomain
echo ""
echo -e $cyan"[*] Start Findomain"$end # Getting a list of subdomains
findomain -t $domain -o &>/dev/null
size=$(wc -l $domain.txt)
echo "[+] Results: $size"



# https://github.com/tomnomnom/httprobe
echo -e "\n[+] HTTProbe"
cat $domain.txt | httprobe > hosts
echo "[*] Results: "$(wc -l hosts)

# link: https://github.com/bing0o/Python-Scripts/blob/master/subchecker.py
#echo ""
#echo -e $cyan"[*] Start Subchecker"$end # Filter the result and save only the live subdomains
#subchecker -w "$domain.txt" -t 30 -o "$domain-checked" 1>/dev/null
#size=$(wc -l $domain-checked)
#echo "[+] Results: $size"

# link: https://github.com/bing0o/Python-Scripts/blob/master/webtech.py
echo ""
echo -e $cyan"[*] Start WebTech"$end # Getting the technologies that running in each subdomain
webtech -w "hosts" -t 30 -o "$domain-Tech" -i 1>/dev/null
size=$(wc -l $domain-Tech)
echo "[+] Results: $size"

# https://github.com/tomnomnom/meg
echo -e "\n[+] Start Meg"
meg -d 1000 -v / 


echo -e "\n[!] Changing The Directory To ./out"
cd out

# gf I changed its name to gff since i already have a linux tool called gf!
# https://github.com/tomnomnom/gf
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

