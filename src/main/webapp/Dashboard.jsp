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
            --primary: #0096c7;
            --primary-dark: #0077b6;
            --secondary: #00b4d8;
            --accent: #90e0ef;
            --success: #2ecc71;
            --warning: #f1c40f;
            --danger: #e74c3c;
            --dark: #1a1a1a;
            --light: #ffffff;
            --gray: #f8f9fa;
            --text-primary: #333;
            --text-secondary: #666;
            --glass-bg: rgba(255, 255, 255, 0.1);
            --glass-border: rgba(255, 255, 255, 0.2);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray);
            color: var(--text-primary);
            transition: all 0.3s ease;
            overflow-x: hidden;
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
            --primary: #0096c7;
            --primary-dark: #0077b6;
            --secondary: #00b4d8;
            --accent: #90e0ef;
            --dark: #1a1a1a;
            --light: #ffffff;
            --gray: #f8f9fa;
            --text-primary: #333;
            --text-secondary: #666;
            --glass-bg: rgba(255, 255, 255, 0.1);
            --glass-border: rgba(0, 0, 0, 0.1);
        }

        .light-theme .card {
            background: var(--light);
            border: 1px solid var(--glass-border);
        }

        .light-theme .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .light-theme .stat-card {
            background: var(--light);
            border: 1px solid var(--glass-border);
        }

        .light-theme .stat-card:hover {
            background: linear-gradient(135deg, var(--gray), var(--light));
        }

        .light-theme .nav-item.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
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
            box-shadow: 0 4px 12px rgba(0, 150, 199, 0.3);
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
            background: var(--light);
            box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            border-right: 1px solid var(--glass-border);
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
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

        .brand-text h1 {
            font-size: 1.5rem;
            margin: 0;
            color: var(--text-primary);
        }

        .brand-text p {
            font-size: 0.875rem;
            margin: 0;
            color: var(--text-secondary);
        }

        .nav-menu {
            padding: 1rem 0;
        }

        .nav-item {
            position: relative;
            display: flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.3s ease;
            border-radius: 0.5rem;
            margin: 0.25rem 1rem;
            cursor: pointer;
        }

        .nav-item i {
            margin-right: 1rem;
            font-size: 1.25rem;
        }

        .nav-item:hover {
            background: var(--glass-bg);
            color: var(--primary);
        }

        .nav-item.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
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
            transition: all 0.3s ease;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title h2 {
            font-size: 1.75rem;
            margin: 0;
            color: var(--text-primary);
        }

        .page-title p {
            font-size: 0.875rem;
            margin: 0.25rem 0 0;
            color: var(--text-secondary);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .theme-toggle {
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 1.25rem;
            transition: all 0.3s ease;
        }

        .theme-toggle:hover {
            color: var(--primary);
        }

        .user-profile {
            position: relative;
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
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .user-info h3 {
            font-size: 0.875rem;
            margin: 0;
            color: var(--text-primary);
        }

        .user-info p {
            font-size: 0.75rem;
            margin: 0;
            color: var(--text-secondary);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--light);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
            border: 1px solid var(--glass-border);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
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
            font-size: 2rem;
            margin: 0;
            color: var(--text-primary);
        }

        .stat-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin: 0.25rem 0 0;
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
            gap: 1.5rem;
            margin-bottom: 2rem;
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
            background: var(--light);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
            border: 1px solid var(--glass-border);
        }

        .activity-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
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
            gap: 1rem;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem;
            background: var(--glass-bg);
            border-radius: 0.75rem;
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: var(--glass-border);
        }

        .activity-icon {
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: white;
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
            font-size: 0.875rem;
            color: var(--text-primary);
            margin: 0;
        }

        .activity-time {
            font-size: 0.75rem;
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
                <i class="fas fa-utensils brand-icon"></i>
                <div class="brand-text">
                    <h1>GrabIT</h1>
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
                    <div class="stat-icon success">
                        <i class="fas fa-shopping-cart"></i>
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
                    <div class="stat-icon warning">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="stat-value">
                        <h3>23</h3>
                        <p class="stat-label">Pending Issues</p>
                        <div class="stat-trend negative">
                            <i class="fas fa-arrow-down"></i>
                            <span>5% decrease</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon danger">
                        <i class="fas fa-ban"></i>
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
                    <div class="activity-icon success">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="activity-content">
                        <p class="activity-text">New order placed: #12345</p>
                        <p class="activity-time">15 minutes ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon warning">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="activity-content">
                        <p class="activity-text">System maintenance scheduled</p>
                        <p class="activity-time">1 hour ago</p>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon danger">
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