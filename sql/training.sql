
DROP TABLE user;

CREATE TABLE user (
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

INSERT INTO user ("first_name", "last_name", "email", "isMale", "birthday", "height", "weight") VALUES 
('Test', 'Testovich', 'test@test.test', true, '1991-12-21', 1.95, 100),
('Archaon', 'the Everchosen', 'burntheoldworld@chaos.net', true, '1964-6-6', 2.15, 10.45),
('Tester', 'the Evertesting', 'tester@test.test', true, '1974-6-6', 2.15, 100),
('Idk', 'Nonamovna', 'idk@imaginative.com', false, '1900-3-24', 1.7, 100.5),
('sadsd', 'asdasdsa', 'Error@eror', true, '1901-12-12', 1.75, 499.9);
/*
SELECT * FROM user ORDER BY id ASC;
*/

CREATE TABLE content (
  "content" serial PRIMARY KEY,
  "name" varchar(128) NOT NULL CHECK ("name" != ''),
  "user" int, 
  "created_at" timestamp DEFAULT current_timestamp,
  "desc" varchar(1024) NOT NULL CHECK ("desc" != '')
  CONSTRAINT "FK_owner_id" FOREIGN KEY ("user") REFERENCES user
);

INSERT INTO content ("name", "owner_id", "desc") VALUES('Hello World', 1, 'My first content Pog');

CREATE TABLE user_reaction (
  "user" int NOT NULL REFERENCES user,
  "content" int NOT NULL REFERENCES content,
  "isLiked" boolean
  
);

INSERT INTO user_reaction ("user", "content", "isLiked") VALUES (2,1, false),
(1,1, true);

SELECT avg("height") AS "average height" FROM "user";
SELECT avg("height") AS "average height", "is_male" FROM "user" GROUP BY "is_male";
SELECT min("height") AS "min height", "is_male" FROM "user" GROUP BY "is_male";

SELECT 
min("height") AS "min height", 
avg("height") AS "avg height", 
max("height") AS "max height", 
"is_male" 
FROM "user" GROUP BY "is_male";

SELECT count(*) 
FROM "user"
WHERE "birthday" = '1970-1-1';

SELECT count(*)
FROM "user"
WHERE "firstName" = 'Alexis';

SELECT count(*)
FROM "user"
WHERE extract(year from age("birthday")) BETWEEN 20 AND 30;


SELECT sum("quantity") FROM "phone_to_order";

SELECT SUM("quantity") FROM "phone";

SELECT avg("price") FROM "phone";

SELECT avg("price"), "brand" FROM "phone" GROUP BY "brand";

SELECT sum("price" * "quantity") FROM "phone" WHERE "price" BETWEEN 10000 AND 20000;

SELECT count("model"), "brand" FROM "phone" GROUP BY "brand";

SELECT count("order"), "user" FROM "order" GROUP BY "user";

SELECT avg("price") FROM "phone" WHERE "brand"='IPhone';



SELECT *, extract(year from age("birthday")) AS "age" 
FROM "user" ORDER BY extract(year from age("birthday")), "firstName";

SELECT count(*) as "people", "age"
FROM (SELECT *, extract(year from age("birthday")) AS "age" 
FROM "user" ) AS "Users with Age"
GROUP BY "age"
HAVING count(*) > 5
ORDER BY "age";


SELECT sum("quantity") as "count","brand"
FROM "phone"
GROUP BY "brand"
HAVING sum("quantity") > 2500; 


SELECT * FROM "user" WHERE "firstName" LIKE 'J%' AND "lastName" ILIKE 'd%';

SELECT char_length(concat("firstName", ' ', "lastName")) AS "fullName",* 
FROM "user"
ORDER BY "fullName" DESC
LIMIT 1;

SELECT * FROM (SELECT *, concat("firstName", ' ', "lastName") as "fullName" FROM "user") AS "withFullName" 
WHERE length(concat("firstName", ' ', "lastName")) >=18;

SELECT length(email) AS "length"
FROM "user"
WHERE email ILIKE 'w%'
GROUP BY "length"
HAVING length(email) > 25;

SELECT length(email) AS "length", count(length(email)) AS "amount"
FROM "user"
WHERE email ILIKE 'w%'
GROUP BY "length"
HAVING count(length(email)) > 2;

SELECT  char_length(concat("firstName", ' ', "lastName")) as "fullNameLength",
count(user) FROM "user"
GROUP BY "fullNameLength"
HAVING char_length(concat("firstName", ' ', "lastName")) >= 18;



/* стоимость каждого заказа */
SELECT o.order, sum(pto.quantity * p.price)
FROM "order" AS o 
  JOIN phone_to_order AS pto USING("order")
  JOIN "phone" AS p USING(phone)
GROUP BY o.order
ORDER BY o.order;
-- order и user зарезервированные так что в двойных

/* все телефоны конкретного заказа*/
SELECT p.model, p.brand, pto.quantity
FROM "order" AS o 
  JOIN phone_to_order AS pto ON pto.order = o.order
  JOIN phone AS p ON p.phone= pto.phone
WHERE o.order = 1
GROUP BY p.model, p.brand, pto.quantity
ORDER BY p.brand, p.model;


/* Заказы каждого пользователя и его мейл*/

SELECT count(o.order) AS "Orders", o.user, u.email
FROM "order" AS o
  JOIN "user" AS u ON u.user = o.user
GROUP BY o.user, u.email
ORDER BY o.user;

/* кол-во позиций товара в определенном заказе */

SELECT count(*)
FROM "order" AS o
  JOIN phone_to_order AS pto ON pto.order = o.order
WHERE o.order = 1;

/* извлечь самый популярный телефон*/

SELECT p.model, p.brand, count(pto.quantity) as "amount"
FROM "phone" AS p
  JOIN phone_to_order AS pto ON pto.phone = p.phone
  JOIN "order" AS o ON pto.order = o.order
GROUP BY p.model, p.brand
ORDER BY p.model, p.brand DESC
LIMIT 1;

/* Пользователи и кол-во моделей которые они покупали*/

/*SELECT pto.order, u.email,count(pto.phone) AS "models"
FROM "user" AS u
  JOIN "order" AS o USING ("user")
  JOIN phone_to_order AS pto USING("order")
  JOIN phone AS p USING(phone)
GROUP BY u.email, pto.order
ORDER BY "models" DESC;*/

/*===============================*/

SELECT user_with_phone.user, count(user_with_phone.phone) 
FROM(
    SELECT u.user, p.phone
    FROM "user" AS u
    JOIN "order" AS o USING ("user")
    JOIN phone_to_order AS pto USING("order")
    JOIN phone AS p USING(phone)
    GROUP BY u.user, p.phone
  ) AS user_with_phone
GROUP BY user_with_phone.user

/* все заказы стоимостью выше среднего чека заказов */ 

SELECT pto.order,
  sum(pto.quantity * p.price) AS "cost"
FROM phone_to_order AS pto
  JOIN phone AS p USING(phone)
GROUP BY pto.order

-- ========================================
SELECT avg(order_w_cost.cost) as avg_cost
FROM (
  SELECT pto.order,
    sum(pto.quantity * p.price) AS "cost"
  FROM phone_to_order AS pto
    JOIN phone AS p USING(phone)
  GROUP BY pto.order
) AS order_w_cost

/* ========================================*/

SELECT order_w_cost.*
FROM (
  SELECT pto.order,
    sum(pto.quantity * p.price) AS "cost"
  FROM phone_to_order AS pto
    JOIN phone AS p USING(phone)
  GROUP BY pto.order
) AS order_w_cost
WHERE order_w_cost.cost > (SELECT avg(order_w_cost.cost) as avg_cost
FROM (
  SELECT pto.order,
    sum(pto.quantity * p.price) AS "cost"
  FROM phone_to_order AS pto
    JOIN phone AS p USING(phone)
  GROUP BY pto.order
) AS order_w_cost)


/* ========================================== */

WITH order_w_cost AS (
  SELECT pto.order,
    sum(pto.quantity * p.price) AS "cost"
  FROM phone_to_order AS pto
    JOIN phone AS p USING(phone)
  GROUP BY pto.order
)
SELECT order_w_cost.* 
FROM order_w_cost
WHERE order_w_cost.cost > (
  SELECT avg(owc.cost)
  FROM order_w_cost AS owc
)
ORDER BY order_w_cost.cost;

/* Извлечь всех пользователей у которых кол-во заказов больше среднего */

WITH order_with_user AS (
  SELECT count(o.order) as orders_of_user, o.user 
  FROM "order" AS o
  GROUP BY o.user
)


SELECT * 
FROM (
  SELECT avg(ord.ord_num)
  FROM (

  ) AS ord
) AS with_avg
  JOIN "user" AS u USING ()

WITH user_w_orders AS (
  SELECT count(o.order) as ord_num, o.user 
  FROM "order" AS o
  GROUP BY o.user
)
SELECT uwo.user
FROM user_w_orders AS uwo
WHERE uwo.ord_num > (
  SELECT avg(owc.ord_num)
  FROM user_w_orders AS owc
)

/* извлечь всех пользователей с мин заказами */

WITH user_w_orders AS (
  SELECT count(o.order) as ord_num, o.user 
  FROM "order" AS o
  GROUP BY o.user
)
SELECT uwo.user
FROM user_w_orders AS uwo
WHERE uwo.ord_num = (
  SELECT min(owc.ord_num)
  FROM user_w_orders AS owc
)

    
/* ВСЕ заказы с определенным телефоном.
  Показать бренд и модель телефона*/

SELECT pto.order, p.brand, p.model, pto.quantity AS "amount ordered", count(pto.order)
FROM phone AS p
  JOIN phone_to_order AS pto USING(phone)
WHERE p.phone = 7
GROUP BY pto.order, p.brand, p.model, "amount ordered"