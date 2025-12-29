package com.project.onlineexam.repository;

import com.project.onlineexam.model.Question;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface QuestionRepository extends MongoRepository<Question, String> {
    List<Question> findByExamId(String examId);
}
