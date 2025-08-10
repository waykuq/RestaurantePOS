USE RestaurantePOS;
GO

/********************************************************************************
 * MÓDULO: PRODUCTOS
 * Procedimientos para: ProductoGrupo, Estacion, ProductoTipo, Producto
 ********************************************************************************/

-- ===================================================================
-- CRUD para la tabla: ProductoGrupo
-- ===================================================================
PRINT 'Creando SPs para ProductoGrupo...';
GO

CREATE OR ALTER PROCEDURE usp_ProductoGrupo_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.ProductoGrupo;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoGrupo_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.ProductoGrupo WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoGrupo_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.ProductoGrupo (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoGrupo_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.ProductoGrupo SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoGrupo_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ProductoGrupo WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: Estacion
-- ===================================================================
PRINT 'Creando SPs para Estacion...';
GO

CREATE OR ALTER PROCEDURE usp_Estacion_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.Estacion;
END
GO

CREATE OR ALTER PROCEDURE usp_Estacion_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.Estacion WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Estacion_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Estacion (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Estacion_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Estacion SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Estacion_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Estacion WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: ProductoTipo
-- ===================================================================
PRINT 'Creando SPs para ProductoTipo...';
GO

CREATE OR ALTER PROCEDURE usp_ProductoTipo_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        tp.id, 
        tp.nombre, 
        tp.id_productogrupo, 
        gp.nombre AS nombre_productogrupo 
    FROM dbo.ProductoTipo tp
    INNER JOIN dbo.ProductoGrupo gp ON tp.id_productogrupo = gp.id;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoTipo_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        tp.id, 
        tp.nombre, 
        tp.id_productogrupo, 
        gp.nombre AS nombre_productogrupo 
    FROM dbo.ProductoTipo tp
    INNER JOIN dbo.ProductoGrupo gp ON tp.id_productogrupo = gp.id
    WHERE tp.id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoTipo_Crear
    @nombre NVARCHAR(100),
    @id_productogrupo INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.ProductoTipo (nombre, id_productogrupo) 
    VALUES (@nombre, @id_productogrupo);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoTipo_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @id_productogrupo INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.ProductoTipo 
    SET nombre = @nombre, id_productogrupo = @id_productogrupo 
    WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_ProductoTipo_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ProductoTipo WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: Producto
-- ===================================================================
PRINT 'Creando SPs para Producto...';
GO

CREATE OR ALTER PROCEDURE usp_Producto_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.id,
        p.nombre,
        p.descripcion,
        p.precio,
        p.id_productotipo,
        tp.nombre AS nombre_productotipo,
        p.id_estacion,
        e.nombre AS nombre_estacion,
        gp.nombre AS nombre_grupoproducto
    FROM dbo.Producto p
    INNER JOIN dbo.ProductoTipo tp ON p.id_productotipo = tp.id
    INNER JOIN dbo.Estacion e ON p.id_estacion = e.id
    INNER JOIN dbo.ProductoGrupo gp ON tp.id_productogrupo = gp.id;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.id,
        p.nombre,
        p.descripcion,
        p.precio,
        p.id_productotipo,
        tp.nombre AS nombre_productotipo,
        p.id_estacion,
        e.nombre AS nombre_estacion,
        gp.nombre AS nombre_grupoproducto
    FROM dbo.Producto p
    INNER JOIN dbo.ProductoTipo tp ON p.id_productotipo = tp.id
    INNER JOIN dbo.Estacion e ON p.id_estacion = e.id
    INNER JOIN dbo.ProductoGrupo gp ON tp.id_productogrupo = gp.id
    WHERE p.id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_Crear
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255),
    @precio DECIMAL(18, 2),
    @id_productotipo INT,
    @id_estacion INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Producto (nombre, descripcion, precio, id_productotipo, id_estacion)
    VALUES (@nombre, @descripcion, @precio, @id_productotipo, @id_estacion);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255),
    @precio DECIMAL(18, 2),
    @id_productotipo INT,
    @id_estacion INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Producto
    SET 
        nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio,
        id_productotipo = @id_productotipo,
        id_estacion = @id_estacion
    WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Producto WHERE id = @id;
END
GO

/********************************************************************************
 * MÓDULO: PERSONAL
 * Procedimientos para: EmpleadoTipo, Empleado
 ********************************************************************************/

-- ===================================================================
-- CRUD para la tabla: EmpleadoTipo
-- ===================================================================
PRINT 'Creando SPs para EmpleadoTipo...';
GO

CREATE OR ALTER PROCEDURE usp_EmpleadoTipo_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.EmpleadoTipo;
END
GO

