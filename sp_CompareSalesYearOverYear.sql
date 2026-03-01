-- sp_CompareSalesYearOverYear: Compare sales between two years



CREATE PROCEDURE sp_CompareSalesYearOverYear
    @year1 INT,
    @year2 INT
AS
BEGIN
    SELECT 
        year_val,
        SUM(revenue) AS total_revenue
    FROM (
        SELECT 
            YEAR(o.order_date) AS year_val,
            (oi.quantity * oi.list_price * (1 - ISNULL(oi.discount,0))) AS revenue
        FROM Orders o
        JOIN Order_items oi ON o.order_id = oi.order_id
        WHERE YEAR(o.order_date) IN (@year1, @year2)
    ) A
    GROUP BY year_val;
END;
