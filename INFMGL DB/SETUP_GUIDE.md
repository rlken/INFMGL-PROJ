# Car Rental System - Setup Guide

This guide will help you set up and run the Car Rental & Travel Agency System with XAMPP.

## 1. Install & Configure XAMPP
XAMPP includes Apache (Web Server), MySQL (Database), and Tomcat (Java Server), making it the easiest way to run this project.

1. **Download XAMPP**:
   - Go to [apachefriends.org](https://www.apachefriends.org/download.html)
   - Download the version with **PHP 8.2** (or latest).
2. **Install**:
   - Run the installer.
   - **Important**: In the component selection screen, ensure **Tomcat** is checked (under Program Languages).
   - Install to `C:\xampp`.
3. **Start Servers**:
   - Open **XAMPP Control Panel**.
   - Start **Apache** and **MySQL**.
   - Start **Tomcat**.

## 2. Database Setup
1. Open your browser and go to `http://localhost/phpmyadmin`.
2. Click **New** on the sidebar.
3. Create a database named `car_rental_travel_agency`.
4. Click the **Import** tab.
5. Choose file: `database/car_rental_travel_agency.sql`.
6. Click **Import** (or **Go**) at the bottom.

## 3. Compile and Deploy
We have provided a script `COMPILE_AND_RUN.bat` to automate this.

### Configuration
1. Open `COMPILE_AND_RUN.bat` in a text editor (Right-click -> Edit).
2. Set the `TOMCAT_HOME` variable to your XAMPP Tomcat path.
   - For XAMPP, this is usually:
     `set TOMCAT_HOME=C:\xampp\tomcat`
   - If you installed Tomcat separately, point it there.

### Running
1. Double-click `COMPILE_AND_RUN.bat`.
2. The script will:
   - Compile the Java source code.
   - Deploy the files to your Tomcat server.
3. If Tomcat was already running, it might reload automatically. If not, click **Stop** then **Start** on Tomcat in the XAMPP Control Panel.

## 4. Access the Application
Go to: `http://localhost:8080/carrental/booking.html`

## Troubleshooting
- **404 Not Found**: Ensure Tomcat is running in XAMPP (Green status).
- **Database Error**: Ensure MySQL is running in XAMPP.
- **Port Conflicts**: If Apache won't start, Skype or VMware might be using port 80. Quit those apps or configure Apache to use port 8080 (but Tomcat serves the app, so Apache is mainly for phpMyAdmin).
