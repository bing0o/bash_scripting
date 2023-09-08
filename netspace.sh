#!/bin/bash
#
# shell script to create a linux network namespace with internet access
#

PRG=${0##*/}

Usage(){
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF
	\r#Options:
	\r    -n, --name       - Name For New Namespace.
	\r    -v, --veth       - Veth name.
	\r    -p, --peer       - Peer name.
	\r    -i, --interface  - Network Interface (Default: eth0).
	\r        --vip        - IP For Veth.
	\r        --pip        - IP For Peer.
	\r    -h, --help       - Shows The Help Message.
	\r#Example:
	\r    $PRG --name vpn --veth veth0 --peer peer0 --interface eth0 --vip 10.0.1.1 --pip 10.0.1.2
EOF
}

ns="vpn"
VETH="veth-0"
PEER="peer-0"
VIP="10.0.1.1"
PIP="10.0.1.2"
IFACE="eth0"

while [ -n "$1" ]; do	
	case $1 in
		-n|--name)
			ns="$2"
			shift ;;
		-v|--veth)
			VETH="$2"
			shift ;;
		-p|--peer)
			PEER="$2"
			shift ;;
		--vip)
			VIP="$2"
			shift ;;
		--pip)
			PIP="$2"
			shift ;;
		-i|--interface)
			IFACE="$2"
			shift ;;
		-h|--help)
			Usage
			exit 
			;;
		*)
			echo "[-] Unknown Option: $1"
			Usage 
			exit 1 
			;;
	esac
	shift
done


# creating new network namespace
ip netns add ${ns}

# setting loopback interface up
ip netns exec ${ns} ip link set lo up

# Creating a veth pair
ip link add ${VETH} type veth peer name ${PEER}

# moving veth-1 to our new namespace
ip link set ${PEER} netns ${ns}

# Assigning IPs to our veth devices
ip addr add ${VIP}/24 dev ${VETH}
ip netns exec ${ns} ip addr add ${PIP}/24 dev ${PEER}

# bring them up
ip link set ${VETH} up
ip netns exec ${ns} ip link set ${PEER} up

# checking if IPv4 Forwarding is enabled and enabling it if it's not.
sysctl -a 2>/dev/null | grep 'ip_forward ' | grep "1$" || echo 1 > /proc/sys/net/ipv4/ip_forward

# Packet forwarding with iptables
iptables -A FORWARD -o ${IFACE} -i ${VETH} -j ACCEPT
iptables -A FORWARD -o ${VETH} -i ${IFACE} -j ACCEPT

# IP Masquerading
iptables -t nat -A POSTROUTING -s ${PIP}/24 -o ${IFACE} -j MASQUERADE

# Default gateway for the new namespace
ip netns exec ${ns} ip route add default via ${VIP}

# setting DNS server for the new namespace
[[ -d /etc/netns/${ns} ]] || mkdir -p /etc/netns/${ns}
echo 'nameserver 8.8.8.8' > /etc/netns/${ns}/resolv.conf

# running curl to check if new netns can access the internet
ip netns exec ${ns} curl ipinfo.io || echo "[-] The new network namespace can not access the internet, check The Configuration!"
