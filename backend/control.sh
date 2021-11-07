#!/bin/bash
if [ $1 == size ] ; then
    ls -lh $2 | awk '{print $5}'
    exit
fi
if [ $# -eq 1 ] ; then
    python3 $1 &
fi
if [ $# -eq 2 ] ; then
    python3 $1 $2 &
fi
if [ $# -eq 3 ] ; then
    python3 $1 $2 $3 &
fi
