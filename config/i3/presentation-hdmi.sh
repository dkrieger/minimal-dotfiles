#!/bin/bash
# Connect/resize monitors

## connect primary
primary_name="eDP-1"
# primary_x="1600"
# primary_y="900"
primary_x="1920"
primary_y="1080"
primary_mode="${primary_x}x${primary_y}"
command="xrandr --output $primary_name --mode $primary_mode --pos 0x0"

## connect external display (if exists)
ext_name="HDMI-1"
ext_x="1920"
ext_y="1080"
ext_mode="${ext_x}x${ext_y}"
xrandr | grep '^HDMI-1 connected' >/dev/null 2>&1
if [[ "$?" -eq 0 ]]; then
	ext_segment=" --output $ext_name --mode $ext_mode --pos ${primary_x}x0"
	command="${command} ${ext_segment}"
fi
eval "$command"

## Disconnect disconnected monitors (so i3 gets the event)
xrandr | awk '$0~/^[a-z0-9A-Z]/ && $2~/^disconnected$/ {print "--output "$1" --off"}' | xargs xrandr

## (re)launch polybar
nohup $HOME/.config/polybar/launch.sh >/dev/null 2>&1 &

exit 0
