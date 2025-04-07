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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
  <style>
    /* ... (keep all the existing CSS styles) ... */
  </style>
</head>
<body>
  <div class="login-container">
    <div class="brand">
      <i class="fas fa-utensils brand-icon"></i>
      <div class="brand-text">
        <h1>GrabIT</h1>
        <p>Admin Portal</p>
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