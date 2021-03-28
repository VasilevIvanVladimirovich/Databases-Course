-- 1) Вывести треки (id, наименование и исполнителя), на которые не было заказов.
--    Отсортируйте по id трека. Выполните запрос двумя или более способами.
--1--------------------------
select DISTINCT tracks.TrackId, 
       tracks.Name, 
       tracks.Composer
from tracks left join invoice_items 
on tracks.TrackId = invoice_items.TrackId
where invoice_items.TrackId is null
group by tracks.TrackId
order by tracks.TrackId;
--2--------------------------
SELECT DISTINCT tracks.TrackId, 
       tracks.Name, 
       tracks.Composer
    FROM tracks
EXCEPT
SELECT DISTINCT invoice_items.TrackId,
                tracks.Name, 
                tracks.Composer
    FROM invoice_items
    INNER JOIN tracks USING(TrackId)
ORDER BY tracks.TrackId;
-----------------------------------
--2) Найдите наиболее покупаемые треки в Германии. 
--    Выведите наименование, исполнителей и количество покупок только тех треков, которые хоть раз покупались.
--    Отсортируйте по количеству покупок по убыванию, внутри - по исполнителю (null в конце группы),
--    внутри исполнителя - по наименованию трека.
select name,
       composer,
       count(name)
from tracks inner join invoice_items using(trackid)
            inner join invoices using(invoiceid)
where invoices.billingCountry = "Germany"
group by name
order by count(name) desc, composer desc, name desc;
-----------------------------------------
--3) Отнесите каждый трек к одной из трех категорий 
--   в зависимости от его продолжительности: менее 3 минут, от 3 до 7 минут и более 7 минут.
--   Посчитайте количество треков и среднюю продолжительность трека в каждой категории.
select name as НазваниеТрека,
        iif(Milliseconds < 180000,Milliseconds,'-') as ПерваяКатегория,
        iif(Milliseconds > 180000 and Milliseconds < 420000,Milliseconds,'-') as ВтораяКатегория,
        iif(Milliseconds > 420000,Milliseconds,'-') as ТретьяКатегория
       -- iif(Milliseconds < 180000 ,count(1),null)  as Количество
from tracks;

SELECT name,
       CASE 
           WHEN Milliseconds < 180000 THEN '1' 
           WHEN Milliseconds > 180000 and Milliseconds < 420000 THEN '2' 
           ELSE '3' 
       END Категория,
       CASE 
           WHEN Milliseconds < 180000 THEN (select count(iif(Milliseconds < 180000,Milliseconds,null)) from tracks)
           WHEN Milliseconds > 180000 and Milliseconds < 420000 THEN (select count(iif(Milliseconds > 180000 and Milliseconds < 420000,Milliseconds,null))from tracks) 
           ELSE (select count(iif(Milliseconds > 420000,Milliseconds,null))from tracks)
       END Количество,
  CASE 
           WHEN Milliseconds < 180000 THEN (select round(avg(iif(Milliseconds < 180000,Milliseconds,null)),2)from tracks)
           WHEN Milliseconds > 180000 and Milliseconds < 420000 THEN (select round(avg(iif(Milliseconds > 180000 and Milliseconds < 420000,Milliseconds,null)),2)from tracks) 
           ELSE (select round(avg(iif(Milliseconds > 420000,Milliseconds,null)),2)from tracks)
       END СредняяПродолжительность
FROM tracks; 

