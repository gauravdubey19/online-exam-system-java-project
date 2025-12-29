<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${exam.title} - Online Exam System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark exam-header">
                <div class="container">
                    <span class="navbar-brand">📝 ${exam.title}</span>
                    <div class="timer" id="timer">⏱️ ${exam.durationInMinutes}:00</div>
                </div>
            </nav>

            <div class="container mt-4 mb-5">
                <form method="post" action="/student/submit" id="examForm">
                    <input type="hidden" name="examId" value="${exam.id}">
                    <% String[] labels={"A", "B" , "C" , "D" , "E" , "F" , "G" , "H" , "I" , "J" };
                        request.setAttribute("labels", labels); %>

                        <c:forEach var="question" items="${questions}" varStatus="status">
                            <div class="card question-card">
                                <div class="card-body">
                                    <h5>
                                        <span class="question-number">Q${status.index + 1}.</span>
                                        ${question.questionText}
                                    </h5>
                                    <div class="mt-4">
                                        <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                            <label class="option-item d-flex align-items-center"
                                                onclick="selectOption(this, 'q${status.index}opt${optStatus.index}')">
                                                <input class="form-check-input me-3" type="radio"
                                                    name="answer_${question.id}" value="${labels[optStatus.index]}"
                                                    id="q${status.index}opt${optStatus.index}">
                                                <span><strong>${labels[optStatus.index]}.</strong> ${option}</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <button type="submit" class="btn btn-primary btn-lg w-100">Submit Exam</button>
                </form>
            </div>

            <script>
                function selectOption(label, inputId) {
                    const parent = label.parentElement;
                    parent.querySelectorAll('.option-item').forEach(item => item.classList.remove('selected'));
                    label.classList.add('selected');
                }

                let duration = parseInt("<c:out value='${exam.durationInMinutes}'/>") * 60;
                const timerEl = document.getElementById('timer');

                const interval = setInterval(() => {
                    duration--;
                    const mins = Math.floor(duration / 60);
                    const secs = duration % 60;
                    timerEl.textContent = '⏱️ ' + mins + ':' + (secs < 10 ? '0' : '') + secs;

                    if (duration <= 60) {
                        timerEl.classList.add('warning');
                    }

                    if (duration <= 0) {
                        clearInterval(interval);
                        document.getElementById('examForm').submit();
                    }
                }, 1000);
            </script>
        </body>

        </html>