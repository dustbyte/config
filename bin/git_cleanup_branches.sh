#!/bin/sh

#
# Remove branches no longer in remote
#

delete_branches()
{
    [ "$#" -gt 0  ] && git branch -d $*
}

git checkout -q develop 2>&1 > /dev/null
delete_branches $(git branch --merged | egrep -v '^\*|master|develop')