CREATE OR ALTER PROCEDURE usp_EmpleadoTipo_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.EmpleadoTipo WHERE id = @id;
END
GO

-- Crear, Actualizar y Eliminar para EmpleadoTipo generalmente no se exponen
-- en una aplicación, ya que son datos de sistema, pero se incluyen por completitud.

CREATE OR ALTER PROCEDURE usp_EmpleadoTipo_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.EmpleadoTipo (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_EmpleadoTipo_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.EmpleadoTipo SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_EmpleadoTipo_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.EmpleadoTipo WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: Empleado
-- ===================================================================
PRINT 'Creando SPs para Empleado...';
GO

CREATE OR ALTER PROCEDURE usp_Empleado_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        e.id,
        e.nombre,
        e.dni,
        e.usuario,
        e.id_empleadotipo,
        te.nombre AS nombre_empleadotipo
    FROM dbo.Empleado e
    INNER JOIN dbo.EmpleadoTipo te ON e.id_empleadotipo = te.id;
END
GO

CREATE OR ALTER PROCEDURE usp_Empleado_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        e.id,
        e.nombre,
        e.dni,
        e.usuario,
        e.id_empleadotipo,
        te.nombre AS nombre_empleadotipo
    FROM dbo.Empleado e
    INNER JOIN dbo.EmpleadoTipo te ON e.id_empleadotipo = te.id
    WHERE e.id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Empleado_Crear
    @nombre NVARCHAR(100),
    @dni NVARCHAR(15),
    @usuario NVARCHAR(50),
    @password_hash NVARCHAR(255),
    @id_empleadotipo INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Empleado (nombre, dni, usuario, password_hash, id_empleadotipo)
    VALUES (@nombre, @dni, @usuario, @password_hash, @id_empleadotipo);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Empleado_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @dni NVARCHAR(15),
    @usuario NVARCHAR(50),
    @id_empleadotipo INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Empleado
    SET
        nombre = @nombre,
        dni = @dni,
        usuario = @usuario,
        id_empleadotipo = @id_empleadotipo
    WHERE id = @id;
END
GO

-- SP para cambiar la contraseña de un empleado
CREATE OR ALTER PROCEDURE usp_Empleado_CambiarPassword
    @id INT,
    @password_hash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Empleado SET password_hash = @password_hash WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Empleado_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Empleado WHERE id = @id;
END
GO


/********************************************************************************
 * MÓDULO: VENTAS Y CLIENTES
 * Procedimientos para: Cliente, Mesa, etc.
 * (Comanda y Comprobante son más complejos y se tratarán por separado)
 ********************************************************************************/

-- ===================================================================
-- CRUD para la tabla: Cliente
-- ===================================================================
PRINT 'Creando SPs para Cliente...';
GO

CREATE OR ALTER PROCEDURE usp_Cliente_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, dni_ruc, correo, telefono, tipo FROM dbo.Cliente;
END
GO

CREATE OR ALTER PROCEDURE usp_Cliente_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, dni_ruc, correo, telefono, tipo FROM dbo.Cliente WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Cliente_Crear
    @nombre NVARCHAR(150),
    @dni_ruc NVARCHAR(15),
    @correo NVARCHAR(100),
    @telefono NVARCHAR(20),
    @tipo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Cliente (nombre, dni_ruc, correo, telefono, tipo)
    VALUES (@nombre, @dni_ruc, @correo, @telefono, @tipo);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Cliente_Actualizar
    @id INT,
    @nombre NVARCHAR(150),
    @dni_ruc NVARCHAR(15),
    @correo NVARCHAR(100),
    @telefono NVARCHAR(20),
    @tipo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Cliente
    SET
        nombre = @nombre,
        dni_ruc = @dni_ruc,
        correo = @correo,
        telefono = @telefono,
        tipo = @tipo
    WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Cliente_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Cliente WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: Mesa
-- ===================================================================
PRINT 'Creando SPs para Mesa...';
GO

CREATE OR ALTER PROCEDURE usp_Mesa_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, estado FROM dbo.Mesa;
END
GO

CREATE OR ALTER PROCEDURE usp_Mesa_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, estado FROM dbo.Mesa WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Mesa_Crear
    @nombre NVARCHAR(100),
    @estado NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Mesa (nombre, estado) VALUES (@nombre, @estado);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Mesa_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @estado NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Mesa SET nombre = @nombre, estado = @estado WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Mesa_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Mesa WHERE id = @id;
END
GO

/********************************************************************************
 * MÓDULO: CAJA Y CONFIGURACIÓN FINANCIERA (VERSIÓN COMPLETA)
 * Procedimientos para: Caja, PagoTipo, MovimientoTipo
 ********************************************************************************/
 
-- ===================================================================
-- CRUD para la tabla: Caja
-- ===================================================================
PRINT 'Creando SPs para Caja...';
GO

CREATE OR ALTER PROCEDURE usp_Caja_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.Caja;
END
GO

CREATE OR ALTER PROCEDURE usp_Caja_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.Caja WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Caja_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Caja (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Caja_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Caja SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Caja_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Caja WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: PagoTipo
-- ===================================================================
PRINT 'Creando SPs para PagoTipo...';
GO

CREATE OR ALTER PROCEDURE usp_PagoTipo_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.PagoTipo;
END
GO

CREATE OR ALTER PROCEDURE usp_PagoTipo_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.PagoTipo WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_PagoTipo_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.PagoTipo (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_PagoTipo_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.PagoTipo SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_PagoTipo_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.PagoTipo WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: MovimientoTipo
-- ===================================================================
PRINT 'Creando SPs para MovimientoTipo...';
GO

CREATE OR ALTER PROCEDURE usp_MovimientoTipo_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, descripcion FROM dbo.MovimientoTipo;
END
GO

CREATE OR ALTER PROCEDURE usp_MovimientoTipo_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, descripcion FROM dbo.MovimientoTipo WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_MovimientoTipo_Crear
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255) = NULL -- Parámetro opcional
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.MovimientoTipo (nombre, descripcion) VALUES (@nombre, @descripcion);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_MovimientoTipo_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.MovimientoTipo 
    SET 
        nombre = @nombre,
        descripcion = @descripcion
    WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_MovimientoTipo_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.MovimientoTipo WHERE id = @id;
END
GO

PRINT 'Creacion de procedimientos almacenados para el modulo de Caja finalizada.';
GO






-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------





/********************************************************************************
 * MÓDULO: OPERACIONES DE COMANDA
 ********************************************************************************/
PRINT 'Creando SPs para Operaciones de Comanda...';
GO

-- ===================================================================
-- 1. Crear la cabecera de una nueva comanda
-- Se ejecuta cuando un mesero abre una nueva orden para una mesa.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_Comanda_Crear
    @id_empleado_mesero INT,
    @id_mesa INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Comanda (fecha_hora, id_empleado_mesero, id_mesa, estado)
    VALUES (GETDATE(), @id_empleado_mesero, @id_mesa, 'Abierta');
    
    -- Devolver el ID de la comanda recién creada
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

-- ===================================================================
-- 2. Agregar un producto al detalle de una comanda existente
-- Se ejecuta cada vez que el mesero añade un ítem al pedido.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_ComandaDetalle_Agregar
    @id_comanda INT,
    @id_producto INT,
    @cantidad DECIMAL(10, 3),
    @nota NVARCHAR(255) = NULL -- Parámetro opcional para notas como 'Sin ají'
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.ComandaDetalle (id_comanda, id_producto, cantidad, nota)
    VALUES (@id_comanda, @id_producto, @cantidad, @nota);

    -- Devolver el ID del detalle recién creado
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO


-- ===================================================================
-- 3. Marcar una comanda como "Lista para servir"
-- Cambia el estado y registra la marca de tiempo de cuando estuvo lista.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_Comanda_MarcarComoLista
    @id_comanda INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que la comanda exista y no esté ya anulada o cerrada
    IF EXISTS (SELECT 1 FROM dbo.Comanda WHERE id = @id_comanda AND estado NOT IN ('Anulada', 'Cerrada'))
    BEGIN
        UPDATE dbo.Comanda
        SET 
            estado = 'Listo',
            fecha_hora_listo = GETDATE()
        WHERE 
            id = @id_comanda;

        -- Devolver un indicador de éxito
        SELECT 1 AS Exito;
    END
    ELSE
    BEGIN
        -- Devolver un indicador de fallo (ej. la comanda no existe o ya está cerrada/anulada)
        SELECT 0 AS Exito;
    END
END
GO

-- ===================================================================
-- 4. Anular una comanda
-- Cambia el estado a "Anulada" y registra la marca de tiempo de la anulación.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_Comanda_Anular
    @id_comanda INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que la comanda exista y no esté ya cerrada
    IF EXISTS (SELECT 1 FROM dbo.Comanda WHERE id = @id_comanda AND estado != 'Cerrada')
    BEGIN
        UPDATE dbo.Comanda
        SET 
            estado = 'Anulada',
            fecha_hora_anulacion = GETDATE()
        WHERE 
            id = @id_comanda;
        
        -- Devolver un indicador de éxito
        SELECT 1 AS Exito;
    END
    ELSE
    BEGIN
        -- Devolver un indicador de fallo (ej. la comanda no existe o ya está cerrada)
        SELECT 0 AS Exito;
    END
END
GO

PRINT 'Procedimientos almacenados para estados de Comanda creados exitosamente.';
GO

/********************************************************************************
 * MÓDULO: OPERACIONES DE COMPROBANTE (FACTURACIÓN)
 ********************************************************************************/
PRINT 'Creando SPs para Operaciones de Comprobante...';
GO

-- ===================================================================
-- 3. Crear la cabecera de un nuevo comprobante
-- Se ejecuta al iniciar el proceso de cobro. Calcula los totales desde la comanda.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_Comprobante_Crear
    @id_comanda INT,
    @id_cliente INT,
    @id_comprobantetipo INT,
    @id_empleado_cajero INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Paso 1: Calcular los totales basados en el detalle de la comanda
    DECLARE @SubTotal DECIMAL(18, 2) = (
        SELECT SUM(cd.cantidad * p.precio)
        FROM dbo.ComandaDetalle cd
        INNER JOIN dbo.Producto p ON cd.id_producto = p.id
        WHERE cd.id_comanda = @id_comanda
    );

    DECLARE @IGV DECIMAL(18, 2) = ISNULL(@SubTotal, 0) * 0.18;
    DECLARE @Total DECIMAL(18, 2) = ISNULL(@SubTotal, 0) + @IGV;
    
    -- Paso 2: Generar un número de comprobante (lógica básica)
    -- NOTA: En un sistema de producción real, esto debería usar una tabla de correlativos con bloqueo de transacciones.
    DECLARE @Correlativo INT;
    DECLARE @TipoDoc CHAR(1) = IIF((SELECT nombre FROM ComprobanteTipo WHERE id = @id_comprobantetipo) LIKE 'Factura%', 'F', 'B');
    
    SET @Correlativo = (SELECT COUNT(*) + 1 FROM dbo.Comprobante WHERE id_comprobantetipo = @id_comprobantetipo);
    DECLARE @NumeroComprobante NVARCHAR(50) = @TipoDoc + '001-' + FORMAT(@Correlativo, '00000000');

    -- Paso 3: Insertar la cabecera del comprobante
    INSERT INTO dbo.Comprobante (
        numero, fecha_hora, igv, total, 
        id_comprobantetipo, id_cliente, id_empleado_cajero, id_comanda
    )
    VALUES (
        @NumeroComprobante, GETDATE(), @IGV, @Total,
        @id_comprobantetipo, @id_cliente, @id_empleado_cajero, @id_comanda
    );

    -- Devolver el ID del comprobante recién creado
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

-- ===================================================================
-- 4. Copiar todos los productos de una comanda al detalle de un comprobante
-- Se ejecuta inmediatamente después de crear la cabecera del comprobante.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_ComprobanteDetalle_CrearDesdeComanda
    @id_comanda INT,
    @id_comprobante INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.ComprobanteDetalle (
        id_comprobante, 
        id_producto, 
        cantidad, 
        precio_unitario
    )
    SELECT 
        @id_comprobante,
        cd.id_producto,
        cd.cantidad,
        p.precio
    FROM dbo.ComandaDetalle cd
    INNER JOIN dbo.Producto p ON cd.id_producto = p.id
    WHERE cd.id_comanda = @id_comanda;
END
GO


/********************************************************************************
 * MÓDULO: OPERACIONES DE CAJA
 ********************************************************************************/
PRINT 'Creando SPs para Operaciones de Caja...';
GO

-- ===================================================================
-- 5. Crear un nuevo movimiento de caja
-- Se ejecuta para registrar cualquier transacción: un ingreso por venta,
-- una apertura de caja, un pago a proveedor, etc.
-- ===================================================================
CREATE OR ALTER PROCEDURE usp_CajaMovimiento_Crear
    @cantidad DECIMAL(18, 2),
    @id_caja INT,
    @id_movimientotipo INT,
    @id_pagotipo INT,
    @id_empleado INT,
    @id_comprobante INT = NULL -- Opcional, solo se usa para ingresos por venta
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.CajaMovimiento (
        fecha_hora, 
        cantidad, 
        id_caja, 
        id_movimientotipo, 
        id_pagotipo, 
        id_empleado, 
        id_comprobante
    )
    VALUES (
        GETDATE(), 
        @cantidad, 
        @id_caja, 
        @id_movimientotipo, 
        @id_pagotipo, 
        @id_empleado, 
        @id_comprobante
    );

    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

PRINT 'Creacion de procedimientos almacenados transaccionales finalizada.';
GO