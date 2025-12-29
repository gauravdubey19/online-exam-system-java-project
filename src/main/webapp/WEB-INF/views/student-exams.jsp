<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Available Exams - Online Exam System</title>
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
                            <a class="nav-link" href="/student/dashboard">Dashboard</a>
                            <a class="nav-link" href="/student/results">My Results</a>
                            <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container mt-4">
                <div class="dashboard-header">
                    <h3>📝 Available Exams</h3>
                    <p class="text-muted">Choose an exam to start</p>
                </div>

                <c:if test="${param.error == 'already_attempted'}">
                    <div class="alert alert-warning">You have already attempted this exam.</div>
                </c:if>

                <div class="row g-4">
                    <c:if test="${empty exams}">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body text-center py-5">
                                    <div style="font-size: 4rem; margin-bottom: 1rem;">📚</div>
                                    <h5>No exams available</h5>
                                    <p class="text-muted">Check back later for new exams</p>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:forEach var="exam" items="${exams}">
                        <div class="col-md-4">
                            <div class="card exam-card h-100">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${exam.title}</h5>
                                    <p class="card-text flex-grow-1">${exam.description}</p>
                                    <div class="exam-meta">
                                        <span>⏱️ ${exam.durationInMinutes} mins</span>
                                        <span class="ms-3">📋 ${exam.questionIds.size()} questions</span>
                                    </div>
                                    <div class="mt-3">
                                        <c:choose>
                                            <c:when test="${examService.hasAttempted(studentId, exam.id)}">
                                                <button class="btn btn-secondary w-100" disabled>✓ Completed</button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="/student/start/${exam.id}" class="btn btn-primary w-100">Start
                                                    Exam</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>