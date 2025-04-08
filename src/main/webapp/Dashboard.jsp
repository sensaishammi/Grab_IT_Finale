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
    int maxInactiveInterval = session.getMaxInactiveInterval();
    long creationTime = session.getCreationTime();
    long lastAccessedTime = session.getLastAccessedTime();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>GrabIT - Dashboard</title>
    <link rel="stylesheet" href="Dashboard.css" />
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
            transition: var(--hover-transition);
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* Dark Theme */
        .dark-theme {
            --primary: #00b4d8;
            --primary-dark: #0096c7;
            --secondary: #90e0ef;
            --accent: #caf0f8;
            --dark: #0f0f0f;
            --light: #1a1a1a;
            --gray: #121212;
            --text-primary: #fff;
            --text-secondary: #aaa;
            --glass-bg: rgba(0, 0, 0, 0.2);
            --glass-border: rgba(255, 255, 255, 0.1);
        }

        .dark-theme .card {
            background: var(--light);
            border: 1px solid var(--glass-border);
        }

        .dark-theme .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 150, 199, 0.3);
        }

        .dark-theme .stat-card {
            background: var(--light);
            border: 1px solid var(--glass-border);
        }

        .dark-theme .stat-card:hover {
            background: linear-gradient(135deg, var(--dark), var(--light));
        }

        .dark-theme .nav-item.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .dark-theme .nav-item:hover {
            background: var(--glass-bg);
            color: var(--secondary);
        }

        .dark-theme .action-button {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }

        .dark-theme .action-button:hover {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 150, 199, 0.3);
        }

        /* Light Theme */
        .light-theme {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary: #3b82f6;
            --accent: #60a5fa;
            --dark: #1e293b;
            --light: #ffffff;
            --gray: #f1f5f9;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --glass-bg: rgba(37, 99, 235, 0.05);
            --glass-border: rgba(37, 99, 235, 0.1);
            --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .light-theme .card {
            background: var(--light);
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .light-theme .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(37, 99, 235, 0.1);
        }

        .light-theme .stat-card {
            background: var(--light);
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .light-theme .stat-card:hover {
            background: linear-gradient(135deg, var(--light), var(--gray));
            box-shadow: 0 8px 30px rgba(37, 99, 235, 0.1);
        }

        .light-theme .nav-item.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2);
        }

        .light-theme .nav-item:hover {
            background: var(--glass-bg);
            color: var(--primary);
        }

        .light-theme .action-button {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }

        .light-theme .action-button:hover {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        .light-theme .brand-text h1 {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .light-theme .sidebar {
            background: linear-gradient(180deg, var(--light), var(--gray));
            border-right: 1px solid var(--glass-border);
        }

        .light-theme .sidebar-header {
            background: linear-gradient(180deg, var(--light), var(--gray));
            border-bottom: 1px solid var(--glass-border);
        }

        .light-theme .header {
            background: linear-gradient(180deg, var(--light), var(--gray));
            box-shadow: var(--card-shadow);
        }

        .light-theme .activity-card {
            background: var(--light);
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .light-theme .activity-item {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }

        .light-theme .activity-item:hover {
            background: var(--glass-border);
        }

        .light-theme .user-profile {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }

        .light-theme .user-profile:hover {
            background: var(--glass-border);
        }

        .light-theme .theme-toggle {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }

        .light-theme .theme-toggle:hover {
            background: var(--glass-border);
            color: var(--primary);
        }

        .light-theme .user-avatar {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2);
        }

        /* Red Theme */
        .red-theme {
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
        }

        .red-theme .card {
            background: linear-gradient(135deg, var(--light), var(--dark));
            border: 1px solid var(--glass-border);
        }

        .red-theme .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(190, 21, 21, 0.3);
        }

        .red-theme .stat-card {
            background: linear-gradient(135deg, var(--light), var(--dark));
            border: 1px solid var(--glass-border);
        }

        .red-theme .stat-card:hover {
            background: linear-gradient(135deg, var(--dark), var(--light));
        }

        .red-theme .nav-item.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .red-theme .nav-item:hover {
            background: var(--glass-bg);
            color: var(--secondary);
        }

        .red-theme .action-button {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }

        .red-theme .action-button:hover {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(190, 21, 21, 0.3);
        }

        .red-theme .brand-icon {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .red-theme .brand-text h1 {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .red-theme .chart-bar {
            background: linear-gradient(to top, var(--primary), var(--secondary));
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 0.7; }
            50% { opacity: 1; }
            100% { opacity: 0.7; }
        }

        /* Enhanced Sidebar */
        .sidebar {
            width: 280px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: linear-gradient(180deg, var(--light), var(--dark));
            box-shadow: var(--card-shadow);
            z-index: 1000;
            transition: var(--hover-transition);
            backdrop-filter: blur(10px);
            border-right: 1px solid var(--glass-border);
        }

        .sidebar-header {
            padding: 2rem 1.5rem;
            border-bottom: 1px solid var(--glass-border);
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.9), rgba(26, 26, 26, 0.9));
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .brand-icon {
            font-size: 2rem;
            color: var(--primary);
        }

        .brand-text {
            text-align: center;
            margin-bottom: 1.8rem;
        }

        .brand-text h1 {
            font-size: 2rem;
            font-weight: 800;
            margin: 0;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.5px;
        }

        .brand-text p {
            color: var(--text-secondary);
            margin: 0.5rem 0 0;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .nav-menu {
            padding: 1rem 0;
        }

        .nav-item {
            position: relative;
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            color: var(--text-secondary);
            text-decoration: none;
            transition: var(--hover-transition);
            border-radius: 0.75rem;
            margin: 0.5rem 1rem;
            cursor: pointer;
            font-weight: 500;
        }

        .nav-item i {
            margin-right: 1rem;
            font-size: 1.25rem;
            transition: var(--hover-transition);
        }

        .nav-item:hover {
            background: var(--glass-bg);
            color: var(--text-primary);
            transform: translateX(5px);
        }

        .nav-item.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.3);
        }

        .nav-item.logout {
            margin-top: auto;
            background: var(--glass-bg);
            color: var(--danger);
        }

        .nav-item.logout:hover {
            background: var(--danger);
            color: white;
        }

        .nav-item.logout i {
            color: inherit;
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            padding: 2rem;
            transition: var(--hover-transition);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.25rem;
            padding: 1.25rem;
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.9), rgba(26, 26, 26, 0.9));
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
        }

        .page-title h2 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }

        .page-title p {
            font-size: 1rem;
            margin: 0.5rem 0 0;
            color: var(--text-secondary);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .theme-toggle {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 1.25rem;
            transition: var(--hover-transition);
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .theme-toggle:hover {
            background: var(--glass-border);
            color: var(--text-primary);
            transform: rotate(15deg);
        }

        .user-profile {
            position: relative;
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem 1.25rem;
            background: var(--glass-bg);
            border-radius: 2rem;
            border: 1px solid var(--glass-border);
            transition: var(--hover-transition);
        }

        .user-profile:hover {
            background: var(--glass-border);
        }

        .session-indicator {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--success);
            transition: all 0.3s ease;
        }

        .session-indicator.warning {
            background: var(--warning);
        }

        .session-indicator.expired {
            background: var(--danger);
        }

        .session-tooltip {
            position: absolute;
            bottom: 100%;
            right: 0;
            background: var(--light);
            padding: 0.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: none;
            min-width: 200px;
            z-index: 1000;
        }

        .session-tooltip.active {
            display: block;
        }

        .session-tooltip-content {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            color: var(--text-primary);
        }

        .session-tooltip-content i {
            color: var(--primary);
        }

        .session-timer {
            font-family: monospace;
            font-weight: bold;
        }

        .user-avatar {
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 1.25rem;
            box-shadow: 0 4px 15px rgba(190, 21, 21, 0.3);
        }

        .user-info h3 {
            font-size: 1rem;
            font-weight: 600;
            margin: 0;
            color: var(--text-primary);
        }

        .user-info p {
            font-size: 0.875rem;
            margin: 0.25rem 0 0;
            color: var(--text-secondary);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.9), rgba(26, 26, 26, 0.9));
            border-radius: 1.25rem;
            padding: 2rem;
            transition: var(--hover-transition);
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(190, 21, 21, 0.2);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 3.5rem;
            height: 3.5rem;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .stat-icon.primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
        }

        .stat-icon.success {
            background: linear-gradient(135deg, var(--success), #27ae60);
        }

        .stat-icon.warning {
            background: linear-gradient(135deg, var(--warning), #f39c12);
        }

        .stat-icon.danger {
            background: linear-gradient(135deg, var(--danger), #c0392b);
        }

        .stat-value h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            color: var(--text-primary);
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 1rem;
            color: var(--text-secondary);
            margin: 0.5rem 0 0;
            font-weight: 500;
        }

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        .stat-trend.positive {
            color: var(--success);
        }

        .stat-trend.negative {
            color: var(--danger);
        }

        /* Charts Grid */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 1.25rem;
            margin-bottom: 1.75rem;
        }

        .chart-card {
            background: var(--light);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
            border: 1px solid var(--glass-border);
        }

        .chart-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .chart-title h3 {
            font-size: 1.25rem;
            margin: 0;
            color: var(--text-primary);
        }

        .chart-actions {
            display: flex;
            gap: 0.5rem;
        }

        .chart-action {
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .chart-action:hover {
            color: var(--primary);
        }

        .chart-container {
            height: 300px;
            position: relative;
        }

        /* Recent Activity */
        .activity-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.9), rgba(26, 26, 26, 0.9));
            border-radius: 1.25rem;
            padding: 1.75rem;
            transition: var(--hover-transition);
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .activity-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .activity-title h3 {
            font-size: 1.25rem;
            margin: 0;
            color: var(--text-primary);
        }

        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 0.875rem;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            padding: 1.25rem;
            background: var(--glass-bg);
            border-radius: 1rem;
            transition: var(--hover-transition);
            border: 1px solid var(--glass-border);
        }

        .activity-item:hover {
            background: var(--glass-border);
            transform: translateX(5px);
        }

        .activity-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .activity-icon.primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
        }

        .activity-icon.success {
            background: linear-gradient(135deg, var(--success), #27ae60);
        }

        .activity-icon.warning {
            background: linear-gradient(135deg, var(--warning), #f39c12);
        }

        .activity-icon.danger {
            background: linear-gradient(135deg, var(--danger), #c0392b);
        }

        .activity-content {
            flex: 1;
        }

        .activity-text {
            font-size: 1rem;
            color: var(--text-primary);
            margin: 0;
            font-weight: 500;
        }

        .activity-time {
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin: 0.25rem 0 0;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .sidebar {
                width: 80px;
            }

            .brand-text, .nav-item span {
                display: none;
            }

            .main-content {
                margin-left: 80px;
            }

            .nav-item {
                justify-content: center;
                padding: 0.75rem;
            }

            .nav-item i {
                margin: 0;
                font-size: 1.5rem;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .menu-toggle {
                display: block;
            }
        }
    </style>
</head>
<body class="red-theme">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="brand">
                <div class="brand-text">
                    <h1><i class="fas fa-utensils"></i> GrabIT</h1>
                    <p>Skip the Line, GrabIT on Time!</p>
                </div>
            </div>
        </div>
        <div class="nav-menu">
            <a href="#" class="nav-item active">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fas fa-users"></i>
                <span>Users</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fas fa-chart-bar"></i>
                <span>Analytics</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fas fa-bell"></i>
                <span>Notifications</span>
            </a>
            <a href="javascript:void(0)" class="nav-item logout" onclick="logout()">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <div class="page-title">
                <h2>Dashboard</h2>
                <p>Welcome back, <%= username %></p>
            </div>
            <div class="user-menu">
                <button class="theme-toggle" onclick="toggleTheme()">
                    <i class="fas fa-moon"></i>
                </button>
                <div class="user-profile" id="userProfile">
                    <div class="session-indicator" id="sessionIndicator"></div>
                    <div class="session-tooltip" id="sessionTooltip">
                        <div class="session-tooltip-content">
                            <i class="fas fa-clock"></i>
                            <span>Session Timeout: <span class="session-timer" id="sessionTimer"><%= maxInactiveInterval/60 %>:00</span></span>
                        </div>
                    </div>
                    <div class="user-avatar"><%= Character.toUpperCase(username.charAt(0)) %></div>
                    <div class="user-info">
                        <h3><%= username %></h3>
                        <p>Administrator</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon primary">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-value">
                        <h3>1,234</h3>
                        <p class="stat-label">Total Users</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>12% increase</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon primary">
                        <i class="fas fa-utensils"></i>
                    </div>
                    <div class="stat-value">
                        <h3>567</h3>
                        <p class="stat-label">Total Orders</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>8% increase</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon primary">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-value">
                        <h3>23</h3>
                        <p class="stat-label">Pending Issues</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>5% increase</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon primary">
                        <i class="fas fa-user-lock"></i>
                    </div>
                    <div class="stat-value">
                        <h3>45</h3>
                        <p class="stat-label">Blocked Users</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>3% increase</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon primary">
                        <i class="fas fa-store"></i>
                    </div>
                    <div class="stat-value">
                        <h3>89</h3>
                        <p class="stat-label">Active Restaurants</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>15% increase</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon primary">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-value">
                        <h3>$12.5K</h3>
                        <p class="stat-label">Total Revenue</p>
                        <div class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>22% increase</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Grid -->
        <div class="charts-grid">
            <div class="chart-card">
                <div class="chart-header">
                    <div class="chart-title">
                        <h3>User Growth</h3>
                    </div>
                    <div class="chart-actions">
                        <button class="chart-action">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                    </div>
                </div>
                <div class="chart-container">
                    <!-- Chart will be rendered here -->
                </div>
            </div>
            <div class="chart-card">
                <div class="chart-header">
                    <div class="chart-title">
                        <h3>Revenue Overview</h3>
                    </div>
                    <div class="chart-actions">
                        <button class="chart-action">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                    </div>
                </div>
                <div class="chart-container">
                    <!-- Chart will be rendered here -->
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="activity-card">
            <div class="activity-header">
                <div class="activity-title">
                    <h3>Recent Activity</h3>
                </div>
                <div class="activity-actions">
                    <button class="chart-action">
                        <i class="fas fa-ellipsis-v"></i>
                    </button>
                </div>
            </div>
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon primary">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="activity-content">
                        <p class="activity-text">New user registered: John Doe</p>
                        <p class="activity-time">2 minutes ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon primary">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="activity-content">
                        <p class="activity-text">New order placed: #12345</p>
                        <p class="activity-time">15 minutes ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon primary">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="activity-content">
                        <p class="activity-text">System maintenance scheduled</p>
                        <p class="activity-time">1 hour ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon primary">
                        <i class="fas fa-ban"></i>
                    </div>
                    <div class="activity-content">
                        <p class="activity-text">User account blocked: Jane Smith</p>
                        <p class="activity-time">2 hours ago</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Session Management
        let sessionTimeout = <%= maxInactiveInterval %>; // Session timeout in seconds
        let warningTime = 60; // 1 minute in seconds
        let timer;

        function startSessionTimer() {
            clearInterval(timer);
            timer = setInterval(updateSessionTimer, 1000);
        }

        function updateSessionTimer() {
            const minutes = Math.floor(sessionTimeout / 60);
            const seconds = sessionTimeout % 60;
            const timerDisplay = document.getElementById('sessionTimer');
            const sessionIndicator = document.getElementById('sessionIndicator');
            const sessionTooltip = document.getElementById('sessionTooltip');
            
            if (timerDisplay && sessionIndicator && sessionTooltip) {
                timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

                if (sessionTimeout <= warningTime) {
                    sessionIndicator.classList.add('warning');
                    sessionIndicator.classList.remove('expired');
                } else {
                    sessionIndicator.classList.remove('warning');
                    sessionIndicator.classList.remove('expired');
                }

                if (sessionTimeout <= 0) {
                    clearInterval(timer);
                    sessionIndicator.classList.remove('warning');
                    sessionIndicator.classList.add('expired');
                    logout();
                }

                sessionTimeout--;
            }
        }

        function logout() {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'logout';
            document.body.appendChild(form);
            form.submit();
        }

        // Add hover effect for session tooltip
        document.addEventListener('DOMContentLoaded', function() {
            const userProfile = document.getElementById('userProfile');
            const sessionTooltip = document.getElementById('sessionTooltip');

            if (userProfile && sessionTooltip) {
                userProfile.addEventListener('mouseenter', function() {
                    sessionTooltip.classList.add('active');
                });

                userProfile.addEventListener('mouseleave', function() {
                    sessionTooltip.classList.remove('active');
                });
            }
        });

        // Theme Toggle
        function toggleTheme() {
            const body = document.body;
            const themeToggle = document.querySelector('.theme-toggle i');
            
            if (body.classList.contains('light-theme')) {
                body.classList.remove('light-theme');
                body.classList.add('dark-theme');
                themeToggle.classList.remove('fa-moon');
                themeToggle.classList.add('fa-sun');
            } else if (body.classList.contains('dark-theme')) {
                body.classList.remove('dark-theme');
                body.classList.add('red-theme');
                themeToggle.classList.remove('fa-sun');
                themeToggle.classList.add('fa-palette');
            } else {
                body.classList.remove('red-theme');
                body.classList.add('light-theme');
                themeToggle.classList.remove('fa-palette');
                themeToggle.classList.add('fa-moon');
            }
        }

        // Start the session timer when the page loads
        window.onload = function() {
            startSessionTimer();
        };
    </script>
</body>
</html> 