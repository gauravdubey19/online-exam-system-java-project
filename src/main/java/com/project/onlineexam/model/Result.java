package com.project.onlineexam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;

@Document(collection = "results")
public class Result {
    @Id
    private String id;
    private String studentId;
    private String examId;
    private int score;
    private int totalQuestions;
    private Date submittedAt;

    public Result() {}

    public Result(String studentId, String examId, int score, int totalQuestions) {
        this.studentId = studentId;
        this.examId = examId;
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.submittedAt = new Date();
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
}
