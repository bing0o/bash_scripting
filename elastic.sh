#!/bin/bash

[ -z "$2" ] && { printf "eslatic.sh <URL:9200> <INDEX>\n"; exit; }

url=$1
index=$2

curl -sk "$url/$index/_search?size=10000" | jq "."
