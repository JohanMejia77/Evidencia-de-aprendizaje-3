CREATE TABLE STG_Oficina (
  ID_oficina        INT,
  ciudad            VARCHAR(30),
  pais              VARCHAR(50),
  region            VARCHAR(50),
  codigo_postal     VARCHAR(10),
  telefono          VARCHAR(20),
  linea_direccion1  VARCHAR(50),
  linea_direccion2  VARCHAR(50),
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);

CREATE TABLE STG_Empleado (
  ID_empleado       INT,
  nombre            VARCHAR(50),
  apellido1         VARCHAR(50),
  apellido2         VARCHAR(50),
  extension         VARCHAR(10),
  email             VARCHAR(100),
  ID_oficina        INT,
  ciudad_oficina    VARCHAR(30),     -- Desnormalizado de oficina
  pais_oficina      VARCHAR(50),     -- Desnormalizado de oficina
  ID_jefe           INT,
  nombre_jefe       VARCHAR(101),    -- Desnormalizado (nombre + apellido1)
  puesto            VARCHAR(50),
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);

CREATE TABLE STG_Categoria_Producto (
  Id_Categoria      INT,
  Desc_Categoria    VARCHAR(50),
  descripcion_texto LONGTEXT,
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);

-- EXCLUIDOS: descripcion_html, imagen
-- Razón: Datos de presentación web, no relevantes
-- para análisis ni reportes.

CREATE TABLE STG_Cliente (
  ID_cliente              INT,
  nombre_cliente          VARCHAR(50),
  nombre_contacto         VARCHAR(30),
  apellido_contacto       VARCHAR(30),
  telefono                VARCHAR(15),
  fax                     VARCHAR(15),
  linea_direccion1        VARCHAR(50),
  linea_direccion2        VARCHAR(50),
  ciudad                  VARCHAR(50),
  region                  VARCHAR(50),
  pais                    VARCHAR(50),
  codigo_postal           VARCHAR(10),
  ID_empleado_rep_ventas  INT,
  nombre_rep_ventas       VARCHAR(101),  -- Desnormalizado
  limite_credito          NUMERIC(15,2),
  -- Columnas de auditoría
  fecha_carga             DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen                  VARCHAR(50) DEFAULT 'JARDINERIA'
);

CREATE TABLE STG_Producto (
  ID_producto       VARCHAR(15),
  nombre            VARCHAR(70),
  Categoria         INT,
  Desc_Categoria    VARCHAR(50),     -- Desnormalizado de Categoria_producto
  dimensiones       VARCHAR(25),
  proveedor         VARCHAR(50),
  cantidad_en_stock SMALLINT,
  precio_venta      NUMERIC(15,2),
  precio_proveedor  NUMERIC(15,2),
  margen_ganancia   NUMERIC(15,2) AS (precio_venta - precio_proveedor),  -- Calculado
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);

-- EXCLUIDO: descripcion (TEXT)
-- Razón: Texto descriptivo extenso, no aporta
-- valor analítico en staging.

CREATE TABLE STG_Pedido (
  ID_pedido         INT,
  fecha_pedido      DATE,
  fecha_esperada    DATE,
  fecha_entrega     DATE,
  estado            VARCHAR(15),
  ID_cliente        INT,
  nombre_cliente    VARCHAR(50),     -- Desnormalizado de cliente
  dias_retraso      INT AS (
    CASE 
      WHEN fecha_entrega IS NOT NULL 
      THEN DATEDIFF(fecha_entrega, fecha_esperada)
      ELSE NULL 
    END
  ),                                  -- Calculado
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);

-- EXCLUIDO: comentarios (TEXT)
-- Razón: Texto libre no estructurado, no relevante
-- para análisis dimensional.

CREATE TABLE STG_Detalle_Pedido (
  ID_pedido         INT,
  ID_producto       VARCHAR(15),
  nombre_producto   VARCHAR(70),     -- Desnormalizado de producto
  cantidad          INT,
  precio_unidad     NUMERIC(15,2),
  numero_linea      SMALLINT,
  subtotal          NUMERIC(15,2) AS (cantidad * precio_unidad),  -- Calculado
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);

CREATE TABLE STG_Pago (
  ID_cliente        INT,
  nombre_cliente    VARCHAR(50),     -- Desnormalizado de cliente
  forma_pago        VARCHAR(40),
  id_transaccion    VARCHAR(50),
  fecha_pago        DATE,
  total             NUMERIC(15,2),
  anio_pago         INT AS (YEAR(fecha_pago)),    -- Calculado
  mes_pago          INT AS (MONTH(fecha_pago)),   -- Calculado
  -- Columnas de auditoría
  fecha_carga       DATETIME DEFAULT CURRENT_TIMESTAMP,
  origen            VARCHAR(50) DEFAULT 'JARDINERIA'
);