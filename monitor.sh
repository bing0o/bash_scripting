#!/bin/bash

mem=$(free -m | awk 'NR==2{print $3*100/$2}' | awk -F. '{print $1}')
disk=$(df -h | awk '$NF=="/"{print $5}' | awk -F% '{print $1}')
cpu=$(top -bn1 | grep load | awk '{print $(NF-2)}' | awk -F. '{print $1}')


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

