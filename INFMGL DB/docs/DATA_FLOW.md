# TravelWheels Car Rental System - Data Flow Documentation

## System Architecture Overview

This document explains how the Travel Agency Car Rental Booking Website works, specifically how data flows from the website to the database through Java Servlets.

```
┌─────────────────┐     HTTP      ┌─────────────────┐     JDBC      ┌─────────────────┐
│                 │   Request     │                 │    Query      │                 │
│  Web Browser    │ ───────────▶  │  Apache Tomcat  │ ───────────▶  │     MySQL       │
│  (HTML/CSS/JS)  │               │  (Java Servlet) │               │    Database     │
│                 │ ◀───────────  │                 │ ◀───────────  │                 │
│                 │   Response    │                 │    Results    │                 │
└─────────────────┘              └─────────────────┘              └─────────────────┘
      Frontend                       Backend                         Database
```

---

## Key Principle: No Direct Database Connection from Website

The website (HTML/JavaScript) **NEVER** connects directly to the MySQL database. All database operations go through Java Servlets:

1. **Frontend** → Sends HTTP requests to the server
2. **Servlet** → Receives requests, processes data, connects to database
3. **Database** → Stores and retrieves data
4. **Servlet** → Sends response back to frontend
5. **Frontend** → Displays the result to user

---

## Detailed Data Flow

### 1. Loading Available Cars (GET Request)

When booking.html loads:

```
booking.html                CarsServlet             MySQL
    │                           │                     │
    │  fetch('/api/cars')       │                     │
    │ ────────────────────────▶ │                     │
    │                           │  SELECT * FROM cars │
    │                           │  WHERE status =     │
    │                           │  'Available'        │
    │                           │ ──────────────────▶ │
    │                           │                     │
    │                           │ ◀────────────────── │
    │                           │   (car records)     │
    │ ◀──────────────────────── │                     │
    │   JSON: [{car_id: 1,      │                     │
    │          brand: "Toyota", │                     │
    │          ...}]            │                     │
    │                           │                     │
    ▼ Populates car dropdown    │                     │
```

**Code Path:**
- `booking.html` → JavaScript `fetch('api/cars')`
- `CarsServlet.doGet()` → `DBConnection.getConnection()`
- SQL: `SELECT * FROM cars WHERE status = 'Available'`
- Returns JSON array of available cars

---

### 2. Submitting a Booking (POST Request)

When user submits the booking form:

```
booking.html              BookingServlet              MySQL
    │                           │                       │
    │  POST /api/booking        │                       │
    │  Form Data: {             │                       │
    │    customerName,          │                       │
    │    contact, email,        │                       │
    │    carId, startDate...    │                       │
    │  }                        │                       │
    │ ────────────────────────▶ │                       │
    │                           │                       │
    │                           │  1. Check car status  │
    │                           │ ────────────────────▶ │
    │                           │ ◀──────────────────── │
    │                           │                       │
    │                           │  2. INSERT customer   │
    │                           │ ────────────────────▶ │
    │                           │ ◀──────────────────── │
    │                           │     (customer_id)     │
    │                           │                       │
    │                           │  3. INSERT booking    │
    │                           │ ────────────────────▶ │
    │                           │ ◀──────────────────── │
    │                           │     (booking_id)      │
    │                           │                       │
    │                           │  4. UPDATE car status │
    │                           │     SET 'Rented'      │
    │                           │ ────────────────────▶ │
    │                           │ ◀──────────────────── │
    │                           │                       │
    │ ◀──────────────────────── │                       │
    │  Redirect: confirmation.  │                       │
    │  html?bookingId=123       │                       │
    │                           │                       │
    ▼ Display success page      │                       │
```

**Code Path:**
- `booking.html` → Form POST to `/api/booking`
- `BookingServlet.doPost()` receives form data
- Step 1: Verify car is still available
- Step 2: `INSERT INTO customers (...) VALUES (...)`
- Step 3: `INSERT INTO bookings (...) VALUES (...)`
- Step 4: `UPDATE cars SET status = 'Rented' WHERE car_id = ?`
- Redirect to `confirmation.html?bookingId=XXX`

---

