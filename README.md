###Report table
|   |  Issue  |  How to find  |  Time to find  |  How to fix  |  Time to fix  |
|---|---|---|---|---|---|
|1|Page redirected to: http://mntlab|Trying to receive responce from server by curl with ip address which setupped in Vagrant file.|1min|We should find Apache(httpd) config and remove redirect from defenition. We should looking for Apache config because we received server in responce. [Server: Apache]|20min|
|2|Request didn't go to tomcat application server.|We received index.html page defined in httpd.conf with curl.|1min| We should check mod_jk log files and mod_jk configuration. In mod_jk logs we see that mod_jk cant initialize normally. Here we will see that "worker" named wrong. We cant use dots in workers names. And worker template included to wrong worker. After fixing this problem we should check config where we link our request with worker. There workers has wrong names to.|40min| 
|3|After previous fix we received custom error page.|Send curl request to server ip adress. We received 503 error. It means that service tomcat where we send our requests unavailable. After checking ports we could see that defined ports for tomcat not listening. It means that tomcat server not started.|10min|Start tomcat server with service tomcat start. We received message [Starting Tomcat OK]|1min|
|4|We received custom error page with curl.|After receiving message that tomcat is started we check listening ports with ps -ef. How we can see tomcat not listen ports. We check tomcat start-stop script. It contains mistakes.|60min|Tomcat start-stop script output disabled with > /dev/null. And any case return success result. So this script will allways return success code and nothing more. We remove from this script wrong values.|50min|
|5|After starting tomcat server error message appears. Cannot find /tmp/bin/setclasspath.sh|Try to start tomcat manually. And find dependencies about error we received.|90min|After investigation detected that tomcat runs under user named tomcat and this user had predefined path variables in .bashrc. We comment defenition ot this variables to use globally defined variables.|60min|
|6|Error message on start tomcat received.|After starting tomcat server we received error message that catalina have no access to logs directory. Check owner of log directory.|60min|Set owner of log directory to tomcat.|20min|
|7|503 error still appears.|Checking log files. Catalina out error. Cant find ELF interpreter. No such file or directory. Check java version with alternatives.|60min|Check paths to java. Change java version to needed by alternatives.|60min|
|8|Curl pages return fine. But custom errors not returned. Tomcat returns default error page.|Try to curl wrong location which not exists.|60min|To send errors from tomcat to apache we should use use_server_errors parameter with mount worker.|60min|

###Additional Questions:
1. What java version is installed?
   * java -version
   * java version "1.7.0_79"
   * Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
   * Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)
2. How was it installed and configured?
   * sudo yum install -y 1.7
3. Where are log files of tomcat and httpd?
   * tomcat : /opt/apache/tomcat/7.0.62/logs
   * httpd :  /var/log/httpd
4. Where is JAVA_HOME and what is it?
   * The JAVA_HOME environment variable points to the directory where the Java runtime environment (JRE) is installed on your computer.
5. Where is tomcat installed?
   * tomcat : /opt/apache/tomcat/7.0.62/
6. What is CATALINA_HOME?
   * The variable CATALINA_HOME is a configuration property that stores the location of the Catalina files.
7. What users run httpd and tomcat processes? How is it configured?
  * httpd: Main process runned under root child processes under apache
  * ps -ef | grep httpd
  * root      7915     1  0 01:49 ?        00:00:00 /usr/sbin/httpd
  * apache    7919  7915  0 01:49 ?        00:00:00 /usr/sbin/httpd
  * ---------------------------------------------------------------------
  * tomcat: Process runned under user tomcat
  * ps -ef | grep tomcat
  * tomcat 7977     1  0 01:49 ?        00:00:06 /usr/bin/java
8. What configuration files are used to make components work with each other?
   * vhost.conf workers.properties
9. What does it mean: “load average: 1.18, 0.95, 0.83”?
   * The load average represents the average system load over a period of time. It conventionally appears in the form of three numbers      * which represent the system load during the last one, five, and fifteen minute periods.
