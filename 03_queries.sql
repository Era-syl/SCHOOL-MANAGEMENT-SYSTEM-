-- =====================================================
-- Файл 3: Бизнес функциялар және аналитикалық есептер
-- Әр сұранысты бөлек таңдап (select), F5 басып орындаңыз
-- =====================================================


-- #####################################################
-- A. БИЗНЕС ФУНКЦИЯЛАР
-- #####################################################

-- A1. Оқушыны сыныпқа тіркеу
INSERT INTO students (full_name, birth_date, gender, class_id)
VALUES ('Мейірім Тұрсын', '2015-04-20', 'M', 1);

-- Тексеру: 5A сыныптағы оқушылар
SELECT s.student_id, s.full_name, c.class_name
FROM students s
JOIN classes c ON c.class_id = s.class_id
WHERE c.class_name = '5A';


-- A2. Сабақ кестесін жасау (5B сыныбына Информатика, Бейсенбі, 2-сабақ)
INSERT INTO schedules (class_id, subject_id, teacher_id, day_of_week, lesson_number, room)
VALUES (2, 3, 3, 4, 2, '201');

-- Тексеру: 5B сыныптың кестесі
SELECT sch.day_of_week AS kun,
       sch.lesson_number AS sabaq_no,
       sub.subject_name AS pan,
       t.full_name AS muğalim,
       sch.room AS kabinet
FROM schedules sch
JOIN classes c   ON c.class_id = sch.class_id
JOIN subjects sub ON sub.subject_id = sch.subject_id
JOIN teachers t  ON t.teacher_id = sch.teacher_id
WHERE c.class_name = '5B'
ORDER BY sch.day_of_week, sch.lesson_number;


-- A3. Журналға баға қою (5-оқушы Данияр, 4-сабақта "5" алды)
INSERT INTO grades (student_id, lesson_id, grade, comment)
VALUES (5, 5, 5, 'Жақсы жауап берді');

-- Тексеру: Алиханның журналы
SELECT l.lesson_date, sub.subject_name, g.grade
FROM grades g
JOIN lessons l    ON l.lesson_id = g.lesson_id
JOIN schedules sc ON sc.schedule_id = l.schedule_id
JOIN subjects sub ON sub.subject_id = sc.subject_id
WHERE g.student_id = 1
ORDER BY l.lesson_date;


-- A4. Қатысуды белгілеу (1-сабақта 3-оқушы кешікті -> өзгерту)
UPDATE attendance
SET status = 'absent'
WHERE lesson_id = 1 AND student_id = 3;

-- Тексеру: сабақтағы қатысу
SELECT s.full_name, a.status
FROM attendance a
JOIN students s ON s.student_id = a.student_id
WHERE a.lesson_id = 1;


-- A5. Үй тапсырмасын жіберу (5-сабаққа)
INSERT INTO homework (lesson_id, description, due_date)
VALUES (5, 'Оқулық 30-бет, 1-3 есептер', '2026-11-16');

-- A6. Кім үй тапсырмасын тапсырмады? (LEFT JOIN)
SELECT s.full_name, h.description
FROM homework h
JOIN lessons l    ON l.lesson_id = h.lesson_id
JOIN schedules sc ON sc.schedule_id = l.schedule_id
JOIN students s   ON s.class_id = sc.class_id
LEFT JOIN homework_submissions hs
       ON hs.homework_id = h.homework_id AND hs.student_id = s.student_id
WHERE hs.submission_id IS NULL;


-- #####################################################
-- B. АНАЛИТИКАЛЫҚ ЕСЕПТЕР
-- #####################################################

-- B1. Сыныптар бойынша орташа үлгерім
SELECT c.class_name,
       ROUND(AVG(g.grade), 2) AS orta_baga,
       COUNT(g.grade_id)      AS baga_sany
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN classes c  ON c.class_id = s.class_id
GROUP BY c.class_name
ORDER BY orta_baga DESC;


-- B2. Сабақ қалдыру статистикасы (әр оқушы бойынша)
SELECT s.full_name,
       c.class_name,
       COUNT(*) FILTER (WHERE a.status = 'absent') AS qaldyrgan,
       COUNT(*) FILTER (WHERE a.status = 'late')   AS keshikken,
       COUNT(*)                                    AS jalpy_sabaq
FROM attendance a
JOIN students s ON s.student_id = a.student_id
JOIN classes c  ON c.class_id = s.class_id
GROUP BY s.full_name, c.class_name
ORDER BY qaldyrgan DESC;


-- B3. Сабақ қалдыру пайызы (сыныптар бойынша)
SELECT c.class_name,
       ROUND(100.0 * COUNT(*) FILTER (WHERE a.status = 'absent') / COUNT(*), 1) AS qaldyru_payyz
FROM attendance a
JOIN students s ON s.student_id = a.student_id
JOIN classes c  ON c.class_id = s.class_id
GROUP BY c.class_name;


-- B4. Мұғалімдердің сағаттық жүктемесі (аптасына, 1 сабақ = 1 сағат деп алсақ)
SELECT t.full_name,
       COUNT(sch.schedule_id) AS saghat_aptasyna
FROM teachers t
LEFT JOIN schedules sch ON sch.teacher_id = t.teacher_id
GROUP BY t.full_name
ORDER BY saghat_aptasyna DESC;


-- B5. Қосымша: ең үздік оқушылар (орташа баға бойынша TOP 3)
SELECT s.full_name,
       ROUND(AVG(g.grade), 2) AS orta_baga
FROM students s
JOIN grades g ON g.student_id = s.student_id
GROUP BY s.full_name
ORDER BY orta_baga DESC
LIMIT 3;


-- B6. Қосымша: төлемі төленбеген оқушылар (қарыздар)
SELECT s.full_name, p.payment_type, p.amount
FROM payments p
JOIN students s ON s.student_id = p.student_id
WHERE p.status = 'pending';


-- B7. Қосымша: үйірмелер бойынша қанша оқушы жазылған
SELECT ea.activity_name,
       COUNT(en.student_id) AS oqushy_sany
FROM extracurricular_activities ea
LEFT JOIN activity_enrollments en ON en.activity_id = ea.activity_id
GROUP BY ea.activity_name;
