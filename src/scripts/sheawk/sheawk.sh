#!/bin/sh

# shell escape from stdin to stdout

case $# in
  0)
	;;
  *)
	echo "Usage: $0" >&2
	exit 2
esac

# getline in solaris awk cannot read from another file
AWK='/usr/bin/nawk'
[ -x "$AWK" ] || AWK='/usr/bin/awk'

exec "$AWK" -F' 	' \
@sheawk.awk\

