-- Необходимо спроектировать базу данных ПОСТАВКА ТОВАРОВ
-- В БД должна храниться информация:

-- - о ТОВАРАХ : код товара, наименование товара, цена товара

-- - ЗАКАЗАХ на поставку товаров: код заказа, наименование заказчика, адрес заказчика, телефон,
-- номер договора, дата заключения договора, наименование товара, плановая поставка (шт.);

-- - фактических ОТГРУЗКАХ товаров: код отгрузки, код заказа, дата отгрузки,
-- отгружено товара (шт.)

-- При проектировании БД необходимо учитывать следующее:
-- • товар имеет несколько заказов на поставку. Заказ соответствует одному товару;
-- • товару могут соответствовать несколько отгрузок. В отгрузке могут участвовать несколько товаров.

-- Кроме того следует учесть:
-- • товар не обязательно имеет заказ. Каждому заказу обязательно соответствует товар;
-- • товар не обязательно отгружается заказчику. Каждая отгрузка обязательно соответствует некоторому товару.

CREATE DATABASE cargo_task;

-- товар
CREATE TABLE products (
  product_id serial PRIMARY KEY,
  "name" varchar(128) NOT NULL,
  price numeric(9,2) NOT NULL CHECK(price > 0)
);


--заказ
CREATE TABLE orders (
  order_id serial PRIMARY KEY,
  product_id int REFERENCES products,
  planned_amount int NOT NULL CHECK(planned_amount > 0)
  -- не факт

  PRIMARY KEY (order_id, customer_id, contract_id)
);

-- заказчик
CREATE TABLE customers (
  customer_id serial PRIMARY KEY,
  "address" jsonb NOT NULL,
  contact_phone varchar(16) NOT NULL,

);

-- договор
CREATE TABLE contracts (
  contract_id serial PRIMARY KEY,
  -- заказ такой то
  order_id int REFERENCES orders
  -- от такой то даты 
  created_at date NOT NULL CHECK(created_at < current_date),
  -- кем сделан
  customer_id int REFERENCES customers,
  -- кому отгружается
  recipient_id int REFERENCES customers
);

-- отгурзка

CREATE TABLE shipments(
  shipment_id serial PRIMARY KEY,
  -- получатель
  recipient_id int REFERENCES contracts(recipient_id)
  -- дата отгрузки 
);
/*
  m:n 
    shipments_to_products

*/