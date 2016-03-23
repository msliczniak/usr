# sheawk

shell escape awk script

reads stdin, writes stdout

	@filename\ alone on a line with no whitespace before or after expands

You can use cpp as a first pass, use '' instead of // to prevent preprocessing
within a regex

	/# escapes back to shell until the end of the line

(cpp will not preprocess inside quotes)

Use C /* */ style comments for awk, do not use shell # or C++ // style comments

# building

	$ make -DDEBUG
	$ make -TGT=~ install
	$ cd test; make clean test; cd ..

# gotchas

	@file1\
	@file2\

glues files together, pass args instead:

	@file\
	 v=1

cpp can change whitespace ouside of quotes

	$(CPP) file

may fail if file is not - or does not end .h or .c

/# does not check that quotes balance

for '' regex you need to backslash escape '

do not use trigraphs, inside '' slash escape each question mark, inside "" paste together "?" "?-", otherwise use CPP line continuation:

	?\
	?-

do not use $ in identifier
