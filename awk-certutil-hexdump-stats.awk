# this is awk-certutil-hexdump-stats.awk
# run:
# certutil "CFTC Commitments of Traders Long Report - AG (Combined) - Copy.txt" | gawk.exe -f awk-certutil-hexdump-stats.awk

# certutil output:
#---BEGIN---
#  000000  ...
#  01dd14
#    000000  20 0d 0a 57 48 45 41 54  2d 53 52 57 20 2d 20 43    ..WHEAT-SRW - C
#    000010  48 49 43 41 47 4f 20 42  4f 41 52 44 20 4f 46 20   HICAGO BOARD OF
#	...
#
#    01dd10  0d 0a 0d 0a                                        ....
#CertUtil: -dump command completed successfully.
#---END---

function isAlnum(ch) { return match(ch, /[[:alnum:]]/) != 0}

NR==2 {LAST=$1}
NR>=3 && $1<=LAST {
	S0b = substr($0,13,16*3)
	n=split(S0b, a)
	ntot += n
	for(i=1;i<=n;i++) {
		x=a[i]
		dec = strtonum("0x" x)
		ch = sprintf("%c",dec)
		hex[a[i]]++
		if(isAlnum(ch)) AlnumTot++; else nonAlnumTot++;
		if(dec<32) { nonPrintable++} else printable++
	}
}
END {
	print "hex"	"\t"	"dec"		"\t"	"chr"		"\t"	"cnt"
	for(x in hex) {
		dec = strtonum("0x" x)
		ch = sprintf("%c",dec)
		if(isAlnum(ch)) continue
		if(dec<32) { ch="N/P"}
		printf("%s\t%d\t%s\t%d\n", x, dec, ch, hex[x])	# https://www.asciitable.com/
	}
	print "-"
	print "1.0 totchars: " ntot
	print "2.1 tot [alnum]: " AlnumTot
	print "2.2 tot non[alnum]: " nonAlnumTot
	print "3.1 tot printable: " printable	
	print "3.2 tot non-printable: " nonPrintable
}
