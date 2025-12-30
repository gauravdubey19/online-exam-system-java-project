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
                <c:if test="${param.error == 'photo_required'}">
                    <div class="alert alert-warning">Please capture your photo before starting the exam.</div>
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
                                            <c:when test="${examService.hasStartedExam(studentId, exam.id)}">
                                                <a href="/student/start/${exam.id}" class="btn btn-warning w-100">
                                                    ▶️ Continue Exam
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-primary w-100"
                                                    onclick="openCameraModal('${exam.id}', '${exam.title}')">
                                                    📷 Start Exam
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Camera Modal -->
            <div class="modal fade camera-modal" id="cameraModal" tabindex="-1" data-bs-backdrop="static">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">📷 Identity Verification</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                onclick="stopCamera()"></button>
                        </div>
                        <div class="modal-body">
                            <div class="photo-instructions">
                                <h6>📋 Instructions:</h6>
                                <ul class="mb-0 text-start">
                                    <li>Position your face clearly in the camera frame</li>
                                    <li>Ensure good lighting on your face</li>
                                    <li>Photo will be captured automatically after 5 seconds</li>
                                    <li>This photo will be saved for exam verification</li>
                                </ul>
                            </div>

                            <div class="camera-container">
                                <video id="cameraPreview" autoplay playsinline></video>
                                <canvas id="photoCanvas" style="display: none;"></canvas>
                                <img id="capturedPhoto" alt="Captured Photo">
                                <div class="countdown-overlay" id="countdown" style="display: none;"></div>
                            </div>

                            <div class="mt-3" id="cameraStatus">
                                <p class="text-muted">Initializing camera...</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                                onclick="stopCamera()">Cancel</button>
                            <button type="button" class="btn btn-capture text-white" id="captureBtn"
                                onclick="startCountdown()" disabled>
                                📸 Capture Photo
                            </button>
                            <button type="button" class="btn btn-success" id="proceedBtn" onclick="proceedToExam()"
                                style="display: none;">
                                ✓ Proceed to Exam
                            </button>
                            <button type="button" class="btn btn-warning" id="retakeBtn" onclick="retakePhoto()"
                                style="display: none;">
                                🔄 Retake
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                let currentExamId = null;
                let currentExamTitle = null;
                let stream = null;
                let capturedPhotoData = null;
                const cameraModal = new bootstrap.Modal(document.getElementById('cameraModal'));

                function openCameraModal(examId, examTitle) {
                    currentExamId = examId;
                    currentExamTitle = examTitle;
                    document.querySelector('.modal-title').textContent = '📷 Identity Verification - ' + examTitle;
                    cameraModal.show();
                    initCamera();
                }

                async function initCamera() {
                    const video = document.getElementById('cameraPreview');
                    const statusEl = document.getElementById('cameraStatus');
                    const captureBtn = document.getElementById('captureBtn');

                    try {
                        stream = await navigator.mediaDevices.getUserMedia({
                            video: {
                                width: { ideal: 640 },
                                height: { ideal: 480 },
                                facingMode: 'user'
                            }
                        });
                        video.srcObject = stream;
                        statusEl.innerHTML = '<p class="text-success">✓ Camera ready! Click "Capture Photo" when ready.</p>';
                        captureBtn.disabled = false;
                    } catch (err) {
                        console.error('Camera error:', err);
                        statusEl.innerHTML = '<p class="text-danger">❌ Could not access camera. Please allow camera permissions and try again.</p>';
                    }
                }

                function startCountdown() {
                    const countdownEl = document.getElementById('countdown');
                    const captureBtn = document.getElementById('captureBtn');
                    const statusEl = document.getElementById('cameraStatus');

                    captureBtn.disabled = true;
                    countdownEl.style.display = 'block';
                    statusEl.innerHTML = '<p class="text-warning">📸 Get ready! Photo capturing in...</p>';

                    let count = 5;
                    countdownEl.textContent = count;

                    const interval = setInterval(() => {
                        count--;
                        if (count > 0) {
                            countdownEl.textContent = count;
                        } else {
                            clearInterval(interval);
                            countdownEl.style.display = 'none';
                            capturePhoto();
                        }
                    }, 1000);
                }

                function capturePhoto() {
                    const video = document.getElementById('cameraPreview');
                    const canvas = document.getElementById('photoCanvas');
                    const capturedImg = document.getElementById('capturedPhoto');
                    const statusEl = document.getElementById('cameraStatus');

                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                    canvas.getContext('2d').drawImage(video, 0, 0);

                    capturedPhotoData = canvas.toDataURL('image/jpeg', 0.8);
                    capturedImg.src = capturedPhotoData;

                    // Hide video, show captured image
                    video.style.display = 'none';
                    capturedImg.style.display = 'block';

                    // Update buttons
                    document.getElementById('captureBtn').style.display = 'none';
                    document.getElementById('proceedBtn').style.display = 'inline-block';
                    document.getElementById('retakeBtn').style.display = 'inline-block';

                    statusEl.innerHTML = '<p class="text-success">✓ Photo captured! Review and proceed or retake.</p>';

                    // Stop camera stream
                    if (stream) {
                        stream.getTracks().forEach(track => track.stop());
                    }
                }

                function retakePhoto() {
                    const video = document.getElementById('cameraPreview');
                    const capturedImg = document.getElementById('capturedPhoto');

                    capturedPhotoData = null;
                    video.style.display = 'block';
                    capturedImg.style.display = 'none';

                    document.getElementById('captureBtn').style.display = 'inline-block';
                    document.getElementById('proceedBtn').style.display = 'none';
                    document.getElementById('retakeBtn').style.display = 'none';

                    initCamera();
                }

                async function proceedToExam() {
                    const proceedBtn = document.getElementById('proceedBtn');
                    const statusEl = document.getElementById('cameraStatus');

                    proceedBtn.disabled = true;
                    proceedBtn.innerHTML = '⏳ Uploading...';
                    statusEl.innerHTML = '<p class="text-info">📤 Uploading photo and starting exam...</p>';

                    try {
                        const response = await fetch('/student/api/start-exam', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({
                                examId: currentExamId,
                                photoData: capturedPhotoData
                            })
                        });

                        const data = await response.json();

                        if (data.success) {
                            statusEl.innerHTML = '<p class="text-success">✓ Photo uploaded! Redirecting to exam...</p>';
                            setTimeout(() => {
                                window.location.href = '/student/start/' + currentExamId;
                            }, 1000);
                        } else {
                            statusEl.innerHTML = '<p class="text-danger">❌ ' + (data.message || 'Failed to start exam') + '</p>';
                            proceedBtn.disabled = false;
                            proceedBtn.innerHTML = '✓ Proceed to Exam';
                        }
                    } catch (err) {
                        console.error('Error:', err);
                        statusEl.innerHTML = '<p class="text-danger">❌ Network error. Please try again.</p>';
                        proceedBtn.disabled = false;
                        proceedBtn.innerHTML = '✓ Proceed to Exam';
                    }
                }

                function stopCamera() {
                    if (stream) {
                        stream.getTracks().forEach(track => track.stop());
                    }
                    // Reset modal state
                    const video = document.getElementById('cameraPreview');
                    const capturedImg = document.getElementById('capturedPhoto');
                    video.style.display = 'block';
                    capturedImg.style.display = 'none';
                    document.getElementById('captureBtn').style.display = 'inline-block';
                    document.getElementById('captureBtn').disabled = true;
                    document.getElementById('proceedBtn').style.display = 'none';
                    document.getElementById('retakeBtn').style.display = 'none';
                    document.getElementById('cameraStatus').innerHTML = '<p class="text-muted">Initializing camera...</p>';
                    capturedPhotoData = null;
                }

                // Clean up on modal close
                document.getElementById('cameraModal').addEventListener('hidden.bs.modal', stopCamera);
            </script>
        </body>

        </html>