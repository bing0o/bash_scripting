#!/bin/bash


end="\e[0m"
cyan="\e[36m"
purple="\e[35m"

read -p "[+] Enter Domain: " domain

# link: https://github.com/Edu4rdSHL/findomain
echo -e $cyan"[*] Start Findomain"$end
findomain -t $domain -o &>/dev/null
echo "	* Results saved in: $domain.txt"

# link: https://github.com/bing0o/Python-Scripts/blob/master/subchecker.py
echo -e $cyan"[*] Start Subchecker"$end
subchecker -w "$domain.txt" -t 30 -o "$domain-checked" &>/dev/null
echo "	* Results saved in: $domain-checked"

# link: https://github.com/bing0o/Python-Scripts/blob/master/webtech.py
echo -e $cyan"[*] Start WebTech"$end
webtech -w "$domain-checked" -t 30 -o "$domain-Tech" -i &>/dev/null
echo "	* Results saved in: $domain-Tech"

echo -e $purple"[!] You Did Nothing Yet,Go Deeper!"$end
