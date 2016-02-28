#!/bin/sh

xset -b
xset s off
xset -dpms
xset r rate 375
setxkbmap -option caps:none

if [ -f ~/.xinitrc_local ]; then
    sh ~/.xinitrc_local
fi

if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

exec i3
