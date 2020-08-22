#!/bin/bash
#
# Tool Used: https://github.com/dwisiswant0/go-dork
#
#[ -z "$1" ] && { printf "[!] google-hacking <DOMAIN>\n"; exit; }
#
#
# ./google-hacking.sh target.com 
# $ cat targets.txt | ./google-hacking.sh
#

DORKS(){
	dir="$ROOT/$1"
	mkdir "$dir"
	printf"Publicly exposed documents:\n" #Publicly exposed documents
	go-dork -q "site:$1 ext:doc | ext:docx | ext:odt | ext:rtf | ext:sxw | ext:psw | ext:ppt | ext:pptx | ext:pps | ext:csv" -s -nc -p 5 | tee "$dir/documents"

	#Directory listing vulnerabilities
	printf "Directory listing:\n"
	go-dork -q "site:$1 intitle:index.of /" -s -nc -p 5 | tee "$dir/dir-listing"

	printf "Configuration files exposed:\n"
	#Configuration files exposed
	go-dork -q "site:$1  ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini | ext:env" -s -nc -p 5 | tee "$dir/config-files"

	printf "Database files exposed:\n"
	#Database files exposed
	go-dork -q "site:$1 ext:sql | ext:dbf | ext:mdb" -s -nc -p 5 | tee "$dir/Databases"

	printf "Log files exposed:\n"
	#Log files exposed
	go-dork -q "site:$1 ext:log | ext:logs" -s -nc -p 5 | tee "$dir/log-files"

	#Backup and old files
	printf "Backup and old files:\n"
	go-dork -q "site:$1 ext:bkf | ext:bkp | ext:bak | ext:old | ext:backup" -s -nc -p 5 | tee "$dir/backups"

	#Login pages
	printf "Login pages:\n"
	go-dork -q "site:$1  inurl:login | inurl:signin | intitle:Login | intitle:\"sign in\" | inurl:auth" -s -nc -p 5 | tee "$dir/login-pages"

	#SQL errors
	printf "SQL errors:\n"
	go-dork -q "site:$1 intext:\"sql syntax near\" | intext:\"syntax error has occurred\" | intext:\"incorrect syntax near\" | intext:\"unexpected end of SQL command\" | intext:\"Warning: mysql_connect()\" | intext:\"Warning: mysql_query()\" | intext:\"Warning: pg_connect()\"" -s -nc -p 5 | tee "$dir/sqlErrors"

	#PHP errors / warnings
	printf "PHP errors / warnings:\n"
	go-dork -q "site:$1 \"PHP Parse error\" | \"PHP Warning\" | \"PHP Error\"" -s -nc -p 5 | tee "$dir/php-errors"

	#phpinfo()
	printf "phpinfo():\n"
	go-dork -q 'site:$1 ext:php intitle:phpinfo "published by the PHP Group"' -s -nc -p 5 | tee "$dir/phpinfo"

	#Search Pastebin.com / pasting sites
	printf "Search Pastebin.com / pasting sites:\n"
	go-dork -q 'site:pastebin.com | site:paste2.org | site:pastehtml.com | site:slexy.org | site:snipplr.com | site:snipt.net | site:textsnip.com | site:bitpaste.app | site:justpaste.it | site:heypasteit.com | site:hastebin.com | site:dpaste.org | site:dpaste.com | site:codepad.org | site:jsitor.com | site:codepen.io | site:jsfiddle.net | site:dotnetfiddle.net | site:phpfiddle.org | site:ide.geeksforgeeks.org | site:repl.it | site:ideone.com | site:paste.debian.net | site:paste.org | site:paste.org.ru | site:codebeautify.org  | site:codeshare.io | site:trello.com "$1"' -s -nc -p 5 | tee "$dir/pastebin"

	#Search Github.com and Gitlab.com
	printf "Search Github.com and Gitlab.com:\n"
	go-dork -q 'site:github.com | site:gitlab.com "$1"' -s -nc -p 5 | tee "$dir/Gits"

	# Search Stackoverflow.com
	printf "Search Stackoverflow.com:\n"
	go-dork -q 'site:stackoverflow.com "$1"' -s -nc -p 5 | tee "$dir/stackoverflow"

	#Signup pages
	printf "Signup pages:\n"
	go-dork -q 'site:$1 inurl:signup | inurl:register | intitle:Signup' -s -nc -p 5 | tee "$dir/signups"

	#papaly bookmarks
	printf "papaly bookmarks:\n"
	go-dork -q 'site:papaly.com "$1"' -s -nc -p 5 | tee "$dir/papaly"


	#go-dork -q 'site:$1 ' -s -nc -p 5

}

ROOT="google-hacking"
mkdir $ROOT

[ -z "$1" ] && while read site; do DORKS "$site"; done || DORKS "$1"
