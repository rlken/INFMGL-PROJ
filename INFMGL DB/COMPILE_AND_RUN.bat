@echo off
setlocal

rem ====================================================
rem  Car Rental System - Compile and Deploy Script
rem ====================================================

rem --- CONFIGURATION: EDIT THIS PATH ---
rem Point this to your Apache Tomcat installation folder
set TOMCAT_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1

rem -------------------------------------

echo [INFO] Checking Tomcat path...
if not exist "%TOMCAT_HOME%" (
    echo [ERROR] Tomcat directory not found at: %TOMCAT_HOME%
    echo [ACTION] Please edit this script (Right-click -> Edit) and set TOMCAT_HOME to your Tomcat folder.
    pause
    exit /b
)

echo [INFO] Creating output directory...
if not exist "webapp\WEB-INF\classes" mkdir "webapp\WEB-INF\classes"

echo [INFO] Compiling Java source code...
rem Compiling all java files in src. 
rem Classpath includes Tomcat's servlet-api.jar and project libs.
javac -d "webapp\WEB-INF\classes" ^
    -cp "%TOMCAT_HOME%\lib\servlet-api.jar;webapp\WEB-INF\lib\*" ^
    src\com\carrental\util\*.java ^
    src\com\carrental\servlet\*.java

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed!
    pause
    exit /b
)

echo [INFO] Compiling successful. Deploying to Tomcat...

rem Define deployment path
set DEPLOY_PATH=%TOMCAT_HOME%\webapps\carrental

rem Clean old deployment if exists
if exist "%DEPLOY_PATH%" (
    echo [INFO] Removing old deployment...
    rmdir /s /q "%DEPLOY_PATH%"
)

rem Copy webapp content
echo [INFO] Copying files to %DEPLOY_PATH%...
xcopy /s /e /y "webapp\*" "%DEPLOY_PATH%\" > nul

echo.
echo ====================================================
echo  DEPLOYMENT COMPLETE
echo ====================================================
echo 1. If Tomcat is running, it may auto-reload. 
echo    If not, restart Tomcat via XAMPP or bin\startup.bat.
echo 2. Open your browser to:
echo    http://localhost:8080/carrental/booking.html
echo ====================================================
pause
