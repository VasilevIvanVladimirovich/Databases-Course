select *
from customers;

select country,
count(country)
from customers
group by country;

select country,
       group_concat(city)     
from customers
group by country
having count(city)>1;

select count(state)
from customers;

select country,
       count(state)
from customers
group by country
having count(state)>0
order by count(state) asc;


select count(*),
       count(*)-count(company)
from customers;
        
