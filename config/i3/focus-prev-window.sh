#!/bin/bash
# (from https://github.com/i3/i3/issues/838#issuecomment-455373401)

queue=( )
queueLimit=6

# 1: value to push
pushOnQueue(){
	queue=( "$1" ${queue[@]:0:$queueLimit} )
}

popOnQueue(){
	queue=( ${queue[@]:1:$queueLimit} )
}

epochMillis(){
	echo $(($(date +%s%N)/1000000))
}

cleanMarkedFocus(){
	markFailed=;
	[[ -z "${queue[0]}" ]] || i3-msg "[id=${queue[0]}] mark --add _prevFocus" 2>/dev/null | grep -i "\"success\":false" >/dev/null && markFailed=true;
	while [ "${queue[0]}" = "$currentFocus" -o ! -z "$markFailed" ]
	do
		popOnQueue
		if [ -z "${queue[0]}" ]
		then
			break
		fi
		markFailed=;
		i3-msg "[id=${queue[0]}] mark --add _prevFocus" 2>/dev/null | grep -i "\"success\":false" >/dev/null && markFailed=true;
	done
}

lastTime=$(epochMillis)
permanence=1000

xprop -root -spy _NET_ACTIVE_WINDOW | 
while read line
do
	currentFocus=$(echo "$line" | awk -F' ' '{printf $NF}')
	if [ "$currentFocus" = "${queue[0]}" ]
	then
		forceNextMark=true
	fi
	cleanMarkedFocus
	if [ "$currentFocus" = "0x0" -o "$currentFocus" = "$prevFocus" ]
	then
		continue
	fi
	currentTime=$(epochMillis)
	period=$(($currentTime-$lastTime))
	lastTime=$currentTime
	# if the permanence (period) is too small then don't care about the focus change but
	# allow jumping between given two windows at fast speed
	if [ ! -z "$forceNextMark" -o $period -gt $permanence  -o "$currentFocus" = "$prevPrevFocus" ]
	then
		forceNextMark=""
		if [ ! -z "$prevFocus" ]
		then
			if i3-msg "[id=$prevFocus] mark --add _prevFocus" 2>/dev/null | grep -i "\"success\":true" 2>&1 1>/dev/null 
			then
				pushOnQueue "$prevFocus"
				prevPrevFocus=$prevFocus
			fi
		fi
	fi
	prevFocus=$currentFocus
done
