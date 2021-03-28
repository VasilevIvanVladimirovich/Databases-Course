
select distinct albums.Title
from tracks inner join albums on albums.AlbumId=tracks.AlbumId
where tracks.composer='Queen';

select tracks.Name,
       albums.Title
from tracks inner join albums inner join media_types on media_types.MediaTypeId=tracks.MediaTypeId and albums.AlbumId=tracks.AlbumId
where media_types.Name='AAC audio file';


select tracks.Name,
       tracks.Composer
from tracks inner join playlists inner join playlist_track on playlists.PlaylistId=playlist_track.PlaylistId and playlist_track.TrackId=tracks.TrackId
where playlists.Name='Heavy Metal Classic';

select customers.FirstName,
       customers.LastName,
       customers.City,
       customers.State,
       tracks.TrackId,
       artists.Name
from tracks inner join artists inner join albums inner join invoice_items inner join invoices  inner join customers on artists.ArtistId=albums.ArtistId and albums.AlbumId =tracks.AlbumId and  tracks.TrackId=invoice_items.TrackId and invoice_items.InvoiceId=invoices.InvoiceId and customers.CustomerId=invoices.CustomerId
where artists.Name='Aerosmith' and tracks.Name='Angel';