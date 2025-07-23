SELECT
  c.Country_Name AS Pais,
  c.Format_Name AS Formato,
  s.Store_Name AS Tienda,
  sa.Date AS Fecha,
  SUM(sa.Quantity) / NULLIF(SUM(sa.Transactions), 0) AS Unidades_Promedio,
  SUM(sa.Sales) / NULLIF(SUM(sa.Transactions), 0) AS Transaccion_Promedio,
  SUM(sa.Sales) / NULLIF(SUM(sa.Quantity), 0) AS Precio_Promedio
FROM 
  Sales sa
  INNER JOIN Store s ON sa.Store_Code = s.Store_Code
  INNER JOIN Country_Format c ON s.Country_Format = c.Country_Format
GROUP BY
  c.Country_Name,
  c.Format_Name,
  s.Store_Name,
  sa.Date;
