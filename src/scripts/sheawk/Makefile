.PHONY : all install clean

PROG = sheawk
TGT  = .
BINDIR = $(TGT)/bin

INSTALL = install -c
MV = mv

all : $(PROG)

$(PROG).awk : $(PROG).h
	$(CPP) $(CPPFLAGS) $< >$(PROG).ho
	$(MV) $(PROG).ho $@

$(PROG) : $(PROG).awk $(PROG).sh
	/usr/bin/awk -f $< <$@.sh >$@.sho
	$(INSTALL) $@.sho $@
	$(RM) $@.sho

install : $(PROG)
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) $< $(BINDIR)

clean : $(PROG).h $(PROG).sh
	$(RM) $(PROG) $(PROG).awk $(PROG).ho $(PROG).sho
