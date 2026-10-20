-- ===================================================
-- SCRIPT: ventas_tech_db.sql
-- PROYECTO: TechStore - Ventas_Tech_DB
-- ===================================================

-- SECCIÓN 1: DROP TABLES (borrado preventivo)
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- SECCIÓN 2: CREATE TABLES (creación del esquema)
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT FOREIGN KEY REFERENCES categorias(id_categoria),
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BIT DEFAULT 1
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT FOREIGN KEY REFERENCES clientes(id_cliente),
    id_producto INT FOREIGN KEY REFERENCES productos(id_producto),
    fecha_venta DATE NOT NULL,
    cantidad INT NOT NULL,
    total DECIMAL(10,2) NOT NULL
);

-- SECCIÓN 3: INSERT INTO (carga de datos iniciales)
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
(1, 'Laptops', 'Equipos portátiles para trabajo y gaming'),
(2, 'Smartphones', 'Teléfonos celulares inteligentes'),
(3, 'Accesorios', 'Periféricos, cables y cargadores');

INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
(1, 'Ana Pérez', 'ana.perez@example.com', 'Buenos Aires', '2024-01-15'),
(2, 'Carlos Gómez', 'carlos.gomez@example.com', 'Córdoba', '2024-02-10'),
(3, 'Lucía Fernández', 'lucia.f@example.com', 'Rosario', '2024-03-05');

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
(101, 'MacBook Air M2', 1, 1200.00, 15, 1),
(102, 'Samsung Galaxy S24', 2, 950.00, 25, 1),
(103, 'Mouse Inalámbrico Logitech', 3, 35.50, 50, 1);

INSERT INTO ventas (id_venta, id_cliente, id_producto, fecha_venta, cantidad, total) VALUES
(1001, 1, 101, '2024-03-10', 1, 1200.00),
(1002, 2, 103, '2024-03-12', 2, 71.00),
(1003, 3, 102, '2024-03-15', 1, 950.00);

-- SECCIÓN 4: VALIDACIÓN
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
