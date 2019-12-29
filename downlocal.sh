#!/bin/bash
#
# Download files from [Index Of] web pages
#

Usage="[+] Usage:\n \
\tdownlocal <LINK>\n
"

[ -z $1 ] || [ $1 = "-h" ] && echo -e $Usage && exit 1 #{ echo "[-] Don't Foret The Argument"; echo "./donwlocal.sh <LINK>"; exit 1; }

begin=$(date +'%s')




down () {
	echo "[+] Download From: " $1
	curl -s $1 | grep href | awk -F'"' '{print $2}' | grep -v "/$" | xargs -I% bash -c "wget $1/% -q"
}

flist=()
path=$(pwd)
res=$(curl -s $1 | grep href | awk -F'"' '{print $2}' | grep "/$")

for i in $res; do
	flist+=($i)
done

down "$1"

#echo $path


#[ ${#flist[@]} -ne 0 ] && { for dir in ${flist[@]}; do cd $path; mkdir $dir; cd $dir; down $1/$dir; done }

#echo ${listdir[@]}

end=$(date +'%s')
time=$(expr $end - $begin)

min=$(expr $time / 60)
sec=$(expr $time % 60)

echo ""
echo "#####################"
echo "[+] Time: $min:$sec"
echo "[+] Done!"
echo "#####################"
