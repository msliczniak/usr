$0 == ("-f " n " \\") {
	printf("'")

	while ((getline < n) > 0) {
		gsub(/'/, "'\\''")
		print
	}

	print "' \\"

	next
}

{ print }
