WITH Ventas_Agregadas AS (
    SELECT
        c.Country_Name AS Pais,
        c.Format_Name AS Formato,
        s.Country_Format,
        sa.Date,
        SUM(sa.Sales) AS Total_Sales
    FROM 
        Sales sa
        INNER JOIN Store s ON sa.Store_Code = s.Store_Code
        INNER JOIN Country_Format c ON s.Country_Format = c.Country_Format
    GROUP BY
        c.Country_Name,
        c.Format_Name,
        s.Country_Format,
        sa.Date
)
SELECT
    v.Pais,
    v.Formato,
    v.Date AS Fecha,
    1 - ((sp.Sales_Plan - v.Total_Sales) / NULLIF(v.Total_Sales, 0)) AS Alcance_Plan
FROM 
    Ventas_Agregadas v
    INNER JOIN Sales_Plan sp 
        ON v.Date = sp.Date
        AND v.Country_Format = sp.Country_Format;
