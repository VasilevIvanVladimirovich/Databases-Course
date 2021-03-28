/*  Задание с использованием оконных функций:
    1) Выдайте названия всех исполнителей и их альбомы, а также количество
       проданных треков с каждого альбома. Отсортируйте исполнителей 
       в порядке убывания количества продаж.
    2) Для каждого альбома найдите его ранг, рассчитанный по количеству продаж
       (1-ый ранг соответствует максимальным продажам).
*/
--№1-------------------------
SELECT  distinct artists.Name AS name_artists, albums.Title AS albums, SUM(invoice_items.quantity) over(partition by albums.AlbumId order by albums.AlbumId ) AS Count_sold_tracks
from artists
    join albums USING(artistId)
    join tracks USING(AlbumId)
    join invoice_items USING(TrackId)
order by Count_sold_tracks desc;
--№2--------------------------
SELECT  distinct albums, DENSE_RANK() OVER(order by Count_sold_tracks desc) AS rank
from (SELECT  distinct artists.Name AS name_artists, albums.Title AS albums, SUM(invoice_items.quantity) over(partition by albums.AlbumId order by albums.AlbumId ) AS Count_sold_tracks
from artists
    join albums USING(artistId)
    join tracks USING(AlbumId)
    join invoice_items USING(TrackId)
order by Count_sold_tracks desc)
ORDER BY rank asc;
-----------------------------

