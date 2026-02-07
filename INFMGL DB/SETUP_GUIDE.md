# Car Rental System - Setup Guide

## Quick Start (For Ken's Groupmates)

### Prerequisites
1. **XAMPP** installed to `C:\xampp` with **Tomcat** component
2. **Java JDK 8+** installed (set as `JAVA_HOME` in system environment variables)

### Step-by-Step Setup

#### 1. Database Setup
1. Open XAMPP Control Panel and start **MySQL**.
2. Go to `http://localhost/phpmyadmin`.
3. Click **New** → Create database named `car_rental_travel_agency`.
4. Click **Import** tab → Choose `database/car_rental_travel_agency.sql` → Click **Go**.

#### 2. Configure Tomcat Port
The project uses port **8081**. Edit your Tomcat config:
1. Open `C:\xampp\tomcat\conf\server.xml` in a text editor.
2. Find `<Connector port="8080"` and change `8080` to `8081`.
3. Save the file.

#### 3. Compile and Deploy
1. Double-click **`COMPILE_AND_RUN.bat`**.
2. Wait for "DEPLOYMENT COMPLETE" message.

#### 4. Start Tomcat
1. Double-click **`START_TOMCAT.bat`**.
2. Wait for "Server startup in [X] ms" message (keep window open).

#### 5. Access the Application
Open browser: **http://localhost:8081/carrental/booking.html**

---

## Troubleshooting

### "Could not find Tomcat" Error
Edit `COMPILE_AND_RUN.bat` and `START_TOMCAT.bat`:
- Find the "Auto-detect Tomcat Path" section
- Add your Tomcat path, e.g.: `set "TOMCAT_HOME=C:\your\path\to\tomcat"`

### "JAVA_HOME not defined" Error
1. Right-click **This PC** → **Properties** → **Advanced system settings**.
2. Click **Environment Variables**.
3. Add new System Variable:
   - Name: `JAVA_HOME`
   - Value: Your JDK path (e.g., `C:\Program Files\Java\jdk1.8.0_xxx`)

### "Error loading cars" on Booking Page
Make sure **MySQL is running** in XAMPP Control Panel.

### Port 8081 Already in Use
Close any other apps using port 8081, or use `START_TOMCAT.bat` which auto-kills conflicting processes.

---

## Project Structure
```
INFMGL DB/
├── src/                    # Java source code
├── webapp/                 # Web files (HTML, CSS, JS)
│   └── WEB-INF/
│       ├── classes/        # Compiled Java classes
│       ├── lib/            # JAR dependencies
│       └── web.xml         # Servlet configuration
├── database/               # SQL files
├── COMPILE_AND_RUN.bat     # Build and deploy script
├── START_TOMCAT.bat        # Start Tomcat server
└── SETUP_GUIDE.md          # This file
```
