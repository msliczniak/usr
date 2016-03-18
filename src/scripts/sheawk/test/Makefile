.PHONY : all clean

PROG = test

MV = mv

all : $(PROG).txt

$(PROG).txt : $(PROG) $(PROG).ver $(PROG).out
	cmp $<.out $<_std.out
	touch $@

$(PROG).awk : $(PROG).h $(PROG)1.h
	$(CPP) $(CPPFLAGS) $< >$(PROG).ho
	$(MV) $(PROG).ho $@

$(PROG)0.awk : $(PROG)0.h
	$(CPP) $(CPPFLAGS) $< >$(PROG)0.ho
	$(MV) $(PROG)0.ho $@

$(PROG) : $(PROG).awk  $(PROG)0.awk $(PROG).sh
	../sheawk <$@.sh >$@.sho
	$(MV) $@.sho $@

# generate all tokens with blank line separating each line
$(PROG).tok : $(PROG)
	/usr/bin/awk '{ for (i = 1; i <= NF; i++) print $$i; print "" }' $< >$@

$(PROG).ver : $(PROG).tok
	cmp $(PROG).tok $(PROG)_std.tok
	touch $@

# generate output
$(PROG).out : $(PROG) $(PROG).ver
	echo "X  /	'X" | /bin/sh $< >$@

clean : $(PROG).h $(PROG).sh $(PROG)_std.tok $(PROG)_std.out \
  $(PROG)0.h $(PROG)1.h
	$(RM) $(PROG) $(PROG).awk $(PROG).ho $(PROG).sho \
	  $(PROG)0.awk $(PROG)0.ho \
	  $(PROG).txt $(PROG).out $(PROG).tok $(PROG).ver
