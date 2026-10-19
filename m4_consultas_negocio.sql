-- =======================================================
-- Pre-entrega 4: Consultas SQL de negocio (RetailPro)
-- Archivo: m4_consultas_negocio.sql
-- =======================================================

USE Ventas_Tech_DB;
GO

-- 1. Resumen ejecutivo mensual
SELECT 
    MONTH(v.fecha_venta) AS mes,
    SUM(v.cantidad * p.precio_unitario) AS total_facturado,
    COUNT(v.id_venta) AS cantidad_pedidos,
    AVG(v.cantidad * p.precio_unitario) AS ticket_promedio
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY MONTH(v.fecha_venta)
ORDER BY mes;
GO

-- 2. Ranking de productos (Top 5 más vendidos)
SELECT TOP 5
    v.id_producto,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio_unitario) AS total_facturado
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY v.id_producto
ORDER BY total_facturado DESC;
GO

-- 3. Clientes recurrentes
SELECT 
    v.id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(v.cantidad * p.precio_unitario) AS total_gastado
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY v.id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO

-- 4. Meses por encima / por debajo del promedio mensual
WITH VentasMensuales AS (
    SELECT 
        MONTH(v.fecha_venta) AS mes,
        SUM(v.cantidad * p.precio_unitario) AS total_mes
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    GROUP BY MONTH(v.fecha_venta)
)
SELECT 
    mes,
    total_mes,
    CASE 
        WHEN total_mes >= (SELECT AVG(total_mes) FROM VentasMensuales) THEN 'Por encima del promedio'
        ELSE 'Por debajo del promedio'
    END AS clasificacion_desempeno
FROM VentasMensuales
ORDER BY mes;
GO

-- =======================================================
-- Hallazgos de negocio
-- =======================================================
-- 1. Concentración en producto líder: El producto con id_producto 1 concentra la mayor facturación del período ($2400.00 sobre un total aproximado de $2960.00).
-- 2. Fidelidad de clientes: El 100% de los clientes registrados (IDs 1, 2 y 3) son recurrentes, ya que realizaron 2 compras cada uno.
-- 3. Estacionalidad mensual: Los meses 1 (enero) y 3 (marzo) superaron el promedio de facturación mensual general, mientras que el mes 2 (febrero) quedó por debajo con $330.00.
