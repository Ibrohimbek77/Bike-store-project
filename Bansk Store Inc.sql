CREATE DATABASE [Bike store Inc]
GO
USE [Bike store Inc]


-- for logs when loadin csv files

CREATE TABLE Logs_audit (
    Message VARCHAR(200),
    Log_time DATETIME
)





-- Final tables

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) DEFAULT 'Not given',
    phone VARCHAR(20) ,
    email VARCHAR(60) DEFAULT 'Not given',
    street VARCHAR(40) NOT NULL,
    city VARCHAR(40) NOT NULL,
    state VARCHAR(40) NOT NULL,
    zip_code VARCHAR(60) NOT NULL
)



CREATE TABLE Orders(
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    order_status VARCHAR(50) DEFAULT 'Pending',
    order_date DATE,
    required_date DATE NOT NULL,
    shipped_date DATE,
    store_id INT NOT NULL,
    staff_id INT NOT NULL,

    CONSTRAINT FK_Orders_customer_id FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT Fk_Orders_store_id FOREIGN KEY(store_id) REFERENCES Stores(store_id),
    CONSTRAINT FK_Orders_staff_id FOREIGN KEY(staff_id) REFERENCES Staffs(staff_id)
)

CREATE TABLE Staffs(
    staff_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(60) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    active VARCHAR(20) DEFAULT 'Active',
    store_id INT NOT NULL,
    manager_id INT DEFAULT NULL,

    CONSTRAINT FK_Staffs_store_id FOREIGN KEY(store_id) REFERENCES Stores(store_id),
    CONSTRAINT FK_Staffs_manager_id FOREIGN KEY(manager_id) REFERENCES Staffs(staff_id)
)

CREATE TABLE Stores(
    store_id INT PRIMARY KEY IDENTITY(1,1),
    store_name VARCHAR(60) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(60) NOT NULL,
    street VARCHAR(30) NOT NULL,
    city VARCHAR(30) NOT NULL,
    state VARCHAR(30) NOT NULL,
    zip_code VARCHAR(60) NOT NULL
)

CREATE TABLE Order_items(
    item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    list_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(4,2),

    CONSTRAINT FK_Order_items_order_id FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_Order_items_product_id FOREIGN KEY(product_id) REFERENCES Products(product_id)
)

CREATE TABLE categories(
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(60) NOT NULL
)

CREATE TABLE Products(
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(100) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year INT NOT NULL,
    list_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Products_brand_id FOREIGN KEY(brand_id) REFERENCES Brands(brand_id),
    CONSTRAINT FK_Products_category_id FOREIGN KEY(category_id) REFERENCES Categories(category_id)
)

CREATE TABLE Stocks(
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT FK_Stocks_product_id FOREIGN KEY(product_id) REFERENCES Products(product_id),
    CONSTRAINT FK_Stocks_store_id FOREIGN KEY(store_id) REFERENCES Stores(store_id)
)

CREATE TABLE Brands(
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name VARCHAR(60) NOT NULL
)


--customers_staging complete!

INSERT INTO Customers(first_name, last_name, phone, email, street, city, state, zip_code)
SELECT first_name, last_name, phone, email, street, city, state, zip_code FROM customers_staging


SELECT * FROM Customers

-- Customers complete!

--Orders_staging complete!

INSERT INTO Orders(customer_id, order_status,order_date, required_date, shipped_date, store_id, staff_id)
SELECT customer_id, order_status, IIF(order_date LIKE 'NULL', NULL, CAST(order_date AS DATE)), required_date, IIF(shipped_date LIKE 'NULL', NULL, CAST(shipped_date AS DATE)), store_id, staff_id FROM orders_staging


INSERT INTO Orders(order_date)
SELECT IIF(order_date LIKE 'NULL', NULL, CAST(order_date AS DATE)) from orders_staging
-- Orders complete! 

--Products_staging complete!

INSERT INTO Products(product_name, brand_id, category_id, model_year, list_price)
SELECT product_name, brand_id, category_id, model_year, list_price FROM products_staging

--Products complete!

--Staff_staging complete! (manager id is varcahr(50) since 'NULL' values were strings!)

INSERT INTO Staffs(first_name, last_name, email, phone, active, store_id, manager_id)
SELECT first_name, last_name, email, phone, active, store_id, IIF(manager_id LIKE 'NULL', NULL, CAST(manager_id AS INT)) FROM Staffs_staging

--staffs complete!

--Store_staging complete!

INSERT INTO Stores(store_name, phone, email, street, city, state, zip_code)
SELECT store_name, phone, email, street, city, state, zip_code FROM stores_staging

