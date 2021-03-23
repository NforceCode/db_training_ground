DROP TABLE "position_to_worker";
DROP TABLE "workers";
DROP TABLE "position";

-- Создайте таблицу “workers” (“id”, “birthday”, “name”, “salary”).

CREATE TABLE "workers"(
  "id" serial PRIMARY KEY,
  "birthday" date CHECK("birthday" > '1930-1-1'),
  "name" varchar(92) NOT NULL CHECK ("name" != ''),
  "salary" int NOT NULL CHECK ("salary" > 0)
);

-- Задачи на INSERT

-- Добавьте нового работника Никиту, 90го года, зарплата 300$.
INSERT INTO "workers" ("name", "birthday", "salary") VALUES ('Nikita', '1990-4-4', 300);

-- Добавьте нового работника Светлану с зарплатой 1200$.
INSERT INTO "workers" ("name", "birthday", "salary") VALUES ('Svetlana',NULL, 1200);

-- Добавьте двух новых работников одним запросом: Ярослава с зарплатой 1200$ и годом 80го, Петра с зарплатой 1000$ и 93 года.
INSERT INTO "workers" ("name", "birthday", "salary") 
VALUES ('Yaroslav','1980-5-7', 1200),('Petr', '1993-1-14', 1000);

INSERT INTO "workers" ("name", "birthday", "salary") 
VALUES ('Vasya','1980-5-7', 150),
('Nikolay', '1974-6-24', 800),
('Nina', '1993-8-11',1500),
('Anna', '1970-2-2', 1100),
('Fedot', '1997-5-1', 300),
('Timur', '1956-12-31', 2500);

-- Задачи на UPDATE

-- Поставьте Васе зарплату в 200$.
UPDATE "workers" SET "salary" = 200 WHERE "name" = 'Vasya';

-- Работнику с id=4 поставьте год рождения 87й.
UPDATE "workers" 
SET "birthday" = make_date(1987,
CAST (extract(month from "birthday") AS int), 
CAST (extract (day from "birthday") AS int)) 
WHERE "id" = 4
RETURNING *;

-- Всем, у кого зарплата 500$ сделайте ее 700$.
UPDATE "workers" SET "salary" = 700 WHERE "salary" < 500;

-- Работникам с id больше 2 и меньше 5 включительно поставьте год 99.
UPDATE "workers" 
SET "birthday" = make_date(1999 , 
CAST (extract (month from "birthday") AS int), 
CAST (extract (day from "birthday") AS int)) 
WHERE "id" BETWEEN 2 AND 5
RETURNING *;

-- Поменяйте Васю на Женю и прибавьте ему зарплату до 900$.
UPDATE "workers"
SET "name" = 'Zhenya' , "salary" = 900
WHERE "name" = 'Vasya'
RETURNING *;

-- Задачи на SELECT

-- Выбрать работника с id = 3.
SELECT * FROM "workers" WHERE "id" =3;

-- Выбрать работников с зарплатой более 400$.
SELECT * FROM "workers" WHERE "salary" > 400;

--Выбрать работников с зарплатой НЕ равной 500$.

SELECT * FROm "workers" WHERE "salary" != 500;

-- Узнайте зарплату и возраст Жени.

SELECT ("salary", "birthday") FROM "workers" WHERE "name" = 'Zhenya';

-- Выбрать работников с именем Петя.

SELECT * FROM "workers" WHERE "name" = 'Petr';

-- Выбрать всех, кроме работников с именем Петя.

SELECT * FROM "workers" WHERE "name" != 'Petr';


-- Выбрать всех работников в возрасте 27 лет или с зарплатой 1000$.

SELECT * FROM "workers" 
WHERE extract(year from age("birthday")) = 27  OR "salary" = 1000;

-- Выбрать работников в возрасте от 25 (не включительно) до 28 лет (включительно).

SELECT * FROM "workers" WHERE (extract(year from age("birthday")) BETWEEN 26 AND 28 );

-- Выбрать всех работников в возрасте от 23 лет до 27 лет или с зарплатой от 400$ до 1000$.
SELECT * FROM "workers" 
--Выбрать всех работников в возрасте 27 лет или с зарплатой не равной 400$.

SELECT * FROM "workers" 
WHERE extract(year from age("birthday")) = 27 
OR "salary" != 400;

-- Задачи на DELETE

-- Удалите работника с id=7.

DELETE FROM "workers" WHERE "id" =7 RETURNING *;

-- Удалите Колю.

DELETE FROM "workers" WHERE "name" ='Nikolay' RETURNING *;

-- Удалите всех работников, у которых возраст 23 года.


DELETE FROM "workers" WHERE extract (year from age("birthday")) = 23 RETURNING *;

--SELECT "id","name", extract (year from age("birthday")) as "full years" FROM "workers" ORDER By "id" ASC;

-- BONUS TASK

CREATE TABLE "position" (
  "id" serial PRIMARY KEY,
  "name" varchar(128) NOT NULL CHECK("name" != '')
);

INSERT INTO "position" ("name") 
VALUES 
('Boss'),
('TeamLead'),
('Coder'),
('Intern');

CREATE TABLE "position_to_worker"(
-- не уверен что тут лучше сделать ключом а что просто уникальным значением
  "worker_id" int UNIQUE REFERENCES "workers" ("id"),
  "position_id" int  REFERENCES "position" ("id"),
  PRIMARY KEY ("worker_id", "position_id")
);


INSERT INTO "position_to_worker" ("worker_id", "position_id") 
VALUES 
(1,1),
(2,2),
(3,3),
(5,4),
(4,4);



