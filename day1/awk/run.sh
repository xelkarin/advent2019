#!/bin/sh

EXECPATH=$(dirname "$0")
DATA="$EXECPATH/../data/input.txt"

exec "$EXECPATH/solve.awk" "$DATA"
