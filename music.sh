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
	echo -e $cyan"[+] The Picked Song: "$end ${pick##*/}

	pkill vlc

	case $vlc in
		True) vlc "$pick" &>/dev/null & ;;
		  *) cvlc "$pick" --play-and-exit &>/dev/null & ;;
	esac
}

prog=${0##*/}

Usage() {
	while read -r line; do
		printf "%b\n" "$line"
	done <<-EOF

	\r #Options:
	\r \t -p, --path\t\t The Path To Your Music Directory.
	\r \t -e, --extension\t The Extension of The Files (mp3, mp4, avi,....etc, or "*" to load all the files).
	\r \t -v, --vlc\t\t to run the music or the video clip with vlc GUI.
	\r \t -l, --list\t\t to list all the songs and pick the music by yourself.
	\r #Example:
	\r \t $prog -p $HOME/Music -e mp3 -v -l

EOF
}

# change the default path here!
path="$HOME/Music"
ext="mp3"
vlc=False
list=False

while [ -n "$1" ]; do
	case "$1" in
		-p|--path)
			path=$2
			shift;;
		-e|--extension)
			ext=$2
			shift;;
		-v|--vlc)
			vlc=True;;
			#shift;;
		-l|--list)
			list=True;;
			#shift;;
		*)
			Usage
			exit 1;;
	esac
	shift
done


m=0
for i in "$path"/*."$ext"; do
	[ -f "$i" ] && music[$m]=$i
	[ $list == True ] && echo "[$m] ${i##*/}"
	let m+=1
done


[ $list == True ] && read -p "[+] Pick a Song: " num || num=$[ $RANDOM % $m ]

MUSIC 
