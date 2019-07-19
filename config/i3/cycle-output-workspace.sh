#!/bin/bash
# enables gnome-shell-like workspace cycling on the focused output
rev="r"
wrap="cat"
while getopts ":wr" opt; do
	case ${opt} in
		r ) rev=""
			;;
		w ) wrap="tee /dev/fd/1"
			;;
		\? ) echo "options: -r (reverse), -w (wrap)"
	esac
done
OUTPUT="$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true) | .output')"
WS="$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true) | .name')"
echo $WS
NEXT_WS="$(i3-msg -t get_workspaces | jq -r --arg focused "$OUTPUT" '.[] | select(.output == $focused) | .name' | eval "sort -un$rev" | eval "$wrap" | awk -v ws="$WS" 'BEGIN{armed="false"}{if(armed=="true"){print $0; exit}else{if($0==ws){armed="true"}}}')"
i3-msg "workspace $NEXT_WS"
