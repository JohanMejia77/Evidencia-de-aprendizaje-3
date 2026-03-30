-- 1. Creación de la dimensión Producto
CREATE TABLE Dim_Producto (
    ID_Dim_Producto INT PRIMARY KEY,
    ID_Producto_Origen INT,
    CodigoProducto VARCHAR(50),
    Nombre_Producto VARCHAR(100),
    Nombre_Categoria VARCHAR(100)
);

-- 2. Creación de la dimensión Tiempo
CREATE TABLE Dim_Tiempo (
    ID_Dim_Tiempo INT PRIMARY KEY,
    Fecha_Completa DATE,
    Anio INT,
    Mes INT,
    Trimestre INT
);

-- 3. Creación de la tabla de Hechos (Ventas)
CREATE TABLE Hechos_Ventas (
    ID_Dim_Producto INT,
    ID_Dim_Tiempo INT,
    Cantidad_Vendida INT,
    Monto_Venta NUMERIC(12, 2),
    
    -- Definición de las claves foráneas (Relaciones)
    FOREIGN KEY (ID_Dim_Producto) REFERENCES Dim_Producto(ID_Dim_Producto),
    FOREIGN KEY (ID_Dim_Tiempo) REFERENCES Dim_Tiempo(ID_Dim_Tiempo)
);