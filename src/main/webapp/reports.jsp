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
    <title>GrabIT - Reports & Analytics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/papaparse@5.3.0/papaparse.min.js"></script>
    
    <!-- Shadcn UI Dependencies -->
    <script src="https://unpkg.com/@radix-ui/react-icons@1.0.3/dist/index.umd.js"></script>
    <script src="https://unpkg.com/@radix-ui/react-slot@1.0.2/dist/index.umd.js"></script>
    <script src="https://unpkg.com/class-variance-authority@0.7.0/dist/index.umd.js"></script>
    <script src="https://unpkg.com/clsx@2.0.0/dist/clsx.umd.min.js"></script>
    <script src="https://unpkg.com/tailwind-merge@2.0.0/dist/index.umd.js"></script>
    <script src="https://unpkg.com/lucide-react@0.294.0/dist/index.umd.js"></script>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
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
            
            /* Shadcn UI Theme Variables */
            --background: var(--dark);
            --foreground: var(--text-primary);
            --card: var(--light);
            --card-foreground: var(--text-primary);
            --popover: var(--light);
            --popover-foreground: var(--text-primary);
            --primary: var(--primary);
            --primary-foreground: var(--text-primary);
            --secondary: var(--secondary);
            --secondary-foreground: var(--text-primary);
            --muted: var(--gray);
            --muted-foreground: var(--text-secondary);
            --accent: var(--accent);
            --accent-foreground: var(--text-primary);
            --destructive: #ef4444;
            --destructive-foreground: var(--text-primary);
            --border: var(--glass-border);
            --input: var(--glass-bg);
            --ring: var(--primary);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, var(--dark), var(--gray));
            color: var(--text-primary);
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        .reports-container {
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

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin-top: 2rem;
        }

        .chart-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.95), rgba(26, 26, 26, 0.95));
            border-radius: 1.5rem;
            padding: 2rem;
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .chart-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--text-primary), var(--text-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .chart-container {
            position: relative;
            height: 400px;
            width: 100%;
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.5), rgba(26, 26, 26, 0.5));
            border-radius: 0.5rem;
            padding: 1rem;
            margin: 1rem 0;
        }

        canvas {
            width: 100% !important;
            height: 100% !important;
        }

        .chart-tooltip {
            background: var(--dark) !important;
            border: 1px solid var(--glass-border) !important;
            border-radius: 0.5rem !important;
            padding: 0.5rem 1rem !important;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1) !important;
        }

        .chart-tooltip-title {
            color: var(--text-primary) !important;
            font-weight: 600 !important;
            margin-bottom: 0.25rem !important;
        }

        .chart-tooltip-body {
            color: var(--text-secondary) !important;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .summary-card {
            background: linear-gradient(180deg, rgba(42, 42, 42, 0.95), rgba(26, 26, 26, 0.95));
            border-radius: 1rem;
            padding: 1.5rem;
            border: 1px solid var(--glass-border);
            box-shadow: var(--card-shadow);
        }

        .summary-card h3 {
            font-size: 1.1rem;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }

        .summary-card .value {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .summary-card .trend {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
            font-size: 0.9rem;
        }

        .trend.positive {
            color: #4CAF50;
        }

        .trend.negative {
            color: var(--accent);
        }

        @media (max-width: 1200px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .reports-container {
                padding: 2rem 1rem;
            }

            .summary-cards {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .summary-cards {
                grid-template-columns: 1fr;
            }
        }

        /* Shadcn UI Components */
        .card {
            background-color: var(--card);
            border-radius: 0.5rem;
            border: 1px solid var(--border);
            color: var(--card-foreground);
            box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        }

        .card-header {
            display: flex;
            flex-direction: column;
            space-y: 1.5rem;
            padding: 1.5rem;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            line-height: 1;
            letter-spacing: -0.025em;
        }

        .card-description {
            font-size: 0.875rem;
            color: var(--muted-foreground);
        }

        .card-content {
            padding: 1.5rem;
            padding-top: 0;
        }

        .card-footer {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            padding-top: 0;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(26, 26, 26, 0.95), rgba(42, 42, 42, 0.95));
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            backdrop-filter: blur(8px);
            transition: opacity 0.3s ease;
        }

        .loading-logo {
            width: 120px;
            height: 120px;
            margin-bottom: 2rem;
            animation: pulse 2s infinite;
        }

        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(190, 21, 21, 0.1);
            border-radius: 50%;
            border-top-color: var(--primary);
            border-right-color: var(--secondary);
            border-bottom-color: var(--accent);
            animation: spin 1.5s linear infinite;
            margin-bottom: 2rem;
        }

        .loading-text {
            color: var(--text-primary);
            font-size: 1.5rem;
            font-weight: 500;
            text-align: center;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--text-primary), var(--text-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .loading-progress {
            width: 300px;
            height: 6px;
            background: rgba(190, 21, 21, 0.1);
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .loading-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            width: 0%;
            transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .loading-progress-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(
                90deg,
                transparent,
                rgba(255, 255, 255, 0.2),
                transparent
            );
            animation: shimmer 2s infinite;
        }

        .loading-steps {
            color: var(--text-secondary);
            font-size: 1rem;
            text-align: center;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .loading-step {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            opacity: 0.5;
            transition: opacity 0.3s ease;
        }

        .loading-step.active {
            opacity: 1;
        }

        .loading-step.completed {
            color: var(--primary);
        }

        .loading-step-icon {
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.05); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .skeleton {
            background: linear-gradient(90deg, 
                rgba(42, 42, 42, 0.5) 25%, 
                rgba(26, 26, 26, 0.5) 50%, 
                rgba(42, 42, 42, 0.5) 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
            border-radius: 0.5rem;
        }

        .skeleton-card {
            height: 100px;
            margin-bottom: 1rem;
        }

        .skeleton-chart {
            height: 300px;
        }
    </style>
</head>
<body class="red-theme">
    <div class="reports-container">
        <a href="Dashboard.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Back to Dashboard
        </a>

        <div class="summary-cards">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Total Orders</h3>
                    <p class="card-description">Total number of unique orders processed</p>
                </div>
                <div class="card-content">
                    <div class="value text-4xl font-bold" id="totalOrders">-</div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Total Revenue</h3>
                    <p class="card-description">Total revenue generated from all orders</p>
                </div>
                <div class="card-content">
                    <div class="value text-4xl font-bold" id="totalRevenue">-</div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Average Order Value</h3>
                    <p class="card-description">Average amount spent per order</p>
                </div>
                <div class="card-content">
                    <div class="value text-4xl font-bold" id="avgOrderValue">-</div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Top Category</h3>
                    <p class="card-description">Most popular food category</p>
                </div>
                <div class="card-content">
                    <div class="value text-4xl font-bold" id="topCategory">-</div>
                </div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Revenue Trends</h2>
                    <p class="card-description">Monthly revenue over time</p>
                </div>
                <div class="card-content">
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Category Distribution</h2>
                    <p class="card-description">Breakdown of orders by category</p>
                </div>
                <div class="card-content">
                    <div class="chart-container">
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Order Trends</h2>
                    <p class="card-description">Daily order distribution</p>
                </div>
                <div class="card-content">
                    <div class="chart-container">
                        <canvas id="orderChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Popular Items</h2>
                    <p class="card-description">Top 5 most ordered items</p>
                </div>
                <div class="card-content">
                    <div class="chart-container">
                        <canvas id="itemsChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Declare chart instances globally
        let revenueChart = null;
        let categoryChart = null;
        let orderChart = null;
        let popularItemsChart = null;

        // Function to format currency
        function formatCurrency(amount) {
            return '₹' + parseFloat(amount).toFixed(2);
        }

        // Function to show loading overlay
        function showLoading(progress = 0, message = 'Loading...') {
            let overlay = document.querySelector('.loading-overlay');
            if (!overlay) {
                overlay = document.createElement('div');
                overlay.className = 'loading-overlay';
                overlay.innerHTML = `
                    <div class="loading-logo">
                        <svg width="120" height="120" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M60 0C26.8629 0 0 26.8629 0 60C0 93.1371 26.8629 120 60 120C93.1371 120 120 93.1371 120 60C120 26.8629 93.1371 0 60 0Z" fill="url(#paint0_linear)"/>
                            <path d="M60 20C37.9086 20 20 37.9086 20 60C20 82.0914 37.9086 100 60 100C82.0914 100 100 82.0914 100 60C100 37.9086 82.0914 20 60 20Z" fill="white"/>
                            <path d="M60 40C47.2975 40 37 50.2975 37 63C37 75.7025 47.2975 86 60 86C72.7025 86 83 75.7025 83 63C83 50.2975 72.7025 40 60 40Z" fill="url(#paint1_linear)"/>
                            <defs>
                                <linearGradient id="paint0_linear" x1="0" y1="0" x2="120" y2="120" gradientUnits="userSpaceOnUse">
                                    <stop stop-color="#BE1515"/>
                                    <stop offset="1" stop-color="#8C0000"/>
                                </linearGradient>
                                <linearGradient id="paint1_linear" x1="37" y1="40" x2="83" y2="86" gradientUnits="userSpaceOnUse">
                                    <stop stop-color="#BE1515"/>
                                    <stop offset="1" stop-color="#8C0000"/>
                                </linearGradient>
                            </defs>
                        </svg>
                    </div>
                    <div class="loading-spinner"></div>
                    <div class="loading-text">${message}</div>
                    <div class="loading-progress">
                        <div class="loading-progress-bar" style="width: ${progress}%"></div>
                    </div>
                    <div class="loading-steps">
                        <div class="loading-step ${progress >= 20 ? 'completed' : progress >= 0 ? 'active' : ''}">
                            <div class="loading-step-icon">
                                <i class="fas fa-server"></i>
                            </div>
                            <span>Connecting to server</span>
                        </div>
                        <div class="loading-step ${progress >= 40 ? 'completed' : progress >= 20 ? 'active' : ''}">
                            <div class="loading-step-icon">
                                <i class="fas fa-database"></i>
                            </div>
                            <span>Loading data</span>
                        </div>
                        <div class="loading-step ${progress >= 60 ? 'completed' : progress >= 40 ? 'active' : ''}">
                            <div class="loading-step-icon">
                                <i class="fas fa-cogs"></i>
                            </div>
                            <span>Processing data</span>
                        </div>
                        <div class="loading-step ${progress >= 80 ? 'completed' : progress >= 60 ? 'active' : ''}">
                            <div class="loading-step-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <span>Generating visualizations</span>
                        </div>
                        <div class="loading-step ${progress >= 100 ? 'completed' : progress >= 80 ? 'active' : ''}">
                            <div class="loading-step-icon">
                                <i class="fas fa-check"></i>
                            </div>
                            <span>Finalizing</span>
                        </div>
                    </div>
                `;
                document.body.appendChild(overlay);
            } else {
                updateLoadingProgress(overlay, progress, message);
            }
            return overlay;
        }

        // Function to hide loading overlay
        function hideLoading() {
            const overlay = document.querySelector('.loading-overlay');
            if (overlay) {
                overlay.style.opacity = '0';
                setTimeout(() => overlay.remove(), 300);
            }
        }

        // Function to update loading progress
        function updateLoadingProgress(overlay, progress, message) {
            if (!overlay) return;
            
            const progressBar = overlay.querySelector('.loading-progress-bar');
            const loadingText = overlay.querySelector('.loading-text');
            const loadingSteps = overlay.querySelectorAll('.loading-step');
            
            if (progressBar) progressBar.style.width = `${progress}%`;
            if (loadingText) loadingText.textContent = message;
            
            // Update step states
            loadingSteps.forEach((step, index) => {
                const stepProgress = (index + 1) * 20;
                if (progress >= stepProgress) {
                    step.classList.add('completed');
                    step.classList.remove('active');
                } else if (progress >= stepProgress - 20) {
                    step.classList.add('active');
                    step.classList.remove('completed');
                } else {
                    step.classList.remove('active', 'completed');
                }
            });
        }

        // Function to create skeleton loading
        function createSkeletonLoading() {
            const cards = document.querySelectorAll('.card');
            cards.forEach(card => {
                const content = card.querySelector('.card-content');
                if (content) {
                    content.innerHTML = '<div class="skeleton skeleton-chart"></div>';
                }
            });
        }

        // Function to load and process data
        async function loadAndProcessData() {
            try {
                showLoading(0, 'Starting...');
                
                const csvUrl = 'cleaned_orders (1) 1.csv';
                console.log('Fetching CSV from:', csvUrl);
                
                const response = await fetch(csvUrl);
                console.log('Response status:', response.status);
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const csvText = await response.text();
                console.log('CSV data length:', csvText.length);
                
                const chunkSize = 900;
                let currentRow = 0;
                
                const analytics = {
                    totalOrders: 0,
                    totalRevenue: 0,
                    categories: {},
                    items: {},
                    daysOrder: {},
                    monthsRevenue: {}
                };

                showLoading(20, 'Processing data...');
                
                Papa.parse(csvText, {
                    header: true,
                    dynamicTyping: true,
                    fastMode: true,
                    chunk: function(results, parser) {
                        try {
                            console.log(`Processing chunk of ${results.data.length} rows`);
                            processChunk(results.data, analytics);
                            currentRow += results.data.length;
                            const progress = Math.min((currentRow / results.data.length) * 100, 100);
                            showLoading(20 + (progress * 0.6), 'Processing data...');
                        } catch (error) {
                            console.error('Error processing chunk:', error);
                            parser.abort();
                        }
                    },
                    complete: function() {
                        console.log('CSV processing complete');
                        console.log('Analytics summary:', analytics);
                        showLoading(80, 'Updating visualizations...');
                        updateSummaryCards(analytics);
                        updateCharts(analytics);
                        showLoading(100, 'Complete!');
                        setTimeout(hideLoading, 500);
                    },
                    error: function(error) {
                        console.error('Error parsing CSV:', error);
                        alert('Error loading data. Please check console for details.');
                        hideLoading();
                    }
                });
            } catch (error) {
                console.error('Error in loadAndProcessData:', error);
                alert('Error loading data. Please check console for details.');
                hideLoading();
            }
        }
        
        function processChunk(data, analytics) {
            data.forEach(row => {
                if (!row['Order ID']) return; // Skip empty rows
                
                analytics.totalOrders++;
                analytics.totalRevenue += parseFloat(row['Price (INR)'] || 0);
                
                // Process categories
                const category = row['Category'];
                analytics.categories[category] = (analytics.categories[category] || 0) + 1;
                
                // Process items
                const item = row['Item Name'];
                analytics.items[item] = (analytics.items[item] || 0) + 1;
                
                // Process daily orders
                const orderDate = row['Order Date'];
                analytics.daysOrder[orderDate] = (analytics.daysOrder[orderDate] || 0) + 1;
                
                // Process monthly revenue
                const month = orderDate.split('-').slice(0, 2).join('-');
                analytics.monthsRevenue[month] = (analytics.monthsRevenue[month] || 0) + parseFloat(row['Price (INR)'] || 0);
            });
        }
        
        function updateSummaryCards(analytics) {
            // Update total orders
            document.getElementById('totalOrders').textContent = analytics.totalOrders;
            
            // Update total revenue
            document.getElementById('totalRevenue').textContent = formatCurrency(analytics.totalRevenue);
            
            // Update average order value
            const avgOrder = analytics.totalRevenue / analytics.totalOrders;
            document.getElementById('avgOrderValue').textContent = formatCurrency(avgOrder);
            
            // Update top category
            const topCategory = Object.entries(analytics.categories)
                .sort((a, b) => b[1] - a[1])[0];
            document.getElementById('topCategory').textContent = topCategory ? topCategory[0] : '-';
        }
        
        function updateCharts(analytics) {
            console.log('Updating charts with analytics:', analytics);
            
            // Destroy existing charts
            if (revenueChart) revenueChart.destroy();
            if (categoryChart) categoryChart.destroy();
            if (orderChart) orderChart.destroy();
            if (popularItemsChart) popularItemsChart.destroy();
            
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart');
            if (revenueCtx) {
                console.log('Initializing revenue chart');
                const months = Object.keys(analytics.monthsRevenue).sort();
                const revenueData = months.map(month => analytics.monthsRevenue[month]);
                
                revenueChart = new Chart(revenueCtx, {
                    type: 'line',
                    data: {
                        labels: months,
                        datasets: [{
                            label: 'Monthly Revenue',
                            data: revenueData,
                            borderColor: '#BE1515',
                            backgroundColor: 'rgba(190, 21, 21, 0.1)',
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(255, 255, 255, 0.1)'
                                }
                            },
                            x: {
                                grid: {
                                    color: 'rgba(255, 255, 255, 0.1)'
                                }
                            }
                        }
                    }
                });
            }
            
            // Category Chart
            const categoryCtx = document.getElementById('categoryChart');
            if (categoryCtx) {
                console.log('Initializing category chart');
                const categories = Object.entries(analytics.categories)
                    .sort((a, b) => b[1] - a[1])
                    .slice(0, 5);
                
                categoryChart = new Chart(categoryCtx, {
                    type: 'doughnut',
                    data: {
                        labels: categories.map(c => c[0]),
                        datasets: [{
                            data: categories.map(c => c[1]),
                            backgroundColor: [
                                '#BE1515',
                                '#E85353',
                                '#FF7A7A',
                                '#8C0000',
                                '#FF9999'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right'
                            }
                        }
                    }
                });
            }
            
            // Order Chart
            const orderCtx = document.getElementById('orderChart');
            if (orderCtx) {
                console.log('Initializing order chart');
                const days = Object.keys(analytics.daysOrder).sort();
                const orderData = days.map(day => analytics.daysOrder[day]);
                
                orderChart = new Chart(orderCtx, {
                    type: 'line',
                    data: {
                        labels: days,
                        datasets: [{
                            label: 'Daily Orders',
                            data: orderData,
                            borderColor: '#E85353',
                            backgroundColor: 'rgba(232, 83, 83, 0.1)',
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(255, 255, 255, 0.1)'
                                }
                            },
                            x: {
                                grid: {
                                    color: 'rgba(255, 255, 255, 0.1)'
                                }
                            }
                        }
                    }
                });
            }
            
            // Popular Items Chart
            const itemsCtx = document.getElementById('itemsChart');
            if (itemsCtx) {
                console.log('Initializing popular items chart');
                const items = Object.entries(analytics.items)
                    .sort((a, b) => b[1] - a[1])
                    .slice(0, 10);
                
                popularItemsChart = new Chart(itemsCtx, {
                    type: 'bar',
                    data: {
                        labels: items.map(i => i[0]),
                        datasets: [{
                            label: 'Orders',
                            data: items.map(i => i[1]),
                            backgroundColor: '#FF7A7A'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(255, 255, 255, 0.1)'
                                }
                            },
                            x: {
                                grid: {
                                    color: 'rgba(255, 255, 255, 0.1)'
                                }
                            }
                        }
                    }
                });
            }
        }
        
        // Load data when the page loads
        document.addEventListener('DOMContentLoaded', loadAndProcessData);
    </script>
</body>
</html> 