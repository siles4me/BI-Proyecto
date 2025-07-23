SELECT
    s.Store_Name AS Tienda,
    SUM(sa.Sales) AS Total_Ventas
FROM
    Sales sa
    INNER JOIN Stores s ON sa.Store_Code = s.Store_Code
    INNER JOIN Country_Format c ON s.Country_Format = c.Country_Format
WHERE
    c.Country_Name = 'Costa Rica'
    AND c.Format_Name = 'Bodega'
    AND MONTH(sa.Date) = 4
GROUP BY
    s.Store_Name
ORDER BY
    Total_Ventas DESC
LIMIT 10;
