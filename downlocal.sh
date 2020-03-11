#!/bin/bash
#
# Download files from [Index Of] web pages
#

Usage="[+] Usage:\n \
\tdownlocal <LINK>\n
"

[ -z $1 ] || [ $1 = "-h" ] && echo -e $Usage && exit 1 #{ echo "[-] Don't Forget The Argument"; echo "./donwlocal.sh <LINK>"; exit 1; }

printf -v begin '%(%s)T' -1




down () {
	echo "[+] Download From: " $1
	curl -s $1 | grep href | awk -F'"' '{print $2}' | grep -v "/$" | xargs -I% bash -c "wget $1/% -q"
}

flist=()
res=$(curl -s $1 | grep href | awk -F'"' '{print $2}' | grep "/$")

for i in $res; do
	flist+=($i)
done

down "$1"

#echo "$PWD"


#[ ${#flist[@]} -ne 0 ] && { for dir in "${flist[@]}"; do cd "$PWD"; mkdir "$dir"; cd "$dir"; down "$1/$dir"; done }

#echo "${listdir[@]}"

printf -v end '%(%s)T' -1
time=$[end - begin]

min=$[time / 60]
sec=$[time % 60]

printf "\n#####################\n"
printf "[+] Time: $min:$sec\n"
printf "[+] Done!\n"
printf "#####################\n"
