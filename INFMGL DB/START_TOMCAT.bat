@echo off
setlocal

rem ====================================================
rem  Start Tomcat Manually (With Auto-Cleanup)
rem ====================================================

rem 1. Kill Zombies
echo [INFO] Cleaning up old processes...
taskkill /F /IM java.exe /T 2>nul
taskkill /F /IM tomcat8.exe /T 2>nul

rem 2. Set Java Home
rem 2. Set Java Home (Optional - System default used if not set)
rem Auto-detect Ken's Java
if exist "C:\Users\Ken\AppData\Local\Programs\Eclipse Adoptium\jdk-25.0.2.10-hotspot" (
    set "JAVA_HOME=C:\Users\Ken\AppData\Local\Programs\Eclipse Adoptium\jdk-25.0.2.10-hotspot"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
    echo [INFO] Detected Ken's JDK.
)
rem set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0_202"

rem 3. Set Tomcat Home
rem Auto-detect Tomcat Path
if exist "C:\Ken\Coding\XAMPP\tomcat" (
    set "CATALINA_HOME=C:\Ken\Coding\XAMPP\tomcat"
) else if exist "C:\xampp\tomcat" (
    set "CATALINA_HOME=C:\xampp\tomcat"
) else (
    echo [ERROR] Could not find Tomcat!
    echo Please edit this file and set CATALINA_HOME manually.
    pause
    exit /b
)

echo [INFO] Starting Tomcat...
if not exist "%CATALINA_HOME%\bin\startup.bat" (
    echo [ERROR] Cannot find startup.bat at %CATALINA_HOME%\bin\startup.bat
    pause
    exit /b
)

call "%CATALINA_HOME%\bin\startup.bat"

echo.
echo [INFO] Startup command executed.
echo [INFO] Wait 15 seconds, then check:
echo http://localhost:8081/carrental/booking.html
echo.
pause
