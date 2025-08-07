USE RestaurantePOS;
GO

/********************************************************************************
 * MÓDULO: PRODUCTOS
 * Procedimientos para: GrupoProducto, Estacion, TipoProducto, Producto
 ********************************************************************************/

-- ===================================================================
-- CRUD para la tabla: GrupoProducto
-- ===================================================================
PRINT 'Creando SPs para GrupoProducto...';
GO

CREATE OR ALTER PROCEDURE usp_GrupoProducto_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.GrupoProducto;
END
GO

CREATE OR ALTER PROCEDURE usp_GrupoProducto_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.GrupoProducto WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_GrupoProducto_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.GrupoProducto (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_GrupoProducto_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.GrupoProducto SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_GrupoProducto_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.GrupoProducto WHERE id = @id;
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
-- CRUD para la tabla: TipoProducto
-- ===================================================================
PRINT 'Creando SPs para TipoProducto...';
GO

CREATE OR ALTER PROCEDURE usp_TipoProducto_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        tp.id, 
        tp.nombre, 
        tp.id_grupoproducto, 
        gp.nombre AS nombre_grupoproducto 
    FROM dbo.TipoProducto tp
    INNER JOIN dbo.GrupoProducto gp ON tp.id_grupoproducto = gp.id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoProducto_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        tp.id, 
        tp.nombre, 
        tp.id_grupoproducto, 
        gp.nombre AS nombre_grupoproducto 
    FROM dbo.TipoProducto tp
    INNER JOIN dbo.GrupoProducto gp ON tp.id_grupoproducto = gp.id
    WHERE tp.id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoProducto_Crear
    @nombre NVARCHAR(100),
    @id_grupoproducto INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.TipoProducto (nombre, id_grupoproducto) 
    VALUES (@nombre, @id_grupoproducto);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoProducto_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @id_grupoproducto INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TipoProducto 
    SET nombre = @nombre, id_grupoproducto = @id_grupoproducto 
    WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoProducto_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.TipoProducto WHERE id = @id;
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
        p.id_tipoproducto,
        tp.nombre AS nombre_tipoproducto,
        p.id_estacion,
        e.nombre AS nombre_estacion,
        gp.nombre AS nombre_grupoproducto
    FROM dbo.Producto p
    INNER JOIN dbo.TipoProducto tp ON p.id_tipoproducto = tp.id
    INNER JOIN dbo.Estacion e ON p.id_estacion = e.id
    INNER JOIN dbo.GrupoProducto gp ON tp.id_grupoproducto = gp.id;
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
        p.id_tipoproducto,
        tp.nombre AS nombre_tipoproducto,
        p.id_estacion,
        e.nombre AS nombre_estacion,
        gp.nombre AS nombre_grupoproducto
    FROM dbo.Producto p
    INNER JOIN dbo.TipoProducto tp ON p.id_tipoproducto = tp.id
    INNER JOIN dbo.Estacion e ON p.id_estacion = e.id
    INNER JOIN dbo.GrupoProducto gp ON tp.id_grupoproducto = gp.id
    WHERE p.id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_Crear
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255),
    @precio DECIMAL(18, 2),
    @id_tipoproducto INT,
    @id_estacion INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Producto (nombre, descripcion, precio, id_tipoproducto, id_estacion)
    VALUES (@nombre, @descripcion, @precio, @id_tipoproducto, @id_estacion);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Producto_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255),
    @precio DECIMAL(18, 2),
    @id_tipoproducto INT,
    @id_estacion INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Producto
    SET 
        nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio,
        id_tipoproducto = @id_tipoproducto,
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
 * Procedimientos para: TipoEmpleado, Empleado
 ********************************************************************************/

-- ===================================================================
-- CRUD para la tabla: TipoEmpleado
-- ===================================================================
PRINT 'Creando SPs para TipoEmpleado...';
GO

CREATE OR ALTER PROCEDURE usp_TipoEmpleado_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.TipoEmpleado;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoEmpleado_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.TipoEmpleado WHERE id = @id;
END
GO

-- Crear, Actualizar y Eliminar para TipoEmpleado generalmente no se exponen
-- en una aplicación, ya que son datos de sistema, pero se incluyen por completitud.

