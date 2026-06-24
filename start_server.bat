@echo off
title MyShop v2.0 Server
cd /d D:\MYSHOP
echo Starting MyShop Server...
set JAVA_HOME=D:\MYSHOP\jdk8
set CATALINA_HOME=D:\MYSHOP\tomcat9
taskkill /f /im java.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start "Tomcat" /MIN cmd /c "set JAVA_HOME=D:\MYSHOP\jdk8 && set CATALINA_HOME=D:\MYSHOP\tomcat9 && D:\MYSHOP\tomcat9\bin\catalina.bat run"
timeout /t 12 /nobreak >nul
start http://localhost:8080/
echo MyShop running at http://localhost:8080/
pause
