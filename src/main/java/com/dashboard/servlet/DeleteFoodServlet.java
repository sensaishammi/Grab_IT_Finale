package com.dashboard.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/delete-food")
public class DeleteFoodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get food ID to delete
            String foodId = request.getParameter("id");

            // TODO: Delete from database
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Food item deleted successfully");
            
            out.print(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(result));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            out.print(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(error));
        }
    }
} 