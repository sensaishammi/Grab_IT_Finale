<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // Check if user is already logged in
    if (session != null && session.getAttribute("isAdmin") != null) {
        response.sendRedirect("Dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>GrabIT - Admin Login</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <style>
    /* Reset and base styles */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    :root {
      --primary: #BE1515;
      --primary-dark: #8C0000;
      --secondary: #E85353;
      --accent: #FF7A7A;
      --success: #2ecc71;
      --warning: #f1c40f;
      --danger: #e74c3c;
      --dark: #1a1a1a;
      --light: #2a2a2a;
      --gray: #121212;
      --text-primary: #fff;
      --text-secondary: #aaa;
      --glass-bg: rgba(190, 21, 21, 0.1);
      --glass-border: rgba(232, 83, 83, 0.2);
    }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
      color: var(--text-primary);
      background: linear-gradient(135deg, #1a1a1a, #2a2a2a);
      position: relative;
      overflow: hidden;
    }

    body::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: 
        radial-gradient(circle at 20% 20%, rgba(190, 21, 21, 0.15) 0%, transparent 50%),
        radial-gradient(circle at 80% 80%, rgba(232, 83, 83, 0.15) 0%, transparent 50%),
        linear-gradient(45deg, rgba(190, 21, 21, 0.1) 0%, transparent 50%),
        linear-gradient(-45deg, rgba(232, 83, 83, 0.1) 0%, transparent 50%);
      z-index: 1;
    }

    body::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23BE1515' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
      z-index: 2;
    }

    .login-container {
      background: rgba(42, 42, 42, 0.95);
      border-radius: 20px;
      box-shadow: 
        0 10px 30px rgba(190, 21, 21, 0.3),
        0 0 0 1px rgba(232, 83, 83, 0.1);
      width: 100%;
      max-width: 400px;
      padding: 2rem;
      position: relative;
      overflow: hidden;
      z-index: 3;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(232, 83, 83, 0.2);
    }

    .login-container::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(90deg, var(--primary), var(--secondary));
    }

    .brand {
      text-align: center;
      margin-bottom: 1.8rem;
    }

    .brand-icon {
      font-size: 3rem;
      margin-bottom: 0.8rem;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      filter: drop-shadow(0 2px 4px rgba(190, 21, 21, 0.3));
    }

    .brand-text h1 {
      font-size: 1.8rem;
      font-weight: 700;
      margin: 0;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      filter: drop-shadow(0 2px 4px rgba(190, 21, 21, 0.3));
    }

    .brand-text p {
      color: var(--text-secondary);
      margin: 0.5rem 0 0;
      font-size: 0.9rem;
    }

    .form-group {
      margin-bottom: 1.2rem;
      position: relative;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      color: var(--text-primary);
      font-weight: 500;
      font-size: 0.9rem;
    }

    .form-control {
      width: 100%;
      padding: 0.8rem 1rem;
      border: 1px solid rgba(232, 83, 83, 0.2);
      border-radius: 10px;
      background: rgba(190, 21, 21, 0.1);
      color: var(--text-primary);
      transition: all 0.3s ease;
      font-size: 0.9rem;
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
    }

    .form-control:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 2px rgba(190, 21, 21, 0.3);
      outline: none;
      background: rgba(190, 21, 21, 0.15);
    }

    .form-control::placeholder {
      color: var(--text-secondary);
    }

    .btn-login {
      width: 100%;
      padding: 0.9rem;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border: none;
      border-radius: 10px;
      color: white;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 1rem;
      margin-top: 0.5rem;
      position: relative;
      overflow: hidden;
    }

    .btn-login::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      transition: 0.5s;
    }

    .btn-login:hover::before {
      left: 100%;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(190, 21, 21, 0.4);
    }

    .error-message {
      color: var(--accent);
      font-size: 0.9rem;
      margin-top: 0.5rem;
      display: none;
      text-align: center;
    }

    .admin-list {
      margin-top: 1.2rem;
      padding: 1rem;
      background: rgba(190, 21, 21, 0.1);
      border-radius: 10px;
      font-size: 0.85rem;
      color: var(--text-secondary);
      border: 1px solid rgba(232, 83, 83, 0.2);
    }

    .admin-list p {
      margin: 0;
      font-weight: 500;
      color: var(--text-primary);
      font-size: 0.85rem;
    }

    .admin-list ul {
      list-style: none;
      padding: 0;
      margin: 0.4rem 0 0;
    }

    .admin-list li {
      margin: 0.2rem 0;
      padding-left: 1.2rem;
      position: relative;
      font-size: 0.8rem;
    }

    .admin-list li::before {
      content: '•';
      position: absolute;
      left: 0;
      color: var(--primary);
    }
  </style>
</head>
<body>
  <div class="login-container">
    <div class="brand">
      <i class="fas fa-utensils brand-icon"></i>
      <div class="brand-text">
        <h1>GrabIT</h1>
        <p>Skip the Line, GrabIT on Time!</p>
      </div>
    </div>

    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST">
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" class="form-control" placeholder="Enter your username" required>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
      </div>
      <c:if test="${not empty error}">
        <div class="error-message" style="display: block;">${error}</div>
      </c:if>
      <button type="submit" class="btn-login">Login</button>
    </form>

    <div class="admin-list">
      <p>Authorized Admins:</p>
      <ul>
        <li>lokesh</li>
        <li>kaustubh</li>
        <li>rutuparna</li>
        <li>heril</li>
        <li>shammi</li>
      </ul>
    </div>
  </div>
</body>
</html> 