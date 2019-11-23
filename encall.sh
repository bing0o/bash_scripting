#!/bin/bash
#
# script to encrypt all the files in a specific directory, using crypto.py python script.
#
# wget https://raw.githubusercontent.com/bing0o/Python-Scripts/master/crypto.py
# chmod +x crypto.py
# sudo cp crypto.py /usr/local/bin/crypto
#
# change the default password!.

if [ -z $1 ] 
then 
	echo "#Usage: encall <OPTIONS (e/d)> <PASSWORD, default (P4ssw@rD)>"
	exit 1
fi

[[ -z $2 ]] && password="P4ssw@rD" || password=$2

if [ "$1" == "e" ]
then
        #use find instead of ls 
	ls * | grep -v ".hacklab$" | xargs -I% bash -c "echo -ne \"[+] Processing: %                                             \r\" && if [ -f % ]; then crypto -e % -p $password -x 1>/dev/null; fi"
fi

if [ "$1" == "d" ]
then
	ls *.hacklab | xargs -I% bash -c "echo -ne \"[+] Processing: %                                                    \r\" ;crypto -d % -p $password -x 1>/dev/null"
fi
echo -ne "[*] Done!                                        \r"
echo ""
