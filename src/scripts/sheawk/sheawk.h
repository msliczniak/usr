/* NB: no awk style // regex matching containing white space, make will break */

#ifdef	DEBUG
#define	DMSG(x)	printf x >"/dev/stderr"
#else	/* DEBUG */
#define	DMSG(x)	/**/
#endif	/* DEBUG */

/* get next character and increment position */
#define	GETC	c = substr($0, i++, 1)

#define	FORC(e, p)	{ printf("%s", p); \
for (GETC; c != e; GETC) { \
	DMSG((">%s<\n", c)); \
	if (c == "") { \
		printf("sheawk: %d: unmatched %c\n", l, e) >"/dev/tty"; \
		exit 2 \
	}

#define	ENDC(p)	} printf("%s", p) }

/* shell escape single quote */
#define	SESQ	\
if (c == "'") { \
	printf("'\\''"); \
	continue \
}

/* shell escape quote */
#define	QUOT(e, p) \
if (c == e) \
\
FORC(e, p) \
SESQ \
\
/* backslash escaped character? */ \
else if (c == "\\") { \
	printf("\\"); \
\
	GETC; \
	SESQ; \
\
	printf("%s", c); \
	continue \
} \
\
else printf("%s", c) \
\
ENDC(p)

/^@.*\\/ {
	n = substr($0, 2, length() - 2)

	printf("'")

	l = 0	/* line number */
	while ((getline <n) == 1) {
		l++; s = -1; i = 1
		DMSG(("%d: %s\n", l, $0))
		if (substr($1, 1, 1) == "#") continue

		FORC("", "")

			if (c == "#") {
				/* 
				 * Remove awk-style comments preceded by whitesp
				 * to prevent people from using a quirk of older
				 * versions of cpp to output awk style comments
				 * which contemporary versions of cpp rightfully
				 * stop preprocesing and exit with an error when
				 * encountered.
				 */
				if (s != 0) {
					print ""
					break
				}

				printf("#")
				continue
			} else s = index(FS, c)

			/* inside double quotes? */
			QUOT("\"", "\"")

			/* inside single quotes? */
			else

			QUOT("'", "/")

			/* escape to shell until end of line? */
			else if (c == "/") {
				GETC

				if (c == "#")

				FORC("", "'")

				printf("%s", c)

				ENDC("'\\")

				else printf("/%s", c)
			}

			else printf("%s", c)


		ENDC("")

		print ""
	}

	print "' \\"
	next
}

{ print }
