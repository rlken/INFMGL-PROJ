@echo off
echo ===================================================
echo      Informatics Fix & Deploy Script
echo ===================================================
echo.
echo [1/3] Copying Compiled Classes to WebApp...
xcopy "bin\com" "webapp\WEB-INF\classes\com" /E /I /Y
if %errorlevel% neq 0 (
    echo [ERROR] Failed to copy classes. Make sure you built the project in VS Code.
    pause
    exit /b
)

echo [2/3] Copying Libraries...
xcopy "lib\*.jar" "webapp\WEB-INF\lib\" /Y

echo [3/3] Updating Timestamp to force reload...
copy /b "webapp\WEB-INF\web.xml" +,, "webapp\WEB-INF\web.xml"

echo.
echo ===================================================
echo     DEPLOYMENT FILES UPDATED SUCCESSFULLY
echo ===================================================
echo.
echo NOW YOU MUST RESTART THE SERVER IN VS CODE:
echo 1. Look at the "Servers" view in VS Code (bottom left).
echo 2. Right-Click your "Apache Tomcat" server.
echo 3. Click "Restart Server" (or Stop then Start).
echo 4. Refresh your website.
echo.
pause
