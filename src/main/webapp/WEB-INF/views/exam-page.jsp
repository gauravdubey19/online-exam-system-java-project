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

            <div class="saving-indicator" id="savingIndicator"></div>

            <div class="container mt-4 mb-5">
                <form method="post" action="/student/submit" id="examForm">
                    <input type="hidden" name="examId" value="${exam.id}" id="examId">
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
                                                onclick="selectOption(this, '${question.id}', '${labels[optStatus.index]}')">
                                                <input class="form-check-input me-3" type="radio"
                                                    name="answer_${question.id}" value="${labels[optStatus.index]}"
                                                    id="q${question.id}opt${optStatus.index}"
                                                    data-question-id="${question.id}">
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
                (function () {
                    var examId = document.getElementById('examId').value;
                    var examStartedAt = <c:out value="${startedAt}" default="Date.now()" />;
                    var durationMinutes = parseInt("${exam.durationInMinutes}");

                    // Parse saved answers from server
                    var savedAnswers = {};
                    <c:if test="${savedAnswers != null}">
                        <c:forEach var="entry" items="${savedAnswers}">
                            savedAnswers["${entry.key}"] = "${entry.value}";
                        </c:forEach>
                    </c:if>

                    // Calculate remaining time based on when exam was started
                    function calculateRemainingTime() {
                        var now = Date.now();
                        var elapsed = Math.floor((now - examStartedAt) / 1000);
                        var totalSeconds = durationMinutes * 60;
                        return Math.max(0, totalSeconds - elapsed);
                    }

                    // Restore saved answers on page load
                    function restoreSavedAnswers() {
                        for (const [questionId, answer] of Object.entries(savedAnswers)) {
                            const inputs = document.querySelectorAll('input[name="answer_' + questionId + '"]');
                            inputs.forEach(input => {
                                if (input.value === answer) {
                                    input.checked = true;
                                    input.closest('.option-item').classList.add('selected', 'saved');
                                }
                            });
                        }
                    }

                    function selectOption(label, questionId, answer) {
                        const parent = label.parentElement;
                        parent.querySelectorAll('.option-item').forEach(item => {
                            item.classList.remove('selected');
                        });
                        label.classList.add('selected');

                        // Save answer to server
                        saveAnswer(questionId, answer);
                    }

                    async function saveAnswer(questionId, answer) {
                        const indicator = document.getElementById('savingIndicator');
                        indicator.textContent = '💾 Saving...';
                        indicator.className = 'saving-indicator saving';
                        indicator.style.display = 'block';

                        try {
                            const response = await fetch('/student/api/save-answer', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({
                                    examId: examId,
                                    questionId: questionId,
                                    answer: answer
                                })
                            });

                            const data = await response.json();

                            if (data.success) {
                                indicator.textContent = '✓ Saved';
                                indicator.className = 'saving-indicator saved';

                                // Mark the option as saved
                                const selectedInput = document.querySelector('input[name="answer_' + questionId + '"]:checked');
                                if (selectedInput) {
                                    selectedInput.closest('.option-item').classList.add('saved');
                                }
                            } else {
                                indicator.textContent = '❌ Save failed';
                                indicator.className = 'saving-indicator error';
                            }
                        } catch (err) {
                            console.error('Save error:', err);
                            indicator.textContent = '❌ Network error';
                            indicator.className = 'saving-indicator error';
                        }

                        setTimeout(() => {
                            indicator.style.display = 'none';
                        }, 2000);
                    }

                    // Timer with remaining time calculation
                    var duration = calculateRemainingTime();
                    var timerEl = document.getElementById('timer');

                    function updateTimer() {
                        var mins = Math.floor(duration / 60);
                        var secs = duration % 60;
                        timerEl.textContent = '⏱️ ' + mins + ':' + (secs < 10 ? '0' : '') + secs;

                        if (duration <= 60) {
                            timerEl.classList.add('warning');
                        }

                        if (duration <= 0) {
                            clearInterval(interval);
                            alert('Time is up! Submitting your exam...');
                            document.getElementById('examForm').submit();
                        }

                        duration--;
                    }

                    // Initial timer display
                    updateTimer();
                    var interval = setInterval(updateTimer, 1000);

                    // Restore saved answers when page loads
                    document.addEventListener('DOMContentLoaded', restoreSavedAnswers);

                    // Warn before leaving page
                    window.addEventListener('beforeunload', function (e) {
                        e.preventDefault();
                        e.returnValue = 'Your answers are saved, but are you sure you want to leave?';
                    });

                    // Remove warning when submitting
                    document.getElementById('examForm').addEventListener('submit', function () {
                        window.removeEventListener('beforeunload', function () { });
                    });
                })();
            </script>
        </body>

        </html>