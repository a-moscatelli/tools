all: awk1.out.txt awk2.out.txt

awk1.out.txt:
	@echo step: prepare file
	type | gawk.exe -v e=L "END{for(i=1;i<=10;i++)print e i}" > awk1.out.txt

awk2.out.txt:
	@echo step: parse file
	gawk.exe -f awk1.awk awk1.out.txt > awk2.out.txt

clean:
	@echo step: clean file
	type awk1.out.txt
	type awk2.out.txt
	del /q awk1.out.txt
	del /q awk2.out.txt


