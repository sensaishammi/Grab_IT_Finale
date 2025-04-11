package com.dashboard.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/reports-data")
public class ReportsServlet extends HttpServlet {
    private static final String CACHE_KEY = "reportsData";
    private static final Map<String, Object> cache = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION = 5 * 60 * 1000; // 5 minutes
    private static long lastCacheUpdate = 0;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Check if we need to update the cache
        if (System.currentTimeMillis() - lastCacheUpdate > CACHE_DURATION || !cache.containsKey(CACHE_KEY)) {
            processData();
        }

        // Return cached data
        PrintWriter out = resp.getWriter();
        out.print(cache.get(CACHE_KEY));
    }

    private void processData() {
        try {
            String csvPath = getServletContext().getRealPath("/cleaned_orders (1) 1.csv");
            File csvFile = new File(csvPath);
            
            if (!csvFile.exists()) {
                throw new IOException("CSV file not found");
            }

            Map<String, Object> analytics = new HashMap<>();
            Set<String> uniqueOrderIds = new HashSet<>();
            double totalRevenue = 0;
            Map<String, Integer> categories = new HashMap<>();
            Map<String, Integer> items = new HashMap<>();
            Map<String, Integer> dailyOrders = new HashMap<>();
            Map<String, Double> monthlyRevenue = new HashMap<>();

            try (CSVParser parser = new CSVParser(new FileReader(csvFile), 
                    CSVFormat.DEFAULT.withFirstRecordAsHeader())) {
                
                for (CSVRecord record : parser) {
                    // Process order ID
                    String orderId = record.get("Order ID");
                    if (orderId != null && !orderId.isEmpty()) {
                        uniqueOrderIds.add(orderId);
                    }

                    // Process revenue
                    String priceStr = record.get("Price (INR)");
                    double price = priceStr != null && !priceStr.isEmpty() ? 
                            Double.parseDouble(priceStr) : 0;
                    totalRevenue += price;

                    // Process category
                    String category = record.get("Category");
                    if (category != null && !category.isEmpty()) {
                        categories.merge(category, 1, Integer::sum);
                    }

                    // Process item
                    String item = record.get("Item Name");
                    if (item != null && !item.isEmpty()) {
                        items.merge(item, 1, Integer::sum);
                    }

                    // Process date
                    String dateStr = record.get("Order Date");
                    if (dateStr != null && !dateStr.isEmpty()) {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                        Date orderDate = dateFormat.parse(dateStr);
                        
                        // Process day of week
                        SimpleDateFormat dayFormat = new SimpleDateFormat("EEE");
                        String dayOfWeek = dayFormat.format(orderDate);
                        dailyOrders.merge(dayOfWeek, 1, Integer::sum);

                        // Process month
                        SimpleDateFormat monthFormat = new SimpleDateFormat("MMM yyyy");
                        String monthYear = monthFormat.format(orderDate);
                        monthlyRevenue.merge(monthYear, price, Double::sum);
                    }
                }
            }

            // Prepare analytics data
            analytics.put("totalOrders", uniqueOrderIds.size());
            analytics.put("totalRevenue", totalRevenue);
            analytics.put("categories", categories);
            analytics.put("items", items);
            analytics.put("dailyOrders", dailyOrders);
            analytics.put("monthlyRevenue", monthlyRevenue);

            // Update cache
            cache.put(CACHE_KEY, analytics);
            lastCacheUpdate = System.currentTimeMillis();

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error processing data", e);
        }
    }
} 