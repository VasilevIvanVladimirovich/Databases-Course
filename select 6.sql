/*  Задание
    1) Для каждого потребителя найдите темп прироста его покупок (в долларах) по годам. 
    Темп прироста (в %) = 100*(покупки в текущем году - покупки в прошлом году)/покупки в прошлом году.
    2) Для каждой страны укажите список покупателей, сумму покупок (в рублях по курсу) 
    и фамилию покупателя, который совершил покупки на максимальную сумму.
*/
select distinct firstname,
                lastname,
                invoicedate
--sum(total)  over (partition by invoicedate ) As деньги
from customers inner join invoices using(customerid)   
order by firstname and invoicedate;