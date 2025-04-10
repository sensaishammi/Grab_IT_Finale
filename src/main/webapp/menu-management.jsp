<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // Check if user is logged in
    if (session == null || session.getAttribute("isAdmin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get session information
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>GrabIT - Menu Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        /* Reuse the existing theme variables and styles */
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
            transition: var(--hover-transition);
            overflow-x: hidden;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        .menu-management-container {
            padding: 3rem;
            transition: var(--hover-transition);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            max-width: 1400px;
            margin: 0 auto;
            gap: 2rem;
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
        }

        .back-button:hover {
            background: var(--glass-border);
            transform: translateX(-5px);
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.2);
        }

        .menu-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            flex: 1;
            align-content: center;
        }

        .menu-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.95), rgba(26, 26, 26, 0.95));
            border-radius: 1.5rem;
            padding: 2.5rem;
            transition: var(--hover-transition);
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
            cursor: pointer;
            text-decoration: none;
            color: var(--text-primary);
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 45px rgba(190, 21, 21, 0.25);
            border-color: var(--secondary);
        }

        .menu-card-header {
            display: flex;
            align-items: center;
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .menu-card-icon {
            width: 4rem;
            height: 4rem;
            border-radius: 1.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            box-shadow: 0 6px 20px rgba(190, 21, 21, 0.3);
        }

        .menu-card-title {
            font-size: 1.75rem;
            font-weight: 600;
            margin: 0;
            background: linear-gradient(135deg, var(--text-primary), var(--text-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .menu-card-description {
            font-size: 1.1rem;
            color: var(--text-secondary);
            margin: 0.75rem 0 0;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .menu-management-container {
                padding: 2rem 1.5rem;
            }
            
            .menu-cards-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .menu-card {
                padding: 2rem;
            }
            
            .menu-card-icon {
                width: 3.5rem;
                height: 3.5rem;
                font-size: 1.75rem;
            }
            
            .menu-card-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body class="red-theme">
    <!-- Main Content -->
    <div class="menu-management-container">
        <a href="Dashboard.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Back to Dashboard
        </a>

        <div class="menu-cards-grid">
            <a href="create-food.jsp" class="menu-card">
                <div class="menu-card-header">
                    <div class="menu-card-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <div>
                        <h3 class="menu-card-title">Create Food Item</h3>
                        <p class="menu-card-description">Add new items to the menu</p>
                    </div>
                </div>
            </a>

            <a href="update-food.jsp" class="menu-card">
                <div class="menu-card-header">
                    <div class="menu-card-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                    <div>
                        <h3 class="menu-card-title">Update Food Item</h3>
                        <p class="menu-card-description">Modify existing menu items</p>
                    </div>
                </div>
            </a>

            <a href="view-food.jsp" class="menu-card">
                <div class="menu-card-header">
                    <div class="menu-card-icon">
                        <i class="fas fa-eye"></i>
                    </div>
                    <div>
                        <h3 class="menu-card-title">View Food Items</h3>
                        <p class="menu-card-description">Browse all menu items</p>
                    </div>
                </div>
            </a>

            <a href="delete-food.jsp" class="menu-card">
                <div class="menu-card-header">
                    <div class="menu-card-icon">
                        <i class="fas fa-trash-alt"></i>
                    </div>
                    <div>
                        <h3 class="menu-card-title">Delete Food Item</h3>
                        <p class="menu-card-description">Remove items from the menu</p>
                    </div>
                </div>
            </a>
        </div>
    </div>
</body>
</html> 