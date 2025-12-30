package com.project.onlineexam.controller;

import com.project.onlineexam.model.*;
import com.project.onlineexam.service.CloudinaryService;
import com.project.onlineexam.service.ExamService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/student")
public class StudentController {
    @Autowired
    private ExamService examService;
    
    @Autowired
    private CloudinaryService cloudinaryService;

    private User getStudent(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && "STUDENT".equals(user.getRole())) {
            return user;
        }
        return null;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User student = getStudent(session);
        if (student == null) return "redirect:/login";
        model.addAttribute("exams", examService.getAllExams());
        model.addAttribute("student", student);
        return "student-dashboard";
    }

    @GetMapping("/exams")
    public String viewExams(HttpSession session, Model model) {
        User student = getStudent(session);
        if (student == null) return "redirect:/login";
        List<Exam> exams = examService.getAllExams();
        model.addAttribute("exams", exams);
        model.addAttribute("examService", examService);
        model.addAttribute("studentId", student.getId());
        return "student-exams";
    }

    @PostMapping("/api/start-exam")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> startExamWithPhoto(
            @RequestBody Map<String, String> payload,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User student = getStudent(session);
        if (student == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        String examId = payload.get("examId");
        String photoData = payload.get("photoData");
        
        if (examId == null || photoData == null) {
            response.put("success", false);
            response.put("message", "Missing required fields");
            return ResponseEntity.badRequest().body(response);
        }
        
        // Check if already completed
        if (examService.hasAttempted(student.getId(), examId)) {
            response.put("success", false);
            response.put("message", "You have already completed this exam");
            return ResponseEntity.badRequest().body(response);
        }
        
        // Upload photo to Cloudinary
        String photoUrl = cloudinaryService.uploadImage(photoData);
        if (photoUrl == null) {
            response.put("success", false);
            response.put("message", "Failed to upload photo");
            return ResponseEntity.status(500).body(response);
        }
        
        // Create result with NOT_ATTEMPTED status
        Result result = examService.startExam(student.getId(), examId, photoUrl);
        
        response.put("success", true);
        response.put("resultId", result.getId());
        response.put("photoUrl", photoUrl);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/api/save-answer")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveAnswer(
            @RequestBody Map<String, String> payload,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User student = getStudent(session);
        if (student == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        String examId = payload.get("examId");
        String questionId = payload.get("questionId");
        String answer = payload.get("answer");
        
        if (examId == null || questionId == null || answer == null) {
            response.put("success", false);
            response.put("message", "Missing required fields");
            return ResponseEntity.badRequest().body(response);
        }
        
        Result result = examService.saveAnswer(student.getId(), examId, questionId, answer);
        if (result != null) {
            response.put("success", true);
            response.put("savedAnswers", result.getSavedAnswers());
        } else {
            response.put("success", false);
            response.put("message", "Could not save answer");
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/saved-answers/{examId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSavedAnswers(
            @PathVariable String examId,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User student = getStudent(session);
        if (student == null) {
            response.put("success", false);
            return ResponseEntity.status(401).body(response);
        }
        
        Optional<Result> resultOpt = examService.getResultByStudentAndExam(student.getId(), examId);
        if (resultOpt.isPresent() && !"COMPLETED".equals(resultOpt.get().getStatus())) {
            response.put("success", true);
            response.put("savedAnswers", resultOpt.get().getSavedAnswers());
            response.put("startedAt", resultOpt.get().getStartedAt());
        } else {
            response.put("success", false);
            response.put("savedAnswers", new HashMap<>());
        }
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/start/{examId}")
    public String startExam(@PathVariable String examId, HttpSession session, Model model) {
        User student = getStudent(session);
        if (student == null) return "redirect:/login";
        if (examService.hasAttempted(student.getId(), examId)) {
            return "redirect:/student/exams?error=already_attempted";
        }
        
        // Check if exam was started (photo captured)
        Optional<Result> inProgress = examService.getInProgressResult(student.getId(), examId);
        if (inProgress.isEmpty()) {
            return "redirect:/student/exams?error=photo_required";
        }
        
        Optional<Exam> exam = examService.getExamById(examId);
        if (exam.isEmpty()) return "redirect:/student/exams";
        List<Question> questions = examService.getQuestionsByExamId(examId);
        model.addAttribute("exam", exam.get());
        model.addAttribute("questions", questions);
        model.addAttribute("savedAnswers", inProgress.get().getSavedAnswers());
        model.addAttribute("startedAt", inProgress.get().getStartedAt().getTime());
        return "exam-page";
    }

    @PostMapping("/submit")
    public String submitExam(@RequestParam String examId, @RequestParam Map<String, String> allParams,
                            HttpSession session, Model model) {
        User student = getStudent(session);
        if (student == null) return "redirect:/login";
        Map<String, String> answers = new HashMap<>();
        for (Map.Entry<String, String> entry : allParams.entrySet()) {
            if (entry.getKey().startsWith("answer_")) {
                String questionId = entry.getKey().substring(7);
                answers.put(questionId, entry.getValue());
            }
        }
        Result result = examService.submitExam(student.getId(), examId, answers);
        model.addAttribute("result", result);
        Optional<Exam> exam = examService.getExamById(examId);
        exam.ifPresent(e -> model.addAttribute("exam", e));
        return "result";
    }

    @GetMapping("/results")
    public String viewResults(HttpSession session, Model model) {
        User student = getStudent(session);
        if (student == null) return "redirect:/login";
        List<Result> results = examService.getResultsByStudentId(student.getId());
        model.addAttribute("results", results);
        model.addAttribute("exams", examService.getAllExams());
        return "student-results";
    }
}
