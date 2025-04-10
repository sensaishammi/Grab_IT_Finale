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
    <title>GrabIT - Create Food Item</title>
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

        .create-food-container {
            max-width: 800px;
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

        .form-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.95), rgba(26, 26, 26, 0.95));
            border-radius: 1.5rem;
            padding: 2.5rem;
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .form-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, var(--text-primary), var(--text-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            color: var(--text-primary);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 0.75rem;
            color: var(--text-primary);
            padding: 0.75rem 1rem;
            transition: var(--hover-transition);
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(232, 83, 83, 0.2);
            color: var(--text-primary);
        }

        .form-select {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--glass-border);
            border-radius: 0.75rem;
            color: var(--text-primary);
            padding: 0.75rem 1rem;
        }

        .form-select:focus {
            background-color: rgba(255, 255, 255, 0.1);
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(232, 83, 83, 0.2);
            color: var(--text-primary);
        }

        .submit-btn {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 0.75rem;
            color: white;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 500;
            width: 100%;
            transition: var(--hover-transition);
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.3);
        }

        .form-text {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        #itemId {
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--text-secondary);
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .create-food-container {
                padding: 2rem 1rem;
            }

            .form-card {
                padding: 1.5rem;
            }
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
    </style>
</head>
<body>
    <!-- Add popup HTML -->
    <div id="successPopup" class="popup">
        <div class="popup-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <div class="popup-content">
            <div class="popup-title">Success!</div>
            <div class="popup-message">Food item has been added successfully.</div>
        </div>
    </div>

    <div class="create-food-container">
        <a href="menu-management.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Back to Menu Management
        </a>

        <div class="form-card">
            <h2 class="form-title">Create Food Item</h2>
            <form id="createFoodForm" action="createFood" method="POST" onsubmit="return handleSubmit(event)">
                <div class="form-group">
                    <label for="category" class="form-label">Category</label>
                    <select class="form-select" id="category" name="category" required>
                        <option value="">Select a category</option>
                        <option value="breakfast">Breakfast</option>
                        <option value="snack">Snack</option>
                        <option value="beverage">Beverage</option>
                        <option value="a_la_carte">A La Carte</option>
                        <option value="main_course">Main Course</option>
                        <option value="chaat">Chaat</option>
                        <option value="chinese_starter">Chinese Starter</option>
                        <option value="chinese">Chinese</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="itemId" class="form-label">Item ID</label>
                    <input type="text" class="form-control" id="itemId" name="itemId" readonly>
                    <small class="form-text">Auto-generated ID</small>
                </div>

                <div class="form-group">
                    <label for="itemName" class="form-label">Item Name</label>
                    <input type="text" class="form-control" id="itemName" name="itemName" required>
                </div>

                <div class="form-group">
                    <label for="price" class="form-label">Price (₹)</label>
                    <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required>
                </div>

                <div class="form-group">
                    <label for="imageUrl" class="form-label">Image URL</label>
                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" required>
                    <small class="form-text">Enter a valid image URL</small>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-plus-circle me-2"></i>
                    Create Food Item
                </button>
            </form>
        </div>
    </div>

    <script>
        // Generate a random item ID when the page loads
        window.onload = function() {
            const timestamp = new Date().getTime();
            const random = Math.floor(Math.random() * 1000);
            const itemId = `ITEM_${timestamp}_${random}`;
            document.getElementById('itemId').value = itemId;
        };

        function showPopup() {
            const popup = document.getElementById('successPopup');
            popup.classList.add('show');
            setTimeout(() => {
                popup.classList.remove('show');
                // Redirect after popup
                window.location.href = 'menu-management.jsp';
            }, 2000);
        }

        function handleSubmit(event) {
            event.preventDefault();
            const form = event.target;
            const formData = new FormData(form);

            fetch(form.action, {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(response => {
                if (response.ok) {
                    showPopup();
                } else {
                    throw new Error('Something went wrong');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // Handle error case
            });

            return false;
        }
    </script>
</body>
</html> 