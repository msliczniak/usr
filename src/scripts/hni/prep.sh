# stat missing on aix, hpux, and solaris
m="`/usr/bin/env - LC_ALL=C POSIXLY_CORRECT= /usr/bin/pr "$t"/j | /usr/bin/awk '
NR == 3 {
	if (NF < 4) exit 1

	a["Jan"] = 1;  a["Feb"] = 2;  a["Mar"] = 3
	a["Apr"] = 4;  a["May"] = 5;  a["Jun"] = 6
	a["Jul"] = 7;  a["Aug"] = 8;  a["Sep"] = 9
	a["Oct"] = 10; a["Nov"] = 11; a["Dec"] = 12

	printf("%04d:%02d:%02d %s:00", $4, a[$1], $2, $3)

	exit 0
}'`"

# 00000000: ffd8                                     ..
#
# 00000002: ffe0 0010 4a46 4946 0001 0100 0001 0001  ....JFIF........
# 00000012: 0000                                     ..
#
# 00000014: ffe1 0076 4578 6966 0000 4d4d 002a 0000  ...vExif..MM.*..
# 00000024: 0008 0005 011a 0005 0000 0001 0000 004a  ...............J
# 00000034: 011b 0005 0000 0001 0000 0052 0128 0003  ...........R.(..
# 00000044: 0000 0001 0001 0000 0132 0002 0000 0014  .........2......
# 00000054: 0000 005a 0213 0003 0000 0001 0001 0000  ...Z............
# 00000064: 0000 0000 0000 0001 0000 0001 0000 0001  ................
# 00000074: 0000 0001 3230 3136 3a31 303a 3231 2032  ....2016:10:21 2
# 00000084: 313a 3130 3a31 3900                      1:10:19.
# 0000008c: ffdb                                     ..
#
# ...
</dev/null /usr/bin/awk 'BEGIN {
  printf("%c%c%c%c%c%c%c%c%c%c", 255, 216, 255, 224, 0, 16, 74, 70, 73, 70)
  printf("%c%c%c%c%c%c%c%c%c%c",   0,   1,   1,   0, 0,  1,  0,  1,  0,  0)
  exit
}' >"$t"'/j' || bail

case "$m" in
  [0-9][0-9][0-9][0-9]:[01][0-9]:[0-3][0-9]' '[0-2][0-9]:[0-5][0-9]:[0-5][0-9])
	echo | /usr/bin/awk 'BEGIN {
  	  printf("%c%c%c%c",         255, 225,   0, 118)
  	  printf("%c%c%c%c%c%c%c%c",  69, 120, 105, 102,   0,   0,  77,  77)
  	  printf("%c%c%c%c%c%c%c%c",   0,  42,   0,   0,   0,   8,   0,   5)
  	  printf("%c%c%c%c%c%c%c%c",   1,  26,   0,   5,   0,   0,   0,   1)
  	  printf("%c%c%c%c%c%c%c%c",   0,   0,   0,  74,   1,  27,   0,   5)
  	  printf("%c%c%c%c%c%c%c%c",   0,   0,   0,   1,   0,   0,   0,  82)
  	  printf("%c%c%c%c%c%c%c%c",   1,  40,   0,   3,   0,   0,   0,   1)
  	  printf("%c%c%c%c%c%c%c%c",   0,   1,   0,   0,   1,  50,   0,   2)
  	  printf("%c%c%c%c%c%c%c%c",   0,   0,   0,  20,   0,   0,   0,  90)
  	  printf("%c%c%c%c%c%c%c%c",   2,  19,   0,   3,   0,   0,   0,   1)
  	  printf("%c%c%c%c%c%c%c%c",   0,   1,   0,   0,   0,   0,   0,   0)
  	  printf("%c%c%c%c%c%c%c%c",   0,   0,   0,   1,   0,   0,   0,   1)
  	  printf("%c%c%c%c%c%c%c%c",   0,   0,   0,   1,   0,   0,   0,   1)
	}
	{ printf("%s%c", m, 0); exit }' m="$m" >>"$t"'/j' || bail
esac

unset m
