package com.project.onlineexam.repository;

import com.project.onlineexam.model.Result;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;
import java.util.Optional;

public interface ResultRepository extends MongoRepository<Result, String> {
    List<Result> findByStudentId(String studentId);
    List<Result> findByExamId(String examId);
    Optional<Result> findByStudentIdAndExamId(String studentId, String examId);
}
