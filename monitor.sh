#!/bin/sh

DepCount=0
for CurDep in awk free notify-send df; do
	if ! command -v "$CurDep" 1> /dev/null 2>&1; then
		printf "ERROR: Dependency '%s' not met.\n" "$CurDep"
		DepCount=$((DepCount + 1))
	fi
done

[ $DepCount -eq 0 ] || exit 1

cpu=$(awk '/^cpu/ {usage=($2+$4)*100/($2+$4+$5)} END{printf("%d\n", usage)}' /proc/stat)
[ $cpu -ge 80 ] && notify-send -u critical "The CPU Almost Filled: $cpu"

mem=$(free -m | awk 'NR==2{printf("%d\n", $3*100/$2)}')
[ $mem -ge 80 ] && notify-send -u critical "The MEMORY Almost Filled: $mem"

# Bourne POSIX-compliant approach.
df -P / | while read F1 _ _ _ F5 _; do
	if ! [ "$F1" = 'Filesystem' ]; then
		Percent=${F5%\%}
		if [ $Percent -ge 80 ]; then
			notify-send -u critical "The DISK Almost Filled: $Percent"
		fi

		# In-case there are for some reason >1 matches.
		break
	fi
done

