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
  * echo|gawk.exe "END{for(i=1;i<=10;i++){print i}}" | gawk "BEGIN{pr=0} pr==0 && /^3$/ {pr=1} pr==1 {print} pr==1 && /^7$/ {pr=0}  END{print \"done\"}"


