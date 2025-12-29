<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>My Results - Online Exam System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="/css/style.css" rel="stylesheet">
            </head>

            <body>
                <nav class="navbar navbar-expand-lg navbar-dark">
                    <div class="container">
                        <a class="navbar-brand" href="/student/dashboard">🎓 Student Portal</a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <div class="navbar-nav ms-auto">
                                <a class="nav-link" href="/student/dashboard">Dashboard</a>
                                <a class="nav-link" href="/student/exams">Available Exams</a>
                                <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container mt-4">
                    <div class="dashboard-header">
                        <h3>📊 My Results</h3>
                        <p class="text-muted">Your exam history and scores</p>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <c:if test="${empty results}">
                                <div class="text-center py-5">
                                    <div style="font-size: 4rem; margin-bottom: 1rem;">📋</div>
                                    <h5>No results yet</h5>
                                    <p class="text-muted">Complete an exam to see your results here</p>
                                    <a href="/student/exams" class="btn btn-primary">Browse Exams</a>
                                </div>
                            </c:if>

                            <c:if test="${not empty results}">
                                <div class="table-responsive">
                                    <table class="table table-dark">
                                        <thead>
                                            <tr>
                                                <th>Exam</th>
                                                <th>Score</th>
                                                <th>Percentage</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="result" items="${results}">
                                                <c:forEach var="exam" items="${exams}">
                                                    <c:if test="${exam.id == result.examId}">
                                                        <tr>
                                                            <td><strong>${exam.title}</strong></td>
                                                            <td>${result.score}/${result.totalQuestions}</td>
                                                            <td>
                                                                <c:set var="pct"
                                                                    value="${(result.score * 100.0) / result.totalQuestions}" />
                                                                <span
                                                                    class="${pct >= 60 ? 'text-success' : 'text-danger'}">
                                                                    ${String.format("%.1f", pct)}%
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${result.submittedAt}"
                                                                    pattern="dd MMM yyyy, HH:mm" />
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>