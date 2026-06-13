create database project;
use project;
-- Change Text data to Varchar

Alter table customers modify column CustomerID varchar(50);
Alter table order_details modify column OrderID varchar(50);
Alter table order_details modify column ProductID varchar(50);
Alter table orders modify column OrderID varchar(50);
Alter table orders modify column CustomerID varchar(50);
Alter table products modify column ProductID varchar(50);
Alter table products modify column SupplierID varchar(50);
Alter table reviews modify column ReviewID varchar(50);
Alter table reviews modify column ProductID varchar(50);
Alter table reviews modify column CustomerID varchar(50);
Alter table suppliers modify column SupplierId varchar(50);

-- Task 2 Identify the PK & FK

Alter table customers add constraint new_constraint primary key(CustomerID);
Alter table orders add constraint New_constraint primary key orders(OrderID);
Alter table products add constraint New_constraint primary key products(ProductID);
Alter table reviews add constraint New_constraint  primary key reviews(ReviewID);
Alter table suppliers add constraint New_constraint primary key suppliers(SupplierID);

-- Foriegn Key Apply

Alter table order_details add constraint fk_order foreign key (OrderID) references orders(OrderID);
Alter table order_details  add constraint fk_products foreign key (ProductID) references products(ProductID);
Alter table orders add constraint fk_customers foreign key (CustomerID) references customers(CustomerID);
Alter table reviews add constraint fk_product foreign key (ProductID) references products(ProductID);
Alter table reviews add constraint fk_customer  foreign key (CustomerID) references customers(CustomerID);

-- INSERT VALUES--

Insert into suppliers(SupplierID)
select distinct SupplierID
from products
where SupplierID not in (select SupplierID from  suppliers);

Alter table suppliers
Modify SupplierID Varchar(50);

Alter table products
Modify SupplierID Varchar(50);

alter table products
add constraint fk_suppliers foreign key (SupplierID) references suppliers(SupplierID);

-- Task 3: Write a query to Retrieve all customers from a specific city.
select * from customers;
select * from customers where City = "West Daniel";
-- category=friut
select * from products;
select ProductName , Category ,Priceperunit,StockQuantity  from products where Category = "Fruits";

-- Task 4: Write DDL statements to recreate the Customers table with the following constraints

--  CustomerID as the primary key. 
Alter table Customers
Add constraint New_constraint primary key (CustomerID);

--  Ensure Age cannot be null and must be greater than 18.

Alter table customers
modify column age int not null;

Select * From customers
Where Age <= 18;

SET SQL_SAFE_UPDATES = 0;

Update customers
Set Age = 19 Where Age <= 18;

-- Add a unique constraint for Name.

Alter table customers modify Name varchar(100);

update customers
set Name = CONCAT(Name, '_', CustomerID)
WHERE Name IN (
    SELECT Name FROM (
        SELECT Name
        FROM customers
        GROUP BY Name
        HAVING COUNT(*) > 1
    ) AS temp
);

Alter table customers
Add constraint unique_name UNIQUE (Name);

-- Data Manipulation Language (DML)
-- Task 5: Insert 3 new rows into the Products table using INSERT statement

SELECT * FROM suppliers;

INSERT INTO suppliers (SupplierID)
VALUES 
('jhvcjq762-hjabjc-23rfcqa32-sedvaqwf5'),
('afbh12-324bjkwsj-32rfa34r-3rf24trf'),
('vkijbqw34-23rfcwww-q3rdf21-f1qert5');

select * from products;

insert into products
values
('1001','Mobiles','Electronics','Sub-Electronics','45000','25','jhvcjq762-hjabjc-23rfcqa32-sedvaqwf5'),
('1002','Sketch','Stationary','sub-stationary','15','12','afbh12-324bjkwsj-32rfa34r-3rf24trf'),
('1003','Remote_control_car','Toys','Sub-toys','55','19','vkijbqw34-23rfcwww-q3rdf21-f1qert5');

select * from products where ProductID=1001;

-- Task 6: Update the stock quantity of a product where ProductID matches a specific ID. 

Update products
set StockQuantity = '75' where ProductID = '1003';

select * from products where ProductID=1003;

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific value.
select City from suppliers;
delete from suppliers where City = "Jeffreytown";

