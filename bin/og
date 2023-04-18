#!/bin/sh

if [ $# -lt 1 ]; then
    echo "$0 path [line_number]" >&2
    exit 1
fi

file_path=$(git ls-files --full-name $1)
line_number=$2
branch=$(git rev-parse --abbrev-ref HEAD)
tracked=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "The branch $branch is not tracked by a remote"
  exit 1
fi

url=$(git remote get-url $(echo $tracked | cut -d / -f 1))

if [ "$line_number" != "" ]; then
  line_number="#L$line_number"
fi

if echo $url | grep '@' > /dev/null ; then
  url="https://$(echo $url | cut -d @ -f 2 | sed 's/\.git$//g' | sed 's/:/\//g')"
fi

open "$url/blob/${branch}/${file_path}${line_number}"
