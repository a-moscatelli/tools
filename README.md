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
* m4
  * m4.exe -E -I . test.m4.txt
  * https://www.gnu.org/software/m4/manual/m4.html
* mustache
  * from https://github.com/cbroglie/mustache/releases
  

### Standalone jar files
* winstone = a servlet container / web server with jsp support
  * https://github.com/a-moscatelli/tools/blob/main/Winstone_ServletContainer_GUIDE.html
  * https://github.com/a-moscatelli/tools/blob/main/start_winstone.bat
* h2 = SQL DB
  * https://h2database.com/html/main.html
  * https://mvnrepository.com/artifact/com.h2database/h2/2.1.210

# Modelling
* UML https://www.umlet.com/download/umlet_15_0/umlet-standalone-15.0.0.zip
* yEd (great for autolayout) https://www.yworks.com/products/yed/download
* jreepad (two-pane outliner)
* zim - https://zim-wiki.org/
* wikidpad - http://wikidpad.sourceforge.net/
* https://en.wikipedia.org/wiki/Data-flow_diagram
  * When using UML, the activity diagram typically takes over the role of the data-flow diagram
  * https://www.lucidchart.com/pages/data-flow-diagram
    * https://www.lucidchart.com/pages/data-flow-diagram
* https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model#Crow's_foot_notation
* https://www.uml-diagrams.org/collaboration-diagrams/collaboration.html
* https://en.wikipedia.org/wiki/Communication_diagram
* https://www.javatpoint.com/uml-state-machine-diagram

  

# Other tools
* for sqlite: https://portableapps.com/apps/development/database_browser_portable
* for dot win32: https://gitlab.com/graphviz/graphviz/-/package_files/50095713/download

# databases
* https://bikas-katwal.medium.com/mongodb-vs-cassandra-vs-rdbms-where-do-they-stand-in-the-cap-theorem-1bae779a7a15
* https://phoenixnap.com/kb/nosql-data-modeling
* https://www.bmc.com/blogs/cap-theorem/
* https://betterprogramming.pub/introduction-to-nosql-databases-7f6ed6e055c5
* https://www.freecodecamp.org/news/nosql-databases-5f6639ed9574/
* https://db-engines.com/en/system/Aerospike%3BHBase%3BOracle+NoSQL
* https://www.infoq.com/news/2013/04/NoSQL-Benchmark/

# systems
* https://github.com/karanpratapsingh/system-design
