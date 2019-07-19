#!/bin/bash
# export CITY="5234381"
# export UNITS="fahrenheit"
pkill polybar
while pgrep polybar >/dev/null; do sleep 1; done
nohup polybar left 2>/dev/null &
nohup polybar right 2>/dev/null &
nohup polybar pres 2>/dev/null &
exit 0
