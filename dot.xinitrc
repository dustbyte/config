#!/bin/sh

xset -b
xset s off
xset -dpms
xset r rate 250 25

if [ `which xmodmap` ]
then
    xmodmap ~/.Xmodmap&
fi

if [ -f ~/.xinitrc_local ]; then
    sh ~/.xinitrc_local
fi

exec i3