CREATE OR ALTER PROCEDURE usp_TipoEmpleado_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.TipoEmpleado (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoEmpleado_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TipoEmpleado SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoEmpleado_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.TipoEmpleado WHERE id = @id;
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
        e.id_tipoempleado,
        te.nombre AS nombre_tipoempleado
    FROM dbo.Empleado e
    INNER JOIN dbo.TipoEmpleado te ON e.id_tipoempleado = te.id;
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
        e.id_tipoempleado,
        te.nombre AS nombre_tipoempleado
    FROM dbo.Empleado e
    INNER JOIN dbo.TipoEmpleado te ON e.id_tipoempleado = te.id
    WHERE e.id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_Empleado_Crear
    @nombre NVARCHAR(100),
    @dni NVARCHAR(15),
    @usuario NVARCHAR(50),
    @password_hash NVARCHAR(255),
    @id_tipoempleado INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Empleado (nombre, dni, usuario, password_hash, id_tipoempleado)
    VALUES (@nombre, @dni, @usuario, @password_hash, @id_tipoempleado);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_Empleado_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @dni NVARCHAR(15),
    @usuario NVARCHAR(50),
    @id_tipoempleado INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Empleado
    SET
        nombre = @nombre,
        dni = @dni,
        usuario = @usuario,
        id_tipoempleado = @id_tipoempleado
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
 * Procedimientos para: Caja, TipoPago, TipoMovimiento
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
-- CRUD para la tabla: TipoPago
-- ===================================================================
PRINT 'Creando SPs para TipoPago...';
GO

CREATE OR ALTER PROCEDURE usp_TipoPago_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.TipoPago;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoPago_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre FROM dbo.TipoPago WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoPago_Crear
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.TipoPago (nombre) VALUES (@nombre);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoPago_Actualizar
    @id INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TipoPago SET nombre = @nombre WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoPago_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.TipoPago WHERE id = @id;
END
GO

-- ===================================================================
-- CRUD para la tabla: TipoMovimiento
-- ===================================================================
PRINT 'Creando SPs para TipoMovimiento...';
GO

CREATE OR ALTER PROCEDURE usp_TipoMovimiento_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, descripcion FROM dbo.TipoMovimiento;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoMovimiento_ObtenerPorId
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id, nombre, descripcion FROM dbo.TipoMovimiento WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoMovimiento_Crear
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255) = NULL -- Parámetro opcional
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.TipoMovimiento (nombre, descripcion) VALUES (@nombre, @descripcion);
    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoMovimiento_Actualizar
    @id INT,
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TipoMovimiento 
    SET 
        nombre = @nombre,
        descripcion = @descripcion
    WHERE id = @id;
END
GO

CREATE OR ALTER PROCEDURE usp_TipoMovimiento_Eliminar
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.TipoMovimiento WHERE id = @id;
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
    @id_tipocomprobante INT,
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
    DECLARE @TipoDoc CHAR(1) = IIF((SELECT nombre FROM TipoComprobante WHERE id = @id_tipocomprobante) LIKE 'Factura%', 'F', 'B');
    
    SET @Correlativo = (SELECT COUNT(*) + 1 FROM dbo.Comprobante WHERE id_tipocomprobante = @id_tipocomprobante);
    DECLARE @NumeroComprobante NVARCHAR(50) = @TipoDoc + '001-' + FORMAT(@Correlativo, '00000000');

    -- Paso 3: Insertar la cabecera del comprobante
    INSERT INTO dbo.Comprobante (
        numero, fecha_hora, igv, total, 
        id_tipocomprobante, id_cliente, id_empleado_cajero, id_comanda
    )
    VALUES (
        @NumeroComprobante, GETDATE(), @IGV, @Total,
        @id_tipocomprobante, @id_cliente, @id_empleado_cajero, @id_comanda
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

    INSERT INTO dbo.DetalleComprobante (
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
CREATE OR ALTER PROCEDURE usp_MovimientoCaja_Crear
    @cantidad DECIMAL(18, 2),
    @id_caja INT,
    @id_tipomovimiento INT,
    @id_tipopago INT,
    @id_empleado INT,
    @id_comprobante INT = NULL -- Opcional, solo se usa para ingresos por venta
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.MovimientoCaja (
        fecha_hora, 
        cantidad, 
        id_caja, 
        id_tipomovimiento, 
        id_tipopago, 
        id_empleado, 
        id_comprobante
    )
    VALUES (
        GETDATE(), 
        @cantidad, 
        @id_caja, 
        @id_tipomovimiento, 
        @id_tipopago, 
        @id_empleado, 
        @id_comprobante
    );

    SELECT SCOPE_IDENTITY() AS id_creado;
END
GO

PRINT 'Creacion de procedimientos almacenados transaccionales finalizada.';
GO