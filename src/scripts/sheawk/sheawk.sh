#!/bin/sh

# shell escape from stdin to stdout

case $# in
  0)
	;;
  *)
	echo "Usage: $0" >&2
	exit 2
esac

exec /usr/bin/awk -F' 	' \
@sheawk.awk\

