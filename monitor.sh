#!/bin/sh

cpu=$(awk '/^cpu/ {usage=($2+$4)*100/($2+$4+$5)} END{printf("%d\n", usage)}' /proc/stat)
[ $cpu -ge 80 ] && notify-send -u critical "High CPU usage: ${cpu}%"

free -m | while read Type Total Used Free _; do
	if [ "$Type" = 'Mem:' ]; then
		PCent=$((Used*100/Total))

		[ $PCent -ge 80 ] && notify-send -u critical "High RAM usage: ${PCent}%"
	fi
done

# Bourne POSIX-compliant approach.
df -P / | while read F1 _ _ _ F5 _; do
	if ! [ "$F1" = 'Filesystem' ]; then
		PCent=${F5%\%}

		[ $PCent -ge 80 ] && notify-send -u critical "High DISK usage: ${PCent}%"

		# In-case there are for some reason >1 matches.
		break
	fi
done

# In-case we're running in a cron job.
exit 0
