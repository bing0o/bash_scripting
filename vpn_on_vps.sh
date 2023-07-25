#!/bin/bash
#
# sometimes you need to change your VPS' ip using a VPN without losing your ssh connection,
# well, this script does exactly that.
#
# but not sure about DNS leaks and other stuff that could expose your IP,
# be carefull when using this method.
#
# 1. SSH to your VPS.
# 2. Run this script.
# 3. Run your VPN client.
#
# your connection will not be closed and the ip of your VPS will be changed.


myip=$(curl ifconfig.me -sk)

ip rule add table 137 from ${myip}

baseip=$(echo ${myip} | cut -d"." -f1-3)

ip route add table 137 to ${baseip}.0/24 dev eth0
ip route add table 137 default via ${baseip}.1

printf "[+] Now run your Openvpn in a tmux or screen session.!\n"
