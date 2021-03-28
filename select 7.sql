/*  Задание
    1) Для каждого потребителя найдите темп прироста его покупок (в долларах) по годам. 
    Темп прироста (в %) = 100*(покупки в текущем году - покупки в прошлом году)/покупки в прошлом году.
    2) Для каждой страны укажите список покупателей, сумму покупок (в рублях по курсу) 
    и фамилию покупателя, который совершил покупки на максимальную сумму.
*/
--№1----------------------------------
SELECT DISTINCT Customerid,
                NameCustomers,
                Year,
                Sum_total,
               COALESCE( round(100 * (Sum_total - LAG(Sum_total) OVER(partition by Customerid order by year)) / LAG(Sum_total) OVER(partition by Customerid order by year)    ,2), 'Firs year, not increase') AS increase        --/ (lag(Sum_total) OVER(order by Sum_total),2) 
FROM (
        SELECT DISTINCT Customerid,NameCustomers,Year,SUM(Total) OVER(PARTITION BY customerid, rank  ORDER BY year) AS Sum_total
        FROM (
            SELECT DISTINCT Customerid,customers.FirstName || " " || customers.LastName AS NameCustomers, strftime('%Y',InvoiceDate) AS Year,Total, DENSE_rank() OVER(PARTITION BY Customerid ORDER BY  strftime('%Y',InvoiceDate))  AS rank
            FROM invoices
            JOIN customers USING (CustomerId)
            )
    );

--№2---------------------------------
SELECT  distinct BillingCountry,
                GROUP_CONCAT(FirstName|| " "|| LastName) OVER(partition by BillingCountry order by BillingCountry) AS NameCustomers,
                round( SUM(Total_rub) over(partition by BillingCountry order by BillingCountry),2) AS max_rub,
                LAST_VALUE(LastName) over(order by BillingCountry) AS Last_name
FROM (
    SELECT distinct BillingCountry, FirstName, LastName,round(SUM(total) over(partition by firstname order by FirstName),2) AS Total_Rub
    FROM invoices
    JOIN customers USING(CustomerId)
    order by billingCountry, Total_Rub asc
    );
    
-------------------------------------
