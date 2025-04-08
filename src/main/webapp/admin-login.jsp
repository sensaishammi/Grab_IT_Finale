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

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      background: linear-gradient(135deg, var(--dark), var(--gray));
      color: var(--text-primary);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }

    .login-container {
      width: 100%;
      max-width: 1200px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      background: linear-gradient(180deg, rgba(42, 42, 42, 0.9), rgba(26, 26, 26, 0.9));
      border-radius: 2rem;
      overflow: hidden;
      box-shadow: var(--card-shadow);
      border: 1px solid var(--glass-border);
    }

    .login-image {
      position: relative;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 3rem;
    }

    .login-image::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80') center/cover;
      opacity: 0.1;
    }

    .brand-section {
      text-align: center;
      z-index: 1;
    }

    .brand-icon {
      font-size: 4rem;
      color: white;
      margin-bottom: 1.5rem;
      text-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    }

    .brand-text h1 {
      font-size: 3rem;
      font-weight: 800;
      margin-bottom: 1rem;
      background: linear-gradient(135deg, #fff, #f0f0f0);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: -1px;
    }

    .brand-text p {
      font-size: 1.25rem;
      color: rgba(255, 255, 255, 0.8);
      max-width: 400px;
      margin: 0 auto;
      line-height: 1.6;
    }

    .login-form {
      padding: 4rem;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .form-header {
      margin-bottom: 2.5rem;
      text-align: center;
    }

    .form-header h2 {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 1rem;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: -1px;
    }

    .form-header p {
      color: var(--text-secondary);
      font-size: 1.1rem;
    }

    .form-group {
      margin-bottom: 1.5rem;
      position: relative;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.75rem;
      color: var(--text-primary);
      font-weight: 500;
    }

    .input-group {
      position: relative;
    }

    .input-group i {
      position: absolute;
      left: 1rem;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-secondary);
      font-size: 1.25rem;
    }

    .form-control {
      width: 100%;
      padding: 1rem 1rem 1rem 3rem;
      background: var(--glass-bg);
      border: 1px solid var(--glass-border);
      border-radius: 1rem;
      color: var(--text-primary);
      font-size: 1rem;
      transition: var(--hover-transition);
    }

    .form-control:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 2px rgba(190, 21, 21, 0.2);
    }

    .form-control::placeholder {
      color: var(--text-secondary);
    }

    .btn-login {
      width: 100%;
      padding: 1rem;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border: none;
      border-radius: 1rem;
      color: white;
      font-size: 1.1rem;
      font-weight: 600;
      cursor: pointer;
      transition: var(--hover-transition);
      margin-top: 1rem;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 15px rgba(190, 21, 21, 0.3);
    }

    .error-message {
      color: var(--accent);
      text-align: center;
      margin-top: 1rem;
      font-size: 0.9rem;
    }

    @media (max-width: 768px) {
      .login-container {
        grid-template-columns: 1fr;
      }
      
      .login-image {
        display: none;
      }
      
      .login-form {
        padding: 2rem;
      }
    }
  </style>
</head>
<body>
  <div class="login-container">
    <div class="login-image">
      <div class="brand-section">
        <i class="fas fa-utensils brand-icon"></i>
        <div class="brand-text">
          <h1>GrabIT</h1>
          <p>Admin Portal - Secure Access</p>
        </div>
      </div>
    </div>
    
    <div class="login-form">
      <div class="form-header">
        <h2>Welcome Back</h2>
        <p>Please sign in to continue</p>
      </div>
      
      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
          <label for="username">Username</label>
          <div class="input-group">
            <i class="fas fa-user"></i>
            <input type="text" id="username" name="username" class="form-control" placeholder="Enter your username" required />
          </div>
        </div>
        
        <div class="form-group">
          <label for="password">Password</label>
          <div class="input-group">
            <i class="fas fa-lock"></i>
            <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required />
          </div>
        </div>
        
        <button type="submit" class="btn-login">Sign In</button>
        
        <c:if test="${not empty error}">
          <div class="error-message">${error}</div>
        </c:if>
      </form>
    </div>
  </div>
</body>
</html> 