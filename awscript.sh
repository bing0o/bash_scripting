#!/bin/bash

# cat ips | xargs -I% sh -c "host %"
# -z True if it's a zero | -n True if it's not a zero!
[ -z $1 ] && { echo "#Usage: awscript.sh <domains/ips>" >&2; exit 1; }

lines=$(wc -l < $1)
c=1
while read line; do 
	echo -ne "[$c/$lines] $line                                                 \r"
	let c=c+1
	res=$(host $line)
	if [[ $res == *"amazonaws"* ]]; then 
		echo $line" | " $res
	fi
done < $1 
