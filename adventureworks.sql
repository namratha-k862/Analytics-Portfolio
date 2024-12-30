create database adventureworks;
use adventureworks;

select * from factinternetsalesnew limit 5;
select * from factinternetsales limit 5;

alter table factinternetsalesnew change column `ï»¿ProductKey` ProductKey int;
alter table factinternetsales change column `ï»¿ProductKey` ProductKey int;
alter table Sales add SalesID int not null AUTO_INCREMENT primary key;

#union
create table sales as
select * from FactInternetSales
union 
select * from FactInternetSalesNew;

select *
from sales;

select *
from products;

alter table products change column `ï»¿ProductKey` ProductKey int;

# lookup product name
select s.salesID, s.ProductKey, p.ProductName, s.OrderQuantity, s.SalesAmount
from Sales s
left join Products p on s.ProductKey = p.ProductKey
where s.ProductKey = 214;

# customer full name
select s.SalesID,s.ProductKey, p.UnitPrice, s.CustomerKey, 
CONCAT(c.FirstName, ' ', IFNULL(c.MiddleName, ''), ' ', c.LastName) as CustomerFullName,s.OrderQuantity,s.SalesAmount
from Sales s
join Customers c on s.CustomerKey = c.CustomerKey
join Products p on s.ProductKey = p.ProductKey;

describe sales;
describe products;

# sales amount
select s.SalesID,s.ProductKey,s.UnitPrice,s.OrderQuantity,s.Discountamount,
    (s.UnitPrice * s.OrderQuantity) * (1 - s.Discountamount) as Sales_Amount
from Sales s;

#production cost
select s.SalesID,s.ProductKey,p.StandardCost,                      
CAST(p.StandardCost as decimal(10, 2)) as UnitCost,s.OrderQuantity,
(CAST(p.StandardCost as decimal(10, 2)) * s.OrderQuantity) as ProductionCost
from Sales s
join  Products p on s.ProductKey = p.ProductKey;

# sales revenue
select s.SalesID,s.ProductKey,s.UnitPrice,s.OrderQuantity,
(s.UnitPrice * s.OrderQuantity) as SalesRevenue
from Sales s;

#profit
select s.SalesID,s.ProductKey,s.UnitPrice, p.StandardCost,s.OrderQuantity,
CAST(p.StandardCost as decimal(10, 2)) * s.OrderQuantity as ProductionCost,
(s.UnitPrice * s.OrderQuantity) as SalesRevenue,
ROUND((s.UnitPrice * s.OrderQuantity) - (CAST(p.StandardCost as decimal(10, 2)) * s.OrderQuantity), 2) as Profit 
from Sales s
join Products p on s.ProductKey = p.ProductKey;

# total sales
select SUM(SalesAmount) as TotalSales
from Sales;

# total quantity sold
select SUM(OrderQuantity) as TotalQuantitySold
from Sales;

select s.ProductKey, p.ProductName, SUM(s.OrderQuantity) AS TotalQuantitySold, SUM(s.SalesAmount) AS TotalSalesAmount
from Sales s
join Products p 
on s.ProductKey = p.ProductKey
group by s.ProductKey, p.ProductName;

# top 5 best selling products
select p.ProductName, SUM(s.SalesAmount) AS TotalSales
from Sales s
join Products p 
on s.ProductKey = p.ProductKey
group by p.ProductName
order by TotalSales desc
limit 5;

# lest 5 selling products
select p.ProductName, SUM(s.OrderQuantity) AS TotalQuantitySold
from Sales s
join Products p 
on s.ProductKey = p.ProductKey
group by p.ProductName
order by TotalQuantitySold asc
limit 5;

#sales per year
select year(OrderDateKey) as Year, SUM(SalesAmount) as TotalSales
from Sales
group by YEAR(OrderDateKey)
order by Year;

# monthly sales
select YEAR(OrderDateKey) as Year, MONTH(OrderDateKey) as Month, SUM(SalesAmount) as TotalSales
from Sales
group by YEAR(OrderDateKey), MONTH(OrderDateKey)
order by Year, Month;

#sales by customer
select CustomerKey, SUM(SalesAmount) as TotalSales
from Sales
group by CustomerKey
order by TotalSales desc;

# top 10 customers
select CustomerKey, SUM(SalesAmount) as TotalSales
from Sales
group by CustomerKey
order by TotalSales desc
limit 10;

# average order value
select round(AVG(SalesAmount),2) as AverageOrderValue
from Sales;

#Percentage Contribution of Each Product to Total Sales
select p.ProductName, SUM(s.SalesAmount) AS TotalSales, 
round((SUM(s.SalesAmount) / (select SUM(SalesAmount) from Sales) * 100),2) as SalesPercentage
from Sales s
join Products p 
on s.ProductKey = p.ProductKey
group by p.ProductName
order by TotalSales desc;

# top 3 products for year
select YEAR(s.OrderDateKey) as Year, p.ProductName, 
SUM(s.SalesAmount) as TotalSales
from Sales s
join Products p 
on s.ProductKey = p.ProductKey
group by YEAR(s.OrderDateKey), p.ProductName
order by Year, TotalSales desc
limit 3;