-- Stores complete!

--order_items-staging complete!

INSERT INTO Order_items(order_id, product_id, quantity, list_price, discount)
SELECT order_id, product_id, quantity, list_price, discount FROM Order_items_staging

--Order_items complete!

--stcoks_staging complete!

INSERT INTO Stocks(store_id, product_id, quantity)
SELECT store_id, product_id, quantity FROM stocks_staging

-- stocks complete!

--catgeories_staging complete!

INSERT INTO Categories(category_name)
SELECT category_name FROM categories_staging

--categories complete!

--brands_staging complete!

INSERT INTO Brands(brand_name)
SELECT brand_name FROM brands_staging
--brands complete!






-- My KPIs??? YES!

-- KPI1 The most 3 sold products each month

;
WITH ProductsMostSold AS(
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        P.product_id,
        product_name,
        SUM(quantity) AS TotalSold,
        SUM(quantity * OI.list_price) AS TotalEarned,
        ROW_NUMBER() OVER(PARTITION BY YEAR(order_date), MONTH(order_date)
                          ORDER BY SUM(quantity)) AS Rating
    FROM Orders AS O
    JOIN Order_items AS OI
        ON O.order_id = OI.order_id
    JOIN Products AS P
        ON OI.product_id = P.product_id
    GROUP BY  YEAR(order_date),
              MONTH(order_date),
              P.product_id,
              product_name
)
SELECT * FROM ProductsMostSold
WHERE Rating <= 3
ORDER BY [year], [month]


-- KPI2 the most popular beand each month
-- KPI3 the top3 employees each month
-- KPI4 Products most bought!
-- KPI5 Customers with most money output!
-- KPI6 Customers with most orders 

-- vw_StoreSalesSummary

SELECT * FROM vw_StoreSalesSummary

-- vw_TopSellingProducts

SELECT * FROM vw_TopSellingProducts

--vw_InventoryStatus

SELECT * FROM vw_InventoryStatus

-- vw_StaffPerformance:

SELECT * FROM vw_StaffPerformance:

-- vw_RegionalTrends

SELECT * FROM vw_RegionalTrends

-- vw_SalesByCategory

SELECT * FROM vw_SalesByCategory



-- sp_CalculateStoreKPI: Input store ID, return full KPI breakdown

EXEC sp_CalculateStoreKPI 1--store_id

-- sp_GenerateRestockList: Output low-stock items per store

EXEC sp_GenerateRestockList @store_id = 1, @threshold = 5 --store_id threashhold


-- sp_CompareSalesYearOverYear: Compare sales between two years

EXEC sp_CompareSalesYearOverYear 2016, 2017 

-- sp_GetCustomerProfile: Returns total spend, orders, and most bought items

EXEC sp_GetCustomerProfile @customer_id = 5



--KPI
--Total Revenue

SELECT 
    SUM(oi.quantity * (oi.list_price - oi.discount)) AS Total_Revenue
FROM Order_items oi;

--Average Order Value (AOV)

SELECT 
    SUM(oi.quantity * (oi.list_price - oi.discount)) / COUNT(DISTINCT oi.order_id) AS Average_Order_Value
FROM Order_items oi;

--Inventory Turnover


--Product Return Rate



--Revenue by Store

SELECT 
    s.store_name,
    SUM(oi.quantity * (oi.list_price - oi.discount)) AS Revenue
FROM Orders o
JOIN Stores s 
    ON o.store_id = s.store_id
JOIN Order_items oi 
    ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY Revenue DESC;


--Gross Profit by Category

SELECT 
    c.category_name,
    SUM(oi.quantity * (oi.list_price - oi.discount)) AS Revenue
FROM Order_items oi
JOIN Products p 
    ON oi.product_id = p.product_id
JOIN Categories c 
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Revenue DESC;


--Sales by Brand

SELECT 
    b.brand_name,
    SUM(oi.quantity * (oi.list_price - oi.discount)) AS Revenue
FROM Order_items oi
JOIN Products p 
    ON oi.product_id = p.product_id
JOIN Brands b 
    ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY Revenue DESC;



--Staff Revenue Contribution

SELECT 
    st.first_name + ' ' + st.last_name AS Staff_Name,
    SUM(oi.quantity * (oi.list_price - oi.discount)) AS Staff_Revenue
FROM Orders o
JOIN Staffs st 
    ON o.staff_id = st.staff_id
JOIN Order_items oi 
    ON o.order_id = oi.order_id
GROUP BY st.first_name, st.last_name
ORDER BY Staff_Revenue DESC;




SELECT servicename, status_desc 
FROM sys.dm_server_services;





