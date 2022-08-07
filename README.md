# Tools
### Port of GNU utilities to Windows

* dependent on the ‘msvcrt.dll’ file in the Windows Operating System
* taken from https://sourceforge.net/projects/unxutils/
* alternatives: https://en.wikipedia.org/wiki/MinGW - https://en.wikipedia.org/wiki/GnuWin32
#### examples
* cksum
  * cksum.exe *
* curl
  * curl --ssl-no-revoke https://download.geonames.org/export/dump/cities15000.zip -o cities15000.zip 
* find
  * find.exe \dev -name "*.groovy" -mtime -31
* gawk
  * echo|gawk.exe -v e=L "END{for(i=1;i<=10;i++)print e i}" | gawk.exe -f awk1.awk
  * using https://github.com/a-moscatelli/unix4win/blob/main/awk1.awk
  * expected output: L3 L4 L5 L6 L7
* make
  * make
  * make clean
  * based on https://github.com/a-moscatelli/unix4win/blob/main/Makefile
### Standalone jar files
* jreepad = a two-pane outliner
* winstone = a servlet container / web server with jsp support
  * https://github.com/a-moscatelli/tools/blob/main/Winstone_ServletContainer_GUIDE.html
  * https://github.com/a-moscatelli/tools/blob/main/start_winstone.bat

