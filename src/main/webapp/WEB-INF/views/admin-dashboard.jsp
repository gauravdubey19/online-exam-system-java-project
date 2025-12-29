<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Admin Dashboard - Online Exam System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark">
                <div class="container">
                    <a class="navbar-brand" href="/admin/dashboard">🎓 Admin Panel</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <div class="navbar-nav ms-auto">
                            <a class="nav-link" href="/admin/createExam">Create Exam</a>
                            <a class="nav-link" href="/admin/addQuestion">Add Questions</a>
                            <a class="nav-link" href="/admin/viewResults">View Results</a>
                            <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container mt-4">
                <div class="dashboard-header">
                    <h3>📋 Manage Exams</h3>
                    <p class="text-muted">Create and manage your exams</p>
                </div>

                <div class="card">
                    <div class="card-body">
                        <c:if test="${empty exams}">
                            <div class="text-center py-5">
                                <div style="font-size: 4rem; margin-bottom: 1rem;">📝</div>
                                <h5>No exams created yet</h5>
                                <p class="text-muted">Get started by creating your first exam</p>
                                <a href="/admin/createExam" class="btn btn-primary">Create Exam</a>
                            </div>
                        </c:if>
                        <c:if test="${not empty exams}">
                            <div class="table-responsive">
                                <table class="table table-dark">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Description</th>
                                            <th>Duration</th>
                                            <th>Questions</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="exam" items="${exams}">
                                            <tr>
                                                <td><strong>${exam.title}</strong></td>
                                                <td>${exam.description}</td>
                                                <td>⏱️ ${exam.durationInMinutes} mins</td>
                                                <td>📋 ${exam.questionIds.size()} questions</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${exam.questionIds.size() == 0}">
                                                            <a href="/admin/addQuestion?examId=${exam.id}"
                                                                class="btn btn-success btn-sm">➕ Add Questions</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="/admin/addQuestion?examId=${exam.id}"
                                                                class="btn btn-warning btn-sm">✏️ Update Questions</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
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