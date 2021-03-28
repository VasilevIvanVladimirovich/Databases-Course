/* Задание. Существуют 4 источника данных, которые использует
компания для получения информации о потенциальных клиентах
(случайно проявили интерес к компании).
Необходимо сформировать из этих таблиц часть хранилища данных.
Создайте необходимые таблицы и заполните их данными (light variant).
либо
Сгенерируйте код для создания и заполнения новых таблиц (hard variant).
Полученные данные можно использовать для маркетинговых кампаний.
*/

--Имеются 4 источника ------------------------------------------------------------------------------------
create table calls_info(
	id number,
	f_name varchar(128),
	l_name varchar(128),
	city varchar(128),
	phone varchar(128)
);

create table cabinet_reg(
	id number,
	first_name varchar(128),
	last_name varchar(128),
	username varchar(128),
	email varchar(128),
	language varchar(128),
	phone varchar(128)
);

create table internet_reg(
	id number,
	person_name varchar(128),
	person_last_name varchar(128),
	dttm timestamp,
	email varchar(128),
	phone varchar(128)
);

create table hackathon_data(
	id number,
	person_name varchar(128),
	person_last_name varchar(128),
	username varchar(128),
	telegram varchar(128),
	email varchar(128)
);
---Создание трёх таблицы, для нашего хранилища данных-------------------------------------------------------------------------------------------------------------------------------------------------------\
create table users (
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name VARCHAR(128) NOT NULL, 
    first_name VARCHAR(128) NOT NULL
);

create table phones (
    id     INTEGER REFERENCES users(id),
    phone  VARCHAR(12)
);
create table emails (
    id     INTEGER REFERENCES users(id),
    email  VARCHAR(128)
);
--Скрипт заполнения наших таблиц----------------------------------------------------------------------------------

CREATE TRIGGER script_calls_info
AFTER INSERT ON calls_info
BEGIN 

INSERT INTO users (last_name,first_name)
 VALUES 
 ((SELECT new.l_name
   FROM calls_info),
   (SELECT new.f_name
   FROM calls_info)
 );
 
INSERT INTO phones 
VALUES
((SELECT max(id) FROM users),
 (SELECT new.phone FROM calls_info)
);
INSERT INTO emails (id)
VALUES
((SELECT max(id) FROM users)
);
END;

CREATE TRIGGER script_cabinet_reg
AFTER INSERT ON cabinet_reg
BEGIN 

INSERT INTO users (last_name,first_name)
 VALUES 
 ((SELECT new.last_name  
   FROM cabinet_reg),
   (SELECT new.first_name 
   FROM cabinet_reg)
 );
 INSERT INTO phones 
VALUES
((SELECT max(id) FROM users),
 (SELECT new.phone FROM cabinet_reg)
);
INSERT INTO emails
VALUES
((SELECT max(id) FROM users),
 (SELECT new.email FROM cabinet_reg)
);

END;

CREATE TRIGGER script_internet_reg_reg
AFTER INSERT ON internet_reg
BEGIN 

INSERT INTO users (last_name,first_name)
 VALUES 
 ((SELECT new.person_last_name
   FROM internet_reg),
   (SELECT new.person_name 
   FROM internet_reg)
 );
 INSERT INTO phones 
VALUES
((SELECT max(id) FROM users),
 (SELECT new.phone FROM internet_reg)
);
INSERT INTO emails
VALUES
((SELECT max(id) FROM users),
 (SELECT new.email FROM internet_reg)
);
END;

CREATE TRIGGER script_hackathon_data
AFTER INSERT ON hackathon_data
BEGIN 

INSERT INTO users (last_name,first_name)
 VALUES 
 ((SELECT new.person_last_name
   FROM hackathon_data),
   (SELECT new.person_name 
   FROM hackathon_data)
 );
INSERT INTO phones (id)
VALUES
((SELECT max(id) FROM users)
);
INSERT INTO emails
VALUES
((SELECT max(id) FROM users),
 (SELECT new.email FROM hackathon_data)
);
END;



