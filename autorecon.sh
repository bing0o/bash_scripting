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

# link: https://github.com/bing0o/Python-Scripts/blob/master/subchecker.py
echo ""
echo -e $cyan"[*] Start Subchecker"$end # Filter the result and save only the live subdomains
subchecker -w "$domain.txt" -t 30 -o "$domain-checked" 1>/dev/null
size=$(wc -l $domain-checked)
echo "[+] Results: $size"

# link: https://github.com/bing0o/Python-Scripts/blob/master/webtech.py
echo ""
echo -e $cyan"[*] Start WebTech"$end # Getting the technologies that running in each subdomain
webtech -w "$domain-checked" -t 30 -o "$domain-Tech" -i 1>/dev/null
size=$(wc -l $domain-Tech)
echo "[+] Results: $size"

echo ""
echo -e $purple"[!] You Did Nothing Yet,Go Deeper!"$end
