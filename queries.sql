CREATE TABLE jsonb_test (
  id bigserial NOT NULL,
  data jsonb
)

-- Example row:
-- 92157390, '{"id": 92157390, "asd": "3Ayxwn", "tags": ["sp1UPy", "O0o2Mpa", "XgFrZ3V6j"], "bla bla": "undefined"}'


SELECT count(*) from jsonb_test; -- seq scan
-- Total query runtime: 8181 ms.
-- 1 row retrieved. (110000000)

SELECT * from jsonb_test OFFSET 92157396 LIMIT 1; -- seq scan
-- Total query runtime: 5422 ms.
-- 1 row retrieved.

------------------------
CREATE INDEX ginix0 ON jsonb_test USING gin ((data->'id'));
-- Query returned successfully with no result in 579020 ms.

SELECT * FROM jsonb_test WHERE data->'id' @> '92157390'::jsonb; -- ginix0
-- Total query runtime: 10 ms.
-- 1 row retrieved.

SELECT * FROM jsonb_test WHERE data->>'id' = '92157390'; -- seq scan
-- Total query runtime: 24962 ms.
-- 1 row retrieved.


------------------------
CREATE INDEX ginix1 ON jsonb_test USING gin ((data->'id') jsonb_path_ops);

-- EXPLAIN
SELECT * FROM jsonb_test WHERE data->'id' @> '92157390';
-- ???

-- EXPLAIN
SELECT * FROM jsonb_test WHERE data->'id' = '92157390';
-- ???

------------------------
CREATE INDEX ginix2 ON jsonb_test USING gin ((data->'tags'));

-- EXPLAIN
SELECT count(*) FROM jsonb_test WHERE data->'tags' ? 'O0o2Mpa'; -- ginix2
-- Total query runtime: 81 ms.
-- 1 row retrieved. (24915)

-- EXPLAIN
SELECT count(*) FROM jsonb_test WHERE data->'tags' @> '"O0o2Mpa"'::jsonb; -- ginix2
-- Total query runtime: 81 ms.
-- 1 row retrieved. (24915)

------------------------
CREATE INDEX ginix3 ON jsonb_test USING gin ((data->'tags') jsonb_path_ops);

-- EXPLAIN
SELECT count(*) FROM jsonb_test WHERE data->'tags' @> '"O0o2Mpa"'::jsonb; -- ginix3
-- Total query runtime: 81 ms.
-- 1 row retrieved. (24915)



