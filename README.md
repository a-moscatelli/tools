# unix4win

Port of GNU utilities to Windows

* dependent on the ‘msvcrt.dll’ file in the Windows Operating System
* taken from https://sourceforge.net/projects/unxutils/
* alternatives:
  * https://en.wikipedia.org/wiki/MinGW
  * https://en.wikipedia.org/wiki/GnuWin32

examples
* cksum
  * cksum.exe *
* curl
  * curl --ssl-no-revoke https://download.geonames.org/export/dump/cities15000.zip -o cities15000.zip 
* find
  * find.exe \dev -name "*.groovy" -mtime -31
* gawk
  * echo|gawk.exe -v e=L "END{for(i=1;i<=10;i++)print e i}" | gawk "BEGIN{px=0} px==0 && /^L3$/ {px=1} px==1 {print} px==1 && /^L7$/ {px=0}"


