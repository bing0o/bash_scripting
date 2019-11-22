#!/bin/bash

if [ -z $1 ] 
then 
	echo "#Usage: encall <OPTIONS (e/d)> <PASSWORD, default (P4ssw@rD)>"
	exit 1
fi

[[ -z $2 ]] && password="P4ssw@rD" || password=$2

if [ "$1" == "e" ]
then
	ls * | grep -v ".hacklab$" | xargs -I% bash -c "echo -ne \"[+] Processing: %                                             \r\" && if [ -f % ]; then crypto -e % -p $password -x 1>/dev/null; fi"
fi

if [ "$1" == "d" ]
then
	ls *.hacklab | xargs -I% bash -c "echo -ne \"[+] Processing: %                                                    \r\" ;crypto -d % -p $password -x 1>/dev/null"
fi
echo -ne "[*] Done!                                        \r"
echo ""
