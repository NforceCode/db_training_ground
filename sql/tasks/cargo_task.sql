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

DROP TABLE IF EXISTS order_to_shipment;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS contracts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- товар
CREATE TABLE products (
  product_id serial PRIMARY KEY,
  product_name varchar(128) NOT NULL,
  price numeric(9,2) NOT NULL CHECK(price > 0)
);

INSERT INTO products (product_name, price) 
VALUES ('apples', 45.5),
('oranges', 30.52);

-- заказчик
CREATE TABLE customers (
  customer_id serial PRIMARY KEY,
  -- нименование заказчика
  customer_name varchar(128) NOT NULL CHECK (customer_name != ''),
  -- адрес заказчика
  customer_address jsonb NOT NULL,
  -- телефон
  contact_phone varchar(16) NOT NULL
);

INSERT INTO customers (customer_name, customer_address, contact_phone) 
VALUES ('Varus', '{"city": "ZP", "street": "testova", "streetNum": 12}', '168-458-7893');

-- договор
CREATE TABLE contracts (
  contract_id serial PRIMARY KEY,
  -- от такой то даты 
  created_at date DEFAULT current_date CHECK(created_at <= current_date),
  -- кем сделан
  customer_id int REFERENCES customers,
  -- кому отгружается
  recipient_id int REFERENCES customers
);

INSERT INTO contracts (customer_id, recipient_id)
VALUES (1,1);

--заказ
CREATE TABLE orders (
  -- код заказа
  order_id serial PRIMARY KEY,
  -- наименование товара
  product_id int REFERENCES products,
  -- договор
  contract_id int REFERENCES contracts(contract_id),
  -- плановая поставка
  planned_amount int NOT NULL CHECK(planned_amount > 0)
);

INSERT INTO orders (product_id, contract_id, planned_amount)
VALUES (1,1,12),
(2,1,20);

-- отгурзка
CREATE TABLE shipments(
  -- код отгрузки
  shipment_id serial PRIMARY KEY,
  -- дата отгрузки 
  shipped_at date DEFAULT current_date CHECK(shipped_at <= current_date),
  -- отгружено товара
  shipped_amount int NOT NULL CHECK(shipped_amount > 0)
);

INSERT INTO shipments (shipped_amount)
VALUES (8),
(15);

CREATE TABLE order_to_shipment (
  order_id int REFERENCES orders(order_id),
  shipment_id int REFERENCES shipments(shipment_id),
  PRIMARY KEY (order_id, shipment_id)
); 

INSERT INTO order_to_shipment (order_id, shipment_id)
VALUES (1, 1),
(2,2);

SELECT *
FROM shipments AS ship
  JOIN order_to_shipment AS ots ON ots.shipment_id = ship.shipment_id
  JOIN orders AS o USING(order_id)
  JOIN contracts as contr USING(contract_id)
  JOIN customers as cust ON cust.customer_id = contr.recipient_id
WHERE ship.shipment_id = 1