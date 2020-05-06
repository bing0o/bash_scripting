#!/bin/bash

[ -z $1 ] && { printf "[!] Usage: whois <DOMAIN>\n"; exit 1; }

curl -sk "https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=API_KEY&gnoreRawTexts=1&outputFormat=json&domainName=$1" | gron | grep -v "rawText\|strippedText" | grep "registrant" | grep "name\|email\|organization"
