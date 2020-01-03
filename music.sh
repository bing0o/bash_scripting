#!/bin/bash
#
# bash script to pick a music for you from the given directory.
# Just For Fun [^^]
#
# chmod 755 music.sh
# sudo cp music.sh /usr/local/bin/music
#

#set -x

cyan="\e[36m"
end="\e[0m"

MUSIC () {
pick=${music[$num]}

echo -e $cyan"\n[+] The Songs: "$end ${#music[@]}
echo -e $cyan"[+] The Picked Number: "$end $num 
echo -e $cyan"[+] The Picked Song: "$end $(echo "$pick" | awk -F/ '{print $NF}')

pkill vlc

[ "$1" == "vlc" ] && { vlc "$pick" &>/dev/null & } || { cvlc "$pick" --play-and-exit &>/dev/null & }

}

[ "$1" == "-h" ] && { 
echo -e "#Usage:
\tmusic <PATH> <EXTENSION> <vlc> <list>\n
\t<PATH>\t\tThe Path To Your Music Directory.
\t<EXTENSION>\tThe Extension of The Files (mp3, mp4, avi,....etc, or \"*\" to load all the files)
\t<vlc>\t\tEnter 'vlc' to run the music or the video clip with vlc GUI.
\t<list>\t\tEnter 'list' to list all the songs and pick the music by yourself.
"; 
exit; 
}

# change the default path here!
[ -z $1 ] || [ "$1" == "." ] && path="/home/bingo/Music" || path=$1
[ -z "$2" ] || [ "$2" == "." ] && ext="mp3" || ext="$2" 

m=0
for i in $path/*.$ext; do 
	[ -f "$i" ] && music[$m]="$i"
	[ "$4" == "list" ] && echo "[$m] $(echo $i | awk -F/ '{print $NF}')"
	let m+=1
done

[ "$4" == "list" ] && read -p "[+] Pick a Song: " num || num=$[ $RANDOM % $m ]

MUSIC "$3"
