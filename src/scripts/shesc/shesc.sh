#!/bin/sh

# shell escape

case $# in
  1)
	;;
  *)
	echo "Usage: $0 file" >&2
	exit 2
esac

exec /usr/bin/awk \
-f shesc.awk \
n="$1"
