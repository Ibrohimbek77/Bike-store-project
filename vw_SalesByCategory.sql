--• vw_SalesByCategory: Sales volume and margin by product category

CREATE VIEW vw_SalesByCategory AS
SELECT 
    c.category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - ISNULL(oi.discount, 0))) AS revenue,
    SUM(oi.quantity * oi.list_price) 
        - SUM(oi.quantity * oi.list_price * (1 - ISNULL(oi.discount, 0))) AS discount_loss
FROM Order_items oi
JOIN Products p 
    ON oi.product_id = p.product_id
JOIN Categories c 
    ON p.category_id = c.category_id
GROUP BY c.category_name;

