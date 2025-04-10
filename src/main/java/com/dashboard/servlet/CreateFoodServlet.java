package com.dashboard.servlet;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

@WebServlet("/createFood")
public class CreateFoodServlet extends HttpServlet {
    private DatabaseReference database;
    private static final AtomicInteger nextId = new AtomicInteger(121);

    @Override
    public void init() throws ServletException {
        try {
            // Initialize Firebase Admin SDK
            InputStream serviceAccount = getServletContext().getResourceAsStream("/WEB-INF/firebase-config.json");
            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .setDatabaseUrl("https://grabit-v1-default-rtdb.firebaseio.com")
                .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }

            // Get database reference
            database = FirebaseDatabase.getInstance().getReference();
        } catch (IOException e) {
            throw new ServletException("Failed to initialize Firebase", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data with proper capitalization
            String category = capitalizeFirstLetter(request.getParameter("category"));
            int itemId = nextId.getAndIncrement();
            String itemName = capitalizeFirstLetter(request.getParameter("itemName"));
            double price = Double.parseDouble(request.getParameter("price"));
            String imageUrl = request.getParameter("imageUrl");

            // Create food item object with specified field names
            Map<String, Object> foodItem = new HashMap<>();
            foodItem.put("Category", category);
            foodItem.put("Image URL", imageUrl);
            foodItem.put("Item ID", String.valueOf(itemId));
            foodItem.put("Item Name", itemName);
            foodItem.put("Price (INR)", price);

            // Save to Firebase
            database.child("Food Items").child(String.valueOf(itemId)).setValueAsync(foodItem)
                .get(); // Wait for completion

            // Set response status to 200 OK
            response.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            // Log the error
            e.printStackTrace();
            
            // Set response status to 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String capitalizeFirstLetter(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        return input.substring(0, 1).toUpperCase() + input.substring(1);
    }
} 