-- заполнение данными источников--------------------------------------------------------------------------------------------------------------------------------------------------------
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14311, 'Михаил',    'Иванов',      'Москва',          '8 909 145 16 31');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14312, 'Анатолий',  'Грибов',      'Екатеринбург',    '8 909 637 17 40');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14313, 'Максим',    'Ушанов',      'Реутов',          '8 916 435 12 30');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14314, 'Ольга',     'Логвина',     'Нижний Новгород', '8 909 375 03 10');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14315, 'Иван',      'Петров',     'Ростов',          '8 916 637 13 30');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14316, 'Екатерина', 'Митрофанова', 'Ставрополь',      '8 909 635 15 40');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14317, 'Юлия',      'Сидорова',    'Москва',          '8 909 637 34 40');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14318, 'Юрий',      'Онищин',      'Москва',          '8 909 125 65 31');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14319, 'Александр', 'Яблоков',     'Ногинск',         '8 916 645 04 30');
insert into calls_info (id, f_name, l_name, city, phone) 
	values(14320, 'Николай',   'Романов',     'Мытищи',          '8 909 375 00 30');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5432, 'Александр', 'Иванов',       'ivan_92',          'ivan.92@mail.ru',          'ru', '8 934 423 53 23 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5433, 'Борис',     'Калинин',      'Bor_Kalin',        'Bor.Kalin@mail.ru',        'fr', '8 923 235 25 54 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5434, 'Петр',      'Суворов',      'Suvor_88_',        'Suvor.88_@mail.ru',        'ru', '8 954 653 65 65 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5435, 'Юрий',      'Сахаров',      'Sacharov_Yuri_13', 'Sacharov.Yuri_13@mail.ru', 'ru', '8 964 134 23 00 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5436, 'Всеволод',  'Долгих',       'Dolg_Seva',        'Dolg.Seva@mail.ru',        'en', '8 934 655 77 34 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5437, 'Александр', 'Виноградов',   'Vino_Sasha',       'Vino.Sasha@mail.ru',       'ru', '8 902 334 34 05 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5438, 'Николай',   'Николаев',     'Nik_nik',          'Nik.nik@mail.ru',          'ru', '8 943 634 12 76 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5439, 'Ольга',     'Печуркина',    'Pech_95',          'Pech.95@mail.ru',          'en', '8 954 134 00 40 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5440, 'Екатерина', 'Александрова', 'Katusha_93',       'Katusha.93@mail.ru',       'ru', '8 922 655 65 76 ');
insert into cabinet_reg (id, first_name, last_name, username, email, language, phone) values(5441, 'Юлия',      'Абрикосова',   'Apricot_Yla',      'Apricot.Yla@mail.ru',      'ru', '8 901 354 00 23 ');
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2523, 'Дмитрий', 'Ушанов',     '2020-12-13', 'ushan@gmail.com',     '8 976 222-66-00');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2524, 'Михаил',  'Иванов',     '2020-10-14', 'mikh.ivan@gmail.com', '8 923 634-23-23');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2525, 'Ольга',   'Ухов',       '2020-04-21', 'olga.uh@gmail.com',   '8 934 754-35-53');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2526, 'Евгений', 'Яблочков',   '2020-02-25', 'yabloch@gmail.com',   '8 964 245-73-65');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2527, 'Аким',    'Нуритдинов', '2019-05-26', 'nurit.aki@gmail.com', '8 909 452-54-34');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2528, 'Петр',    'Солнцев',    '2020-02-10', 'solnc.pet@gmail.com', '8 932 653-12-77');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2529, 'Мария',   'Лучникова',  '2019-06-04', 'luch.mari@gmail.com', '8 909 125 65 31');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2530, 'Юрий',    'Абраженин',  '2020-04-11', 'abraj.yur@gmail.com', '8 909 235-34-65');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2531, 'Евгения', 'Педченко',   '2019-07-09', 'pedchenko@gmail.com', '8 956 346-54-23');                                     
insert into internet_reg (id, person_name, person_last_name, dttm, email, phone) values(2532, 'Антон',   'Ульянов',    '2020-03-23', 'ulyanov.anton@gmail.com', '8 934 234-22-73');                                     
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7642, 'Николай',   'Кальков',   'kalk_nik',       '@kalk_nik',      'kalk_nik@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7643, 'Анатолий',  'Приоров',   'prior_anat',     '@prior_anat',    'prior_anat@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7644, 'Александр', 'Ярмеев',    'yarm_Sasha',     '@yarm_Sasha',    'yarm_Sasha@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7645, 'Борис',     'Пилюлин',   'pil_bor',        '@pil_bor',       'pil_bor@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7646, 'Всеволод',  'Жарков',    'jar_seva',       '@jar_seva',      'jar_seva@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7647, 'Валерий',   'Усманов',   'usmanov_val',    '@usmanov_val',   'usmanov_val@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7648, 'Ольга',     'Ульянова',  'ulyanova_olga',  '@ulyanova_olga', 'ulyanova_olga@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7649, 'Мария',     'Маринкина', 'marinkina_mar',  '@marinkina_mar', 'marinkina_mar@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7650, 'Елена',     'Светлова',  'svet_elena',     '@svet_elena',    'svet_elena@mail.ru');
insert into hackathon_data (id, person_name, person_last_name, username, telegram, email) values(7651, 'Евгений',   'Добрых',    'dobr.jenya',     '@dobr.jenya',    'dobr.jenya@mail.ru');
--Проверка--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM users;

SELECT * 
FROM phones;

SELECT *
FROM emails;
