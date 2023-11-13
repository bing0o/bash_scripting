#!/bin/bash
#
# Bash script to update your godaddy dns record to your current public ip address (dynamic dns).
#

Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
	\r#OPTIONS:
	\r        -i, --ip             - Your Public IP Address.
	\r        -d, --domain         - Your Domain Name (example.com).
	\r        -t, --type           - DNS Record Type (default: A).
	\r        -n, --name           - Subdomain Name (mysub) without domain name.
	\r        -k, --key            - Godaddy Key (here: https://developer.godaddy.com/getstarted).
	\r        -s, --secret         - Godaddy Secret.
	\r        -h, --help           - Displays The Help And Exit.
	\r
	EOF
	exit
}

# you can set default values here #
IP="$(curl -sk ipinfo.io/ip)"
DOMAIN="example.com"
TYPE="A"
NAME="mysub"
KEY="" 
SEC="" 
###################################


while [ -n "$1" ]; do
	case $1 in
		-i|--ip)
			IP="$2"
			shift ;;
		-d|--domain)
			DOMAIN="$2"
   			shift ;;
		-t|--type)
			TYPE="$2"
			shift ;;
		-n|--name)
			NAME="$2"
			shift ;;
		-k|--key)
			KEY="$2"
			shift ;;
		-s|--secret)
			SEC="$2"
   			shift ;;
		-h|--help)
			Usage ;;
		*)
			echo "[-] Unknown Option: $1"
			Usage ;;
	esac
	shift
done

DATA="[{\"data\": \"${IP}\", \"ttl\": 600}]"
HEADERS="Authorization: sso-key ${KEY}:${SEC}"
DNS=$(curl -s -XGET -H "$HEADERS" "https://api.godaddy.com/v1/domains/$DOMAIN/records/$TYPE/$NAME" | jq -r '.[].data')

[[ ${IP} =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "[!] Check Your Internet Connection and Try Again!"; exit 1; }

[[ ${IP} == ${DNS} ]] && { echo "[!] Same IP, No Need To Update!"; exit 0; }

echo "New IP: ${IP}"

echo "[+] Updating DNS Record...."

curl -sk -XPUT -H "Content-Type: application/json" -H "Accept: application/json" -H "${HEADERS}" -d "${DATA}" https://api.godaddy.com/v1/domains/${DOMAIN}/records/${TYPE}/${NAME}

echo "[+] Done!"
