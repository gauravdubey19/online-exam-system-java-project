package com.project.onlineexam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.ArrayList;
import java.util.List;

@Document(collection = "questions")
public class Question {
    @Id
    private String id;
    private String examId;
    private String questionText;
    private List<String> options = new ArrayList<>();
    private String correctAnswer;

    public Question() {}

    public Question(String examId, String questionText, List<String> options, String correctAnswer) {
        this.examId = examId;
        this.questionText = questionText;
        this.options = options;
        this.correctAnswer = correctAnswer;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getExamId() { return examId; }
    public void setExamId(String examId) { this.examId = examId; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }
    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    
    // Helper method to get option label (A, B, C, etc.)
    public static String getOptionLabel(int index) {
        return String.valueOf((char) ('A' + index));
    }
}
