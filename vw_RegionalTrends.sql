--• vw_RegionalTrends: Revenue by city or region

CREATE VIEW vw_RegionalTrends AS
SELECT 
    s.city,
    s.state,
    SUM(oi.quantity * oi.list_price * (1 - ISNULL(oi.discount, 0))) AS total_revenue
FROM Orders o
JOIN Stores s 
    ON o.store_id = s.store_id
JOIN Order_items oi 
    ON o.order_id = oi.order_id
GROUP BY s.city, s.state;



