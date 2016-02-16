.PHONY : install clean

PROG = shesc
TGT  = .

INSTALL = install -c

$(PROG) : Makefile $(PROG).sh $(PROG).awk
	/usr/bin/awk -f $(PROG).awk n=$(PROG).awk <$(PROG).sh >$(PROG)
	$(INSTALL) $(PROG) .

install : Makefile $(PROG) $(TGT)
	$(INSTALL) $(PROG) $(TGT)

clean : Makefile $(PROG).awk $(PROG).sh
	$(RM) $(PROG)
