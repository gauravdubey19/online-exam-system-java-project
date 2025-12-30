package com.project.onlineexam.service;

import com.project.onlineexam.model.Exam;
import com.project.onlineexam.model.Question;
import com.project.onlineexam.model.Result;
import com.project.onlineexam.repository.ExamRepository;
import com.project.onlineexam.repository.QuestionRepository;
import com.project.onlineexam.repository.ResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ExamService {
    @Autowired
    private ExamRepository examRepository;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private ResultRepository resultRepository;

    public Exam createExam(Exam exam) {
        return examRepository.save(exam);
    }

    public List<Exam> getAllExams() {
        return examRepository.findAll();
    }

    public Optional<Exam> getExamById(String id) {
        return examRepository.findById(id);
    }

    public Question addQuestion(Question question) {
        Question saved = questionRepository.save(question);
        Optional<Exam> exam = examRepository.findById(question.getExamId());
        if (exam.isPresent()) {
            exam.get().getQuestionIds().add(saved.getId());
            examRepository.save(exam.get());
        }
        return saved;
    }

    public List<Question> getQuestionsByExamId(String examId) {
        return questionRepository.findByExamId(examId);
    }

    public Result submitExam(String studentId, String examId, Map<String, String> answers) {
        List<Question> questions = questionRepository.findByExamId(examId);
        int score = 0;
        for (Question q : questions) {
            String answer = answers.get(q.getId());
            if (answer != null && answer.equals(q.getCorrectAnswer())) {
                score++;
            }
        }
        
        // Check if there's an existing result (in-progress)
        Optional<Result> existingResult = resultRepository.findByStudentIdAndExamId(studentId, examId);
        if (existingResult.isPresent()) {
            Result result = existingResult.get();
            result.setScore(score);
            result.setTotalQuestions(questions.size());
            result.setStatus("COMPLETED");
            result.setSubmittedAt(new Date());
            result.setSavedAnswers(answers);
            return resultRepository.save(result);
        }
        
        Result result = new Result(studentId, examId, score, questions.size());
        return resultRepository.save(result);
    }

    public List<Result> getResultsByStudentId(String studentId) {
        return resultRepository.findByStudentId(studentId);
    }

    public List<Result> getAllResults() {
        return resultRepository.findAll();
    }

    public boolean hasAttempted(String studentId, String examId) {
        Optional<Result> result = resultRepository.findByStudentIdAndExamId(studentId, examId);
        return result.isPresent() && "COMPLETED".equals(result.get().getStatus());
    }

    public boolean hasStartedExam(String studentId, String examId) {
        return resultRepository.findByStudentIdAndExamId(studentId, examId).isPresent();
    }

    public Optional<Result> getInProgressResult(String studentId, String examId) {
        Optional<Result> result = resultRepository.findByStudentIdAndExamId(studentId, examId);
        if (result.isPresent() && !"COMPLETED".equals(result.get().getStatus())) {
            return result;
        }
        return Optional.empty();
    }

    public Result startExam(String studentId, String examId, String photoUrl) {
        // Check if already started
        Optional<Result> existing = resultRepository.findByStudentIdAndExamId(studentId, examId);
        if (existing.isPresent()) {
            return existing.get();
        }
        Result result = new Result(studentId, examId, photoUrl);
        return resultRepository.save(result);
    }

    public Result saveAnswer(String studentId, String examId, String questionId, String answer) {
        Optional<Result> resultOpt = resultRepository.findByStudentIdAndExamId(studentId, examId);
        if (resultOpt.isPresent()) {
            Result result = resultOpt.get();
            if (!"COMPLETED".equals(result.getStatus())) {
                result.getSavedAnswers().put(questionId, answer);
                result.setStatus("IN_PROGRESS");
                return resultRepository.save(result);
            }
        }
        return null;
    }

    public Optional<Result> getResultByStudentAndExam(String studentId, String examId) {
        return resultRepository.findByStudentIdAndExamId(studentId, examId);
    }

    public Question updateQuestion(Question question) {
        return questionRepository.save(question);
    }

    public void deleteQuestion(String questionId) {
        Optional<Question> question = questionRepository.findById(questionId);
        if (question.isPresent()) {
            String examId = question.get().getExamId();
            questionRepository.deleteById(questionId);
            Optional<Exam> exam = examRepository.findById(examId);
            if (exam.isPresent()) {
                exam.get().getQuestionIds().remove(questionId);
                examRepository.save(exam.get());
            }
        }
    }

    public Optional<Question> getQuestionById(String questionId) {
        return questionRepository.findById(questionId);
    }
}
