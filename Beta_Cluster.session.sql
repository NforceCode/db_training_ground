
DROP TABLE users;

CREATE TABLE users (
  id serial PRIMARY KEY,
  first_name varchar(64) NOT NULL ,
  last_name varchar(64) NOT NULL ,
  email varchar(256) NOT NULL UNIQUE CHECK (email != ''),
  isMale boolean NOT NULL,
  birthday date NOT NULL CHECK (birthday < current_date AND birthday > '1900-1-1'),
  height numeric(3,2) NOT NULL CHECK (height > 0.2 AND height < 3),
  weight numeric(5,2) NOT NULL CHECK (weight > 0 AND weight < 500),
  CONSTRAINT "UNQ_FULL_NAME" UNIQUE (first_name, last_name),
  CONSTRAINT "CK_FULL_NAME" CHECK (first_name !='' AND last_name !='')
);

INSERT INTO users (first_name, last_name, email, isMale, birthday, height, weight) VALUES 
('Test', 'Testovich', 'test@test.test', true, '1991-12-21', 1.95, 100),
('Archaon', 'the Everchosen', 'burntheoldworld@chaos.net', true, '1964-6-6', 2.15, 10.45),
('Tester', 'the Evertesting', 'tester@test.test', true, '1974-6-6', 2.15, 100),
('Idk', 'Nonamovna', 'idk@imaginative.com', false, '1900-3-24', 1.7, 100.5),
('sadsd', 'asdasdsa', 'Error@eror', true, '1901-12-12', 1.75, 499.9);
/*
SELECT * FROM users ORDER BY id ASC;
*/

CREATE TABLE content (
  id serial PRIMARY KEY,
  name varchar(128) NOT NULL CHECK (name != ''),
  owner_id int REFERENCES users (id), 
  created_at timestamp DEFAULT current_timestamp,
  "desc" varchar(1024) NOT NULL CHECK ("desc" != '')
);

INSERT INTO content (name, owner_id, "desc") VALUES('Hello World', 1, 'My first content Pog');

CREATE TABLE user_reaction (
  user_id int NOT NULL REFERENCES users (id),
  content_id int NOT NULL REFERENCES content (id),
  isLiked boolean
  --FOREIGN KEY (user_id, content_id) REFERENCES  ()
);

INSERT INTO user_reaction (user_id, content_id, isLiked) VALUES (2,1, false),
(1,1, true);
