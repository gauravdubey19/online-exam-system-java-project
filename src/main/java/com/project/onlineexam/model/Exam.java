package com.project.onlineexam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.List;
import java.util.ArrayList;

@Document(collection = "exams")
public class Exam {
    @Id
    private String id;
    private String title;
    private String description;
    private int durationInMinutes;
    private List<String> questionIds = new ArrayList<>();

    public Exam() {}

    public Exam(String title, String description, int durationInMinutes) {
        this.title = title;
        this.description = description;
        this.durationInMinutes = durationInMinutes;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getDurationInMinutes() { return durationInMinutes; }
    public void setDurationInMinutes(int durationInMinutes) { this.durationInMinutes = durationInMinutes; }
    public List<String> getQuestionIds() { return questionIds; }
    public void setQuestionIds(List<String> questionIds) { this.questionIds = questionIds; }
}
