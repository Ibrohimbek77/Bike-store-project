-- sp_GetCustomerProfile: Returns total spend, orders, and most bought items




CREATE PROCEDURE sp_GetCustomerProfile
    @customer_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Total spend
    SELECT 
        SUM(oi.quantity * oi.list_price * (1 - ISNULL(oi.discount,0))) AS total_spent
    FROM Orders o
    JOIN Order_items oi ON oi.order_id = o.order_id
    WHERE o.customer_id = @customer_id;

    -- Total orders
    SELECT COUNT(*) AS total_orders
    FROM Orders
    WHERE customer_id = @customer_id;

    -- Most bought product(s)
    SELECT TOP 5
        p.product_name,
        SUM(oi.quantity) AS total_quantity
    FROM Orders o
    JOIN Order_items oi ON o.order_id = oi.order_id
    JOIN Products p ON p.product_id = oi.product_id
    WHERE o.customer_id = @customer_id
    GROUP BY p.product_name
    ORDER BY total_quantity DESC;
END;
