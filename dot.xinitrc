#!/bin/sh

xset -b
xset s off
xset -dpms
xset r rate 350
setxkbmap -option caps:none

if [ -f ~/.xinitrc_local ]; then
    sh ~/.xinitrc_local
fi

if [ `which xmodmap` ]
then
    xmodmap ~/.Xmodmap&
fi

exec i3
