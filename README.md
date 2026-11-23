# 🏫 CASE 20: School Management System (Орта мектеп жүйесі)

SQL және PostgreSQL (pgAdmin 4) пәніне арналған оқу жобасы.

## 📌 Сипаттамасы
Заманауи мектеп-лицейдің білім беру процесін басқаратын дерекқор: оқушылар, ата-аналар, мұғалімдер, сабақ кестесі, бағалар, қатысу, үй тапсырмасы, үйірмелер және төлемдер.

## 📁 Файлдар

| Файл | Мазмұны |
|------|---------|
| `01_schema.sql` | 16 кестені құру (CREATE TABLE) |
| `02_data.sql` | Тест деректері (INSERT) |
| `03_queries.sql` | Бизнес функциялар + аналитикалық есептер |

## ▶️ pgAdmin-де іске қосу
1. pgAdmin ашып, жаңа дерекқор жасаңыз: **Databases → Create → Database…** → атауы `school_db`.
2. `school_db` үстінде оң жақ батырма → **Query Tool**.
3. Файлдарды ретімен ашып (📂 Open File) орындаңыз (**F5**):
   1. `01_schema.sql`
   2. `02_data.sql`
   3. `03_queries.sql` (сұранысты бөлек белгілеп, F5 басыңыз)
4. Тексеру: `SELECT * FROM students;`

## 🗂 Кестелер және байланыстар

```
teachers ──< classes ──< students >──< student_parents >── parents
   │                         │
   │                         ├──< grades >── lessons ── schedules ──> subjects
   │                         ├──< attendance >──┘            │
   │                         ├──< homework_submissions       └──> classes, teachers
   │                         ├──< activity_enrollments >── extracurricular_activities
   │                         └──< payments
teachers >──< teacher_subjects >──< subjects
lessons ──< homework ──< homework_submissions
```

| Кесте | Не үшін керек |
|-------|----------------|
| `students` | Оқушылар тізімі (class_id арқылы сыныпқа байланған) |
| `parents` | Ата-аналар |
| `student_parents` | Оқушы ↔ ата-ана (көп-көпке байланыс) |
| `classes` | Сыныптар (5A, 5B), сынып жетекшісі |
| `teachers` | Мұғалімдер |
| `subjects` | Пәндер |
| `teacher_subjects` | Мұғалім ↔ пән (көп-көпке) |
| `schedules` | Апталық сабақ кестесі |
| `lessons` | Нақты өткен сабақтар (күні, тақырыбы) |
| `grades` | Журнал бағалары (2–5) |
| `attendance` | Қатысу: present / absent / late |
| `homework` | Үй тапсырмасы |
| `homework_submissions` | Оқушы тапсырған жұмыс |
| `extracurricular_activities` | Үйірмелер |
| `activity_enrollments` | Үйірмеге жазылу |
| `payments` | Оқу ақысы және үйірме төлемдері |

## 🎯 Бизнес функциялар (`03_queries.sql`, A бөлімі)
- Оқушыны сыныпқа тіркеу — `INSERT INTO students`
- Сабақ кестесін жасау — `INSERT INTO schedules`
- Журналға баға қою — `INSERT INTO grades`
- Қатысуды белгілеу — `INSERT/UPDATE attendance`
- Үй тапсырмасын жіберу — `INSERT INTO homework`

## 📊 Аналитикалық есептер (B бөлімі)
- Сыныптар бойынша орташа үлгерім — `AVG` + `GROUP BY`
- Сабақ қалдыру статистикасы — `COUNT ... FILTER`
- Мұғалімдердің сағаттық жүктемесі — `COUNT` + `LEFT JOIN`

## 🧠 Қолданылған SQL тақырыптары
`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `JOIN`, `LEFT JOIN`, `GROUP BY`, `AVG`, `COUNT`, `ORDER BY`, `LIMIT`
