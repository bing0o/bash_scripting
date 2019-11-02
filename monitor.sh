#!/bin/bash

mem=$(free -m | awk 'NR==2{printf("%d\n", $3*100/$2)}')
disk=$(df -h | awk '$NF=="/"{print $5}' | awk -F% '{print $1}')
cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage ""}' | awk -F. '{print $1}')

if [ "$cpu" -ge "80" ]
then
	notify-send -u critical "The CPU Almost Filled: $cpu"
fi


if [ "$disk" -ge "80" ]
then
	notify-send -u critical "The DISK Almost Filled: $disk"
fi


if [ "$mem" -ge "80" ]
then
	notify-send -u critical "The MEMORY Almost Filled: $mem"
fi

