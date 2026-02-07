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


public class AdminServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // GET: List all bookings
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String sql = "SELECT b.booking_id, c.name as customer_name, car.brand, car.model, b.start_date, b.end_date, b.total_estimated, b.status " +
                     "FROM bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN cars car ON b.car_id = car.car_id " +
                     "ORDER BY b.booking_id DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                
                json.append("{");
                json.append("\"booking_id\":").append(rs.getInt("booking_id")).append(",");
                json.append("\"customer_name\":\"").append(rs.getString("customer_name")).append("\",");
                json.append("\"car_info\":\"").append(rs.getString("brand")).append(" ").append(rs.getString("model")).append("\",");
                json.append("\"dates\":\"").append(rs.getString("start_date")).append(" to ").append(rs.getString("end_date")).append("\",");
                json.append("\"total\":").append(rs.getDouble("total_estimated")).append(",");
                json.append("\"status\":\"").append(rs.getString("status")).append("\"");
                json.append("}");
            }
            json.append("]");
            out.print(json.toString());
            
        } catch (SQLException e) {
            response.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
    
    // POST: Delete/Cancel booking
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("bookingId");
        
        if (idStr == null || action == null) {
            response.setStatus(400);
            return;
        }
        
        int bookingId = Integer.parseInt(idStr);
        String sql = "";
        
        if ("delete".equals(action)) {
            sql = "DELETE FROM bookings WHERE booking_id = ?";
        } else if ("cancel".equals(action)) {
            sql = "UPDATE bookings SET status = 'Cancelled' WHERE booking_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();
            response.setStatus(200);
            
        } catch (SQLException e) {
            response.setStatus(500);
            e.printStackTrace();
        }
    }
}
