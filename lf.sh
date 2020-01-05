#!/bin/bash
#
# just a bash script to list directories or files in the given path
#

Usage () {
u="#Usage:\n
\tlf <d/f> <PATH Optional>\n
\td\tFor Directories\n
\tf\tFor Files\n
"
echo -e $u
}

[ -z $1 ] && { Usage; exit 1; }
[ -z $2 ] && path=$(pwd) || path=$2

[ $1 != "f" ] && [ $1 != "d" ] && { Usage; exit 1; }
#echo $path
ls -a $path | grep -v "^\.\.$\|^\.$" | xargs -I% bash -c "[ -$1 $path/'%' ] && echo '%'" 
