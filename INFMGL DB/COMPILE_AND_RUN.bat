@echo off
setlocal

rem ====================================================
rem  Car Rental System - Compile and Deploy Script
rem ====================================================

rem --- CONFIGURATION ---
rem Auto-detect Tomcat Path
if exist "C:\Ken\Coding\XAMPP\tomcat" (
    set "TOMCAT_HOME=C:\Ken\Coding\XAMPP\tomcat"
    echo [INFO] Detected custom Tomcat path (Ken).
) else if exist "C:\xampp\tomcat" (
    set "TOMCAT_HOME=C:\xampp\tomcat"
    echo [INFO] Detected standard XAMPP Tomcat.
) else (
    echo [ERROR] Could not find Tomcat!
    echo Please edit this file and set TOMCAT_HOME manually.
    pause
    exit /b
)

rem JAVA_HOME should be set automatically by your system.
rem Auto-detect Ken's Java
if exist "C:\Users\Ken\AppData\Local\Programs\Eclipse Adoptium\jdk-25.0.2.10-hotspot" (
    set "JAVA_HOME=C:\Users\Ken\AppData\Local\Programs\Eclipse Adoptium\jdk-25.0.2.10-hotspot"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
    echo [INFO] Detected Ken's JDK.
)


rem -------------------------------------

echo [INFO] Environment Check:
echo JAVA_HOME: %JAVA_HOME%
echo TOMCAT_HOME: %TOMCAT_HOME%

echo [INFO] Killing any existing Java/Tomcat processes...
taskkill /F /IM java.exe /T 2>nul
taskkill /F /IM tomcat8.exe /T 2>nul
if not exist "%TOMCAT_HOME%" (
    echo [ERROR] Tomcat directory still not found at: %TOMCAT_HOME%
    pause
    exit /b
)

echo [INFO] Creating output directory...
if not exist "webapp\WEB-INF\classes" mkdir "webapp\WEB-INF\classes"

echo [INFO] Compiling Java source code...
rem Compiling all java files in src (explicitly listed to avoid wildcard issues with spaces)
javac --release 8 -d "webapp\WEB-INF\classes" ^
    -cp "%TOMCAT_HOME%\lib\servlet-api.jar;webapp\WEB-INF\lib\*" ^
    "src\com\carrental\util\DBConnection.java" ^
    "src\com\carrental\servlet\AdminServlet.java" ^
    "src\com\carrental\servlet\BookingServlet.java" ^
    "src\com\carrental\servlet\CarsServlet.java" ^
    "src\com\carrental\servlet\PackagesServlet.java" ^
    "src\com\carrental\servlet\TestServlet.java"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed!
    pause
    exit /b
)

echo [INFO] Compiling successful. Deploying to Tomcat...

rem Define deployment path - Deploys to /carrental
set "DEPLOY_PATH=%TOMCAT_HOME%\webapps\carrental"

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
echo 1. Start Tomcat via XAMPP Control Panel (Stop/Start if already running).
echo 2. Open your browser to:
echo    http://localhost:8081/carrental/booking.html
echo ====================================================
pause
