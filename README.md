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
  * gawk.exe -v e=L "BEGIN{for(i=1;i<=10;i++)print e i; exit 0}" | gawk.exe -f awk1.awk
  * using https://github.com/a-moscatelli/unix4win/blob/main/awk1.awk
  * expected output: L3 L4 L5 L6 L7
* make
  * make
  * make clean
  * based on https://github.com/a-moscatelli/unix4win/blob/main/Makefile
* M4
  * m4.exe -E -I . test.m4.txt
  * https://www.gnu.org/software/m4/manual/m4.html

### Standalone jar files
* jreepad = a two-pane outliner
* winstone = a servlet container / web server with jsp support
  * https://github.com/a-moscatelli/tools/blob/main/Winstone_ServletContainer_GUIDE.html
  * https://github.com/a-moscatelli/tools/blob/main/start_winstone.bat
* h2
  * https://h2database.com/html/main.html
  * https://mvnrepository.com/artifact/com.h2database/h2/2.1.210

# Modelling
* UML https://www.umlet.com/download/umlet_15_0/umlet-standalone-15.0.0.zip
* yEd (great for autolayout) https://www.yworks.com/products/yed/download
* jreepad (two-pane outliner)
* zim - https://zim-wiki.org/
* wikidpad - http://wikidpad.sourceforge.net/


