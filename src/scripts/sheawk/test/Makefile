.PHONY : all clean

PROG = test

MV = mv

all : $(PROG).txt

$(PROG).txt : $(PROG) $(PROG).ver $(PROG).out
	cmp $<.out $<_std.out
	touch $@

$(PROG).awk : $(PROG).h
	$(CPP) $(CPPFLAGS) $< >$(PROG).ho
	$(MV) $(PROG).ho $@

$(PROG) : $(PROG).awk $(PROG).sh
	../sheawk <$@.sh >$@.sho
	$(MV) $@.sho $@

# generate all tokens with blank line separating each line
$(PROG).tok : $(PROG)
	/usr/bin/awk '{ for (i = 1; i <= NF; i++) print $i; print "" }' $< >$@

$(PROG).ver : $(PROG).tok
	cmp $(PROG).tok $(PROG)_std.tok
	touch $@

# generate output
$(PROG).out : $(PROG) $(PROG).ver
	echo XXX | /bin/sh $< >$@

clean : $(PROG).h $(PROG).sh $(PROG)_std.tok $(PROG)_std.out
	$(RM) $(PROG) $(PROG).awk $(PROG).ho $(PROG).sho \
	  $(PROG).txt $(PROG).out $(PROG).tok $(PROG).ver
