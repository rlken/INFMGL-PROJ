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
 * PackagesServlet - Retrieves tour packages from the database
 * 
 * This servlet returns a JSON list of all available tour packages.
 * Used by the booking form for optional package selection.
 * 
 * URL: /api/packages
 * Method: GET
 * Response: JSON array of tour packages
 */

public class PackagesServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Handles GET requests - Returns list of packages as JSON
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
        
        // SQL query to get all packages
        String sql = "SELECT package_id, name, destination, days, price, description " +
                     "FROM packages ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            // Build JSON array manually
            StringBuilder json = new StringBuilder();
            json.append("[");
            
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;
                
                json.append("{");
                json.append("\"package_id\":").append(rs.getInt("package_id")).append(",");
                json.append("\"name\":\"").append(escapeJson(rs.getString("name"))).append("\",");
                json.append("\"destination\":\"").append(escapeJson(rs.getString("destination"))).append("\",");
                json.append("\"days\":").append(rs.getInt("days")).append(",");
                json.append("\"price\":").append(rs.getDouble("price")).append(",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\"");
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
