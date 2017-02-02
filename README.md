
###Report table
|   |  Issue  |  How to find  |  Time to find  |  How to fix  |  Time to fix  |
|---|---|---|---|---|---|
| 1 |Page redirected to: http://mntlab|Trying to receive responce from server by curl with ip address which setupped in Vagrant file.|1min| We should find Apache(httpd) config and remove redirect from defenition. We should looking for Apache config because we received server in responce. [Server: Apache]  | 20min  |
| 2 |Request didn't go to tomcat application server.|We received index.html page defined in httpd.conf with curl.|1min| We should check mod_jk log files and mod_jk configuration. In mod_jk logs we see that mod_jk cant initialize normally. Here we will see that "worker" named wrong. We cant use dots in workers names. And worker template included to wrong worker. After fixing this problem we should check config where we link our request with worker. There workers has wrong names to. | 40min 
| 3 | After previous fix we received custom error page.  | Send curl request to server ip adress. We received 503 error. It means that service tomcat where we send our requests unavailable. After checking ports we could see that defined ports for tomcat not listening. It means that tomcat server not started.  | 10min  |  Start tomcat server with service tomcat start. We received message [Starting Tomcat OK]  |1min|
|4||||||
