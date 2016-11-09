.PHONEY : all install clean

PROG = hni
LIB  = lib
PREP = prep
TGT  = .
BINDIR = $(TGT)/bin

MV      = mv
SED     = sed
INSTALL = install -c

DEPS = $(PROG).awk $(PREP).h $(LIB).h

all : $(PROG)

$(PROG) : $(PROG).sh $(PROG).awk
	$(SED) '/^#AWK/r '$(PROG).awk $< >$@.o
	$(INSTALL) $@.o $@
	$(RM) $@.o

$(PROG).awk : $(PROG).h $(LIB).h $(PREP).h
	$(SED) -e '/^\\$$/r '$(LIB).h -e '/^ \\$$/r '$(PREP).h $< >$@.o
	$(MV) $@.o $@

$(PREP).h : $(PREP).sh sh.sed
	$(SED) -f sh.sed $< >$@.o
	$(MV) $@.o $@

$(LIB).h : $(LIB).sh sh.sed
	$(SED) -f sh.sed $< >$@.o
	$(MV) $@.o $@

install : $(PROG)
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) $< $(BINDIR)

clean : $(PROG).sh $(DEPS) sh.sed
	$(RM) $(PROG) $(PROG).o $(PROG).awk.o $($PREP).h.o $(LIB).h.o 
	$(RM) $(PROG).awk $(PREP).h $(LIB).h 
