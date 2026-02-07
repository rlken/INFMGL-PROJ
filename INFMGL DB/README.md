# Car Rental & Travel Agency System
**College Finals Project - INFMGL**

A web-based booking system for car rentals and tour packages, built with **Java Servlets, JSP, MySQL, provided by Apache Tomcat**.

## 🚀 Features
- **Car Rental Booking**: Browse available cars with rates and categories.
- **Tour Packages**: Select from popular Philippine destinations.
- **Real-time Cost Estimation**: JavaScript-based price calculation.
- **Database Integration**: Backend architecture designed for MySQL (customers, bookings, cars tables).
- **Responsive Design**: Modern UI with CSS animations and mobile support.

---

## 🛠️ Project Structure
- **`src/`**: Java source code (Servlets, Database Connection, Utilities).
- **`webapp/`**: Frontend files (HTML, CSS, JS, JSP).
- **`database/`**: SQL script (`car_rental_travel_agency.sql`) for database setup.
- **`lib/`**: MySQL JDBC Driver.

---

## ⚙️ Setup Instructions

### 1. Database Setup (XAMPP)
1. Open **XAMPP Control Panel** and start **Apache** and **MySQL**.
2. Go to `http://localhost/phpmyadmin` in your browser.
3. Import the database:
   - Go to **Import** tab.
   - Choose file: `database/car_rental_travel_agency.sql`.
   - Click **Go**.

### 2. VS Code & Server Setup
1. Install **Java Extension Pack** and **Community Server Connectors** in VS Code.
2. Add **Apache Tomcat** to the "Servers" view.
3. **Run the Project**:
   - Right-click the `webapp` folder -> **Run on Server**.
   - Or in Servers view: Right-click Tomcat -> **Add Deployment** -> Select `webapp` folder.

### 3. Running the Website
Open your browser to:
`http://localhost:8080/webapp/booking.html`

---

## ⚠️ Note for Grader / Reviewer
**Current Mode: Presentation / Demo Mode**
The frontend (`booking.html`) is currently configured to use **static JSON data** (`api/cars.json`) to ensure stability during the video presentation.

**To enable the Live Database Backend:**
1. Ensure Java JDK is installed and Tomcat is configured with the correct classpath.
2. In `booking.html`, change the fetch URLs:
   - `api/cars.json` ➡️ `api/cars`
   - `api/packages.json` ➡️ `api/packages`
3. The Java backend code is fully implemented in the `src/` folder.
