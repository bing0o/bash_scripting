#!/bin/bash

red="\e[31m"
green="\e[32m"
end="\e[0m"

[ -z $1 ] && { echo -e "#Usage:\n\tport <IP> <PORT (Optional)>"; exit; }

IP=$1

SCAN () {
        (echo 1 > /dev/tcp/$IP/$1) 2>/dev/null 
        [ $? -eq 0 ] && echo -e "$1 -$green Online$end\n" || echo -e "$1 -$red Offline$end\n"
}

[ -z $2 ] && while read PORT; do SCAN $PORT; done || { PORT=$2; SCAN $PORT; exit; } 
