#!/bin/bash
###################################################################################
######################### Fixing httpd ############################################

###remove virtualhost section from httpd conf
sed -i '/\<VirtualHost /,/\<\VirtualHost>/d' /etc/httpd/conf/httpd.conf

#add server name derective to config file
sed -i '/NameVirtualHost/a ServerName CustomersServer' /etc/httpd/conf/httpd.conf

#replace tomcat.worker to tomcat-worker
sed -i 's/tomcat.worker/tomcat-worker/g' /etc/httpd/conf.d/workers.properties
sed -i 's/worker-jk@ppname/tomcat-worker/g' /etc/httpd/conf.d/workers.properties
sed -i 's/192.168.56.100/192.168.56.10/g' /etc/httpd/conf.d/workers.properties

#vhost fixing
sed -i 's/tomcat.worker/tomcat-worker/g' /etc/httpd/conf.d/vhost.conf
sed -i 's/mntlab/*/g' /etc/httpd/conf.d/vhost.conf

#restarting httpd
/etc/init.d/httpd restart

###################################################################################
######################### Fixing tomcat ###########################################

#enable tomcat autostart
chkconfig tomcat on

#TODO understand how to use variables as argument for /bin/something as string parameter
#path_to_java=`ls -la /etc/alternatives/ | grep bin/java$ | awk '{print $11}'`
#echo $path_to_java
#alternatives --set java `ls -la /etc/alternatives/ | grep bin/java$ | awk '{print $11}'`
#alternatives --set java "/opt/oracle/java/i586//jdk1.7.0_79/bin/java"

#fix java version problems with alternatives
sudo alternatives --remove java /opt/oracle/java/i586//jdk1.7.0_79/bin/java
sudo alternatives --install /usr/bin/java java /opt/oracle/java/x64//jdk1.7.0_79/bin/java 2000

#fixing log storage problem
chown -R tomcat:tomcat /opt/apache/tomcat/7.0.62/logs/
chmod -R 666 /opt/apache/tomcat/7.0.62/logs/

#start tomcat
/opt/apache/tomcat/7.0.62/bin/startup.sh


###################################################################################
######################### IpTables Settings #######################################
#fixing problems with file attribute
chattr -i /etc/sysconfig/iptables
#adding rules for firewall
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#save iptables settings
service iptables save
