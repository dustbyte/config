#!/bin/sh

xset -b&

if [ `which xmodmap` ]
then
    xmodmap ~/.Xmodmap&
fi

if [ -f ~/.xinitrc_local ]; then
    sh ~/.xinitrc_local
fi

exec i3
