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
            max-width: 1200px;
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
            padding: 2.5rem;
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .table-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, var(--text-primary), var(--text-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 1rem;
            overflow: hidden;
        }

        th, td {
            padding: 1rem;
            border: 1px solid var(--glass-border);
            color: var(--text-primary);
        }

        th {
            background: var(--glass-bg);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        tr:hover {
            background: var(--glass-bg);
        }

        input, select {
            width: 100%;
            padding: 0.75rem;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 0.75rem;
            color: var(--text-primary);
            transition: var(--hover-transition);
        }

        input:focus, select:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--secondary);
            outline: none;
        }

        .save-button {
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 0.75rem;
            cursor: pointer;
            transition: var(--hover-transition);
            font-weight: 500;
        }

        .save-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.3);
        }

        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: var(--light);
            border: 1px solid var(--glass-border);
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            z-index: 1000;
            box-shadow: var(--card-shadow);
        }

        .popup.show {
            display: block;
            animation: fadeIn 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translate(-50%, -60%); }
            to { opacity: 1; transform: translate(-50%, -50%); }
        }

        .popup h3 {
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .popup button {
            padding: 0.75rem 1.5rem;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 0.75rem;
            cursor: pointer;
            transition: var(--hover-transition);
        }

        .popup button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .loading {
            display: inline-block;
            width: 2rem;
            height: 2rem;
            border: 3px solid var(--glass-border);
            border-radius: 50%;
            border-top: 3px solid var(--primary);
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .error-message {
            color: var(--accent);
            padding: 1rem;
            margin: 1rem 0;
            border: 1px solid var(--accent);
            border-radius: 0.75rem;
            background: rgba(255, 122, 122, 0.1);
            display: none;
        }

        .food-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 1px solid var(--glass-border);
        }

        @media (max-width: 768px) {
            .update-food-container {
                padding: 2rem 1rem;
            }

            .table-card {
                padding: 1.5rem;
            }

            table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body class="red-theme">
    <div class="update-food-container">
        <a href="menu-management.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Back to Menu Management
        </a>

        <div class="table-card">
            <h2 class="table-title">Update Food Items</h2>
            <div id="errorMessage" class="error-message"></div>
            <table>
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Image</th>
                        <th>Item ID</th>
                        <th>Item Name</th>
                        <th>Price (INR)</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="foodItemsBody"></tbody>
            </table>
        </div>
    </div>

    <div class="popup" id="popup">
        <h3>Success!</h3>
        <p>The item has been successfully updated.</p>
        <button onclick="closePopup()">OK</button>
    </div>

    <script type="module">
        import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js";
        import { getDatabase, ref, get, set } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-database.js";

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

        const tableBody = document.getElementById("foodItemsBody");

        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            setTimeout(() => {
                errorDiv.style.display = 'none';
            }, 5000);
        }

        function showLoading() {
            tableBody.innerHTML = '<tr><td colspan="6" class="text-center"><div class="loading"></div> Loading food items...</td></tr>';
        }

        async function loadFoodItems() {
            showLoading();
            try {
                console.log("Initializing Firebase...");
                const app = initializeApp(firebaseConfig);
                const database = getDatabase(app);
                console.log("Firebase initialized, getting reference to 'Food Items'...");
                const foodItemsRef = ref(database, "Food Items");
                console.log("Getting snapshot...");
                const snapshot = await get(foodItemsRef);
                console.log("Snapshot received:", snapshot);
                
                if (snapshot.exists()) {
                    const foodItems = snapshot.val();
                    console.log("Food items data:", foodItems);
                    if (Object.keys(foodItems).length === 0) {
                        console.log("No food items found in the database");
                        tableBody.innerHTML = "<tr><td colspan='6'>No food items found</td></tr>";
                    } else {
                        console.log("Found", Object.keys(foodItems).length, "food items");
                        tableBody.innerHTML = ''; // Clear loading state
                        Object.entries(foodItems).forEach(([id, data]) => {
                            console.log("Processing food item:", id, data);
                            const row = document.createElement("tr");

                            // Category
                            const categoryCell = document.createElement("td");
                            const categorySelect = createSelect(data['Category'] || '');
                            categoryCell.appendChild(categorySelect);
                            row.appendChild(categoryCell);

                            // Image
                            const imageCell = document.createElement("td");
                            const img = document.createElement("img");
                            img.src = data['Image URL'] || 'https://via.placeholder.com/50';
                            img.alt = data['Item Name'] || 'Food item';
                            img.className = 'food-image';
                            img.onerror = () => img.src = 'https://via.placeholder.com/50';
                            imageCell.appendChild(img);
                            row.appendChild(imageCell);

                            // Item ID
                            const idCell = document.createElement("td");
                            idCell.textContent = data['Item ID'] || id;
                            row.appendChild(idCell);

                            // Item Name
                            const nameCell = document.createElement("td");
                            const nameInput = createInput(data['Item Name'] || '');
                            nameCell.appendChild(nameInput);
                            row.appendChild(nameCell);

                            // Price
                            const priceCell = document.createElement("td");
                            const priceInput = createInput(data['Price (INR)'] || '0');
                            priceInput.type = 'number';
                            priceInput.step = '0.01';
                            priceInput.min = '0';
                            priceCell.appendChild(priceInput);
                            row.appendChild(priceCell);

                            // Action
                            const actionCell = document.createElement("td");
                            const saveBtn = document.createElement("button");
                            saveBtn.className = "save-button";
                            saveBtn.innerHTML = '<i class="fas fa-save"></i> Save';
                            saveBtn.onclick = () => {
                                const updatedData = {
                                    'Category': categorySelect.value,
                                    'Image URL': data['Image URL'],
                                    'Item ID': data['Item ID'] || id,
                                    'Item Name': nameInput.value,
                                    'Price (INR)': parseFloat(priceInput.value) || 0
                                };

                                // Update only the specific entry in the database
                                const itemRef = ref(database, `Food Items/${id}`);
                                set(itemRef, updatedData)
                                    .then(() => {
                                        showPopup();
                                        // Update the image if it exists
                                        if (img) {
                                            img.src = updatedData['Image URL'];
                                        }
                                    })
                                    .catch((error) => {
                                        console.error('Update failed:', error);
                                        showError('Failed to update item. Please try again later.');
                                    });
                            };
                            actionCell.appendChild(saveBtn);
                            row.appendChild(actionCell);

                            tableBody.appendChild(row);
                        });
                    }
                } else {
                    console.log("No data exists at the specified path");
                    tableBody.innerHTML = "<tr><td colspan='6'>No food items found</td></tr>";
                }
            } catch (error) {
                console.error('Error loading food items:', error);
                showError('Failed to load food items. Please try again later.');
                tableBody.innerHTML = "<tr><td colspan='6'>Error loading food items</td></tr>";
            }
        }

        function createInput(value, disabled = false) {
            const input = document.createElement("input");
            input.value = value || "";
            if (disabled) input.disabled = true;
            return input;
        }

        function createSelect(selected) {
            const select = document.createElement("select");
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
            categories.forEach(category => {
                const opt = document.createElement("option");
                opt.value = category;
                opt.textContent = category;
                if (selected === category) opt.selected = true;
                select.appendChild(opt);
            });
            return select;
        }

        function showPopup() {
            document.getElementById("popup").classList.add("show");
        }

        function closePopup() {
            document.getElementById("popup").classList.remove("show");
        }

        // Initialize Firebase and load data
        try {
            loadFoodItems();
        } catch (error) {
            console.error("Error initializing Firebase:", error);
            showError('Failed to initialize Firebase. Please check your connection and try again.');
        }
    </script>
</body>
</html>
