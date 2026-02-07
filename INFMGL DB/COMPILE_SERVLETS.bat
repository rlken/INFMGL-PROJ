@echo off
echo ==========================================
echo  Compiling Java Servlets for Car Rental
echo ==========================================
echo.

:: First, let's see what's happening
echo Checking for Java...
echo.

:: Try to find javac
where javac
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ==========================================
    echo  Java compiler (javac) not found in PATH!
    echo ==========================================
    echo.
    echo You may need to restart your computer after
    echo installing Java for it to take effect.
    echo.
    echo OR the Java installation did not add itself
    echo to the system PATH automatically.
    echo.
    pause
    exit /b 1
)

echo.
echo Java found! Showing version:
javac -version
echo.

set TOMCAT_LIB=C:\Users\Ken\.rsp\redhat-community-server-connector\runtimes\installations\tomcat-11.0.0-M6\apache-tomcat-11.0.0-M6\lib
set MYSQL_JAR=webapp\WEB-INF\lib\mysql-connector-j-9.6.0.jar
set OUTPUT_DIR=webapp\WEB-INF\classes
set SRC_DIR=src

echo Step 1: Creating output directories...
if not exist "%OUTPUT_DIR%\com\carrental\util" mkdir "%OUTPUT_DIR%\com\carrental\util"
if not exist "%OUTPUT_DIR%\com\carrental\servlet" mkdir "%OUTPUT_DIR%\com\carrental\servlet"
echo Done.

echo.
echo Step 2: Compiling DBConnection.java...
javac -cp "%TOMCAT_LIB%\servlet-api.jar;%MYSQL_JAR%" -d "%OUTPUT_DIR%" "%SRC_DIR%\com\carrental\util\DBConnection.java"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile DBConnection.java
    pause
    exit /b 1
)
echo SUCCESS: DBConnection.java compiled

echo.
echo Step 3: Compiling Servlets...
javac -cp "%TOMCAT_LIB%\servlet-api.jar;%MYSQL_JAR%;%OUTPUT_DIR%" -d "%OUTPUT_DIR%" "%SRC_DIR%\com\carrental\servlet\CarsServlet.java" "%SRC_DIR%\com\carrental\servlet\PackagesServlet.java" "%SRC_DIR%\com\carrental\servlet\BookingServlet.java" "%SRC_DIR%\com\carrental\servlet\TestServlet.java"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile servlets
    pause
    exit /b 1
)
echo SUCCESS: All servlets compiled

echo.
echo ==========================================
echo  Compilation Complete!
echo ==========================================
echo.
echo Next steps:
echo 1. Restart your Tomcat server in VS Code
echo 2. Test: http://localhost:8080/webapp/api/cars
echo.
pause
