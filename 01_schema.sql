-- =====================================================
-- CASE 20: SCHOOL MANAGEMENT SYSTEM (Орта мектеп жүйесі)
-- Файл 1: Кестелерді құру (DDL)
-- СУБД: PostgreSQL (pgAdmin 4)
-- =====================================================

-- Қайта іске қосқанда ескі кестелерді тазалау (тәуелділік ретімен)
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS activity_enrollments CASCADE;
DROP TABLE IF EXISTS extracurricular_activities CASCADE;
DROP TABLE IF EXISTS homework_submissions CASCADE;
DROP TABLE IF EXISTS homework CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS lessons CASCADE;
DROP TABLE IF EXISTS schedules CASCADE;
DROP TABLE IF EXISTS teacher_subjects CASCADE;
DROP TABLE IF EXISTS subjects CASCADE;
DROP TABLE IF EXISTS student_parents CASCADE;
DROP TABLE IF EXISTS parents CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;

-- 1. teachers: мұғалімдер
CREATE TABLE teachers (
    teacher_id  SERIAL PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE,
    phone       VARCHAR(20),
    hire_date   DATE DEFAULT CURRENT_DATE
);

-- 2. classes: сыныптар (5A, 5B ...)
CREATE TABLE classes (
    class_id            SERIAL PRIMARY KEY,
    class_name          VARCHAR(10) NOT NULL UNIQUE,
    grade_level         INT NOT NULL CHECK (grade_level BETWEEN 1 AND 11),
    academic_year       VARCHAR(9) NOT NULL,              -- мысалы: 2026-2027
    homeroom_teacher_id INT REFERENCES teachers(teacher_id)  -- сынып жетекшісі
);

-- 3. students: оқушылар
CREATE TABLE students (
    student_id    SERIAL PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    birth_date    DATE NOT NULL,
    gender        CHAR(1) CHECK (gender IN ('M', 'F')),
    class_id      INT REFERENCES classes(class_id),
    enrolled_date DATE DEFAULT CURRENT_DATE
);

-- 4. parents: ата-аналар
CREATE TABLE parents (
    parent_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone     VARCHAR(20),
    email     VARCHAR(100)
);

-- 5. student_parents: оқушы мен ата-ана байланысы (көп-көпке)
CREATE TABLE student_parents (
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    parent_id  INT REFERENCES parents(parent_id)   ON DELETE CASCADE,
    relation   VARCHAR(20) NOT NULL,                 -- father / mother / guardian
    PRIMARY KEY (student_id, parent_id)
);

-- 6. subjects: пәндер
CREATE TABLE subjects (
    subject_id      SERIAL PRIMARY KEY,
    subject_name    VARCHAR(50) NOT NULL UNIQUE,
    hours_per_week  INT CHECK (hours_per_week > 0)
);

-- 7. teacher_subjects: мұғалім қандай пән беретіні (көп-көпке)
CREATE TABLE teacher_subjects (
    teacher_id INT REFERENCES teachers(teacher_id) ON DELETE CASCADE,
    subject_id INT REFERENCES subjects(subject_id) ON DELETE CASCADE,
    PRIMARY KEY (teacher_id, subject_id)
);

-- 8. schedules: апталық сабақ кестесі
CREATE TABLE schedules (
    schedule_id   SERIAL PRIMARY KEY,
    class_id      INT NOT NULL REFERENCES classes(class_id),
    subject_id    INT NOT NULL REFERENCES subjects(subject_id),
    teacher_id    INT NOT NULL REFERENCES teachers(teacher_id),
    day_of_week   INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 5),  -- 1=Дүйсенбі ... 5=Жұма
    lesson_number INT NOT NULL CHECK (lesson_number BETWEEN 1 AND 8),
    room          VARCHAR(10),
    UNIQUE (class_id, day_of_week, lesson_number)   -- сыныпта бір уақытта 1 сабақ
);

-- 9. lessons: өткен нақты сабақтар (күні бойынша)
CREATE TABLE lessons (
    lesson_id   SERIAL PRIMARY KEY,
    schedule_id INT NOT NULL REFERENCES schedules(schedule_id),
    lesson_date DATE NOT NULL,
    topic       VARCHAR(200)
);

-- 10. grades: журнал бағалары (қазақстандық 5 балдық жүйе: 2-5)
CREATE TABLE grades (
    grade_id   SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    lesson_id  INT NOT NULL REFERENCES lessons(lesson_id),
    grade      INT NOT NULL CHECK (grade BETWEEN 2 AND 5),
    comment    VARCHAR(200)
);

-- 11. attendance: қатысу
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    lesson_id     INT NOT NULL REFERENCES lessons(lesson_id),
    student_id    INT NOT NULL REFERENCES students(student_id),
    status        VARCHAR(10) NOT NULL CHECK (status IN ('present', 'absent', 'late')),
    UNIQUE (lesson_id, student_id)
);

-- 12. homework: үй тапсырмасы
CREATE TABLE homework (
    homework_id SERIAL PRIMARY KEY,
    lesson_id   INT NOT NULL REFERENCES lessons(lesson_id),
    description VARCHAR(300) NOT NULL,
    due_date    DATE NOT NULL
);

-- 13. homework_submissions: оқушылардың тапсырған жұмысы
CREATE TABLE homework_submissions (
    submission_id SERIAL PRIMARY KEY,
    homework_id   INT NOT NULL REFERENCES homework(homework_id),
    student_id    INT NOT NULL REFERENCES students(student_id),
    submitted_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    score         INT CHECK (score BETWEEN 2 AND 5),
    UNIQUE (homework_id, student_id)
);

-- 14. extracurricular_activities: үйірмелер
CREATE TABLE extracurricular_activities (
    activity_id   SERIAL PRIMARY KEY,
    activity_name VARCHAR(100) NOT NULL,
    teacher_id    INT REFERENCES teachers(teacher_id),
    monthly_fee   NUMERIC(10,2) DEFAULT 0
);

-- 15. activity_enrollments: үйірмеге жазылу
CREATE TABLE activity_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    activity_id   INT NOT NULL REFERENCES extracurricular_activities(activity_id),
    student_id    INT NOT NULL REFERENCES students(student_id),
    enroll_date   DATE DEFAULT CURRENT_DATE,
    UNIQUE (activity_id, student_id)
);

-- 16. payments: төлемдер
CREATE TABLE payments (
    payment_id   SERIAL PRIMARY KEY,
    student_id   INT NOT NULL REFERENCES students(student_id),
    activity_id  INT REFERENCES extracurricular_activities(activity_id),  -- үйірме төлемі болса
    amount       NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    payment_type VARCHAR(10) NOT NULL CHECK (payment_type IN ('tuition', 'activity')),
    payment_date DATE DEFAULT CURRENT_DATE,
    status       VARCHAR(10) DEFAULT 'paid' CHECK (status IN ('paid', 'pending'))
);