## Database Schema Relationships

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│  customers  │       │   bookings  │       │    cars     │
├─────────────┤       ├─────────────┤       ├─────────────┤
│ customer_id │◀──────│ customer_id │       │   car_id    │
│ name        │       │ car_id      │──────▶│   brand     │
│ contact     │       │ package_id  │       │   model     │
│ email       │       │ start_date  │       │   status    │
│ nationality │       │ end_date    │       │ rate_per_day│
└─────────────┘       │ status      │       └─────────────┘
                      │ total_est.  │
                      └──────┬──────┘
                             │
                             │ (optional)
                             ▼
                      ┌─────────────┐
                      │  packages   │
                      ├─────────────┤
                      │ package_id  │
                      │ name        │
                      │ destination │
                      │ price       │
                      └─────────────┘
```

---

## File Structure Summary

```
INFMGL DB/
├── database/
│   └── car_rental_travel_agency.sql    ← Database schema & sample data
│
├── webapp/                              ← Deploy this folder to Tomcat
│   ├── index.html                       ← Home page
│   ├── booking.html                     ← Booking form
│   ├── confirmation.html                ← Success page
│   ├── error.html                       ← Error page
│   ├── css/
│   │   └── style.css                    ← Stylesheet
│   └── WEB-INF/
│       ├── web.xml                      ← Servlet configuration
│       ├── classes/                     ← Compiled .class files
│       └── lib/
│           └── mysql-connector-j.jar    ← MySQL JDBC driver
│
├── src/
│   └── com/carrental/
│       ├── util/
│       │   └── DBConnection.java        ← Database connection utility
│       └── servlet/
│           ├── BookingServlet.java      ← Handles booking submission
│           ├── CarsServlet.java         ← Returns available cars
│           └── PackagesServlet.java     ← Returns tour packages
│
└── docs/
    └── DATA_FLOW.md                     ← This documentation
```

---

## Deployment Instructions

### Prerequisites
- Java JDK 8 or higher
- Apache Tomcat 9 or higher
- MySQL 8.0 or higher
- MySQL Connector/J (JDBC Driver)

### Step 1: Setup Database
```bash
# Open MySQL command line or MySQL Workbench
mysql -u root -p

# Run the SQL script
source C:/path/to/database/car_rental_travel_agency.sql
```

### Step 2: Add MySQL JDBC Driver
1. Download MySQL Connector/J from: https://dev.mysql.com/downloads/connector/j/
2. Copy `mysql-connector-j-8.x.x.jar` to `webapp/WEB-INF/lib/`

### Step 3: Configure Database Connection
Edit `src/com/carrental/util/DBConnection.java`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/car_rental_travel_agency";
private static final String DB_USER = "root";         // Your MySQL username
private static final String DB_PASSWORD = "";         // Your MySQL password
```

### Step 4: Compile Java Files
```bash
# Navigate to project folder
cd "C:\Users\Ken\OneDrive\Documents\Code\INFMGL DB"

# Compile all Java files
javac -cp "webapp/WEB-INF/lib/*" -d webapp/WEB-INF/classes src/com/carrental/util/*.java src/com/carrental/servlet/*.java
```

### Step 5: Deploy to Tomcat
1. Copy the entire `webapp` folder to `TOMCAT_HOME/webapps/`
2. Rename `webapp` to `carrental`
3. Start Tomcat

### Step 6: Access the Website
Open browser and navigate to:
```
http://localhost:8080/carrental/
```

---

## Booking Status Flow

```
Pending ──▶ Approved ──▶ Ongoing ──▶ Completed
                │                        
                └──▶ Cancelled           
```

- **Pending**: Initial status when booking is submitted
- **Approved**: Admin approves the booking
- **Ongoing**: Customer has picked up the car
- **Completed**: Car returned, booking finished
- **Cancelled**: Booking was cancelled

---

## Security Notes

1. **Input Validation**: Required fields are validated both client-side (JavaScript) and server-side (Java Servlet)
2. **SQL Injection Prevention**: Using PreparedStatement with parameterized queries
3. **Double Booking Prevention**: Car availability is checked before inserting booking
4. **Transaction Safety**: Database operations use transactions (commit/rollback)

---

*Document created for INFMGL Database Finals Project*
