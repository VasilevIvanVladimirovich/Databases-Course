/* Задание. Имеется таблица со списком товаров:
   Product (id_product, price, quantity),
   таблица заказов:
   Order (id_order, id_product, total),
   где total - сумма заказа (в рублях),
   и таблица со счетами:
   Invoice (id_order, id_product, num_order, sum_order, return, date),
   где num_order - количество покупаемого товара,
   sum_order - на какую сумму товар покупается,
   return - остаток (total - price * num_order)
   В заказе только один товар.
   При поступлении заказа делаем запись в таблице Order.
   В таблице Product уменьшаем поле quantity на максимальное количество
   товара, которое можно продать на сумму заказа. 
   В таблицу Invoice записываем все данные о заказе. 
*/


CREATE TABLE Product (           
            id_product INTEGER PRIMARY KEY AUTOINCREMENT,
            price NUMERIC NOT NULL, 
            quantity INTEGER NOT NULL DEFAULT 0
            );

INSERT INTO Product(price,quantity)
VALUES 
(50,10),
(100,15),
(150,20),
(200,25),
(250,30);

CREATE TABLE orders (
                    id_order INTEGER PRIMARY KEY AUTOINCREMENT, 
                    id_product INTEGER,
                    total NUMERIC NOT NULL,
                    
                    FOREIGN KEY  (id_product) REFERENCES Product(id_product)
                    );
        
CREATE TABLE Invoice (
                        id_order INTEGER , 
                        id_product INTEGER, 
                        num_order NUMERIC NOT NULL, 
                        sum_order NUMERIC NOT NULL, 
                        return NUMERIC NOT NULL, 
                        date data NOT NULL,
            
                       FOREIGN KEY (id_order) REFERENCES orders(id_order),
                       FOREIGN KEY (id_product) REFERENCES Product(id_product) 
                        
                    );
--TRANSACTION-----------------------------------------------------------------------------------
BEGIN TRANSACTION;

INSERT INTO orders (id_product, total)
VALUES
(3,5555);

INSERT INTO Invoice 
VALUES
( (SELECT LAST_VALUE(id_order) OVER() FROM orders),     --id_order

  (SELECT LAST_VALUE(id_product) OVER() FROM orders), --id_product
  
  (SELECT  CASE                                                              --num_order
              WHEN (quantity - (LAST_VALUE(total) OVER()) / price) >= 0 THEN  (LAST_VALUE(total) OVER())/price
              ELSE quantity
           END  
    FROM orders 
    JOIN Product USING (id_product)
    WHERE Product.id_product = (SELECT LAST_VALUE(id_product) OVER() FROM orders)) ,
    
  (SELECT CASE                                                               --sum_order
            WHEN quantity - (LAST_VALUE(total) OVER())/price >=0 THEN ROUND((LAST_VALUE(total) OVER())/price) * price
            ELSE (LAST_VALUE(total) OVER()) - price * (-quantity + (LAST_VALUE(total) OVER())/price) - LAST_VALUE(total) OVER() % price
          END
    FROM orders 
    JOIN Product USING(id_product) 
    WHERE Product.id_product =  (SELECT LAST_VALUE(id_product) OVER() FROM orders)), 
    
    (SELECT LAST_VALUE(total) over() - (SELECT CASE                                                               
                                                WHEN quantity - (LAST_VALUE(total) OVER())/price >=0 THEN ROUND((LAST_VALUE(total) OVER())/price) * price
                                                ELSE (LAST_VALUE(total) OVER()) - price * (-quantity + (LAST_VALUE(total) OVER())/price) - LAST_VALUE(total) OVER() % price
                                                END
                                        FROM orders 
                                        JOIN Product USING(id_product) 
                                        WHERE Product.id_product =  (SELECT LAST_VALUE(id_product) OVER() FROM orders)) 
    FROM Product
    JOIN orders USING(id_product)), 
    datetime('now'));

UPDATE Product
SET quantity = quantity - orders.total/Product.price
FROM orders 
WHERE Product.id_product =  (SELECT LAST_VALUE(id_product) OVER() FROM orders);

UPDATE Product
SET quantity = 0
WHERE quantity < 0;

COMMIT;
--TRANSACTION-----------------------------------------------------------------------------------


SELECT * FROM Invoice;
SELECT * FROM orders;
SELECT * FROM product;

DROP TABLE Invoice;
DROP TABLE orders;
DROP TABLE product;
