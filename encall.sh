#!/bin/bash
#
# script to encrypt all the files in a specific directory, using crypto.py python script.
#
# wget https://raw.githubusercontent.com/bing0o/Python-Scripts/master/crypto.py
# chmod +x crypto.py
# sudo cp crypto.py /usr/local/bin/crypto
#
# change the default password!.

Do()
{
	setterm -linewrap off
	find -maxdepth 1 \( -type f $1 -name '*.hacklab'\
		-exec crypto $1 {} -p ${2:-P4ssw@rD} -x 1>/dev/null \;\
		-exec tput el \; \) -printf "%p\r"
	setterm -linewrap on
	echo "[*] Done!"
}

case $1 in
	e)
		Do -not -e ;;
	d)
		Do ' ' -d ;;
	''|*)
		echo "Usage: encall <OPTIONS (e/d)> <PASSWORD, default (P4ssw@rD)>"
		exit 1 ;;
esac
