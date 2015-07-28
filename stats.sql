SELECT grade_course_id AS course_id, grade_professor_id AS professor_id, overall AS rating, diff AS difficulty, gpa FROM (SELECT c.id AS grade_course_id, p.id AS grade_professor_id, AVG(g.gpa) AS gpa FROM sections s JOIN courses c ON s.course_id=c.id JOIN section_professors sp ON s.id=sp.section_id JOIN professors p ON sp.professor_id=p.id LEFT OUTER JOIN grades g ON s.id=g.section_id GROUP BY c.id, p.id) grades LEFT OUTER JOIN (SELECT course_id AS review_course_id, professor_id AS review_professor_id, AVG((professor_rating + enjoyability + recommend)/3) AS overall, AVG(difficulty) AS diff FROM reviews GROUP BY course_id, professor_id) reviews ON grades.grade_course_id=reviews.review_course_id AND grades.grade_professor_id=reviews.review_professor_id;



DROP TABLE stats_sql;
CREATE TABLE stats_sql AS SELECT grade_course_id AS course_id, grade_professor_id AS professor_id, overall AS rating, diff AS difficulty, gpa FROM (SELECT c.id AS grade_course_id, p.id AS grade_professor_id, AVG(g.gpa) AS gpa FROM sections s JOIN courses c ON s.course_id=c.id JOIN section_professors sp ON s.id=sp.section_id JOIN professors p ON sp.professor_id=p.id LEFT OUTER JOIN grades g ON s.id=g.section_id GROUP BY c.id, p.id) grades LEFT OUTER JOIN (SELECT course_id AS review_course_id, professor_id AS review_professor_id, AVG((professor_rating + enjoyability + recommend)/3) AS overall, AVG(difficulty) AS diff FROM reviews GROUP BY course_id, professor_id) reviews ON grades.grade_course_id=reviews.review_course_id AND grades.grade_professor_id=reviews.review_professor_id;
ALTER TABLE stats_sql MODIFY rating DOUBLE;
ALTER TABLE stats_sql MODIFY difficulty DOUBLE;
ALTER TABLE stats_sql MODIFY gpa DOUBLE;
ALTER TABLE stats_sql ADD id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE stats_sql ADD UNIQUE KEY `index_stats_on_course_id_and_professor_id` (`course_id`, `professor_id`) USING BTREE;
ALTER TABLE stats_sql ADD KEY `index_stats_on_course_id` (`course_id`) USING BTREE;
ALTER TABLE stats_sql ADD KEY `index_stats_on_professor_id` (`professor_id`) USING BTREE;
