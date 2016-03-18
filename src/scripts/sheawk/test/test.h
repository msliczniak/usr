#include "test1.h"
'^X  /	\'X$' { P }
END {
	P "'"
	P "\'"
	P "\""
	P n
	P v

	/* trigraphs */
	P "?\?-"
	P "?\
?-"
}
