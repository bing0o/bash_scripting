#!/bin/bash
#
# bash script to pick a music for you from the given directory.
# just for fun :)
#
# chmod 755 music.sh
# sudo cp music.sh /usr/local/bin/music
#

cyan="\e[36m"
end="\e[0m"

[ "$1" == "-h" ] && { echo "#Usage:"; echo -e "\tmusic <PATH> <EXTENSION> <VLC>"; exit; }

pkill vlc

# change the default path here!
[ -z $1 ] || [ "$1" == "." ] && path="/home/bingo/Music" || path=$1
[ -z "$2" ] || [ "$2" == "." ] && ext="mp3" || ext="$2"

m=0
for i in $path/*.$ext; do 
	music[$m]="$i"
	let m+=1
done

rand=$[ $RANDOM % $m ] 
pick=${music[$rand]}

echo -e $cyan"[+] The Items: "$end ${#music[@]}
echo -e $cyan"[+] The Picked Number: "$end $rand
echo -e $cyan"[+] The Picked Item: "$end $(echo "$pick" | awk -F/ '{print $NF}')

[ "$3" == "vlc" ] && { vlc "$pick" &>/dev/null & } || { cvlc "$pick" --play-and-exit &>/dev/null & }

