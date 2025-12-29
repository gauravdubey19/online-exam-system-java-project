<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Login - Online Exam System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="/css/style.css" rel="stylesheet">
        </head>

        <body>
            <div class="auth-container">
                <div class="auth-card">
                    <div class="card">
                        <div class="card-body p-4">
                            <div class="text-center">
                                <div class="auth-logo">🎓</div>
                                <h2 class="auth-title">Online Exam System</h2>
                                <p class="auth-subtitle">Sign in to your account</p>
                            </div>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">${success}</div>
                            </c:if>
                            <form method="post" action="/login">
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" name="email" class="form-control" placeholder="Enter your email"
                                        required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Password</label>
                                    <input type="password" name="password" class="form-control"
                                        placeholder="Enter your password" required>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 mb-3">Sign In</button>
                            </form>
                            <p class="text-center mb-0">Don't have an account? <a href="/register">Create one</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>