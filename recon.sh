#!/bin/bash
#
# Combined Tools:
#     https://github.com/bing0o/SubEnum/
#     https://github.com/tomnomnom/hacks/tree/master/filter-resolved
#     https://github.com/projectdiscovery/naabu
#     https://github.com/tomnomnom/httprobe
#     https://github.com/projectdiscovery/nuclei/
#
#

[ -z "$1" ] && { printf "[!] auto.sh <DOMAIN>\n"; exit; }

temps="$HOME/tools/nuclei-templates/all/"

subenum -s -d $1 | tee subs-$1 | filter-resolved -c 50 | sudo $(which naabu) -silent -t 50 -ports 80,81,443,3000,6443,8000,8001,8008,8080,8083,8443,8834,8888,9090 | httprobe -c 50 | tee hosts-$1 | sort -u | nuclei -c 50 -t "$temps" -o nuclei-$1.logs


