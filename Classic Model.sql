-- Use classicmodels;

-- Q1(a)
SELECT employeenumber, firstname, lastname
FROM employees
WHERE jobtitle = 'Sales Rep'AND reportsTo = 1102;

-- Q1(b)
SELECT DISTINCT productline
FROM products
WHERE productline LIKE '%cars';

-- Q2
SELECT 
    customerNumber,customerName,
    CASE
        WHEN country IN ('USA', 'Canada') THEN 'North America'
        WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment
FROM customers;

-- Q3(a)
SELECT productCode, SUM(quantityOrdered) AS totalQuantity
FROM OrderDetails
GROUP BY productCode
ORDER BY totalQuantity DESC
LIMIT 10;

-- Q3(b)
SELECT 
    MONTHNAME(paymentDate) AS payment_month, 
    COUNT(paymentDate) AS num_payment
FROM Payments
GROUP BY monthname(paymentDate)
HAVING num_payment > 20
ORDER BY num_payment DESC;

-- Q4(a)
Create database Customers_Orders;
use Customers_Orders;

CREATE TABLE Customer 
(customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20));
    
-- Q4(b)
CREATE TABLE Orders
(order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount > 0));
    
-- Q5
use classicmodels;
select count(o.ordernumber) as order_count,c.country 
from orders as o 
join customers as c
on o.customernumber=c.customernumber
group by c. country order by order_count desc
limit 5;     
    
-- Q6
CREATE TABLE Project
 (EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female'),
    ManagerID INT);
    INSERT INTO Project (FullName,Gender,ManagerID)
    VALUES("Pranaya","Male",3),
    ("Priyanka","Female",1),
    ("Preety","Female",null),
    ("Anurag","Male",1),
    ("Sambit","Male",1),
    ("Rajesh","Male",3),
    ("Hina","Female",3);
SELECT p1.FullName AS "Manager Name", p2.FullName AS "Emp Name" 
FROM Project p1 
JOIN Project p2 ON p1.EmployeeID = p2.ManagerID;

-- Q7
CREATE TABLE facility
(Facility_ID INT, Name VARCHAR(255),State VARCHAR(255),Country VARCHAR(255));
ALTER TABLE facility
MODIFY Facility_ID INT AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE facility
ADD City VARCHAR(255) NOT NULL AFTER Name;

-- Q8
CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    Products p
JOIN 
    ProductLines pl ON p.productLine = pl.productLine
JOIN 
    OrderDetails od ON p.productCode = od.productCode
JOIN 
    Orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;
select * from product_category_sales;

-- Q9
DELIMITER $$

CREATE PROCEDURE Get_country_payments(IN input_year INT, IN input_country VARCHAR(50))
BEGIN
    SELECT 
        input_year AS Year,
        input_country AS Country,
        CONCAT(FORMAT(SUM(p.amount) / 1000, 0), 'K') AS total_amount
    FROM 
        Customers c
    JOIN 
        Payments p ON c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentDate) = input_year
        AND c.country = input_country
    GROUP BY 
        YEAR(p.paymentDate), c.country;
END$$

DELIMITER ;

SHOW CREATE PROCEDURE Get_country_payments;
CALL Get_country_payments(2003, 'FRANCE');

-- Q10
select customername,
 count(ordernumber) as order_count,
dense_rank() over( ORDER BY COUNT(orders.orderNumber) DESC) AS"order_frequency_rank" 
 from customers
 join 
 orders on customers.customerNumber=orders.customerNumber
 group by 
 customers.customerNumber,customers.customerName
ORDER BY 
   order_count desc;
   
   
-- Q10(b)
WITH X AS (
   SELECT 
      year(orderdate) AS Year, 
      monthname(orderdate) AS Month, 
      count(orderdate) AS Total_orders 
   FROM Orders 
   GROUP BY Year, Month
)
SELECT 
   Year, 
   Month, 
   Total_orders AS TotalOrders,
   CONCAT(
      ROUND(
         100 * ((Total_orders - LAG(Total_orders) OVER (ORDER BY Year)) 
         / LAG(Total_orders) OVER (ORDER BY Year)), 0), 
      "%"
   ) AS `YoY_Changes`
FROM X;

-- Q11
SELECT productLine, COUNT(*) AS ProductLineCount
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine 
order by productLinecount desc;

-- Q12
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY AUTO_INCREMENT,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

DELIMITER //

-- Q12

CREATE PROCEDURE InsertIntoEmp_EH(
    IN emp_id INT,
    IN emp_name VARCHAR(100),
    IN email_address VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle the error
        SELECT 'Error occurred' AS ErrorMessage;
        -- Rollback the transaction if needed
        ROLLBACK;
    END;

    -- Start a transaction
    START TRANSACTION;

    -- Insert the values into the Emp_EH table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (emp_id, emp_name, email_address);

    -- Commit the transaction if no errors occurred
    COMMIT;

    -- Optionally, return a success message
    SELECT 'Insert successful' AS SuccessMessage;
END //

DELIMITER ;

CALL InsertIntoEmp_EH(1, 'John Doe', 'john.doe@example.com');

CALL InsertIntoEmp_EH(1, 'tom','john.doe@example.com');

CALL InsertIntoEmp_EH(1, 'null','marchin@gmail.com');

-- Q13
CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);


DELIMITER //

CREATE TRIGGER before_insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END //

DELIMITER ;

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) 
VALUES ('Alice', 'Scientist', '2020-10-05', -8);
SELECT * FROM Emp_BIT;
