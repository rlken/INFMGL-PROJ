package com.carrental.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.carrental.util.DBConnection;

/**
 * CarsServlet - Retrieves available cars from the database
 * 
 * This servlet returns a JSON list of all cars with status='Available'.
 * Used by the booking form to populate the car selection dropdown.
 * 
 * URL: /api/cars
 * Method: GET
 * Response: JSON array of available cars
 */

public class CarsServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Handles GET requests - Returns list of available cars as JSON
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Add CORS headers for local development
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        PrintWriter out = response.getWriter();
        
        // SQL query to get only available cars
        String sql = "SELECT car_id, brand, model, plate_no, category, capacity, rate_per_day " +
                     "FROM cars WHERE status = 'Available' ORDER BY brand, model";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            // Build JSON array manually (no external library needed)
            StringBuilder json = new StringBuilder();
            json.append("[");
            
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;
                
                json.append("{");
                json.append("\"car_id\":").append(rs.getInt("car_id")).append(",");
                json.append("\"brand\":\"").append(escapeJson(rs.getString("brand"))).append("\",");
                json.append("\"model\":\"").append(escapeJson(rs.getString("model"))).append("\",");
                json.append("\"plate_no\":\"").append(escapeJson(rs.getString("plate_no"))).append("\",");
                json.append("\"category\":\"").append(escapeJson(rs.getString("category"))).append("\",");
                json.append("\"capacity\":").append(rs.getInt("capacity")).append(",");
                json.append("\"rate_per_day\":").append(rs.getDouble("rate_per_day"));
                json.append("}");
            }
            
            json.append("]");
            out.print(json.toString());
            
        } catch (SQLException e) {
            // Return error as JSON
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Database error: " + escapeJson(e.getMessage()) + "\"}");
            e.printStackTrace();
        }
    }
    
    /**
     * Escapes special characters for JSON string values
     */
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
