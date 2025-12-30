# Online Exam System

A web-based exam system built with Spring Boot, MongoDB Atlas, and JSP with dark theme.

## Features

### Admin

- Login to admin dashboard
- Create exams with title, description, and duration
- Add multiple-choice questions to exams
- View all student results

### Student

- Register and login
- View available exams
- Attempt exams with timer
- Submit and view results

## Tech Stack

- Backend: Spring Boot 3.2
- Database: MongoDB Atlas
- Frontend: JSP with Bootstrap 5 (Dark Theme)
- Build: Maven

## Setup

1. **Configure MongoDB Atlas**

   Update `src/main/resources/application.properties`:

   ```
   spring.data.mongodb.uri=mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/online_exam
   ```

2. **Build and Run**

   ```bash
   cd online-exam-system
   mvn spring-boot:run
   ```

3. **Access the Application**
   - URL: http://localhost:8080
   - Default Admin: `admin@exam.com` / `aDmin@123`

## Project Structure

```
src/main/java/com/project/onlineexam/
├── controller/     # AuthController, AdminController, StudentController
├── service/        # UserService, ExamService
├── repository/     # MongoDB repositories
├── model/          # User, Exam, Question, Result
└── config/         # DataInitializer

src/main/webapp/WEB-INF/views/
├── login.jsp, register.jsp
├── admin-dashboard.jsp, create-exam.jsp, add-question.jsp, admin-results.jsp
├── student-dashboard.jsp, student-exams.jsp, exam-page.jsp, result.jsp, student-results.jsp
```

## Exam Flow

1. Admin creates exam → Adds questions
2. Student views available exams → Starts exam
3. Timer runs → Student answers → Submits
4. System evaluates → Shows result
