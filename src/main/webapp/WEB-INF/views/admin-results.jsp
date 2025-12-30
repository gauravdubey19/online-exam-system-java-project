<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>All Results - Online Exam System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="/css/style.css" rel="stylesheet">
            </head>

            <body>
                <nav class="navbar navbar-expand-lg navbar-dark">
                    <div class="container">
                        <a class="navbar-brand" href="/admin/dashboard">🎓 Admin Panel</a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <div class="navbar-nav ms-auto">
                                <a class="nav-link" href="/admin/dashboard">Dashboard</a>
                                <a class="nav-link" href="/admin/createExam">Create Exam</a>
                                <a class="nav-link" href="/admin/addQuestion">Add Questions</a>
                                <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container mt-4">
                    <div class="dashboard-header">
                        <h3>📊 All Student Results</h3>
                        <p class="text-muted">View all exam submissions</p>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <c:if test="${empty results}">
                                <div class="text-center py-5">
                                    <div style="font-size: 4rem; margin-bottom: 1rem;">📋</div>
                                    <h5>No results yet</h5>
                                    <p class="text-muted">Results will appear here when students complete exams</p>
                                </div>
                            </c:if>

                            <c:if test="${not empty results}">
                                <div class="table-responsive">
                                    <table class="table table-dark">
                                        <thead>
                                            <tr>
                                                <th>Photo</th>
                                                <th>Student</th>
                                                <th>Exam</th>
                                                <th>Status</th>
                                                <th>Score</th>
                                                <th>Percentage</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="result" items="${results}">
                                                <tr>
                                                    <td>
                                                        <c:if test="${not empty result.photoUrl}">
                                                            <img src="${result.photoUrl}" alt="Student Photo" 
                                                                style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover; cursor: pointer;"
                                                                onclick="showPhoto('${result.photoUrl}')">
                                                        </c:if>
                                                        <c:if test="${empty result.photoUrl}">
                                                            <span class="text-muted">No photo</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:set var="student"
                                                            value="${userService.findById(result.studentId).orElse(null)}" />
                                                        <strong>${student != null ? student.name : 'Unknown'}</strong>
                                                    </td>
                                                    <td>
                                                        <c:forEach var="exam" items="${exams}">
                                                            <c:if test="${exam.id == result.examId}">${exam.title}
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${result.status == 'COMPLETED'}">
                                                                <span class="badge bg-success">Completed</span>
                                                            </c:when>
                                                            <c:when test="${result.status == 'IN_PROGRESS'}">
                                                                <span class="badge bg-warning">In Progress</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Not Attempted</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${result.score}/${result.totalQuestions}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${result.totalQuestions > 0}">
                                                                <c:set var="pct"
                                                                    value="${(result.score * 100.0) / result.totalQuestions}" />
                                                                <span class="${pct >= 60 ? 'text-success' : 'text-danger'}">
                                                                    ${String.format("%.1f", pct)}%
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${result.submittedAt}"
                                                            pattern="dd MMM yyyy, HH:mm" />
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
                <script>
                    function showPhoto(url) {
                        window.open(url, '_blank', 'width=600,height=600');
                    }
                </script>
            </body>

            </html>