--• vw_InventoryStatus: Items running low on stock

CREATE VIEW vw_InventoryStatus AS
SELECT
    S.store_id,--decided it would be more logical?? Right??
    P.product_id,
    SUM(quantity) AS TotalQuantity
FROM Stocks AS S
JOIN Products AS P
    ON S.product_id = P.product_id
GROUP BY S.store_id, P.product_id
HAVING(SUM(quantity) <= 10)-- why 10. I don't know. h=just felt like!


















