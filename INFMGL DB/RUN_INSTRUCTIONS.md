# Car Rental Travel Agency - Detailed Run Instructions

This guide provides step-by-step instructions to set up and run the Car Rental Travel Agency web application. It is designed for beginners and specifies exactly which applications to use.

## Prerequisites
Ensure you have the following installed on your computer:
1.  **Visual Studio Code** (App for coding).
2.  **XAMPP Control Panel** (App for the database).
3.  **Java JDK** (Development Kit).

---

## Part 1: Database Setup (Using XAMPP and Browser)

1.  **Open the application: "XAMPP Control Panel"**.
2.  Find the rules for **Apache** and **MySQL** and click the **Start** button for both.
    *   *Result: They should turn green.*
3.  **Open the application: "Google Chrome"** (or your preferred web browser).
4.  In the address bar, type: `http://localhost/phpmyadmin` and press Enter.
5.  In phpMyAdmin (the website you just opened):
    *   Click the **"Import"** tab at the top.
    *   Click **"Choose File"**.
    *   Navigate to your project folder: `C:\Users\Ken\OneDrive\Documents\Code\INFMGL DB\database\`.
    *   Select the file: `car_rental_travel_agency.sql`.
    *   Click **"Open"**.
    *   Scroll down and click the **"Import"** or **"Go"** button at the bottom.
    *   *Result: You should see a green success message.*

---

## Part 2: Folder and Driver Setup (Using File Explorer)

You need to add a "driver" file so the Java code can talk to the database.

1.  **Download the Driver**:
    *   Go to Google and search for "MySQL Connector J JAR download" or use [this link](https://dev.mysql.com/downloads/connector/j/).
    *   Select "Platform Independent" and download the ZIP file.
    *   Extract the ZIP file and look for a file ending in `.jar` (e.g., `mysql-connector-j-8.x.x.jar`).

2.  **Open the application: "File Explorer"** (The yellow folder icon).
3.  **Navigate to your project**:
    *   Go to `C:\Users\Ken\OneDrive\Documents\Code\INFMGL DB\`.
4.  **Create the Library Folder**:
    *   Double-click to open the `webapp` folder.
    *   Double-click to open the `WEB-INF` folder.
    *   **Right-click** in an empty space -> **New** -> **Folder**.
    *   Name the new folder: `lib`
    *   *Final Path should be:* `...\INFMGL DB\webapp\WEB-INF\lib\`
5.  **Copy the Driver**:
    *   Copy the `.jar` file you downloaded in Step 1.
    *   Paste it into the new `lib` folder you just created.

---

## Part 3: Running the Website (Using Visual Studio Code)

1.  **Open the application: "Visual Studio Code"**.
2.  Make sure your project is open (`INFMGL DB` folder).
3.  **Install Extensions** (if you haven't already):
    *   Click the "Extensions" icon on the left sidebar (looks like squares).
    *   Search for "Community Server Connectors".
    *   Click **Install**.
4.  **Start the Server (Deployment)**:
    *   **Easier Method**:
        *   Go to the **Explorer** view (your file list).
        *   Right-click the `webapp` folder.
        *   Select **"Run on Server"**.
        *   (If asked, select your "Apache Tomcat" server).
    *   **Manual Method**:
        *   In the "Servers" view, Right-Click your Tomcat server -> **Add Deployment**.
        *   Select "Exploded" or "Folder" if asked.
        *   *Tip: If clicking `webapp` opens it, look for a "Select this folder" button or try the Easier Method above.*
    *   Once added, right-click the server -> **Start Server**.
    *   Right-click the server -> **Server Actions** -> **Show in Browser**.
    *   *Alternatively*, open Chrome and go to: `http://localhost:8080/webapp/`

## Troubleshooting

*   **Error: "Driver not found"**:
    *   Go back to **Part 2**. Double-check that you created the `lib` folder inside `WEB-INF` and put the `.jar` file there.
*   **Error: "404 Not Found"**:
    *   Make sure you are going to `/webapp/` or `/carrental/` depending on how you named it when deploying, NOT just `localhost:8080`.
