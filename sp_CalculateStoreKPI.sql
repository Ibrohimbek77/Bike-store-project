-- sp_CalculateStoreKPI: Input store ID, return full KPI breakdown

CREATE PROCEDURE sp_CalculateStoreKPI
    @store_id INT
AS
BEGIN
    --vw_StoreSalesSummary
    SELECT * 
    FROM vw_StoreSalesSummary 
    WHERE store_id = @store_id

     -- AOV
    SELECT 
        AVG(order_total) AS avg_order_value
    FROM (
        SELECT o.order_id,
               SUM(oi.quantity * oi.list_price * (1 - ISNULL(oi.discount, 0))) AS order_total
        FROM Orders o
        JOIN Order_items oi ON o.order_id = oi.order_id
        WHERE o.store_id = @store_id
        GROUP BY o.order_id
    ) t


    -- Inventory Turnover = (Cost of Sales) / Avg Inventory
    SELECT 
        SUM(oi.quantity) AS units_sold,
        SUM(st.quantity) AS total_stock,
        CASE WHEN SUM(st.quantity) = 0 THEN NULL
        ELSE CAST(SUM(oi.quantity) AS DECIMAL(10,2)) / SUM(st.quantity)
        END AS inventory_turnover
    FROM Stocks st
    LEFT JOIN Order_items oi ON st.product_id = oi.product_id
    LEFT JOIN Orders o ON oi.order_id = o.order_id AND o.store_id = @store_id
    WHERE st.store_id = @store_id;

    -- Staff revenue contribution
    SELECT 
        s.staff_id,
        s.first_name + ' ' + s.last_name AS staff_name,
        SUM(oi.quantity * oi.list_price * (1 - ISNULL(oi.discount,0))) AS staff_revenue
    FROM Staffs s
    LEFT JOIN Orders o ON o.staff_id = s.staff_id
    LEFT JOIN Order_items oi ON oi.order_id = o.order_id
    WHERE s.store_id = @store_id
    GROUP BY s.staff_id, s.first_name, s.last_name;

END;
