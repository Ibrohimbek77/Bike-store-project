--• vw_TopSellingProducts: Rank products by total sales

CREATE VIEW vw_TopSellingProducts AS
SELECT 
    P.product_id,
    P.product_name,
    SUM((OI.quantity * OI.list_price) * (1 - discount)) AS TotalSales,
    ROW_NUMBER() OVER(ORDER BY SUM((OI.quantity * OI.list_price) - (OI.quantity * OI.list_price) * discount) DESC) AS Rating
FROM Order_items OI
JOIN Products AS P
    ON OI.product_id = P.product_id
GROUP BY P.product_id, P.product_name



