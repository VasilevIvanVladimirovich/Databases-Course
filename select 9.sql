-- view

SELECT
   trackid,
   tracks.name track,
   albums.Title AS album,
   media_types.Name AS format,
   genres.Name AS genre
FROM
    tracks
    INNER JOIN albums ON Albums.AlbumId = tracks.AlbumId
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN genres ON genres.GenreId = tracks.GenreId;

CREATE VIEW tracks_view 
AS 
    SELECT
       trackid,
       tracks.name track,
       albums.Title AS album,
       media_types.Name AS format,
       genres.Name AS genre
    FROM
        tracks
        INNER JOIN albums ON Albums.AlbumId = tracks.AlbumId
        INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
        INNER JOIN genres ON genres.GenreId = tracks.GenreId;
        
SELECT track, album
FROM tracks_view
WHERE genre = 'Classical';

PRAGMA table_info(tracks_view);

-- Вывести название альбома, тип файлов, жанр и количество треков
SELECT  DISTINCT album,
        format,
        genre,
        COUNT(trackid) OVER (PARTITION BY album) num_tracks
FROM  tracks_view
ORDER BY album;       

DROP VIEW tracks_view;

-- index

SELECT trackid, name, composer
FROM   tracks
WHERE  name = 'Hearts and Minds';

EXPLAIN QUERY PLAN 
SELECT trackid, name
FROM   tracks
WHERE  name = 'Hearts and Minds';

CREATE INDEX name_track_idx 
ON tracks (name);

PRAGMA index_list('tracks');
PRAGMA index_info('name_track_idx');

CREATE INDEX name_customer_idx 
ON customers (FirstName, LastName);

PRAGMA index_info('name_customer_idx');

DROP INDEX name_track_idx;
DROP INDEX name_customer_idx;

-- trigger

CREATE TRIGGER [IF NOT EXISTS] trigger_name 
   [BEFORE|AFTER|INSTEAD OF] [INSERT|UPDATE|DELETE] 
   ON table_name
   [WHEN condition]
BEGIN
 statements;
END;

CREATE TABLE contacts (
	id integer PRIMARY KEY,
	first_name text NOT NULL,
	last_name text NOT NULL,
	phone text NOT NULL,
	email text NOT NULL
);

CREATE TRIGGER validate_email_before_insert_contact 
   BEFORE INSERT ON contacts
BEGIN
   SELECT
      CASE
	 WHEN NEW.email NOT LIKE '%_@_%.__%' THEN
   	  RAISE (ABORT,'Invalid email address')
      END;
END;
-- RAISE (ABORT | FAIL | IGNORE | ROLLBACK, error_message)
 
INSERT INTO contacts (first_name, last_name, phone, email)
VALUES('John', 'Doe', '123456789','john@com');

INSERT INTO contacts (first_name, last_name, phone, email)
VALUES('John', 'Doe', '123456789','john@gmail.com');

SELECT * FROM contacts;

CREATE TABLE contact_logs (
	id INTEGER PRIMARY KEY,
	old_phone text,
	new_phone text,
	old_email text,
	new_email text,
	user_action text,
	date text
);

CREATE TRIGGER log_contact_after_update 
   AFTER UPDATE ON contacts
   WHEN old.phone <> new.phone
        OR old.email <> new.email
BEGIN
	INSERT INTO contact_logs (
		old_phone,
		new_phone,
		old_email,
		new_email,
		user_action,
		date
	)
VALUES
	(
		old.phone,
		new.phone,
		old.email,
		new.email,
		'UPDATE',
		DATETIME('NOW')
	) ;
END;

SELECT * FROM contacts;

UPDATE contacts
SET 
   phone = '987654321'
WHERE
   id = 1;
   
SELECT * FROM contact_logs;

UPDATE contacts
SET 
   last_name = 'Smith'
WHERE
   id = 1;
   
DROP TRIGGER log_contact_after_update;

CREATE TRIGGER update_view
INSTEAD OF UPDATE ON tracks_view
FOR EACH ROW
BEGIN
    UPDATE tracks SET name=new.track WHERE trackid=new.trackid;
END;

UPDATE tracks_view
SET track='For Those About To Rock'
WHERE trackid=1;

SELECT * FROM tracks WHERE trackid=1;

-- 1)

CREATE TABLE bosses (
    id     INT PRIMARY KEY,
    name   CHAR(20),
    gender CHAR(1) CHECK(gender IN('F','M')),
    role   CHAR(20) CHECK(role IN('Head','Main','Prime'))
);
-- Написать триггер, который на ввод новой строки выдает ошибку
-- если введен еще один босс с ролью Prime (он должен быть единственным) 

-- 2) Написать триггер, который при удалении строк из представления
-- tracks_view записывает их в таблицу del_tracks

---№1-----------------------------------------------------------------
SELECT *
FROM bosses;

CREATE TRIGGER uppdate_bosses
BEFORE INSERT ON bosses
BEGIN    
SELECT
    CASE 
    WHEN new.role='Prime'  and new.role in (SELECT role from bosses) THEN RAISE (ABORT,'Invalid PRIME')
    END;
END;

INSERT INTO bosses VALUES(1,'Ваня','M','Prime');
INSERT INTO bosses VALUES(2,'Ваня2','M','Main');
INSERT INTO bosses VALUES(3,'Ваня3','M','Head');
INSERT INTO bosses VALUES(4,'Ваня4','M','Prime');

--№2---------------------------------------------------
CREATE VIEW tracks_view 
AS 
    SELECT
       trackid,
       tracks.name track,
       albums.Title AS album,
       media_types.Name AS format,
       genres.Name AS genre
    FROM
        tracks
        INNER JOIN albums ON Albums.AlbumId = tracks.AlbumId
        INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
        INNER JOIN genres ON genres.GenreId = tracks.GenreId;
        
CREATE TABLE del_tracks 
(
    trackid int,
    track text,
    album text,
    format text,
    genre text

);

DELETE FROM tracks_view
WHERE  trackid = 3;

CREATE TRIGGER tr_view
INSTEAD OF DELETE ON tracks_view 
FOR EACH ROW
BEGIN
    INSERT INTO del_tracks SELECT distinct old.trackid, old.track,old.album,old.format,old.genre FROM tracks_view;   
     
    DELETE FROM playlist_track
    WHERE trackid = old.trackid;
    
    DELETE FROM invoice_items
    WHERE trackid = old.trackid;
    
     DELETE FROM tracks
    WHERE trackid = old.trackid;
    
END;

SELECT *
FROM tracks_view ;

SELECT *
FROM del_tracks;

-----------------------------------------------------------