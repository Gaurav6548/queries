create database joins;
use joins;
select * from album;
select * from song;
select * from record_label;
select * from artist;
select a.name artist,r.name record from artist a join record_label r on r.id=a.record_label_id order by a.name;
select name from record_label where id not in(select distinct record_label_id from artist);

select count(s.id) as songs,ar.name from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id group by ar.name order by songs desc;

select count(s.id) as songs,ar.name from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id group by ar.name order by songs desc limit 1;

with songcount as(
select count(s.id) as songs,ar.name as artist_name from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id group by ar.name order by songs desc
)
select artist_name,songs from songcount where songs=(select min(songs) from songcount);

select count(s.id) as songs,ar.name from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id where s.duration>5 group by ar.name order by songs desc ;

select count(s.id) as songs,ar.name,a.name from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id where s.duration<5 group by ar.name,a.name order by a.name;

select a.year,count(s.id) as songs from song s join album a on s.album_id =a.id group by a.year order by songs desc limit 1;

select ar.name,a.name,s.name,a.year,s.duration from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id order by s.duration desc limit 5;

select count(id),year from album group by year order by year;
with temp as (
select count(id) as albums,year from album group by year order by year
)
select albums,year from temp where albums in (select max(albums) from temp);

select round(sum(s.duration),2) as duration,ar.name from song s join album a on s.album_id =a.id join artist ar  on a.artist_id =ar.id  group by ar.name order by duration desc ;

SELECT artist.name AS artist_name, album.name AS album_name
FROM album
JOIN artist ON album.artist_id = artist.id
JOIN song ON album.id = song.album_id
GROUP BY artist.name, album.name
HAVING MIN(song.duration) > 5; 

SELECT 
    artist.name AS artist_name, 
    album.name AS album_name, 
    song.name AS song_name, 
    song.duration AS song_duration
FROM 
    artist
JOIN 
    album ON artist.id = album.artist_id
JOIN 
    song ON album.id = song.album_id
ORDER BY 
    artist.name ASC, 
    album.name ASC, 
    song.name ASC;

SELECT 
    album.name AS album_name,
    SUM(song.duration) AS total_seconds    
FROM 
    album
JOIN 
    song ON album.id = song.album_id
WHERE 
    album.name = 'Greatest Hits'
GROUP BY 
    album.name;

select distinct ar.name from artist ar join album a on a.artist_id =ar.id where a.year not between 1980 and 1999 order by ar.name;

select distinct ar.name from artist ar join album a on a.artist_id =ar.id where a.year  between 1980 and 1999 order by ar.name;
