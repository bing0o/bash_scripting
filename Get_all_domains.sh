#!/bin/bash
#
# bash script to enumerate for all domains related to your target based on the Registrare Email/Name.
#

[ -z "$1" ] && { echo "[!] ./alldomains.sh <Registrare Email/Name>"; exit 1; }

curl -s -XPOST https://reverse-whois-api.whoisxmlapi.com/api/v2 -d "{\"apiKey\": \"YOUR_API_KEY\",\"mode\": \"purchase\",\"basicSearchTerms\": {\"include\": [\"$1\"]}}" | tr ',\|[' '\n' | cut -d '"' -f 2 | grep -v "domainsCount\|domainsList"
