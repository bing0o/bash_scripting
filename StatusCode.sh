#!/bin/bash

[ -z $1 ] && { echo -e "#Usage:\n\tcodesh.sh <DOMAINS> <THREADS:5>"; exit 1; }
[ -z $2 ] && t=5 || t=$2

cat $1 | xargs -P $t -I{} bash -c "curl {} --connect-timeout 10 -w '%{http_code},%{url_effective},%{size_download},%{redirect_url}\n' -o /dev/null -sk"
