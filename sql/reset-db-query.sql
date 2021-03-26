DROP TABLE IF EXISTS phone_to_order;
DROP TABLE IF EXISTS "order";
DROP TABLE IF EXISTS "phone";
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS "user";
/*  */
CREATE TABLE "user" (
  "user" serial PRIMARY KEY,
  "firstName" varchar(64) NOT NULL,
  "lastName" varchar(64) NOT NULL,
  email varchar(256) NOT NULL CHECK (email != ''),
  "isMale" boolean NOT NULL,
  birthday date NOT NULL CHECK (
    birthday < current_date
    AND birthday > '1900/1/1'
  ),
  "createdAt" timestamp default current_timestamp,
  height numeric(3, 2) NOT NULL CHECK (
    height > 0.20
    AND height < 2.5
  ),
  CONSTRAINT "CK_FULL_NAME" CHECK (
    "firstName" != ''
    AND "lastName" != ''
  )
);
/*  */
CREATE TABLE "phone"(
  "phone" serial PRIMARY KEY,
  brand varchar(20) NOT NULL,
  model varchar(40) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK(price >= 0),
  quantity int NOT NULL CHECK(quantity >= 0) DEFAULT 0,
  "description" text,
  "createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  CONSTRAINT "unique_phone" UNIQUE (brand, model)
);
/*  */
CREATE TABLE "order" (
  "order" serial PRIMARY KEY,
  "user" int REFERENCES "user",
  "createdAt" timestamp NOT NULL DEFAULT current_timestamp
);
/*  */
CREATE TABLE phone_to_order (
  "order" int REFERENCES "order",
  "phone" int REFERENCES "phone",
  quantity int NOT NULL CHECK (quantity > 0) DEFAULT 1,
  PRIMARY KEY ("order", "phone")
);

CREATE TABLE tasks (
  task serial PRIMARY KEY,
  "name" varchar(1024) NOT NULL CHECK ("name" != ''),
  "user" int REFERENCES "user",
  is_done boolean DEFAULT false,
  "priority" varchar(1024) NOT NULL CHECK ("priority" != ''),
  description text
);
