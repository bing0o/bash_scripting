#!/bin/bash
# script to encrypt all the files in a specific directory | https://github.com/bing0o/Python-Scripts/blob/master/crypto.py
if [ -z $1 ] 
then 
	echo "#Usage: encall <OPTIONS (e/d)>"
	exit 1
fi

# -f for files & -d for directories
if [ "$1" == "e" ]
then
	ls * | xargs -I% sh -c "echo '[+] Processing: %' && if [ -f % ]; then crypto -e % -p password -x 1>/dev/null; fi"
fi

if [ "$1" == "d" ]
then
	ls *.hacklab | xargs -I% sh -c "echo '[+] Processing: %' ; crypto -d % -p password -x 1>/dev/null"
fi
	
