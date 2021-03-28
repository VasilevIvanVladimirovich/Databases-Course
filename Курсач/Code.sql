CREATE TABLE Student
(
      student_book_number int PRIMARY KEY,
      last_name varchar(30) NOT NULL,
      first_name varchar(15) NOT NULL,
      patronymic varchar(20) NOT NULL,
      date_of_dirth data(8) NOT NULL,
      group_id varchar REFERENCES Groups(group_id),
      course int NOT NULL
);
CREATE TABLE Groups
(
    group_id varchar PRIMARY KEY,
    specialty_id int REFERENCES Specialty(specialty_id)
);

CREATE TABLE Specialty
(
    specialty_id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_id INTEGER REFERENCES Department(department_id),
    specialty_name text NOT NULL,
    target_set int NOT NULL
);

CREATE TABLE Department    
(
    department_id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name text NOT NULL
);

CREATE TABLE Points
(
        applicant_id INTEGER REFERENCES Applicant(applicant_id),
        Academic_subject_id REFERENCES Academic_subject(Academic_subject_id),
        Point_count int NOT NULL
        
        CHECK ((Academic_subject_id = 1 AND  Point_count >= 36) OR
               (Academic_subject_id = 2 AND  Point_count >= 27) OR
               (Academic_subject_id = 3 AND  Point_count >= 36) OR
               (Academic_subject_id = 4 AND  Point_count >= 36) OR
               (Academic_subject_id = 5 AND  Point_count >= 36) OR
               (Academic_subject_id = 6 AND  Point_count >= 42))
);

CREATE TABLE Academic_subject
(
    Academic_subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
    Academic_subject_name text
);

CREATE TABLE Applicant
(
    applicant_id INTEGER PRIMARY KEY AUTOINCREMENT,
    specialty_id INTEGER REFERENCES Specialty(specialty_id),
    last_name varchar(30) NOT NULL,
    first_name varchar(15) NOT NULL,
    patronymic varchar(20) NOT NULL,
    date_of_dirth data NOT NULL,
    date_application data NOT NULL
);

INSERT INTO Department  (department_name) VALUES ('ИЭИС');
INSERT INTO Department  (department_name) VALUES ('ИЭУП');
INSERT INTO Department  (department_name) VALUES ('ИСХПР');
INSERT INTO Department  (department_name) VALUES ('ИМО');
-------------------------------------------------------------
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (1,'Прикладная математика и информатика',5);
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (1,'Программное обеспечение вычислительной техники и автоматизированных систем',5);
-------------------------------------------------------------
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (2,'Бухгатерский учет, анализ и аудит',5);
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (2,'Маркетинг',5);
-------------------------------------------------------------
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (3,'Химия и технология удобрений',5);
-------------------------------------------------------------
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (4,'Лечебное дело',5);
INSERT INTO Specialty (department_id,specialty_name,target_set) VALUES (4,'Стоматология',5);
-------------------------------------------------------------
INSERT INTO Academic_subject(Academic_subject_name) VALUES 
('Русский язык'), 
('Математика профиль'), 
('Физика'), 
('Химия'),
('Биология'),
('Обществознание');

--INDEX--------------------------------------------------
CREATE INDEX IND_Applicant_applicant_id
ON Applicant(applicant_id);

CREATE UNIQUE INDEX IND_Student_student_book_number 
ON Student(student_book_number);

CREATE INDEX IND_Point_applicant_id
ON Points(applicant_id);

CREATE INDEX IND_Groups_group_id
ON Groups(group_id);

--TRIGGERS--------------------------------------------------
CREATE TRIGGER create_new_group -- ТРИГГЕР НА СОЗДАНИЕ ГРУППЫ
BEFORE INSERT ON Student
WHEN new.group_id NOT IN(SELECT group_id FROM Groups) and new.course = 1
BEGIN
    INSERT INTO Groups(group_id) VALUES(new.group_id);
END;

CREATE TRIGGER delete_applicant
BEFORE DELETE ON Applicant
BEGIN
        DELETE FROM Points 
        WHERE Points.applicant_id = old.applicant_id;
