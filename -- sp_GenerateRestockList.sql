-- sp_GenerateRestockList: Output low-stock items per store


CREATE PROCEDURE sp_GenerateRestockList
    @store_id INT,
    @threshold INT = 5
AS
BEGIN
    SELECT 
        p.product_id,
        p.product_name,
        st.quantity AS current_stock
    FROM Stocks st
    JOIN Products p ON st.product_id = p.product_id
    WHERE 
        st.store_id = @store_id
        AND st.quantity <= @threshold
    ORDER BY st.quantity ASC
END;
