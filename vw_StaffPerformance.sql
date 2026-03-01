--• vw_StaffPerformance: Orders and revenue handled per staff

CREATE VIEW vw_StaffPerformance AS
WITH OrdersPerStaff AS(
    SELECT 
        S.staff_id,
        S.first_name,
        S.last_name,
        COUNT(O.order_id) AS TotalOrdersHandled -- IIF not needed lazy to delete!
    FROM Staffs AS S
    LEFT JOIN Orders AS O
        ON S.staff_id = O.staff_id
    GROUP BY S.staff_id, S.first_name, S.last_name
),RevenuePerStaff AS(
    SELECT 
        S.staff_id,
        S.first_name,
        S.last_name,
        COALESCE(SUM((quantity * list_price) * (1 - discount)), 0) AS TotalIncomeAchieved 
    FROM Staffs AS S
    LEFT JOIN Orders AS O
        ON S.staff_id = O.staff_id
    LEFT JOIN Order_items AS OI
        ON O.order_id = OI.order_id
    GROUP BY S.staff_id, S.first_name, S.last_name
)
SELECT 
    O.staff_id,
    O.first_name,
    O.last_name,
    O.TotalOrdersHandled,
    R.TotalIncomeAchieved
FROM OrdersPerStaff AS O
JOIN RevenuePerStaff AS R
    ON O.staff_id = R.staff_id



