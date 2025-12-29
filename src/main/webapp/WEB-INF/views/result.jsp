<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Exam Result - Online Exam System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark">
                <div class="container">
                    <a class="navbar-brand" href="/student/dashboard">🎓 Student Portal</a>
                    <div class="navbar-nav ms-auto">
                        <a class="nav-link" href="/student/dashboard">Dashboard</a>
                        <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body result-container">
                                <h3 class="mb-2">🎉 Exam Completed!</h3>
                                <p class="text-muted mb-4">${exam.title}</p>

                                <div class="score-circle">
                                    <span class="score-text">${result.score}/${result.totalQuestions}</span>
                                </div>

                                <c:set var="percentage" value="${(result.score * 100) / result.totalQuestions}" />

                                <h4 class="result-message">
                                    <c:choose>
                                        <c:when test="${percentage >= 80}">🏆 Excellent!</c:when>
                                        <c:when test="${percentage >= 60}">👍 Good Job!</c:when>
                                        <c:when test="${percentage >= 40}">📚 Keep Practicing!</c:when>
                                        <c:otherwise>💪 Don't Give Up!</c:otherwise>
                                    </c:choose>
                                </h4>

                                <p class="result-percentage">Score: ${String.format("%.1f", percentage)}%</p>

                                <a href="/student/exams" class="btn btn-primary mt-3">Back to Exams</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>