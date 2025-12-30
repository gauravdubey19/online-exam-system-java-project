package com.project.onlineexam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Document(collection = "results")
public class Result {
    @Id
    private String id;
    private String studentId;
    private String examId;
    private int score;
    private int totalQuestions;
    private Date submittedAt;
    private String status; // NOT_ATTEMPTED, IN_PROGRESS, COMPLETED
    private String photoUrl;
    private Map<String, String> savedAnswers; // questionId -> selected answer
    private Date startedAt;

    public Result() {
        this.savedAnswers = new HashMap<>();
    }

    public Result(String studentId, String examId, int score, int totalQuestions) {
        this.studentId = studentId;
        this.examId = examId;
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.submittedAt = new Date();
        this.status = "COMPLETED";
        this.savedAnswers = new HashMap<>();
    }

    // Constructor for starting exam with photo
    public Result(String studentId, String examId, String photoUrl) {
        this.studentId = studentId;
        this.examId = examId;
        this.photoUrl = photoUrl;
        this.status = "NOT_ATTEMPTED";
        this.startedAt = new Date();
        this.savedAnswers = new HashMap<>();
        this.score = 0;
        this.totalQuestions = 0;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public String getExamId() { return examId; }
    public void setExamId(String examId) { this.examId = examId; }
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }
    public Date getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Date submittedAt) { this.submittedAt = submittedAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }
    public Map<String, String> getSavedAnswers() { return savedAnswers; }
    public void setSavedAnswers(Map<String, String> savedAnswers) { this.savedAnswers = savedAnswers; }
    public Date getStartedAt() { return startedAt; }
    public void setStartedAt(Date startedAt) { this.startedAt = startedAt; }
}
