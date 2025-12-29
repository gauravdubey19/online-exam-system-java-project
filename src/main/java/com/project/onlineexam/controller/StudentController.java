package com.project.onlineexam.controller;

import com.project.onlineexam.model.*;
import com.project.onlineexam.service.ExamService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
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

    @GetMapping("/start/{examId}")
    public String startExam(@PathVariable String examId, HttpSession session, Model model) {
        User student = getStudent(session);
        if (student == null) return "redirect:/login";
        if (examService.hasAttempted(student.getId(), examId)) {
            return "redirect:/student/exams?error=already_attempted";
        }
        Optional<Exam> exam = examService.getExamById(examId);
        if (exam.isEmpty()) return "redirect:/student/exams";
        List<Question> questions = examService.getQuestionsByExamId(examId);
        model.addAttribute("exam", exam.get());
        model.addAttribute("questions", questions);
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
