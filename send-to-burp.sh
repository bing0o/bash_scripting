#!/bin/bash
#
# Usage: $ ./burp.sh "<URL>"
#        $ cat URLs.txt | ./burp.sh

SEND() {
        curl -sk "$1" -x http://127.0.0.1:8080 &>/dev/null
}

[ -z "$1" ] && while read URL; do SEND "$URL";  done || SEND "$1"
