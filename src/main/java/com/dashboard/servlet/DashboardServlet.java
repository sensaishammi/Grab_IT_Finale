package com.dashboard.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (pathInfo) {
            case "/stats":
                Map<String, Object> stats = new HashMap<>();
                stats.put("totalRevenue", 45231);
                stats.put("subscriptions", 2350);
                stats.put("sales", 12234);
                stats.put("activeUsers", 573);
                out.print(objectMapper.writeValueAsString(stats));
                break;

            case "/recent-sales":
                Map<String, Object>[] recentSales = new Map[]{
                    createSale("Olivia Martin", 1999.00),
                    createSale("Jackson Lee", 39.00),
                    createSale("Isabella Nguyen", 299.00),
                    createSale("William Kim", 99.00),
                    createSale("Sofia Davis", 39.00)
                };
                out.print(objectMapper.writeValueAsString(recentSales));
                break;

            case "/overview":
                int[] overviewData = {120, 50, 140, 140, 40, 90, 170, 100, 180, 130, 70, 90};
                out.print(objectMapper.writeValueAsString(overviewData));
                break;

            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private Map<String, Object> createSale(String name, double amount) {
        Map<String, Object> sale = new HashMap<>();
        sale.put("name", name);
        sale.put("amount", amount);
        return sale;
    }
} 