package com.carrental.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - Reusable Database Connection Utility
 *
 * This class provides a centralized way to connect to the MySQL database. It
 * uses JDBC (Java Database Connectivity) to establish connections.
 *
 * Usage: Connection conn = DBConnection.getConnection(); // Use the
 * connection... conn.close();
 */
public class DBConnection {

    // Database connection parameters
    // Change these values according to your MySQL setup
    private static final String DB_URL = "jdbc:mysql://localhost:3306/car_rental_travel_agency";
    private static final String DB_USER = "root";           // Your MySQL username
    private static final String DB_PASSWORD = "";           // Your MySQL password (empty for XAMPP default)

    // JDBC Driver class name
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Static block to load the JDBC driver when the class is first loaded. This
     * ensures the driver is available before any connection attempts.
     */
    static {
        try {
            Class.forName(JDBC_DRIVER);
            System.out.println("MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("ERROR: MySQL JDBC Driver not found!");
            System.err.println("Make sure mysql-connector-j.jar is in WEB-INF/lib/");
            e.printStackTrace();
        }
    }

    /**
     * Gets a connection to the database.
     *
     * @return Connection object if successful
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connection established successfully.");
            return connection;
        } catch (SQLException e) {
            System.err.println("ERROR: Failed to connect to database!");
            System.err.println("URL: " + DB_URL);
            System.err.println("Check that MySQL is running and database exists.");
            throw e;
        }
    }

    /**
     * Tests the database connection. Can be run as a standalone class to verify
     * connectivity.
     */
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("SUCCESS: Connected to car_rental_travel_agency database!");
                System.out.println("Database Product: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("Database Version: " + conn.getMetaData().getDatabaseProductVersion());
            }
        } catch (SQLException e) {
            System.err.println("FAILED: Could not connect to database.");
            e.printStackTrace();
        }
    }
}
