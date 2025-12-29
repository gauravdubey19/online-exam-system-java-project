package com.project.onlineexam.controller;

import com.project.onlineexam.model.*;
import com.project.onlineexam.service.ExamService;
import com.project.onlineexam.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private ExamService examService;
    @Autowired
    private UserService userService;

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("exams", examService.getAllExams());
        return "admin-dashboard";
    }

    @GetMapping("/createExam")
    public String createExamPage(HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        return "create-exam";
    }

    @PostMapping("/createExam")
    public String createExam(@RequestParam String title, @RequestParam String description,
                            @RequestParam int duration, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        Exam exam = new Exam(title, description, duration);
        examService.createExam(exam);
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/addQuestion")
    public String addQuestionPage(HttpSession session, Model model,
                                  @RequestParam(required = false) String examId) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("exams", examService.getAllExams());
        model.addAttribute("selectedExamId", examId);
        if (examId != null && !examId.isEmpty()) {
            model.addAttribute("existingQuestions", examService.getQuestionsByExamId(examId));
        }
        return "add-question";
    }

    @PostMapping("/addQuestion")
    public String addQuestion(@RequestParam String examId, @RequestParam String questionText,
                             @RequestParam List<String> options,
                             @RequestParam String correctAnswer, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        List<String> filteredOptions = new ArrayList<>();
        for (String opt : options) {
            if (opt != null && !opt.trim().isEmpty()) {
                filteredOptions.add(opt.trim());
            }
        }
        Question question = new Question(examId, questionText, filteredOptions, correctAnswer);
        examService.addQuestion(question);
        return "redirect:/admin/addQuestion?examId=" + examId + "&success=true";
    }

    @GetMapping("/api/questions/{examId}")
    @ResponseBody
    public ResponseEntity<List<Question>> getQuestionsByExam(@PathVariable String examId, HttpSession session) {
        if (!isAdmin(session)) return ResponseEntity.status(401).build();
        return ResponseEntity.ok(examService.getQuestionsByExamId(examId));
    }

    @PostMapping("/updateQuestion")
    public String updateQuestion(@RequestParam String questionId, @RequestParam String examId,
                                @RequestParam String questionText, @RequestParam List<String> options,
                                @RequestParam String correctAnswer, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        List<String> filteredOptions = new ArrayList<>();
        for (String opt : options) {
            if (opt != null && !opt.trim().isEmpty()) {
                filteredOptions.add(opt.trim());
            }
        }
        Optional<Question> existing = examService.getQuestionById(questionId);
        if (existing.isPresent()) {
            Question question = existing.get();
            question.setQuestionText(questionText);
            question.setOptions(filteredOptions);
            question.setCorrectAnswer(correctAnswer);
            examService.updateQuestion(question);
        }
        return "redirect:/admin/addQuestion?examId=" + examId + "&updated=true";
    }

    @PostMapping("/deleteQuestion")
    public String deleteQuestion(@RequestParam String questionId, @RequestParam String examId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        examService.deleteQuestion(questionId);
        return "redirect:/admin/addQuestion?examId=" + examId + "&deleted=true";
    }

    @GetMapping("/viewResults")
    public String viewResults(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        List<Result> results = examService.getAllResults();
        model.addAttribute("results", results);
        model.addAttribute("exams", examService.getAllExams());
        model.addAttribute("userService", userService);
        return "admin-results";
    }
}
