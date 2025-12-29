<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Manage Questions - Online Exam System</title>
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
                                <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="/logout">Logout</a>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container mt-4">
                    <div class="row">
                        <!-- Left: Add/Edit Question Form -->
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body p-4">
                                    <h4 class="mb-4" id="formTitle">➕ Add New Question</h4>

                                    <c:if test="${param.success == 'true'}">
                                        <div class="alert alert-success">Question added successfully!</div>
                                    </c:if>
                                    <c:if test="${param.updated == 'true'}">
                                        <div class="alert alert-info">Question updated successfully!</div>
                                    </c:if>
                                    <c:if test="${param.deleted == 'true'}">
                                        <div class="alert alert-warning">Question deleted!</div>
                                    </c:if>

                                    <c:if test="${empty exams}">
                                        <div class="alert alert-warning">
                                            No exams available. <a href="/admin/createExam">Create an exam first.</a>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty exams}">
                                        <form method="post" action="/admin/addQuestion" id="questionForm">
                                            <input type="hidden" name="questionId" id="questionId" value="">

                                            <div class="row">
                                                <div class="col-md-8 mb-3">
                                                    <label class="form-label">Select Exam</label>
                                                    <select name="examId" id="examSelect" class="form-select" required
                                                        onchange="loadExamQuestions()">
                                                        <option value="">Choose an exam...</option>
                                                        <c:forEach var="exam" items="${exams}">
                                                            <option value="${exam.id}" ${exam.id==selectedExamId
                                                                ? 'selected' : '' }>${exam.title}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Min Options</label>
                                                    <select id="minOptions" class="form-select"
                                                        onchange="updateMinOptions()">
                                                        <option value="2" selected>2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                        <option value="6">6</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Question Text</label>
                                                <textarea name="questionText" id="questionText" class="form-control"
                                                    rows="2" placeholder="Enter your question" required></textarea>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Options</label>
                                                <div id="optionsContainer">
                                                    <div class="option-row">
                                                        <span class="option-label-badge">A</span>
                                                        <input type="text" name="options" class="form-control"
                                                            placeholder="Option A" required>
                                                    </div>
                                                    <div class="option-row">
                                                        <span class="option-label-badge">B</span>
                                                        <input type="text" name="options" class="form-control"
                                                            placeholder="Option B" required>
                                                    </div>
                                                </div>
                                                <button type="button" class="btn btn-outline-secondary btn-sm mt-2"
                                                    onclick="addOption()">
                                                    ➕ Add Option
                                                </button>
                                            </div>

                                            <div class="mb-4">
                                                <label class="form-label">Correct Answer</label>
                                                <select name="correctAnswer" class="form-select"
                                                    id="correctAnswerSelect" required>
                                                    <option value="">Select correct answer...</option>
                                                    <option value="A">A</option>
                                                    <option value="B">B</option>
                                                </select>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <button type="submit" class="btn btn-primary flex-grow-1"
                                                    id="submitBtn">Add Question</button>
                                                <button type="button" class="btn btn-secondary" id="cancelBtn"
                                                    style="display:none;" onclick="resetForm()">Cancel</button>
                                            </div>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Existing Questions List -->
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body p-4">
                                    <h4 class="mb-4">📋 Existing Questions</h4>
                                    <div id="questionsListContainer">
                                        <c:choose>
                                            <c:when test="${not empty existingQuestions}">
                                                <c:forEach var="q" items="${existingQuestions}" varStatus="status">
                                                    <div class="question-item" id="question-${q.id}">
                                                        <div
                                                            class="d-flex justify-content-between align-items-start mb-2">
                                                            <div>
                                                                <span class="question-number">Q${status.index +
                                                                    1}</span>
                                                                <span class="correct-badge">Answer:
                                                                    ${q.correctAnswer}</span>
                                                            </div>
                                                            <div>
                                                                <button class="btn btn-sm btn-outline-warning"
                                                                    onclick='editQuestion("${q.id}")'>✏️ Edit</button>
                                                                <form method="post" action="/admin/deleteQuestion"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="questionId"
                                                                        value="${q.id}">
                                                                    <input type="hidden" name="examId"
                                                                        value="${selectedExamId}">
                                                                    <button type="submit"
                                                                        class="btn btn-sm btn-outline-danger"
                                                                        onclick="return confirm('Delete this question?')">🗑️</button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                        <p class="mb-2"><strong>${q.questionText}</strong></p>
                                                        <div class="small text-muted options-list"
                                                            data-options='<c:forEach var="opt" items="${q.options}" varStatus="os">${opt}<c:if test="${!os.last}">|||</c:if></c:forEach>'>
                                                        </div>
                                                        <script>
                                                            (function () {
                                                                var labels = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];
                                                                var container = document.currentScript.previousElementSibling;
                                                                var optionsStr = container.getAttribute('data-options');
                                                                if (optionsStr) {
                                                                    var opts = optionsStr.split('|||');
                                                                    opts.forEach(function (opt, i) {
                                                                        var div = document.createElement('div');
                                                                        div.textContent = labels[i] + '. ' + opt;
                                                                        container.appendChild(div);
                                                                    });
                                                                }
                                                                container.removeAttribute('data-options');
                                                            })();
                                                        </script>
                                                        <div class="question-data" data-id="${q.id}"
                                                            data-text="${fn:escapeXml(q.questionText)}"
                                                            data-options='<c:forEach var="opt" items="${q.options}" varStatus="os">${fn:escapeXml(opt)}<c:if test="${!os.last}">|||</c:if></c:forEach>'
                                                            data-answer="${q.correctAnswer}" style="display:none;">
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:when test="${not empty selectedExamId}">
                                                <div class="text-center text-muted py-4">
                                                    <div style="font-size: 3rem;">📝</div>
                                                    <p>No questions added yet</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center text-muted py-4">
                                                    <div style="font-size: 3rem;">👈</div>
                                                    <p>Select an exam to view questions</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    let optionCount = 2;
                    let minOptions = 2;
                    const maxOptions = 10;
                    let editingQuestionId = null;

                    function getOptionLabel(index) {
                        return String.fromCharCode(65 + index);
                    }

                    function updateMinOptions() {
                        const targetCount = parseInt(document.getElementById('minOptions').value);
                        minOptions = targetCount;

                        while (optionCount < targetCount) {
                            addOption();
                        }

                        while (optionCount > targetCount) {
                            const container = document.getElementById('optionsContainer');
                            const rows = container.querySelectorAll('.option-row');
                            if (rows.length > targetCount) {
                                rows[rows.length - 1].remove();
                                optionCount--;
                            }
                        }

                        updateOptionLabels();
                    }

                    function addOption() {
                        if (optionCount >= maxOptions) {
                            alert('Maximum ' + maxOptions + ' options allowed');
                            return;
                        }

                        const container = document.getElementById('optionsContainer');
                        const label = getOptionLabel(optionCount);

                        const optionRow = document.createElement('div');
                        optionRow.className = 'option-row';
                        optionRow.innerHTML =
                            '<span class="option-label-badge">' + label + '</span>' +
                            '<input type="text" name="options" class="form-control" placeholder="Option ' + label + '" required>' +
                            '<button type="button" class="btn btn-outline-danger btn-remove" onclick="removeOption(this)">✕</button>';
                        container.appendChild(optionRow);

                        const select = document.getElementById('correctAnswerSelect');
                        const option = document.createElement('option');
                        option.value = label;
                        option.textContent = label;
                        select.appendChild(option);

                        optionCount++;
                    }

                    function removeOption(button) {
                        if (optionCount <= minOptions) {
                            alert('Minimum ' + minOptions + ' options required');
                            return;
                        }

                        const row = button.closest('.option-row');
                        row.remove();
                        optionCount--;

                        updateOptionLabels();
                    }

                    function updateOptionLabels() {
                        const rows = document.querySelectorAll('#optionsContainer .option-row');
                        const select = document.getElementById('correctAnswerSelect');
                        const currentValue = select.value;

                        while (select.options.length > 1) {
                            select.remove(1);
                        }

                        rows.forEach(function (row, index) {
                            const label = getOptionLabel(index);
                            row.querySelector('.option-label-badge').textContent = label;
                            row.querySelector('input').placeholder = 'Option ' + label;

                            const option = document.createElement('option');
                            option.value = label;
                            option.textContent = label;
                            select.appendChild(option);
                        });

                        const validOptions = Array.from(select.options).map(function (o) { return o.value; });
                        if (validOptions.includes(currentValue)) {
                            select.value = currentValue;
                        } else {
                            select.value = '';
                        }
                    }

                    function loadExamQuestions() {
                        const examId = document.getElementById('examSelect').value;
                        if (examId) {
                            window.location.href = '/admin/addQuestion?examId=' + examId;
                        }
                    }

                    function editQuestion(id) {
                        const dataEl = document.querySelector('.question-data[data-id="' + id + '"]');
                        if (!dataEl) return;

                        const data = {
                            questionText: dataEl.getAttribute('data-text'),
                            options: dataEl.getAttribute('data-options').split('|||'),
                            correctAnswer: dataEl.getAttribute('data-answer')
                        };

                        editingQuestionId = id;

                        // Update form
                        document.getElementById('questionId').value = id;
                        document.getElementById('questionText').value = data.questionText;
                        document.getElementById('questionForm').action = '/admin/updateQuestion';
                        document.getElementById('formTitle').textContent = '✏️ Edit Question';
                        document.getElementById('submitBtn').textContent = 'Update Question';
                        document.getElementById('submitBtn').classList.remove('btn-primary');
                        document.getElementById('submitBtn').classList.add('btn-warning');
                        document.getElementById('cancelBtn').style.display = 'block';

                        // Clear and rebuild options
                        const container = document.getElementById('optionsContainer');
                        container.innerHTML = '';
                        optionCount = 0;

                        data.options.forEach(function (opt, index) {
                            const label = getOptionLabel(index);
                            const optionRow = document.createElement('div');
                            optionRow.className = 'option-row';
                            optionRow.innerHTML =
                                '<span class="option-label-badge">' + label + '</span>' +
                                '<input type="text" name="options" class="form-control" placeholder="Option ' + label + '" value="' + opt.replace(/"/g, '&quot;') + '" required>' +
                                (index >= 2 ? '<button type="button" class="btn btn-outline-danger btn-remove" onclick="removeOption(this)">✕</button>' : '');
                            container.appendChild(optionRow);
                            optionCount++;
                        });

                        // Update correct answer dropdown
                        updateOptionLabels();
                        document.getElementById('correctAnswerSelect').value = data.correctAnswer;

                        // Highlight editing question
                        document.querySelectorAll('.question-item').forEach(function (el) {
                            el.classList.remove('editing');
                        });
                        document.getElementById('question-' + id).classList.add('editing');

                        // Scroll to form
                        document.getElementById('questionForm').scrollIntoView({ behavior: 'smooth' });
                    }

                    function resetForm() {
                        editingQuestionId = null;
                        document.getElementById('questionId').value = '';
                        document.getElementById('questionText').value = '';
                        document.getElementById('questionForm').action = '/admin/addQuestion';
                        document.getElementById('formTitle').textContent = '➕ Add New Question';
                        document.getElementById('submitBtn').textContent = 'Add Question';
                        document.getElementById('submitBtn').classList.remove('btn-warning');
                        document.getElementById('submitBtn').classList.add('btn-primary');
                        document.getElementById('cancelBtn').style.display = 'none';

                        // Reset options to default 2
                        const container = document.getElementById('optionsContainer');
                        container.innerHTML =
                            '<div class="option-row">' +
                            '<span class="option-label-badge">A</span>' +
                            '<input type="text" name="options" class="form-control" placeholder="Option A" required>' +
                            '</div>' +
                            '<div class="option-row">' +
                            '<span class="option-label-badge">B</span>' +
                            '<input type="text" name="options" class="form-control" placeholder="Option B" required>' +
                            '</div>';
                        optionCount = 2;

                        updateOptionLabels();
                        document.getElementById('correctAnswerSelect').value = '';

                        // Remove highlight
                        document.querySelectorAll('.question-item').forEach(function (el) {
                            el.classList.remove('editing');
                        });
                    }
                </script>
            </body>

            </html>