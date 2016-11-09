BEGIN {
	s = "/bin/sh"; v = "00000"; a = "0001"

	print \
\
	  |s
}

NR == 1 {
	printf("t=%s; d=%s\n", t, d) |s
	print \
 \
	  |s
}

/[Ss][Ee][Gg][Mm][Ee][Nn][Tt]/ {
	if (0 != vi = match($0, /\/([0-9]{5})v/)) {
		# video
		vi = substr($0, vi + 1, 5)
		#print v, vi

		if (vi != v) {
			print "\nv", substr(v,1,4), substr(v,5,1) |s
			vn++; v = vi
		}
	} else if (0 != ai =  match($0, /\/([0-9]{4})a/)) {
		# audio
		ai = substr($0, ai + 1, 4)
		#print a, ai

		if (ai != a) {
			an++; al = a; a = ai
		}
	} else {
		next
	}

	if (vn >= 10 && an >= 1) {
		vn -= 10; an--
		print "\na", al |s
		al = ai
	}
}

END {
	print "\nv", substr(vi,1,4), substr(vi,5,1), "; a", al |s
}
