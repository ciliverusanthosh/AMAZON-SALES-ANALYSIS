use new_schema;
select * from amazon;

alter table amazon
add column timeofday varchar(10);

update amazon 
set timeofday = 
case
    when time between "06:00:00" and "12:00:00" then "morning"
    when time between "12:01:00" and "16:00:00" then "afternoon"
    else "evening"
end;

alter table amazon
add column dayname varchar(20);
update amazon
set dayname = DAYNAME(date);


alter table amazon
add column monthname varchar(10);
update amazon
set monthname = 
case
    when month(date) = 1 then "jan"
    when month(date) = 2 then "feb"
    when month(date) = 3 then "mar"
    when month(date) = 4 then "apr"
    when month(date) = 5 then "may"
    when month(date) = 6 then "jun"
    when month(date) = 7 then "jul"
    when month(date) = 8 then "aug"
    when month(date) = 9 then "sep"
    when month(date) = 10 then "oct"
    when month(date) = 11 then "nov"
    else "dec"
end;

-- business questions
-- 1.What is the count of distinct cities in the dataset?
select count(distinct city) from amazon;
 # 3
 
-- 2.For each branch, what is the corresponding city?
select distinct Branch,City from amazon;
# A  = Yangon
# C = Naypyitaw
# B = mandalay

-- 3.What is the count of distinct product lines in the dataset?
select count(distinct `Product line`) from amazon;
# 6

-- 4.Which payment method occurs most frequently?

select Payment,count(*) as frequency from amazon
Group by payment
order by frequency desc
limit 1;
# E wallet 345

-- 5.Which product line has the highest sales?
select `Product line`,count(Total) from amazon
group by `Product line`
order by count(Total) desc
limit 1;
# Fashion accesories = 178

-- 6.How much revenue is generated each month?
select monthname,sum(total) from amazon
group by monthname
order by sum(total) desc;

-- 7.In which month did the cost of goods sold reach its peak?
select monthname, sum(cogs) from amazon
group by monthname
order by sum(cogs) desc
limit 1;
# january

-- 8.Which product line generated the highest revenue?
select `Product line`,round(sum(Total),2) as revenue from amazon
group by `Product line`
order by revenue desc
limit 1;

# Food and Bevarages - 56144.84

-- 9.In which city was the highest revenue recorded?
select City, round(sum(Total),2) as revenue from amazon
group by City
order by revenue desc
limit 1;

# Naypitaw - 110568.71

-- 10.Which product line incurred the highest Value Added Tax?
select `Product line`,round(sum(`Tax 5%`),2) as tax from amazon
group by `Product line`
order by tax desc
limit 1;

# Food and Bevarages  - 2673.56

-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

alter table amazon
add column remark varchar(20);

update amazon 
set remark = 
  case
      when total >= (select avg(g.total) from (select total from amazon) as g) then 'good'
      else 'bad'
  end;
  
select distinct(`Product line`),remark from amazon;

-- 12.Identify the branch that exceeded the average number of products sold.
select Branch,sum(Quantity) from amazon
group by Branch 
having sum(Quantity)> (select avg(Quantity) from amazon)
order by sum(quantity) desc
limit 1;

-- 13.Which product line is most frequently associated with each gender?
SELECT Gender, `Product line`, COUNT(*) AS frequency
FROM amazon
GROUP BY Gender, `Product line`
ORDER BY frequency DESC;

-- 14.Calculate the average rating for each product line.
select `Product line` as p, avg(Rating) from amazon
group by p
order by avg(Rating) desc;
-- 15.Count the sales occurrences for each time of day on every weekday.
select timeofday,dayname,count(Quantity) q from amazon
where dayname like 'monday' 
group by timeofday,dayname
order by q desc;
-- 16.Identify the customer type contributing the highest revenue.
select `Customer type` as ct,sum(Total) from amazon
group by ct
order by sum(Total) desc
limit 1;

-- 17.Determine the city with the highest VAT percentage.
select City, round(sum(`Tax 5%`),2) as vat from amazon
group by City
order by vat desc
limit 1;

-- 18.Identify the customer type with the highest VAT payments.
select `Customer type` as ct,avg(`Tax 5%`) as vat from amazon
group by ct
order by vat;

-- 19.What is the count of distinct customer types in the dataset?
select distinct `Customer type` ct,count(*) as c from amazon
group by ct;

-- 20. What is the count of distinct payment methods in the dataset?
select payment,count(*) c from amazon
group by payment;

-- 21.Which customer type occurs most frequently?
select distinct `Customer type`,count(*)as frequency from amazon
group by `Customer type`
order by frequency desc;


-- 22.Identify the customer type with the highest purchase frequency.
select `Customer type`,round(sum(Total),2) as purchase_frequency from amazon
group by `Customer type`
order by purchase_frequency desc;


-- 23.Determine the predominant gender among customers.
SELECT `Customer type`,Gender, COUNT(*) AS frequency
FROM amazon
GROUP BY `customer type`,Gender
ORDER BY frequency DESC;

-- 24.Examine the distribution of genders within each branch.

SELECT Branch, Gender, COUNT(*) AS frequency
FROM amazon
GROUP BY Branch, Gender
ORDER BY Branch, frequency DESC;

-- 25.Identify the time of day when customers provide the most ratings.
select timeofday,count(Rating) as rating_count from amazon
group by timeofday
order by rating_count desc;

-- 26.Determine the time of day with the highest customer ratings for each branch.
select Branch,timeofday,count(Rating) as rating_count from amazon
group by Branch,timeofday
order by Branch,rating_count desc;

-- 27.Identify the day of the week with the highest average ratings.
select dayname,round(avg(Rating),2) as rating_average from amazon
group by dayname
order by rating_average desc
limit 1;

-- 28.Determine the day of the week with the highest average ratings for each branch.
select Branch,dayname,avg(Rating) as avg_rating from amazon
group by Branch,dayname
order by Branch,avg_rating desc;

