
rem to start a H2 server, inmemory or persistent SQL DBMS (the default db shipped with Spring Boot)

SET JAVA_HOME=%JAVA_HOME%

echo starting H2SERVER

SET H2JAR=groovy-2.5.6\lib\h2-2.1.214.jar
rem taken from https://mvnrepository.com/artifact/com.h2database/h2/2.1.214

set H2PORT=9092
rem (default: 9092)

goto console_access_allowed_from_local_IP

:console_access_allowed_from_local_IP
%JAVA_HOME%\bin\java -cp %H2JAR% org.h2.tools.Server -tcp -ifNotExists -tcpPort %H2PORT% -web -baseDir .
goto theend
 :console_access_allowed_from_any_IP
%JAVA_HOME%\bin\java -cp %H2JAR% org.h2.tools.Server -tcp -ifNotExists -tcpPort %H2PORT% -web -baseDir . -webAdminPassword saam -webAllowOthers
goto theend
:print_help
%JAVA_HOME%\bin\java -cp %H2JAR% org.h2.tools.Server -?

rem TCP server running at tcp://10.62.111.24:9092 (only local connections)
rem Web Console server running at http://10.62.111.24:8082 (only local connections)

:theend
