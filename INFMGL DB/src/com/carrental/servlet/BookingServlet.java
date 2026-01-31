package com.carrental.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.carrental.util.DBConnection;

/**
 * BookingServlet - Main booking handler
 * 
 * This servlet processes the booking form submission:
 * 1. Receives POST data from the booking form
 * 2. Validates required fields
 * 3. Inserts customer into customers table
 * 4. Calculates estimated total cost
 * 5. Inserts booking into bookings table with status 'Pending'
 * 6. Updates car status to 'Rented'
 * 7. Redirects to confirmation page
 * 
 * URL: /api/booking
 * Method: POST
 */
@WebServlet("/api/booking")
public class BookingServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Handles POST requests - Processes booking form submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // ============================================
        // Step 1: Get form parameters
        // ============================================
        String customerName = request.getParameter("customerName");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String nationality = request.getParameter("nationality");
        String carIdStr = request.getParameter("carId");
        String packageIdStr = request.getParameter("packageId");
        String purpose = request.getParameter("purpose");
        String pickupLocation = request.getParameter("pickupLocation");
        String dropoffLocation = request.getParameter("dropoffLocation");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // ============================================
        // Step 2: Validate required fields
        // ============================================
        StringBuilder errors = new StringBuilder();
        
        if (isEmpty(customerName)) errors.append("Customer name is required. ");
        if (isEmpty(contact)) errors.append("Contact number is required. ");
        if (isEmpty(email)) errors.append("Email is required. ");
        if (isEmpty(carIdStr)) errors.append("Please select a car. ");
        if (isEmpty(pickupLocation)) errors.append("Pickup location is required. ");
        if (isEmpty(dropoffLocation)) errors.append("Drop-off location is required. ");
        if (isEmpty(startDateStr)) errors.append("Start date is required. ");
        if (isEmpty(endDateStr)) errors.append("End date is required. ");
        
        // If validation fails, redirect back with error
        if (errors.length() > 0) {
            response.sendRedirect("booking.html?error=" + java.net.URLEncoder.encode(errors.toString(), "UTF-8"));
            return;
        }
        
        // Parse values
        int carId = Integer.parseInt(carIdStr);
        Integer packageId = isEmpty(packageIdStr) ? null : Integer.parseInt(packageIdStr);
        LocalDate startDate = LocalDate.parse(startDateStr);
        LocalDate endDate = LocalDate.parse(endDateStr);
        
        // Validate date range
        if (endDate.isBefore(startDate)) {
            response.sendRedirect("booking.html?error=" + java.net.URLEncoder.encode("End date must be after start date.", "UTF-8"));
            return;
        }
        
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);  // Start transaction
            
            // ============================================
            // Step 3: Check if car is still available
            // ============================================
            if (!isCarAvailable(conn, carId)) {
                conn.rollback();
                response.sendRedirect("booking.html?error=" + java.net.URLEncoder.encode("Sorry, this car is no longer available. Please select another car.", "UTF-8"));
                return;
            }
            
            // ============================================
            // Step 4: Insert customer into customers table
            // ============================================
            String insertCustomerSQL = "INSERT INTO customers (name, contact, email, nationality) VALUES (?, ?, ?, ?)";
            int customerId;
            
            try (PreparedStatement stmt = conn.prepareStatement(insertCustomerSQL, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, customerName);
                stmt.setString(2, contact);
                stmt.setString(3, email);
                stmt.setString(4, nationality);
                stmt.executeUpdate();
                
                // Get the generated customer_id
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        customerId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to get customer ID.");
                    }
                }
            }
            
            // ============================================
            // Step 5: Calculate estimated total cost
            // ============================================
            double totalEstimated = calculateEstimatedCost(conn, carId, packageId, startDate, endDate);
            
            // ============================================
            // Step 6: Insert booking into bookings table
            // ============================================
            String insertBookingSQL = "INSERT INTO bookings (customer_id, car_id, package_id, purpose, " +
                                      "pickup_location, dropoff_location, start_date, end_date, " +
                                      "total_estimated, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";
            int bookingId;
            
            try (PreparedStatement stmt = conn.prepareStatement(insertBookingSQL, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, customerId);
                stmt.setInt(2, carId);
                if (packageId != null) {
                    stmt.setInt(3, packageId);
                } else {
                    stmt.setNull(3, java.sql.Types.INTEGER);
                }
                stmt.setString(4, purpose);
                stmt.setString(5, pickupLocation);
                stmt.setString(6, dropoffLocation);
                stmt.setDate(7, Date.valueOf(startDate));
                stmt.setDate(8, Date.valueOf(endDate));
                stmt.setDouble(9, totalEstimated);
                stmt.executeUpdate();
                
                // Get the generated booking_id
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        bookingId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to get booking ID.");
                    }
                }
            }
            
            // ============================================
            // Step 7: Update car status to 'Rented'
            // ============================================
            String updateCarSQL = "UPDATE cars SET status = 'Rented' WHERE car_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateCarSQL)) {
                stmt.setInt(1, carId);
                stmt.executeUpdate();
            }
            
            // Commit the transaction
            conn.commit();
            
            // ============================================
            // Step 8: Redirect to confirmation page
            // ============================================
            response.sendRedirect("confirmation.html?bookingId=" + bookingId + 
                                  "&customerName=" + java.net.URLEncoder.encode(customerName, "UTF-8") +
                                  "&totalEstimated=" + totalEstimated);
            
        } catch (SQLException e) {
            // Rollback on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendRedirect("booking.html?error=" + java.net.URLEncoder.encode("Database error: " + e.getMessage(), "UTF-8"));
            
        } finally {
            // Close connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Checks if a car is available for booking
     */
    private boolean isCarAvailable(Connection conn, int carId) throws SQLException {
        String sql = "SELECT status FROM cars WHERE car_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return "Available".equals(rs.getString("status"));
                }
            }
        }
        return false;
    }
    
    /**
     * Calculates the estimated total cost of the booking
     * Formula: (car rate per day * number of days) + package price (if selected)
     */
    private double calculateEstimatedCost(Connection conn, int carId, Integer packageId, 
                                          LocalDate startDate, LocalDate endDate) throws SQLException {
        double total = 0.0;
        
        // Calculate number of rental days (minimum 1 day)
        long days = ChronoUnit.DAYS.between(startDate, endDate);
        if (days < 1) days = 1;
        
        // Get car rate per day
        String carSQL = "SELECT rate_per_day FROM cars WHERE car_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(carSQL)) {
            stmt.setInt(1, carId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total += rs.getDouble("rate_per_day") * days;
                }
            }
        }
        
        // Add package price if selected
        if (packageId != null) {
            String pkgSQL = "SELECT price FROM packages WHERE package_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(pkgSQL)) {
                stmt.setInt(1, packageId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        total += rs.getDouble("price");
                    }
                }
            }
        }
        
        return total;
    }
    
    /**
     * Checks if a string is null or empty
     */
    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
