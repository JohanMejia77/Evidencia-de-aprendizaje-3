-- Verificar duplicados en Dim_Producto
SELECT ID_Dim_Producto, COUNT(*) as Total_Duplicados
FROM Dim_Producto
GROUP BY ID_Dim_Producto
HAVING COUNT(*) > 1;

-- Verificar duplicados en Dim_Tiempo
SELECT ID_Dim_Tiempo, COUNT(*) as Total_Duplicados
FROM Dim_Tiempo
GROUP BY ID_Dim_Tiempo
HAVING COUNT(*) > 1;

-- Verificar métricas nulas en la tabla de Hechos
SELECT *
FROM Hechos_Ventas
WHERE Cantidad_Vendida IS NULL 
   OR Monto_Venta IS NULL;

-- Verificar atributos clave nulos en Dim_Producto
SELECT *
FROM Dim_Producto
WHERE CodigoProducto IS NULL 
   OR Nombre_Producto IS NULL;

-- Las ventas y montos no deberían ser negativos
SELECT *
FROM Hechos_Ventas
WHERE Cantidad_Vendida < 0 
   OR Monto_Venta < 0;

-- Los meses de la dimensión tiempo deben estar entre 1 y 12
SELECT *
FROM Dim_Tiempo
WHERE Mes < 1 
   OR Mes > 12;

-- Los trimestres deben estar entre 1 y 4
SELECT *
FROM Dim_Tiempo
WHERE Trimestre < 1 
   OR Trimestre > 4;