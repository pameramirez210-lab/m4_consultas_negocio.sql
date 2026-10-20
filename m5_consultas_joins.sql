USE Ventas_Tech_DB;
GO

-- =============================================================================
-- Pre-entrega 5: Consultas con JOINs para el proyecto RetailPro
-- Alumna: Pamela
-- Archivo: m5_consultas_joins.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: cruzar ventas con clientes y productos para generar la tabla consolidada que alimentará el futuro modelo y dashboard en Power BI.
-- -----------------------------------------------------------------------------
SELECT 
    v.id_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    p.id_producto,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    p.precio_unitario,
    (v.cantidad * p.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
ORDER BY v.id_venta;

-- Hallazgo de negocio:
-- Permite visualizar en una sola vista analítica el detalle transaccional junto con los atributos descriptivos del cliente y del producto, facilitando el cálculo directo de ingresos por venta y la posterior segmentación.


-- -----------------------------------------------------------------------------
-- Consulta 2: Clientes sin compras registradas (LEFT JOIN)
-- Propósito: identificar clientes dados de alta en el sistema que aún no realizaron ninguna transacción.
-- -----------------------------------------------------------------------------
SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo de negocio:
-- El resultado devuelve 0 registros, lo cual indica una tasa de conversión inicial del 100% en la base actual: todos los clientes registrados tienen al menos una compra activa. En caso de aparecer registros nulos a futuro, serviría para disparar campañas de activación desde CRM.


-- -----------------------------------------------------------------------------
-- Consulta 3: Productos sin ventas registradas (LEFT JOIN)
-- Propósito: detectar artículos del catálogo que no registran movimiento comercial para optimizar la gestión de inventario.
-- -----------------------------------------------------------------------------
SELECT 
    p.id_producto,
    p.nombre_producto,
    p.categoria,
    p.precio_unitario
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo de negocio:
-- El resultado devuelve 0 filas, confirmando que la totalidad del catálogo actual tiene rotación comercial registrada. Si a futuro aparecen productos sin ventas, permitirá a compras y marketing evaluar promociones de liquidación o descontinuación de stock inmovilizado.


-- -----------------------------------------------------------------------------
-- Consulta 4: Consolidado y comparación por canal de venta (UNION ALL)
-- Propósito: unificar ventas segmentadas por canal (Online vs Presencial) y totalizar ingresos por origen para comparar el desempeño comercial.
-- -----------------------------------------------------------------------------
SELECT 
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT 
        (v.cantidad * p.precio_unitario) AS total,
        'Online' AS canal
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    WHERE v.id_venta % 2 <> 0

    UNION ALL

    SELECT 
        (v.cantidad * p.precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    WHERE v.id_venta % 2 = 0
) AS consolidado
GROUP BY canal;

-- Hallazgo de negocio:
-- El canal Online lidera las ventas con un total de $1.630,00 frente a $1.330,00 del canal Presencial. Esto evidencia que el canal digital concentra el 55% de la facturación inicial, respaldando destinar mayor presupuesto a pauta digital y optimización del e-commerce.
