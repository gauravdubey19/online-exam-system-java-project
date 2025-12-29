<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Student Dashboard - Online Exam System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark">
                <div class="container">
                    <a class="navbar-brand" href="/student/dashboard">🎓 Student Portal</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <div class="navbar-nav ms-auto">
                            <a class="nav-link" href="/student/exams">Available Exams</a>
                            <a class="nav-link" href="/student/results">My Results</a>
                            <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container mt-4">
                <div class="dashboard-header">
                    <h3>Welcome back, ${student.name}! 👋</h3>
                    <p class="text-muted">Ready to take an exam?</p>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card stat-card">
                            <div class="stat-icon">📝</div>
                            <h5>Available Exams</h5>
                            <p>${exams.size()} exam(s) ready to attempt</p>
                            <a href="/student/exams" class="btn btn-primary">Browse Exams</a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card stat-card">
                            <div class="stat-icon">📊</div>
                            <h5>My Results</h5>
                            <p>View your exam scores and history</p>
                            <a href="/student/results" class="btn btn-primary">View Results</a>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>