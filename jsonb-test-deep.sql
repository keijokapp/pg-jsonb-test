truncate table "jsonb-test-deep"; alter sequence "jsonb-test-deep_id_seq" restart 1;

CREATE TABLE "jsonb-test-deep" (
  id bigserial NOT NULL,
  data jsonb
) -- TABLESPACE dedicated;

-- Example row:
-- 40000029, "{"id": 40000029, "asd00": {"asd10": {"asd20": "FrJLokDK", "asd21": {"asd30": "ZbVgEha", "asd31": "jROZ0XUe", "asd32": "jROZ0XUe", "asd33": "ZbVgEha"}, "asd22": "jROZ0XUe"}}}"

SELECT count(*) from "jsonb-test-deep"; -- seq scan
-- Total query runtime: 3502 ms.
-- 1 row retrieved.

SELECT * from "jsonb-test-deep" WHERE id=40000029; -- seq scan
-- Total query runtime: 3837 ms.
-- 1 row retrieved.

------------------------
CREATE INDEX ginix0 ON "jsonb-test-deep" USING gin ((data->'id'));
-- Query returned successfully with no result in 354288 ms.

SELECT * FROM "jsonb-test-deep" WHERE data->'id' @> '48692795'::jsonb; -- ginix0
-- Total query runtime: 13 ms.
-- 1 row retrieved.

-- SELECT * FROM "jsonb-test-deep" WHERE data->'id' = '48692795'; -- seq scan
-- ???

------------------------
CREATE INDEX ginix1 ON "jsonb-test-deep" USING gin ((data->'asd00'->'asd10'->'asd22') jsonb_path_ops);
-- Query returned successfully with no result in 20518 ms.

SELECT count(*) FROM "jsonb-test-deep" WHERE data->'asd00'->'asd10'->'asd22' @> '"jROZ0XUe"'; -- ginix1
-- Total query runtime: 1796 ms.
-- 1 row retrieved. (161843)

SELECT count(*) FROM "jsonb-test-deep" WHERE data->'asd00'->'asd10'->'asd22' @> '"jROZ0XUe"' AND data->'asd00'->'asd10'->'asd20' @> '"FrJLokDK"'; -- ginix1 & index scan
-- Total query runtime: 1835 ms.
-- 1 row retrieved. (22759)

------------------------
CREATE INDEX ginix2 ON "jsonb-test-deep" USING gin ((data->'asd00'->'asd10'->'asd21'));
-- Query returned successfully with no result in 20517 ms.

SELECT count(*) FROM "jsonb-test-deep" WHERE data->'asd00'->'asd10' ? 'asd21'; -- seq scan
-- Total query runtime: 13129 ms.
-- 1 row retrieved. (1625498)

SELECT count(*) FROM "jsonb-test-deep" WHERE data->'asd00'->'asd10'->'asd21' ? 'asd30'; -- ginix2
-- Total query runtime: 4447 ms.
-- 1 row retrieved.

------------------------
-- lets add row with unique data->'asd00'->'asd10'->'asd22' (and we have 3 indices activated at the moment)
INSERT INTO "jsonb-test-deep" (data) VALUES('{ "asd00": { "asd10" : { "asd22":"bla bla" } } }');
-- Query returned successfully: one row affected, 11 ms execution time.

SELECT * FROM "jsonb-test-deep" WHERE data->'asd00'->'asd10'->'asd22' @> '"bla bla"'; -- ginix1
-- Total query runtime: 12 ms.
-- 1 row retrieved.

