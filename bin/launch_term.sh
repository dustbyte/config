#!/bin/sh

which konsole 2>&1 > /dev/null && konsole || xterm
