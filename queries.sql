CREATE TABLE jsonb_test (
  id bigserial NOT NULL,
  data jsonb
)

--- Example row:
--- 92157390, '{"id": 92157390, "asd": "3Ayxwn", "tags": ["sp1UPy", "O0o2Mpa", "XgFrZ3V6j"], "bla bla": "undefined"}'

CREATE INDEX ginix0 ON jsonb_test
  USING gin ((data->'id'::text));

CREATE INDEX ginix1 ON jsonb_test
  USING gin ((data->'tags'::text));

--- Queries:

--- EXPLAIN
SELECT count(*) from jsonb_test;
--- Total query runtime: 8320 ms.
--- 1 row retrieved. (110000000)

--- EXPLAIN
SELECT * from jsonb_test OFFSET 92157396 LIMIT 1;
--- Total query runtime: 5422 ms.
--- 1 row retrieved.

--- EXPLAIN
SELECT count(*) FROM jsonb_test WHERE
data->'tags' ? 'O0o2Mpa';
--- Total query runtime: 81 ms.
--- 1 row retrieved. (24915)

--- EXPLAIN
SELECT count(*) FROM jsonb_test WHERE
data->'tags' @> '"O0o2Mpa"'::jsonb;
--- Total query runtime: 81 ms.
--- 1 row retrieved. (24915)

--- EXPLAIN
SELECT * FROM jsonb_test WHERE
data->'id' @> '92157390'::jsonb;
--- Total query runtime: 10 ms.
--- 1 row retrieved.


