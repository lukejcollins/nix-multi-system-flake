#!/bin/sh

sleep 2

xrandr --output "$(xrandr | awk '/ connected/{print $1; exit; }')" --auto
sleep 1
i3-msg restart

xev -root -event randr | \
grep --line-buffered 'subtype XRROutputChangeNotifyEvent' | \
while read foo ; do \
    xrandr --output "$(xrandr | awk '/ connected/{print $1; exit; }')" --auto
    sleep 1
    i3-msg restart
done
