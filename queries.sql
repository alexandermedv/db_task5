SELECT a.genre_name,
	count(performer_id)
FROM test.genre a
LEFT JOIN test.performer_genre b
	ON a.genre_id = b.genre_id
GROUP BY a.genre_name;

SELECT b.album_name, 
	b.year, 
	count(track_id)
FROM test.track a
LEFT JOIN test.album b
	ON a.album_id = b.album_id
WHERE b.year IN ('2019', '2020')
GROUP BY b.album_name, 
	b.year;
	
SELECT a.album_name,
	round(avg(b.duration))
FROM test.album a
LEFT JOIN test.track b
	ON a.album_id = b.track_id
GROUP BY a.album_name;

SELECT performer_name
FROM (SELECT * FROM test.album WHERE year <> '2020') a
LEFT JOIN test.performer_album b
	ON a.album_id = b.album_id
LEFT JOIN test.performer c
	ON b.performer_id = c.performer_id;

SELECT DISTINCT a.collection_name
FROM test.collection a
LEFT JOIN test.track_collection b
	ON a.collection_id = b.collection_id
LEFT JOIN test.track c
	ON b.track_id = c.track_id
LEFT JOIN test.performer_album d
	ON d.album_id = c.album_id
LEFT JOIN test.performer e
	ON d.performer_id = e.performer_id
WHERE e.performer_name = 'Queen';

SELECT album_name
FROM test.album a
LEFT JOIN test.performer_album b
	ON a.album_id = b.album_id
LEFT JOIN test.performer c
	ON b.performer_id = c.performer_id
LEFT JOIN test.performer_genre d
	ON c.performer_id = d.performer_id
GROUP BY album_name
HAVING count(genre_id) > 1;

SELECT a.track_name
FROM test.track a
LEFT JOIN test.track_collection b
	ON a.track_id = b.track_id
WHERE b.collection_id IS NULL;

SELECT d.performer_name
FROM test.track a
LEFT JOIN test.album b
	ON a.album_id = b.album_id
LEFT JOIN test.performer_album c
	ON b.album_id = c.album_id
LEFT JOIN test.performer d
	ON c.performer_id = d.performer_id
GROUP BY d.performer_name
HAVING min(a.duration) = (
	SELECT e.duration
	FROM test.track e
	LEFT JOIN test.album f
		ON e.album_id = f.album_id
	LEFT JOIN test.performer_album g
		ON f.album_id = g.album_id
	LEFT JOIN test.performer h
		ON g.performer_id = h.performer_id
	ORDER BY e.duration ASC
	LIMIT 1
);

SELECT a.album_name, 
	count(b.track_id)
FROM test.album a
LEFT JOIN test.track b
	ON a.album_id = b.album_id
GROUP BY a.album_name
HAVING count(b.track_id) = 
				(SELECT count(d.track_id)
					FROM test.album c
				LEFT JOIN test.track d
					ON c.album_id = d.album_id
				GROUP BY c.album_name
				ORDER BY count(d.track_id) ASC
				LIMIT 1);