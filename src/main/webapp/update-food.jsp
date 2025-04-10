<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // Check if user is logged in
    if (session == null || session.getAttribute("isAdmin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>GrabIT - Update Food Items</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        :root {
            --primary: #BE1515;
            --primary-dark: #8C0000;
            --secondary: #E85353;
            --accent: #FF7A7A;
            --dark: #1a1a1a;
            --light: #2a2a2a;
            --gray: #121212;
            --text-primary: #fff;
            --text-secondary: #aaa;
            --glass-bg: rgba(190, 21, 21, 0.1);
            --glass-border: rgba(232, 83, 83, 0.2);
            --card-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            --hover-transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, var(--dark), var(--gray));
            color: var(--text-primary);
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        .update-food-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.5rem;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 1rem;
            color: var(--text-primary);
            text-decoration: none;
            transition: var(--hover-transition);
            width: fit-content;
            font-size: 1.1rem;
            font-weight: 500;
            margin-bottom: 2rem;
        }

        .back-button:hover {
            background: var(--glass-border);
            transform: translateX(-5px);
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.2);
        }

        .table-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.95), rgba(26, 26, 26, 0.95));
            border-radius: 1.5rem;
            padding: 2rem;
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 1rem;
        }

        .food-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            color: var(--text-primary);
        }

        .food-table th {
            background: var(--glass-bg);
            padding: 1.25rem 1rem;
            font-weight: 600;
            text-align: left;
            border-bottom: 2px solid var(--glass-border);
        }

        .food-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--glass-border);
            vertical-align: middle;
        }

        .food-table tbody tr {
            transition: var(--hover-transition);
        }

        .food-table tbody tr:hover {
            background: var(--glass-bg);
        }

        .edit-btn {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 0.5rem;
            color: white;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            cursor: pointer;
            transition: var(--hover-transition);
        }

        .edit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(190, 21, 21, 0.3);
        }

        .category-select {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 0.5rem;
            color: var(--text-primary);
            padding: 0.5rem;
            width: 100%;
        }

        .form-input {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 0.5rem;
            color: var(--text-primary);
            padding: 0.5rem;
            width: 100%;
        }

        .form-input:focus, .category-select:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(232, 83, 83, 0.2);
        }

        /* Popup Styles */
        .popup {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 20px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.3);
            z-index: 1000;
            transform: translateX(150%);
            transition: transform 0.3s ease-in-out;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .popup.show {
            transform: translateX(0);
        }

        .popup-icon {
            font-size: 24px;
        }

        .popup-content {
            display: flex;
            flex-direction: column;
        }

        .popup-title {
            font-weight: 600;
            margin-bottom: 4px;
        }

        .popup-message {
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .update-food-container {
                padding: 2rem 1rem;
            }

            .table-card {
                padding: 1rem;
            }

            .food-table th, .food-table td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Success Popup -->
    <div id="successPopup" class="popup">
        <div class="popup-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <div class="popup-content">
            <div class="popup-title">Success!</div>
            <div class="popup-message">Food item has been updated successfully.</div>
        </div>
    </div>

    <div class="update-food-container">
        <a href="menu-management.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Back to Menu Management
        </a>

        <div class="table-card">
            <div class="table-responsive">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="text-white mb-0">Food Items</h3>
                    <div class="item-count" style="background: var(--glass-bg); padding: 0.5rem 1rem; border-radius: 0.5rem; border: 1px solid var(--glass-border);">
                        <span class="text-white">Total Items: </span>
                        <span id="totalItemsCount" class="text-white">0</span>
                    </div>
                </div>
                <table class="food-table" id="foodTable">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Item ID</th>
                            <th>Item Name</th>
                            <th>Price (INR)</th>
                            <th>Image URL</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="foodTableBody">
                        <!-- Table rows will be populated dynamically -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script type="module">
        // Import Firebase modules
        import { initializeApp } from 'https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js';
        import { getDatabase, ref, onValue, update } from 'https://www.gstatic.com/firebasejs/10.8.0/firebase-database.js';

        // Firebase configuration
        const firebaseConfig = {
            apiKey: "AIzaSyBPrAfspM6BH3ORqZkLB4EARDl7jiWwP1A",
            authDomain: "grabit-v1.firebaseapp.com",
            databaseURL: "https://grabit-v1-default-rtdb.firebaseio.com",
            projectId: "grabit-v1",
            storageBucket: "grabit-v1.appspot.com",
            messagingSenderId: "953641039652",
            appId: "1:953641039652:web:c928b3fd85b81523c63149"
        };

        // Initialize Firebase
        const app = initializeApp(firebaseConfig);
        const database = getDatabase(app);
        const foodItemsRef = ref(database, 'Food Items');

        // Categories array
        const categories = [
            "Breakfast",
            "Snack",
            "Beverage",
            "A La Carte",
            "Main Course",
            "Chaat",
            "Chinese Starter",
            "Chinese"
        ];

        // Function to create category select
        function createCategorySelect(currentValue) {
            const select = document.createElement('select');
            select.className = 'category-select';
            categories.forEach(category => {
                const option = document.createElement('option');
                option.value = category.toLowerCase();
                option.textContent = category;
                if (category === currentValue) {
                    option.selected = true;
                }
                select.appendChild(option);
            });
            return select;
        }

        // Function to show success popup
        function showPopup() {
            const popup = document.getElementById('successPopup');
            popup.classList.add('show');
            setTimeout(() => {
                popup.classList.remove('show');
            }, 2000);
        }

        // Listen for changes in the database
        onValue(foodItemsRef, (snapshot) => {
            const foodTableBody = document.getElementById('foodTableBody');
            const totalItemsCount = document.getElementById('totalItemsCount');
            foodTableBody.innerHTML = ''; // Clear existing rows
            
            const data = snapshot.val();
            
            if (data) {
                // Filter out items with ID > 120 and sort them
                const sortedItems = Object.entries(data)
                    .filter(([_, itemData]) => parseInt(itemData['Item ID']) <= 120)
                    .sort((a, b) => parseInt(a[1]['Item ID']) - parseInt(b[1]['Item ID']))
                    .map(([firebaseKey, itemData]) => ({ firebaseKey, itemData }));
                
                // Update the total items count display
                totalItemsCount.textContent = sortedItems.length;
                
                // Create table rows
                sortedItems.forEach(({ firebaseKey, itemData }) => {
                    const row = createTableRow(firebaseKey, itemData);
                    foodTableBody.appendChild(row);
                });
            } else {
                console.log("No data found in Firebase");
                totalItemsCount.textContent = "0";
            }
        });

        // Function to create editable row
        function createTableRow(firebaseKey, itemData) {
            const row = document.createElement('tr');
            
            // Category cell
            const categoryCell = document.createElement('td');
            const categorySelect = createCategorySelect(itemData.Category);
            categoryCell.appendChild(categorySelect);
            
            // Item ID cell
            const itemIdCell = document.createElement('td');
            itemIdCell.textContent = itemData['Item ID'];
            
            // Item Name cell
            const itemNameCell = document.createElement('td');
            const itemNameInput = document.createElement('input');
            itemNameInput.type = 'text';
            itemNameInput.className = 'form-input';
            itemNameInput.value = itemData['Item Name'];
            itemNameCell.appendChild(itemNameInput);
            
            // Price cell
            const priceCell = document.createElement('td');
            const priceInput = document.createElement('input');
            priceInput.type = 'number';
            priceInput.className = 'form-input';
            priceInput.value = itemData['Price (INR)'];
            priceCell.appendChild(priceInput);
            
            // Image URL cell
            const imageUrlCell = document.createElement('td');
            const imageUrlInput = document.createElement('input');
            imageUrlInput.type = 'text';
            imageUrlInput.className = 'form-input';
            imageUrlInput.value = itemData['Image URL'];
            imageUrlCell.appendChild(imageUrlInput);
            
            // Actions cell
            const actionsCell = document.createElement('td');
            const updateButton = document.createElement('button');
            updateButton.className = 'edit-btn';
            updateButton.innerHTML = '<i class="fas fa-save"></i> Save';
            updateButton.onclick = () => {
                const newData = {
                    Category: categorySelect.value.charAt(0).toUpperCase() + categorySelect.value.slice(1),
                    'Item ID': itemData['Item ID'],
                    'Item Name': itemNameInput.value.charAt(0).toUpperCase() + itemNameInput.value.slice(1),
                    'Price (INR)': parseFloat(priceInput.value),
                    'Image URL': imageUrlInput.value
                };
                
                // Update the existing item using its Firebase key
                const itemRef = ref(database, `Food Items/${firebaseKey}`);
                
                // First verify the item exists
                onValue(itemRef, (snapshot) => {
                    if (snapshot.exists()) {
                        // Item exists, proceed with update
                        update(itemRef, newData)
                            .then(() => {
                                showPopup();
                                console.log(`Successfully updated item ${itemData['Item ID']}`);
                                
                                // Update the local data to reflect changes
                                itemData.Category = newData.Category;
                                itemData['Item Name'] = newData['Item Name'];
                                itemData['Price (INR)'] = newData['Price (INR)'];
                                itemData['Image URL'] = newData['Image URL'];
                                
                                // Update the form inputs to show the new values
                                categorySelect.value = newData.Category.toLowerCase();
                                itemNameInput.value = newData['Item Name'];
                                priceInput.value = newData['Price (INR)'];
                                imageUrlInput.value = newData['Image URL'];
                            })
                            .catch((error) => {
                                console.error(`Error updating item ${itemData['Item ID']}:`, error);
                                alert('Failed to update item. Please try again.');
                            });
                    } else {
                        console.error(`Item ${itemData['Item ID']} not found in database`);
                        alert('Item not found. Please refresh the page and try again.');
                    }
                }, {
                    onlyOnce: true
                });
            };
            actionsCell.appendChild(updateButton);
            
            // Append all cells
            row.appendChild(categoryCell);
            row.appendChild(itemIdCell);
            row.appendChild(itemNameCell);
            row.appendChild(priceCell);
            row.appendChild(imageUrlCell);
            row.appendChild(actionsCell);
            
            return row;
        }
    </script>
</body>
</html> 