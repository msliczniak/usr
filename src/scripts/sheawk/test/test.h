#define	P	print
BEGIN {
v = /#"$k"
",bar,baz"
}
'^XXX$' { P }
END {
	P "'"
	P "\'"
	P "\""
	P n
}
