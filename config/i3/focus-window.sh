#!/bin/bash
i3-msg -t get_tree | jq -r 'recurse(.nodes[]) | select(.type == "con" and .window != null) | {name, id} | select(.name | strings) | (.id | tostring) + ":\t" + .name' | $HOME/go/bin/fzf | awk -F':' '{print $1}' | xargs -I'%' i3-msg [con_id=%] focus
