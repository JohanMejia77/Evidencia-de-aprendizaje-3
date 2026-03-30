-- =============================================
-- ETL: Carga de STG_Oficina
-- Fuente: jardineria.oficina
-- Destino: STG_Jardineria.STG_Oficina
-- =============================================

-- Paso 1: Limpiar tabla destino (truncate)
TRUNCATE TABLE STG_Jardineria.STG_Oficina;

-- Paso 2: Insertar registros desde origen
INSERT INTO STG_Jardineria.STG_Oficina (
  ID_oficina, ciudad, pais, 
  region, codigo_postal, telefono,
  linea_direccion1, linea_direccion2
)
SELECT 
  ID_oficina,
  ciudad,
  pais,
  region,
  codigo_postal,
  telefono,
  linea_direccion1,
  linea_direccion2
FROM jardineria.oficina;

-- =============================================
-- ETL: Carga de STG_Empleado
-- Fuente: jardineria.empleado
--         jardineria.oficina
-- Destino: STG_Jardineria.STG_Empleado
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Empleado;

INSERT INTO STG_Jardineria.STG_Empleado (
  ID_empleado, nombre, apellido1, apellido2,
  extension, email, ID_oficina, ciudad_oficina,
  pais_oficina, ID_jefe, nombre_jefe, puesto
)
SELECT 
  e.ID_empleado,
  e.nombre,
  e.apellido1,
  e.apellido2,
  e.extension,
  e.email,
  e.ID_oficina,
  o.ciudad          AS ciudad_oficina,
  o.pais            AS pais_oficina,
  e.ID_jefe,
  CASE 
    WHEN j.ID_empleado IS NOT NULL 
    THEN CONCAT(j.nombre, ' ', j.apellido1)
    ELSE NULL 
  END               AS nombre_jefe,
  e.puesto
FROM jardineria.empleado e
INNER JOIN jardineria.oficina o 
  ON e.ID_oficina = o.ID_oficina
LEFT JOIN jardineria.empleado j 
  ON e.ID_jefe = j.ID_empleado;

  -- =============================================
-- ETL: Carga de STG_Categoria_Producto
-- Fuente: jardineria.Categoria_producto
-- Destino: STG_Jardineria.STG_Categoria_Producto
-- Excluidos: descripcion_html, imagen
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Categoria_Producto;

INSERT INTO STG_Jardineria.STG_Categoria_Producto (
  Id_Categoria, Desc_Categoria, descripcion_texto
)
SELECT 
  Id_Categoria,
  Desc_Categoria,
  descripcion_texto
FROM jardineria.Categoria_producto;

-- =============================================
-- ETL: Carga de STG_Cliente
-- Fuente: jardineria.cliente
--         jardineria.empleado
-- Destino: STG_Jardineria.STG_Cliente
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Cliente;

INSERT INTO STG_Jardineria.STG_Cliente (
  ID_cliente, nombre_cliente, nombre_contacto,
  apellido_contacto, telefono, fax,
  linea_direccion1, linea_direccion2, ciudad,
  region, pais, codigo_postal,
  ID_empleado_rep_ventas, nombre_rep_ventas,
  limite_credito
)
SELECT 
  c.ID_cliente,
  c.nombre_cliente,
  c.nombre_contacto,
  c.apellido_contacto,
  c.telefono,
  c.fax,
  c.linea_direccion1,
  c.linea_direccion2,
  c.ciudad,
  c.region,
  c.pais,
  c.codigo_postal,
  c.ID_empleado_rep_ventas,
  CASE 
    WHEN e.ID_empleado IS NOT NULL 
    THEN CONCAT(e.nombre, ' ', e.apellido1)
    ELSE NULL 
  END AS nombre_rep_ventas,
  c.limite_credito
FROM jardineria.cliente c
LEFT JOIN jardineria.empleado e 
  ON c.ID_empleado_rep_ventas = e.ID_empleado;

-- =============================================
-- ETL: Carga de STG_Producto
-- Fuente: jardineria.producto
--         jardineria.Categoria_producto
-- Destino: STG_Jardineria.STG_Producto
-- Excluidos: descripcion (TEXT)
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Producto;

INSERT INTO STG_Jardineria.STG_Producto (
  ID_producto, nombre, Categoria, 
  Desc_Categoria, dimensiones, proveedor,
  cantidad_en_stock, precio_venta, precio_proveedor
)
SELECT 
  p.ID_producto,
  p.nombre,
  p.Categoria,
  cp.Desc_Categoria,
  p.dimensiones,
  p.proveedor,
  p.cantidad_en_stock,
  p.precio_venta,
  p.precio_proveedor
FROM jardineria.producto p
INNER JOIN jardineria.Categoria_producto cp 
  ON p.Categoria = cp.Id_Categoria;

-- =============================================
-- ETL: Carga de STG_Pedido
-- Fuente: jardineria.pedido
--         jardineria.cliente
-- Destino: STG_Jardineria.STG_Pedido
-- Excluidos: comentarios (TEXT)
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Pedido;

INSERT INTO STG_Jardineria.STG_Pedido (
  ID_pedido, fecha_pedido, fecha_esperada,
  fecha_entrega, estado, ID_cliente,
  nombre_cliente
)
SELECT 
  p.ID_pedido,
  p.fecha_pedido,
  p.fecha_esperada,
  p.fecha_entrega,
  p.estado,
  p.ID_cliente,
  c.nombre_cliente
FROM jardineria.pedido p
INNER JOIN jardineria.cliente c 
  ON p.ID_cliente = c.ID_cliente;

-- =============================================
-- ETL: Carga de STG_Detalle_Pedido
-- Fuente: jardineria.detalle_pedido
--         jardineria.producto
-- Destino: STG_Jardineria.STG_Detalle_Pedido
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Detalle_Pedido;

INSERT INTO STG_Jardineria.STG_Detalle_Pedido (
  ID_pedido, ID_producto, nombre_producto,
  cantidad, precio_unidad, numero_linea
)
SELECT 
  dp.ID_pedido,
  dp.ID_producto,
  p.nombre        AS nombre_producto,
  dp.cantidad,
  dp.precio_unidad,
  dp.numero_linea
FROM jardineria.detalle_pedido dp
INNER JOIN jardineria.producto p 
  ON dp.ID_producto = p.ID_producto;

-- =============================================
-- ETL: Carga de STG_Pago
-- Fuente: jardineria.pago
--         jardineria.cliente
-- Destino: STG_Jardineria.STG_Pago
-- =============================================

TRUNCATE TABLE STG_Jardineria.STG_Pago;

INSERT INTO STG_Jardineria.STG_Pago (
  ID_cliente, nombre_cliente, forma_pago,
  id_transaccion, fecha_pago, total
)
SELECT 
  pa.ID_cliente,
  c.nombre_cliente,
  pa.forma_pago,
  pa.id_transaccion,
  pa.fecha_pago,
  pa.total
FROM jardineria.pago pa
INNER JOIN jardineria.cliente c 
  ON pa.ID_cliente = c.ID_cliente;