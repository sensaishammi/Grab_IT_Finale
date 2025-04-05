<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            transition: background-color 0.3s, color 0.3s;
        }

        .dark-mode {
            background-color: #0f0f0f;
            color: white;
        }

        .dark-mode .card {
            background-color: #1a1a1a;
            color: white;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
        }

        .light-mode {
            background-color: #f8f9fa;
            color: #212529;
        }

        .light-mode .card {
            background-color: white;
            color: #212529;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .card {
            border: none;
            padding: 20px;
            border-radius: 10px;
            transition: background-color 0.3s, color 0.3s;
        }

        .chart-bar {
            background-color: currentColor;
            opacity: 0.7;
            width: 30px;
            margin: 5px;
            border-radius: 5px;
        }

        .overview-chart {
            display: flex;
            align-items: flex-end;
            height: 200px;
            padding: 10px 0;
        }

        .toggle-btn {
            background-color: transparent;
            color: inherit;
            border: 1px solid currentColor;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body class="dark-mode">
    <div class="container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Dashboard</h2>
            <button class="toggle-btn" onclick="toggleTheme()">Toggle Light/Dark Mode</button>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-3" id="stats-container">
            <div class="col-md-3">
                <div class="card">
                    <h5>Total Revenue</h5>
                    <h3 id="total-revenue">$45,231</h3>
                    <small>+20.1% from last month</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <h5>Subscriptions</h5>
                    <h3 id="subscriptions">+2350</h3>
                    <small>+180.1% from last month</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <h5>Sales</h5>
                    <h3 id="sales">+12,234</h3>
                    <small>+19% from last month</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <h5>Active Now</h5>
                    <h3 id="active-users">+573</h3>
                    <small>+201 since last hour</small>
                </div>
            </div>
        </div>

        <!-- Overview Chart and Recent Sales -->
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <h5>Overview</h5>
                    <div class="overview-chart" id="overview-chart">
                        <div class="chart-bar" style="height: 120px;"></div>
                        <div class="chart-bar" style="height: 50px;"></div>
                        <div class="chart-bar" style="height: 140px;"></div>
                        <div class="chart-bar" style="height: 140px;"></div>
                        <div class="chart-bar" style="height: 40px;"></div>
                        <div class="chart-bar" style="height: 90px;"></div>
                        <div class="chart-bar" style="height: 170px;"></div>
                        <div class="chart-bar" style="height: 100px;"></div>
                        <div class="chart-bar" style="height: 180px;"></div>
                        <div class="chart-bar" style="height: 130px;"></div>
                        <div class="chart-bar" style="height: 70px;"></div>
                        <div class="chart-bar" style="height: 90px;"></div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <h5>Recent Sales</h5>
                    <ul class="list-unstyled" id="recent-sales">
                        <li>Olivia Martin - $1,999.00</li>
                        <li>Jackson Lee - $39.00</li>
                        <li>Isabella Nguyen - $299.00</li>
                        <li>William Kim - $99.00</li>
                        <li>Sofia Davis - $39.00</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Theme toggle function
        function toggleTheme() {
            const body = document.body;
            body.classList.toggle("dark-mode");
            body.classList.toggle("light-mode");
        }

        // Fetch and display dashboard data
        async function fetchDashboardData() {
            try {
                // Fetch stats
                const statsResponse = await fetch('${pageContext.request.contextPath}/api/dashboard/stats');
                const stats = await statsResponse.json();
                
                // Update stats
                document.getElementById('total-revenue').textContent = `$${stats.totalRevenue.toLocaleString()}`;
                document.getElementById('subscriptions').textContent = `+${stats.subscriptions.toLocaleString()}`;
                document.getElementById('sales').textContent = `+${stats.sales.toLocaleString()}`;
                document.getElementById('active-users').textContent = `+${stats.activeUsers.toLocaleString()}`;

                // Fetch recent sales
                const salesResponse = await fetch('${pageContext.request.contextPath}/api/dashboard/recent-sales');
                const recentSales = await salesResponse.json();
                
                // Update recent sales
                const recentSalesList = document.getElementById('recent-sales');
                recentSalesList.innerHTML = recentSales.map(sale => 
                    `<li>${sale.name} - $${sale.amount.toFixed(2)}</li>`
                ).join('');

                // Fetch overview data
                const overviewResponse = await fetch('${pageContext.request.contextPath}/api/dashboard/overview');
                const overviewData = await overviewResponse.json();

                // Update overview chart
                const overviewChart = document.getElementById('overview-chart');
                overviewChart.innerHTML = overviewData.map(height => 
                    `<div class="chart-bar" style="height: ${height}px;"></div>`
                ).join('');
            } catch (error) {
                console.error('Error fetching dashboard data:', error);
            }
        }

        // Fetch data when page loads
        document.addEventListener('DOMContentLoaded', fetchDashboardData);
    </script>
</body>
</html> 