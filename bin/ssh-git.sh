#!/bin/sh

if [ -z "$PKEY" ]; then\
    ssh "$@"
else
    ssh -i "$PKEY" "$@"
fi
