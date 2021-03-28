/*  Задания.
    1) Найдите дубликаты по полю email в таблице employees 
    (добавьте для теста парочку существующих адресов).
    2) Вытащить текст между двумя разделителями 'unstructured;text;format'
    (длина текста может быть любой).
*/
--№1-----------------------------------------
INSERT INTO employees(LastName,FirstName,Email)
VALUES 
('Ivan','vas','steve.johnson@chinookcorp.com');

INSERT INTO employees(LastName,FirstName,Email)
VALUES 
('Ivan','vas','steve.johnson@chinookcorp.com');

SELECT Email, count(*) AS number_of_duplicates
FROM employees
GROUP BY Email
HAVING count(*) > 1;
--№2------------------------------------------
CREATE TABLE temp1 (var TEXT);
DROP TABLE temp1;

INSERT INTO temp1 VALUES ('unstructured123;againtext;format123654646546546546456');
INSERT INTO temp1 VALUES ('unstr6546uctured;text;nstr6546uctured'); 

SELECT SUBSTR(var,0,INSTR(var,';')) AS First_name,
       SUBSTR(LTRIM(LTRIM(var,SUBSTR(var,0,INSTR(var,';'))),';'),0,INSTR(LTRIM(LTRIM(var,SUBSTR(var,0,INSTR(var,';'))),';'),';')) AS Second_name,
       SUBSTR(LTRIM(LTRIM(var,SUBSTR(var,0,INSTR(var,';'))),';'),INSTR(LTRIM(LTRIM(var,SUBSTR(var,0,INSTR(var,';'))),';'),';')+1, LENGTH(var)) AS Thirt_name
FROM temp1;


SELECT * FROM temp1;