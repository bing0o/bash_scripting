#!/bin/bash
#
# sometimes you need to change your VPS' ip using a VPN without losing your ssh connection,
# well, this script does exactly that.
#
# but not sure about DNS leaks and other stuff that could expose your IP,
# be carefull when using this method.
#


myip=$(curl ifconfig.me -sk)

ip rule add table 137 from ${myip}

baseip=$(echo ${myip} | cut -d"." -f1-3)

ip route add table 137 to ${baseip}.0/24 dev eth0
ip route add table 137 default via ${baseip}.1

printf "[+] Now run your Openvpn in a tmux or screen session.!"
