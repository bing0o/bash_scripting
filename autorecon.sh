#!/bin/bash


end="\e[0m"
cyan="\e[36m"
purple="\e[35m"

read -p "[+] Enter Domain: " domain

# link: https://github.com/aboul3la/Sublist3r
echo -e $cyan"[*] Start Sublist3r"$end
sublist3r -d $domain -o "$domain-list" &>/dev/null

# link: https://github.com/bing0o/Python-Scripts/blob/master/subchecker.py
echo -e $cyan"[*] Start Subchecker"$end
subchecker -w "$domain-list" -t 30 -o "$domain-checked" &>/dev/null

# link: https://github.com/bing0o/Python-Scripts/blob/master/webtech.py
echo -e $cyan"[*] Start WebTech"$end
webtech -w "$domain-checked" -t 30 -o "$domain-Tech" -i &>/dev/null

echo -e $purple"[!] You Did Nothing Yet,Go Deeper!"$end