-- Task 8: Use SQL constraints 
alter table reviews
add constraint CHK_rating check (Rating between 1 and 5) ;

select * from reviews where Rating between 1 and 5 ;

-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No")
alter table customers
modify PrimeMember varchar(10) default 'No';

-- Task 9: Clauses and Aggregations
-- WHERE
select * from orders where OrderDate = 2024-01-01;
select * from orders;
-- HAVING
select p.ProductID , p.ProductName , avg(rating) as AVG_Rating from reviews as r join products as p ON 
r.ProductID = p.ProductID group by p.ProductID , p.ProductName having avg_rating > 4;
-- GROUP BY and ORDER BY
select ProductID , ProductName , sum(PricePerUnit*StockQuantity) as Total_Sales from products
group by ProductID, ProductName order by Total_Sales ;
 
select p.ProductID , p.ProductName , sum(PricePerUnit * StockQuantity) as Total_Sales from products as p
join order_details as o ON o.ProductID = p.ProductID group by p.ProductID , p.ProductName order by Total_Sales;

-- Task 10
-- Calculate each customer's total spending. 
SELECT c.CustomerID, c.Name, SUM(od.Quantity * od.UnitPrice) AS Total_Spending
FROM customers as c
JOIN orders as o ON c.CustomerID = o.CustomerID
JOIN order_details as od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Spending ;

-- Rank customers based on their spending. 
SELECT c.CustomerID, c.Name, SUM(od.Quantity * od.UnitPrice) AS Total_Spending,
    RANK() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS Rank_Position
FROM customers AS c
JOIN orders AS o ON c.CustomerID = o.CustomerID
JOIN order_details AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Spending DESC;

-- Identify customers who have spent more than ₹5,000.
select c.customerid, c.name, sum(od.quantity * od.unitprice) as total_spending
from customers as c
join orders as o on c.customerid = o.customerid
join order_details as od on o.orderid = od.orderid
group by c.customerid, c.name
having sum(od.quantity * od.unitprice) > 5000
order by total_spending desc; 

-- Task:11 Complex Aggregations and Joins 
-- Join the Orders and OrderDetails tables to calculate total revenue per order. 
select 
    o.orderid,
    sum(od.Quantity * od.UnitPrice) as total_revenue
from orders as o
join order_details as od on o.orderid = od.orderid
group by o.orderid
order by total_revenue desc;

--  Identify customers who placed the most orders in a specific time period. 

select c.customerid,c.name,count(o.orderid) as total_orders
from customers as c
join orders as o on c.customerid = o.customerid
where o.orderdate between '2025-01-01' and '2025-06-30'
group by c.customerid, c.name
order by total_orders desc;

-- Find the supplier with the most products in stock. 

select 
    s.SupplierID,
    s.SupplierName,
    sum(p.StockQuantity) as total_stock
from suppliers as s
join products as p on s.SupplierID = p.SupplierID
group by s.SupplierID, s.SupplierName
order by total_stock desc
limit 1;

select * from suppliers where SupplierID='5f23af2b-90e2-45a7-b4d6-f02d3fbf2ab0';

-- Task:12 Normalization
-- Separate product categories and subcategories into a new table. 

Create table categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100),
    SubCategoryName VARCHAR(100)
);

INSERT INTO categories (CategoryName, SubCategoryName)
SELECT DISTINCT Category, SubCategory
FROM products;

select * from categories ;

ALTER TABLE products
ADD CategoryID INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE products p
JOIN categories c 
ON p.Category = c.CategoryName 
AND p.SubCategory = c.SubCategoryName
SET p.CategoryID = c.CategoryID;

select * from categories;

-- Create foreign keys to maintain relationships.

ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (CategoryID)
REFERENCES categories(CategoryID);

-- Task 13:Subqueries and Nested Queries 
--   Identify the top 3 products based on sales revenue

select *
from (select p.ProductID,p.ProductName,sum(od.Quantity * od.UnitPrice) as total_revenue
    from products as p
    join order_details as od on p.ProductID=od.ProductID
    group by p.ProductID, p.ProductName
) as product_revenue
order by total_revenue desc
limit 3;

-- Find customers who haven’t placed any orders yet. 

select customerid,name
from customers
where customerid not in (
    select customerid from orders
);


-- Project END