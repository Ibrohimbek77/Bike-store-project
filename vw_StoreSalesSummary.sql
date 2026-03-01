--• vw_StoreSalesSummary: Revenue, #Orders, AOV per store

CREATE VIEW vw_StoreSalesSummary AS
WITH OrdersQuantityPerStore AS(
    SELECT 
        store_id,
        COUNT(order_id) AS [#Orders]
    FROM Orders
    GROUP BY store_id
), TotalRevenuePerStore AS(
    SELECT 
        S.store_id,
        S.store_name,
        SUM(quantity * list_price) AS Revenue
    FROM Stores AS S
    JOIN Orders AS O
        ON S.store_id = O.store_id
    JOIN Order_items AS OI
        ON O.order_id = OI.order_id
    GROUP BY S.store_id, S.store_name
)
SELECT 
    T.store_id,
    T.store_name,
    T.Revenue,
    P.[#Orders],
    (T.Revenue / P.[#Orders]) AS AOV
FROM TotalRevenuePerStore T
JOIN OrdersQuantityPerStore AS P
    ON T.store_id = P.store_id


-- No cat gpt used! But had to know what #orders and AOV mean through it!



