all: \
awk2.out.txt

AWK=gawk.exe
AWKPROGRAM=awk1.awk


awk1.out.txt:
	@echo step: prepare file
	$(AWK) -v e=L "BEGIN { for(i=1;i<=10;i++) print e i; exit 0}" > $@

awk2.out.txt: awk1.out.txt
	@echo step: parse file
	$(AWK) -f $(AWKPROGRAM) $< > $@

clean:
	@echo step: clean file
	type awk1.out.txt
	type awk2.out.txt
	del /q awk1.out.txt
	del /q awk2.out.txt



# also available:
# $(wildcard *)
