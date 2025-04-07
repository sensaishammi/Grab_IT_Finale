<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Internal Server Error</title>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #1a1a1a, #2a2a2a);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .error-container {
            padding: 2rem;
        }
        h1 {
            font-size: 4rem;
            margin: 0;
            color: #BE1515;
        }
        p {
            font-size: 1.2rem;
            margin: 1rem 0;
        }
        a {
            color: #E85353;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <p>Internal Server Error</p>
        <a href="admin-login.jsp">Return to Login</a>
    </div>
</body>
</html> 