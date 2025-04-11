<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("isAdmin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Food Items</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 1200px;
            margin: 0 auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
        }
        th, td {
            padding: 12px;
            border: 1px solid #dee2e6;
            text-align: left;
        }
        th {
            background-color: #343a40;
            color: white;
            font-weight: 600;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #e9ecef;
        }
        .food-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        .delete-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #343a40;
        }
        .header h2 {
            color: #343a40;
            margin: 0;
        }
        .back-btn {
            text-decoration: none;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 8px 16px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        .back-btn:hover {
            color: #343a40;
            background-color: #e9ecef;
        }
        .modal-content {
            border-radius: 8px;
        }
        .modal-header {
            background-color: #343a40;
            color: white;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }
        .modal-title {
            font-weight: 600;
        }
        .btn-close {
            color: white;
        }
        .text-center {
            text-align: center;
        }
        .text-danger {
            color: #dc3545;
        }
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .loading::after {
            content: '';
            display: inline-block;
            width: 30px;
            height: 30px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .error-message {
            display: none;
            color: #dc3545;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #dc3545;
            border-radius: 4px;
            background-color: #f8d7da;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Delete Food Items</h2>
            <a href="Dashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <div id="errorContainer" class="error-message"></div>
        <div id="loadingSpinner" class="loading"></div>
        <table class="table">
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="foodTableBody">
                <tr>
                    <td colspan="5">Loading...</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this food item?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="module">
        import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js";
        import { getDatabase, ref, get, remove } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-database.js";

        const firebaseConfig = {
            apiKey: "AIzaSyCU8-WUpNCecR-ZWjiySfaelZVke6qC08U",
            authDomain: "grabit-mpstme.firebaseapp.com",
            databaseURL: "https://grabit-mpstme-default-rtdb.firebaseio.com",
            projectId: "grabit-mpstme",
            storageBucket: "grabit-mpstme.appspot.com",
            messagingSenderId: "180238227469",
            appId: "1:180238227469:web:11b04a0b5404c3e345ca9e",
            measurementId: "G-7B4QW1XZZN"
        };

        function showError(message) {
            const errorContainer = document.getElementById('errorContainer');
            errorContainer.textContent = message;
            errorContainer.style.display = 'block';
            setTimeout(() => {
                errorContainer.style.display = 'none';
            }, 5000);
        }

        function showLoading(show) {
            document.getElementById('loadingSpinner').style.display = show ? 'block' : 'none';
        }

        async function loadFoodItems() {
            const tableBody = document.getElementById('foodTableBody');
            showLoading(true);
            
            try {
                console.log("Starting to load food items...");
                const foodItemsRef = ref(database, 'FoodItems');
                console.log("Firebase reference created:", foodItemsRef);
                
                const snapshot = await get(foodItemsRef);
                console.log("Firebase response received:", snapshot);
                
                if (snapshot.exists()) {
                    const foodItems = snapshot.val();
                    console.log("Food items data:", foodItems);
                    
                    if (Object.keys(foodItems).length === 0) {
                        console.log("No food items found in the database");
                        tableBody.innerHTML = "<tr><td colspan='5'>No food items found</td></tr>";
                    } else {
                        console.log("Found", Object.keys(foodItems).length, "food items");
                        tableBody.innerHTML = '';
                        
                        Object.entries(foodItems).forEach(([id, data]) => {
                            console.log("Processing food item:", id, data);
                            const row = document.createElement('tr');
                            
                            const imageCell = document.createElement('td');
                            const img = document.createElement('img');
                            img.src = data['Image URL'] || data.imageUrl || 'https://via.placeholder.com/50';
                            img.alt = data['Item Name'] || data.name || 'Food item';
                            img.className = 'food-image';
                            img.onerror = () => img.src = 'https://via.placeholder.com/50';
                            imageCell.appendChild(img);
                            row.appendChild(imageCell);
                            
                            const nameCell = document.createElement('td');
                            nameCell.textContent = data['Item Name'] || data.name || 'N/A';
                            row.appendChild(nameCell);
                            
                            const categoryCell = document.createElement('td');
                            categoryCell.textContent = data['Category'] || data.category || 'N/A';
                            row.appendChild(categoryCell);
                            
                            const priceCell = document.createElement('td');
                            const price = data['Price (INR)'] || data.price;
                            priceCell.textContent = price ? `₹${price}` : 'N/A';
                            row.appendChild(priceCell);
                            
                            const deleteCell = document.createElement('td');
                            const deleteBtn = document.createElement('button');
                            deleteBtn.className = 'delete-button';
                            deleteBtn.textContent = 'Delete';
                            deleteBtn.onclick = () => {
                                if (confirm('Are you sure you want to delete this item?')) {
                                    const itemRef = ref(database, `FoodItems/${id}`);
                                    remove(itemRef)
                                        .then(() => {
                                            row.remove();
                                            if (tableBody.children.length === 0) {
                                                tableBody.innerHTML = "<tr><td colspan='5'>No food items found</td></tr>";
                                            }
                                        })
                                        .catch((error) => {
                                            console.error('Delete failed:', error);
                                            showError('Failed to delete item. Please try again later.');
                                        });
                                }
                            };
                            deleteCell.appendChild(deleteBtn);
                            row.appendChild(deleteCell);
                            
                            tableBody.appendChild(row);
                        });
                    }
                } else {
                    console.log("No data exists at the specified path");
                    tableBody.innerHTML = "<tr><td colspan='5'>No food items found</td></tr>";
                }
            } catch (error) {
                console.error('Error loading food items:', error);
                console.error("Error details:", {
                    code: error.code,
                    message: error.message,
                    stack: error.stack
                });
                showError('Failed to load food items. Please try again later.');
                tableBody.innerHTML = "<tr><td colspan='5'>Error loading food items</td></tr>";
            } finally {
                showLoading(false);
            }
        }

        // Initialize Firebase and load data
        try {
            const app = initializeApp(firebaseConfig);
            const database = getDatabase(app);
            loadFoodItems();
        } catch (error) {
            console.error("Error initializing Firebase:", error);
            showError('Failed to initialize Firebase. Please check your connection and try again.');
        }
    </script>
</body>
</html> 