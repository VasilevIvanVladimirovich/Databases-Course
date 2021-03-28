select *
from customers;

select distinct country
from customers
order by country;

select FirstName,
       LastName     
from customers
where country = 'Brazil'
order by lastname;

select city
from customers
where PostalCode = 11230;

select FirstName,
       LastName,
       Email
from customers
where Email like '%gmail.%';


select FirstName,
       LastName,
       Company
from customers
where company like '_%'
order by Company;

select FirstName,
       LastName,
       city,
       Country
from customers
where Country not in ('Brazil','Canada','USA','Australia', 'Argentina', 'Chile', 'India')
order by country, city,LastName;

/*
Используя таблицу customers из БД chinook, выполните следующие запросы.
1) Из каких стран покупатели? Выведите список стран без повторений в алфавитном порядке.
2) Выведите покупателей из Бразилии. Указать имя и фамилию. Отсортировать по фамилии.
3) У какого города почтовый индекс 11230?
4) Выведите всех покупателей с почтой gmail. Указать имя, фамилию и почту.
5) Выведите имя, фамилию и компанию корпоративных покупателей, отсортированных по наименованию компании.
6) Выведите имя, фамилию, город и страну всех европейских покупателей. Отсортируйте по стране, внутри - по городу, внутри города - по фамилии.
*/