END;
--VIEW--------------------------------------------------
CREATE VIEW Applicants_info AS
SELECT DISTINCT applicant_id AS ID_Абитуриента,
       last_name AS Фамилия,
       first_name AS Имя,
       patronymic AS Отчество,
       date_of_dirth AS Дата_рождения,
       date_application AS Дата_заявления,
       specialty_id AS id_Специальности,
       specialty_name AS Специальность,
       GROUP_CONCAT(Academic_subject_name|| '-' || Point_count) OVER(PARTITION BY applicant_id) AS Баллы_ЕГЭ     
FROM Applicant
JOIN Specialty USING(specialty_id)
JOIN Points USING(applicant_id)
JOIN Academic_subject USING(Academic_subject_id);

CREATE VIEW Students_info AS
SELECT student_book_number AS Зачётка,
       group_id AS Группа,
       last_name AS Фамилия,
       first_name AS Имя,
       patronymic AS Отчество,
       date_of_dirth AS Дата_рождения,
       course AS Курс,
       specialty_name AS Специальность
FROM Student
JOIN Groups USING(group_id)
JOIN Specialty USING(specialty_id);
--------------------------------------------------
INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Баранов','Алексей','Сергеевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,50);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,55);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Бочкарёв','Борис','Анатольевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,90);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,70);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,67);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Васильев','Иван ','Владимирович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,70);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,70);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Григорьев','Дмитрий','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,80);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Ефимов','Артём','Сергеевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,50);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,60);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Кудряшов','Иван','Анатольевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,70);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,90);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Кулаков','Игорь','Юрьевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,90);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,67);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Лехновский','Александр','Денисович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,70);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Мухачёв','Александр','Александрович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,69);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Петров','Фёдор','Максимович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,92);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,84);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Попов','Владимир','Сергеевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,99);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,72);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Скородумов','Сергей','Николаевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,84);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,81);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Петров','Владимир','Александрович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,49);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,80);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Попов','Сергей','Денисович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,70);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,83);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Кудряшов','Игорь','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,69);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,95);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,60);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Бочкарёв','Иван','Юрьевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,69);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,99);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,52);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Баранов','Дмитрий','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,55);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,54);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Ефимов','Борис','Сергеевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Попов','Фёдор','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,65);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Васильев','Александр','Сергеевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,87);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Баранов','Борис','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,87);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Скородумов','Фёдор','Максимович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,98);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Кудряшов','Сергей','Александрович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,88);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,77);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Мухачёв','Иван','Юрьевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,56);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Петров','Фёдор','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,97);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Скородумов','Сергей','Максимович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,42);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Попов','Александр','лександрович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,87);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Кулаков','Борис','Денисович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,64);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Лехновский','Дмитрий','Николаевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,89);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,61);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Ефимов','Иван','Сергеевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,52);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,65);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Кудряшов','Владимир','Максимович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,45);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Петров','Владимир','Николаевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,89);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,96);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Скородумов','Иван','Максимович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Кулаков','Дмитрий','Денисович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,49);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Попов','Сергей','Максимович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,97);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Ефимов','Фёдор','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,64);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Лехновский','Иван','Юрьевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,97);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,56);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Кулаков','Иван','Александрович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,97);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Васильев','Сергей','Игоревич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,56);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Борисов','Никита','Васильевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,89);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,96);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Винокурова','Мария','Викторовна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,80);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,55);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Волкова','Дарина','Павловна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,80);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,55);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Галимова','Нина','Геннадьевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,55);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,52);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,73);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Жандармона','Алина','Максимовна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,59);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,77);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Клыкова','Анастасия','Андреева','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,91);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,84);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,93);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Игнатьева','Валерия','Андреевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,84);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,82);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Конев','Иван','Викторович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,97);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,91);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Прокофьева','Алина','Алексеевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,99);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Понамарёва','Мария','Александровна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,69);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,58);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Гыка','Сергей','Викторович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,69);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,66);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Большеков','Евгений','Олегович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,81);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Васильев','Иван','Владимирович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,65);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Соловьёв','Никита','Панфилович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,87);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Зёмченков','Анатолий','Семёнович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,81);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Аксырк','Кристина','Анатольевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,77);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Гусев','Алексей','Дмитриевич','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Соболева','Алина','Александровна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,54);


INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Андреевская','Инга','Сергеевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,97);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,65);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Смирнова','Арина','Алексеевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,61);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Бадия','Ангелина','Николаевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,81);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,92);


INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Большакова','Юлия','Павловна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,92);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Золотова','Диана','Романовна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Ивушкина','Софья','Яковлевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,72);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,81);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Шушкова','Аурика','Сергеевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,89);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,92);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Моисеев','Илья','Константинович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,91);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,54);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Квардаков','Никита','Владимирович','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,61);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,73);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Дербина','Виктория','Сергеевна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,87);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Соколова','Екатерина','Александровна','2000-08-20','2020-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,55);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,51);


BEGIN TRANSACTION; --зачисление
UPDATE Student
SET Course = Course +1;
INSERT INTO Student 
SELECT CAST(CAST(stream AS INT) as TEXT) || CAST(department_id AS TEXT) || CAST(specialty_id AS TEXT) || '-' || rank,
       last_name,
       first_name,
       patronymic,
       date_of_dirth,
       CAST(CAST(stream AS INT) as TEXT) || CAST(department_id AS TEXT) || CAST(specialty_id AS TEXT) AS group_id,
       1
FROM(
SELECT applicant_id,
       last_name,
       first_name,
       specialty_id,
       patronymic,
       date_of_dirth,
       date_applic - 10 * round((date_applic/10)-0.5,0) AS stream,
       Sum_total,
       target_set,
       ROW_NUMBER() OVER(PARTITION BY specialty_id ORDER BY Sum_total DESC) AS rank,
       department_id

FROM (
    SELECT DISTINCT applicant_id,
           last_name,
           first_name,
           patronymic,
           specialty_id,
           date_of_dirth,
           CAST(strftime('%Y',date_application) as double) AS date_applic,
           SUM(Point_count) OVER(PARTITION BY applicant_id) AS Sum_total,
           target_set,
           department_id
           FROM Applicant
       JOIN Points USING(applicant_id)
       JOIN Specialty USING(specialty_id)
       JOIN Department USING(department_id)
       WHERE date_applic = (SELECT MAX(strftime('%Y',date_application)) FROM Applicant)
       ORDER BY specialty_id, SUM(Point_count) OVER(PARTITION BY applicant_id) desc,applicant_id ASC))
       WHERE rank <= target_set;
ROLLBACK;
COMMIT;

select * from student;
select * from applicant;
select * from points ;
select * from groups;
SELECT * FROM Academic_subject;
SELECT * FROM Students_info;
SELECT * FROM Applicants_info;

--1)
    SELECT * 
    FROM Student
    WHERE group_id='011';
    
    SELECT *
    FROM Students_info
    WHERE Специальность = 'Маркетинг';
    
--2)
    SELECT DISTINCT Специальность,
                    Count,
                    COALESCE( round(100 * (Count - LAG(Count) OVER(partition by Специальность order by strftime('%Y',Дата_заявления))) / LAG(Count) OVER(partition by Специальность order by strftime('%Y',Дата_заявления))    ,2)||'%', 'Firs year, not increase') AS increase,  
                    strftime('%Y',Дата_заявления)
                    
    FROM (
    SELECT DISTINCT 
                    Специальность,
                    Дата_заявления,
                    COUNT() OVER(PARTITION BY Специальность ORDER BY Специальность, strftime('%Y',Дата_заявления)) AS Count
    FROM Applicants_info)
    ORDER BY Специальность;
--3)

    SELECT  Фамилия,
            Имя,
            Отчество,
            Дата_рождения,
            Специальность
    FROM Applicants_info
    EXCEPT
    SELECT  Фамилия,
            Имя,
            Отчество,
            Дата_рождения,
            Специальность
    FROM Students_info;
    
INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Зайцева','Дарина','Дмитриевна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,53);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,82);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Андреева','Алёна','Ивановна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,84);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Костина','Мальвина','Викторовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,47);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,65);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Ширшова','Екатерина','Андреевн','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,87);


INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Лавриентиев','Павел','Юрьевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,84);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Чернов','Ростислав','Игоревич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Мельников','Семён','Александрович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,86);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Фандер','Марина','Викторовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,72);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Макарова','Ирина','Сергеевна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Алексеева','Елена','Анатольевна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Шиловский','Егор','Алексеевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,55);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,54);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Белый','Дмитрий','Аристархович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Якубова','Дарья','Александровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Поровский','Алексей','Геннадьевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,91);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Арсеньев','Виталий','Андреевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,84);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Осипов','Олег','Валентинович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,72);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,92);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Клещёв','Алексей','Сергеевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,93);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Ильина','Татьяна','Владимировна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,63);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Фёдоров','Илья','Ильич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Околович','Марина','Данииловна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,47);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Аверьянов','Альберт','Давидович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,64);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Кузницов','Роман','Александрович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,92);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Васильевич','Илья','Сергеевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,77);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Гончарова','Яна','Викторовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Сепп','Юлианна','Алексеева','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,83);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Григорьев','Дмитрий','Сергеевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Леонтьева','Юлия','Максимова','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,66);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Арутюнова','Яна','Петровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Тимофеева','Анастасия','Прохорова','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,85);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Прохорова','Ангелина','Львовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Тихонова','Анна','Антоновна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Белозёрова','Валерия','Викторовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,54);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Третьеков','Даниил','Александрович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Соколова','Дарья','Денисовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,84);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,56);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Стрижак','Дарья','Дмитриевна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,81);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Косарева','Екатерина','Александрова','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Капитонов','Иван','Михахайлович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,90);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Виноградов','Кирилл','Витальевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,93);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,77);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Устюгов','Максим','Павлович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,97);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Вяземская','Ольга','Александрова','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,65);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Павлова','Софья','Шодмоновна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,86);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Хоромская','Диана','Артёмовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,50);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,77);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (6,'Тюрина','Алина','Олеговна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Козлов',' Давид', 'Платонович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,96);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Григорьев', 'Александр', 'Ильич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Лебедев',' Арсений', 'Ярославович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Моисеев', 'Андрей', 'Александрович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,95);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Фирсова', 'Анна','Арсеновна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,90);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,53);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Алексеев', 'Марк', 'Захарович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,56);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,59);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (7,'Жданова', 'Ева' ,'Александровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,73);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,63);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Рыжова', 'Арина', 'Тимуровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,57);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,67);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Рыжова' ,'Арина', 'Тимуровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Иванов', 'Ярослав','Кириллович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Маслова', 'Юлия','Львовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,47);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,89);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,78);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (1,'Зиновьева', 'Полина',' Егоровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,66);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,78);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Маслова',' Юлия', 'Львовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Тюрина','Алина','Олеговна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,88);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Ильина', 'Полина', 'Михайловна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Родионов', 'Макар', 'Даниилович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,86);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Терентьев', 'Тимофей', 'Артёмович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (2,'Баранов', 'Давид', 'Билалович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),3,67);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Полякова', 'Дарья', 'Макаровна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,90);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,87);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Филатов','Павел','Маратович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,75);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Скворцов', 'Михаил', 'Николаевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,87);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,58);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Никитин', 'Александр', 'Владимирович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (3,'Евдокимов', 'Даниил', 'Львович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,94);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,82);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Крылова', 'Арина', 'Саввична','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,62);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Борисова', 'Екатерина', 'Максимовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,75);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Архипов', 'Максим', 'Георгиевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,88);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,76);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Мартынов', 'Всеволод', 'Евгеньевич','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,76);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,47);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,50);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Гуляева', 'Марта', 'Матвеевна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,67);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (4,'Герасимова', 'Софья', 'Матвеевна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,73);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,73);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),6,88);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Дьяков',' Герман', 'Антонович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,85);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,68);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,85);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Уткин','Лука', 'Александрович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,74);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,82);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Ларионова','Милана', 'Ивановна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,84);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,72);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,70);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Беспалова', 'Александра', 'Денисовна','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,88);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,86);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,70);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Широков', 'Эмин', 'Михайлович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,65);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,60);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,56);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Хохлов', 'Артём', 'Владимирович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,63);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,83);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),4,94);

INSERT INTO Applicant (specialty_id,last_name,first_name,patronymic,date_of_dirth,date_application) VALUES (5,'Кузнецов', 'Матвей', 'Артёмович','2000-08-20','2021-08-20');
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),1,77);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),2,79);
INSERT INTO Points(applicant_id,Academic_subject_id,Point_count) VALUES((SELECT MAX(applicant_id) FROM Applicant),5,56);
