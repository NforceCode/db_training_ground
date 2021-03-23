
DROP TABLE users;

CREATE TABLE users (
  "id" serial PRIMARY KEY,
  "first_name" varchar(64) NOT NULL ,
  "last_name" varchar(64) NOT NULL ,
  "email" varchar(256) NOT NULL UNIQUE CHECK ("email" != ''),
  "isMale" boolean NOT NULL,
  "birthday" date NOT NULL CHECK ("birthday" < current_date AND "birthday" > '1900-1-1'),
  "height" numeric(3,2) NOT NULL CHECK ("height" > 0.2 AND "height" < 3),
  "weight" numeric(5,2) NOT NULL CHECK ("weight" > 0 AND "weight" < 500),
  CONSTRAINT "UNQ_FULL_NAME" UNIQUE ("first_name", "last_name"),
  CONSTRAINT "CK_FULL_NAME" CHECK ("first_name" !='' AND "last_name" !='')
);

INSERT INTO users ("first_name", "last_name", "email", "isMale", "birthday", "height", "weight") VALUES 
('Test', 'Testovich', 'test@test.test', true, '1991-12-21', 1.95, 100),
('Archaon', 'the Everchosen', 'burntheoldworld@chaos.net', true, '1964-6-6', 2.15, 10.45),
('Tester', 'the Evertesting', 'tester@test.test', true, '1974-6-6', 2.15, 100),
('Idk', 'Nonamovna', 'idk@imaginative.com', false, '1900-3-24', 1.7, 100.5),
('sadsd', 'asdasdsa', 'Error@eror', true, '1901-12-12', 1.75, 499.9);
/*
SELECT * FROM users ORDER BY id ASC;
*/

CREATE TABLE content (
  "id" serial PRIMARY KEY,
  "name" varchar(128) NOT NULL CHECK ("name" != ''),
  "owner_id" int, 
  "created_at" timestamp DEFAULT current_timestamp,
  "desc" varchar(1024) NOT NULL CHECK ("desc" != '')
  CONSTRAINT "FK_owner_id" FOREIGN KEY ("owner_id") REFERENCES users (id)
);

INSERT INTO content ("name", "owner_id", "desc") VALUES('Hello World', 1, 'My first content Pog');

CREATE TABLE user_reaction (
  "user_id" int NOT NULL CONSTRAINT "FK_user_id" FOREIGN KEY ("user_id") REFERENCES users (id),
  "content_id" int NOT NULL CONSTRAINT "FK_content_id" FOREIGN KEY ("content_id") REFERENCES content (id),
  "isLiked" boolean
  
);

INSERT INTO user_reaction ("user_id", "content_id", "isLiked") VALUES (2,1, false),
(1,1, true);

SELECT avg("height") AS "average height" FROM "users";
SELECT avg("height") AS "average height", "is_male" FROM "users" GROUP BY "is_male";
SELECT min("height") AS "min height", "is_male" FROM "users" GROUP BY "is_male";

SELECT 
min("height") AS "min height", 
avg("height") AS "avg height", 
max("height") AS "max height", 
"is_male" 
FROM "users" GROUP BY "is_male";

SELECT count(*) 
FROM "users"
WHERE "birthday" = '1970-1-1';

SELECT count(*)
FROM "users"
WHERE "first_name" = 'Alexis';

SELECT count(*)
FROM "users"
WHERE extract(year from age("birthday")) BETWEEN 20 AND 30;