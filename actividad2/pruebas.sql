-- Verifica que las llaves primarias no se repitan
SELECT ID_cliente, COUNT(*) FROM STG_Cliente GROUP BY ID_cliente HAVING COUNT(*) > 1;

SELECT ID_producto, COUNT(*) FROM STG_Producto GROUP BY ID_producto HAVING COUNT(*) > 1;

SELECT ID_pedido, ID_producto, COUNT(*) FROM STG_Detalle_Pedido 
GROUP BY ID_pedido, ID_producto HAVING COUNT(*) > 1;

-- Verifica que los campos obligatorios no estén vacíos
-- Campos críticos que no deben ser NULL
SELECT 'Empleado' as Tabla, ID_empleado FROM STG_Empleado WHERE nombre IS NULL OR email IS NULL;
SELECT 'Pedido' as Tabla, ID_pedido FROM STG_Pedido WHERE ID_cliente IS NULL OR fecha_pedido IS NULL;
SELECT 'Producto' as Tabla, ID_producto FROM STG_Producto WHERE precio_venta IS NULL OR Categoria IS NULL;

-- Verifica que los números y fechas tengan sentido
-- Precios o stock negativos
SELECT ID_producto FROM STG_Producto WHERE precio_venta <= 0 OR cantidad_en_stock < 0;

-- Fechas de entrega incoherentes
SELECT ID_pedido FROM STG_Pedido WHERE fecha_entrega < fecha_pedido;

-- Pagos con total cero o negativo
SELECT id_transaccion FROM STG_Pago WHERE total <= 0;