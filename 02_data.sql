-- =====================================================
-- Файл 2: Тест деректерін енгізу (INSERT)
-- Алдымен 01_schema.sql орындалуы керек!
-- =====================================================

-- Мұғалімдер
INSERT INTO teachers (full_name, email, phone, hire_date) VALUES
('Айгерім Нұрланқызы', 'aigerim@school.kz', '+77011111111', '2018-09-01'),
('Берік Сейітов',      'berik@school.kz',   '+77022222222', '2019-09-01'),
('Дана Омарова',       'dana@school.kz',    '+77033333333', '2020-09-01');

-- Сыныптар (сынып жетекшісі = teacher_id)
INSERT INTO classes (class_name, grade_level, academic_year, homeroom_teacher_id) VALUES
('5A', 5, '2026-2027', 1),
('5B', 5, '2026-2027', 2);

-- Оқушылар
INSERT INTO students (full_name, birth_date, gender, class_id, enrolled_date) VALUES
('Алихан Ермеков',    '2015-03-12', 'M', 1, '2026-09-01'),
('Айша Садыкова',     '2015-07-25', 'F', 1, '2026-09-01'),
('Нұрсұлтан Қасым',   '2015-01-05', 'M', 1, '2026-09-01'),
('Томирис Ахметова',  '2015-11-30', 'F', 2, '2026-09-01'),
('Данияр Жұмабек',    '2015-05-18', 'M', 2, '2026-09-01'),
('Аружан Бекова',     '2015-09-09', 'F', 2, '2026-09-01');

-- Ата-аналар
INSERT INTO parents (full_name, phone, email) VALUES
('Ермеков Серік',   '+77051000001', 'serik@mail.kz'),
('Ермекова Гүлнар', '+77051000002', 'gulnar@mail.kz'),
('Садыков Марат',   '+77051000003', 'marat@mail.kz'),
('Қасымова Айнур',  '+77051000004', 'ainur@mail.kz'),
('Ахметов Талгат',  '+77051000005', 'talgat@mail.kz'),
('Жұмабек Нұрлан',  '+77051000006', 'nurlan@mail.kz'),
('Бекова Салтанат', '+77051000007', 'saltanat@mail.kz');

-- Оқушы - ата-ана байланысы (Алиханның 2 ата-анасы бар)
INSERT INTO student_parents (student_id, parent_id, relation) VALUES
(1, 1, 'father'),
(1, 2, 'mother'),
(2, 3, 'father'),
(3, 4, 'mother'),
(4, 5, 'father'),
(5, 6, 'father'),
(6, 7, 'mother');

-- Пәндер
INSERT INTO subjects (subject_name, hours_per_week) VALUES
('Математика',   5),
('Қазақ тілі',   4),
('Информатика',  2);

-- Мұғалім - пән
INSERT INTO teacher_subjects (teacher_id, subject_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Сабақ кестесі (day_of_week: 1=Дс, 2=Сс, 3=Ср ...)
INSERT INTO schedules (class_id, subject_id, teacher_id, day_of_week, lesson_number, room) VALUES
(1, 1, 1, 1, 1, '101'),   -- 5A Математика, Дс, 1-сабақ
(1, 3, 3, 2, 2, '201'),   -- 5A Информатика, Сс, 2-сабақ
(2, 2, 2, 1, 1, '102'),   -- 5B Қазақ тілі, Дс, 1-сабақ
(2, 1, 1, 3, 3, '101');   -- 5B Математика, Ср, 3-сабақ

-- Өткен сабақтар
INSERT INTO lessons (schedule_id, lesson_date, topic) VALUES
(1, '2026-11-02', 'Жай бөлшектер'),
(1, '2026-11-09', 'Ондық бөлшектер'),
(2, '2026-11-03', 'Алгоритм дегеніміз не'),
(3, '2026-11-02', 'Зат есім'),
(4, '2026-11-04', 'Жай бөлшектер');

-- Бағалар
INSERT INTO grades (student_id, lesson_id, grade, comment) VALUES
(1, 1, 5, 'Өте жақсы'),
(2, 1, 4, NULL),
(3, 1, 3, 'Көбірек жаттығу керек'),
(1, 2, 5, NULL),
(3, 2, 4, NULL),
(1, 3, 5, NULL),
(2, 3, 5, NULL),
(3, 3, 4, NULL),
(4, 4, 4, NULL),
(5, 4, 3, NULL),
(6, 4, 5, NULL),
(4, 5, 5, NULL),
(6, 5, 4, NULL);

-- Қатысу
INSERT INTO attendance (lesson_id, student_id, status) VALUES
(1, 1, 'present'), (1, 2, 'absent'),  (1, 3, 'late'),
(2, 1, 'present'), (2, 2, 'absent'),  (2, 3, 'present'),
(3, 1, 'present'), (3, 2, 'present'), (3, 3, 'present'),
(4, 4, 'present'), (4, 5, 'present'), (4, 6, 'absent'),
(5, 4, 'present'), (5, 5, 'absent'),  (5, 6, 'present');

-- Үй тапсырмасы
INSERT INTO homework (lesson_id, description, due_date) VALUES
(1, 'Оқулық 25-бет, 1-5 есептер', '2026-11-09'),
(4, '10 зат есімді тауып жазу',   '2026-11-09');

-- Үй тапсырмасын тапсыру (3-оқушы мен 6-оқушы тапсырмаған)
INSERT INTO homework_submissions (homework_id, student_id, submitted_at, score) VALUES
(1, 1, '2026-11-08 18:00', 5),
(1, 2, '2026-11-08 20:30', 4),
(2, 4, '2026-11-07 17:15', 5),
(2, 5, '2026-11-09 08:00', 3);

-- Үйірмелер
INSERT INTO extracurricular_activities (activity_name, teacher_id, monthly_fee) VALUES
('Шахмат үйірмесі',  3, 5000),
('Футбол секциясы',  2, 7000),
('Робототехника',    3, 10000);

-- Үйірмеге жазылу
INSERT INTO activity_enrollments (activity_id, student_id, enroll_date) VALUES
(1, 1, '2026-09-05'),
(1, 2, '2026-09-05'),
(2, 4, '2026-09-06'),
(3, 3, '2026-09-07'),
(3, 5, '2026-09-07');

-- Төлемдер
INSERT INTO payments (student_id, activity_id, amount, payment_type, payment_date, status) VALUES
(1, NULL, 50000, 'tuition',  '2026-09-01', 'paid'),
(2, NULL, 50000, 'tuition',  '2026-09-01', 'paid'),
(3, NULL, 50000, 'tuition',  '2026-09-01', 'pending'),
(4, NULL, 50000, 'tuition',  '2026-09-02', 'paid'),
(1, 1,     5000, 'activity', '2026-09-10', 'paid'),
(2, 1,     5000, 'activity', '2026-09-10', 'pending'),
(4, 2,     7000, 'activity', '2026-09-10', 'paid'),
(3, 3,    10000, 'activity', '2026-09-10', 'paid');
