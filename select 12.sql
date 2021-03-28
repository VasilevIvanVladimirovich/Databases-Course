/* Постройте SCD2 версионную таблицу баланса на счете (таблица cash).
   Результат должен быть такой:
------------------------------------
Баланс	Effective_from	Effective_to
------------------------------------
0	1900-01-01	2019-12-31
1000	2020-01-01	2020-02-13
800	2020-02-14	2020-02-22
500	2020-02-23	2020-03-06
1200	2020-03-07	2020-03-19
700	2020-03-20	2999-01-01
*/

DROP TABLE cash;

CREATE TABLE cash (
    dt     DATETIME, 
    value  NUMERIC (10, 2)
);

INSERT INTO cash (dt, value)
VALUES   ('2020-01-01', 1000),
         ('2020-02-14', -200),         
         ('2020-02-23', -300),
         ('2020-03-07', 700),       
         ('2020-03-20', -500);
         
SELECT  dt Дата,
        value Сумма
FROM cash;

--№1----------------------------------------------------------------------------
SELECT  (SELECT SUM(value) FROM cash cash1 WHERE cash1.dt <= cash2.dt) balance,
        dt AS Effective_from,
        coalesce (lead(strftime('%Y-%m-%d', dt, '-1 days')) over(), '2999-12-31') Effective_to
FROM cash cash2
UNION 
SELECT DISTINCT '0' AS balance, '1900-01-01', strftime('%Y-%m-%d', FIRST_VALUE(dt) OVER(), '-1 days')
FROM cash
GROUP BY dt
ORDER BY Effective_from;
-----------------------------------------------------------------------------------------
