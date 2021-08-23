--Составьте сводную таблицу и выведите среднюю сумму инвестиций для каждой страны за 2011, 2012 и 2013 годы. Данные за каждый год должны быть в отдельном поле. Отсортируйте таблицу по среднему значению инвестиций за 2011 год от большего к меньшему.

WITH 

t2011 as
(SELECT country_code as cc, 
    AVG(funding_total) as money
FROM company
WHERE EXTRACT (YEAR from founded_at) = 2011
GROUP BY country_code),

t2012 as
(SELECT country_code as cc, 
    AVG(funding_total) as money
FROM company
WHERE EXTRACT (YEAR from founded_at) = 2012
GROUP BY country_code),

t2013 as
(SELECT country_code as cc, 
    AVG(funding_total) as money
FROM company
WHERE EXTRACT (YEAR from founded_at) = 2013
GROUP BY country_code)

SELECT t2011.cc, 
    t2011.money as year_2011,
    t2012.money as year_2012,
    t2013.money as year_2013
    
FROM t2011

INNER JOIN t2012 on t2011.cc=t2012.cc
INNER JOIN t2013 on t2011.cc=t2013.cc

ORDER BY  year_2011 DESC
;

--Для каждого месяца с 2010 по 2013 год найдите количество уникальных фондов, зарегистрированных в США.
--Получите таблицу, в которой будут следующие поля: - номер месяца; - количество уникальных фондов из США; - количество купленных компаний; - общая сумма сделок за месяц.

With fr as(
select count(Distinct f.name)as name,
Extract(month from cast (funded_at as date))as month
from funding_round As fr


Left join investment as i on fr.id=i.funding_round_id
Left join fund as f on i.fund_id = f.id

WHERE EXTRACT(YEAR FROM funded_at) BETWEEN 2010 AND 2013 and country_code = 'USA'
Group by month
order by month)  ,

   A as(SELECT
              Count(acquired_company_id) as count,
              sum(price_amount) as price,
              Extract(month from cast(acquired_at as date)) as month
              FROM acquisition
        WHERE EXTRACT(YEAR FROM acquired_at) BETWEEN 2010 AND 2013
        Group by month
        Order by month) 
        Select  fr.month,name,count,price From fr left join a on fr.month=a.month
        
