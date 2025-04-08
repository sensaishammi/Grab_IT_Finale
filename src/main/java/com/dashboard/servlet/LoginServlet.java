package com.dashboard.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt - Username: " + username + ", Password: " + password);
        
        // Simple authentication - in a real application, this would check against a database
        if (isValidAdmin(username, password)) {
            System.out.println("Login successful for user: " + username);
            HttpSession session = request.getSession();
            session.setAttribute("isAdmin", true);
            session.setAttribute("username", username);
            response.sendRedirect(request.getContextPath() + "/Dashboard.jsp");
        } else {
            System.out.println("Login failed for user: " + username);
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
    
    private boolean isValidAdmin(String username, String password) {
        // In a real application, this would check against a database
        // For now, we'll just check if the username is in the list of authorized admins
        // and the password matches the username
        String[] authorizedAdmins = {"lokesh", "kaustubh", "rutuparna", "heril", "shammi"};
        for (String admin : authorizedAdmins) {
            if (admin.equals(username) && admin.equals(password)) {
                return true;
            }
        }
        return false;
    }
} 