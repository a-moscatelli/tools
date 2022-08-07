set JAVA_HOME=M:\APPS\openjdk8
set JAR=winstone-0.9.10.jar
set "OPTS1=--webroot=. --httpsPort=-1 --httpPort=8084"
set "OPTS2=--ajp13Port=-1 --controlPort=-1 --mimeTypes=csv=text/csv:gz=application/gzip"
%JAVA_HOME%\bin\java -jar %JAR% %OPTS1% %OPTS2%
