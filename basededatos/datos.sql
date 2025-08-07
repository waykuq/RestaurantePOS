/********************************************************************************
 * SCRIPT DE INSERCION DE DATOS DE PRUEBA PARA RestaurantePOS (VERSION FINAL Y ROBUSTA)
 * Destino: Microsoft SQL Server
 * Correcciones: Script autocontenido con creacion de datos maestros (idempotente),
 *               seleccion aleatoria corregida y sintaxis T-SQL estandar.
 ********************************************************************************/

USE RestaurantePOS;
GO

SET NOCOUNT ON; 

PRINT 'Iniciando la insercion de datos de prueba...';

/********************************************************************************
 * PASO 1: VERIFICAR Y CREAR DATOS MAESTROS ESENCIALES (SCRIPT IDEMPOTENTE)
 * Este bloque se asegura de que la configuracion basica exista antes de continuar.
 * Se puede ejecutar multiples veces sin generar duplicados.
 ********************************************************************************/
PRINT '-> Verificando y creando datos de configuracion basicos...';

-- MERGE para TipoEmpleado
MERGE INTO dbo.TipoEmpleado AS Target
USING (VALUES 
    ('Administrador'), ('Cajero'), ('Mesero'), ('Cocinero')
) AS Source (nombre)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre) VALUES (Source.nombre);

-- MERGE para Estacion
MERGE INTO dbo.Estacion AS Target
USING (VALUES 
    ('Cocina'), ('Barra'), ('Parrilla'), ('Postres')
) AS Source (nombre)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre) VALUES (Source.nombre);

-- MERGE para GrupoProducto
MERGE INTO dbo.GrupoProducto AS Target
USING (VALUES 
    ('Comidas'), ('Bebidas'), ('Postres')
) AS Source (nombre)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre) VALUES (Source.nombre);

-- MERGE para TipoProducto
MERGE INTO dbo.TipoProducto AS Target
USING (VALUES 
    ('Entradas', 'Comidas'), 
    ('Platos de Fondo', 'Comidas'),
    ('Gaseosas', 'Bebidas'),
    ('Licores', 'Bebidas'),
    ('Postres', 'Postres')
) AS Source (nombre_tipo, nombre_grupo)
ON Target.nombre = Source.nombre_tipo
WHEN NOT MATCHED THEN
    INSERT (nombre, id_grupoproducto) 
    VALUES (Source.nombre_tipo, (SELECT id FROM dbo.GrupoProducto WHERE nombre = Source.nombre_grupo));

-- MERGE para TipoComprobante
MERGE INTO dbo.TipoComprobante AS Target
USING (VALUES 
    ('Boleta de Venta Electronica'), ('Factura Electronica'), ('Nota de Venta Interna')
) AS Source (nombre)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre) VALUES (Source.nombre);

-- MERGE para TipoMovimiento
MERGE INTO dbo.TipoMovimiento AS Target
USING (VALUES 
    ('Apertura de Caja', 'Monto inicial al comenzar el turno'),
    ('Ingreso por Venta', 'Ingreso generado por un comprobante de venta'),
    ('Egreso por Gasto', 'Salida de dinero para pagar a proveedores, servicios, etc.'),
    ('Cierre de Caja', 'Monto final al cerrar el turno')
) AS Source (nombre, descripcion)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre, descripcion) VALUES (Source.nombre, Source.descripcion);

-- MERGE para TipoPago
MERGE INTO dbo.TipoPago AS Target
USING (VALUES 
    ('Efectivo'), ('Yape'), ('Plin'), ('Tarjeta de Credito/Debito')
) AS Source (nombre)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre) VALUES (Source.nombre);

-- MERGE para Caja
MERGE INTO dbo.Caja AS Target
USING (VALUES 
    ('Caja Efectivo Principal'), ('Cuenta Yape Negocio'), ('Cuenta Plin Negocio')
) AS Source (nombre)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre) VALUES (Source.nombre);

-- MERGE para Mesa
MERGE INTO dbo.Mesa AS Target
USING (VALUES 
    ('Mesa 01', 'Libre'), ('Mesa 02', 'Libre'), ('Mesa 03', 'Libre'), ('Mesa 04', 'Libre'), ('Barra 01', 'Libre')
) AS Source (nombre, estado)
ON Target.nombre = Source.nombre
WHEN NOT MATCHED THEN
    INSERT (nombre, estado) VALUES (Source.nombre, Source.estado);

-- MERGE para Clientes base
IF NOT EXISTS (SELECT 1 FROM dbo.Cliente WHERE dni_ruc = '00000000')
    INSERT INTO dbo.Cliente (nombre, dni_ruc, tipo) VALUES ('Varios', '00000000', 'Persona');

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE usuario='admin')
BEGIN
    PRINT '-> Insertando Empleados y Clientes adicionales...';
    INSERT INTO Empleado (nombre, dni, usuario, password_hash, id_tipoempleado) VALUES
    ('Juan Admin', '11111111', 'admin', 'HASH_PASS', (SELECT id FROM TipoEmpleado WHERE nombre='Administrador')),
    ('Maria Caja', '22222222', 'cajero1', 'HASH_PASS', (SELECT id FROM TipoEmpleado WHERE nombre='Cajero')),
    ('Carlos Caja', '33333333', 'cajero2', 'HASH_PASS', (SELECT id FROM TipoEmpleado WHERE nombre='Cajero')),
    ('Ana Mesera', '44444444', 'mesero1', 'HASH_PASS', (SELECT id FROM TipoEmpleado WHERE nombre='Mesero')),
    ('Luis Mesero', '55555555', 'mesero2', 'HASH_PASS', (SELECT id FROM TipoEmpleado WHERE nombre='Mesero')),
    ('Pedro Cocinero', '66666666', 'cocinero1', 'HASH_PASS', (SELECT id FROM TipoEmpleado WHERE nombre='Cocinero'));

    INSERT INTO Cliente (nombre, dni_ruc, correo, telefono, tipo) VALUES
    ('Juan Perez', '10457896', 'juan.perez@email.com', '987654321', 'Persona'),
    ('ACME Corp S.A.C.', '20506070801', 'compras@acmecorp.com', '014567890', 'Empresa');
END

IF NOT EXISTS (SELECT 1 FROM Producto WHERE nombre='Ceviche de Pescado')
BEGIN
    PRINT '-> Insertando catalogo de productos peruanos...';
    INSERT INTO Producto (nombre, descripcion, precio, id_tipoproducto, id_estacion) VALUES
    ('Ceviche de Pescado', 'Trozos de pescado fresco marinados en jugo de limon de pica.', 35.00, (SELECT id FROM TipoProducto WHERE nombre='Entradas'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Lomo Saltado', 'Trozos de lomo fino salteados con cebolla, tomate y papas fritas.', 42.00, (SELECT id FROM TipoProducto WHERE nombre='Platos de Fondo'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Aji de Gallina', 'Pechuga de gallina deshilachada en una cremosa salsa de aji amarillo.', 38.00, (SELECT id FROM TipoProducto WHERE nombre='Platos de Fondo'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Papa a la Huancaina', 'Papas amarillas bañadas en una salsa de aji y queso fresco.', 20.00, (SELECT id FROM TipoProducto WHERE nombre='Entradas'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Pisco Sour', 'Coctel emblematico a base de pisco, jugo de limon y clara de huevo.', 25.00, (SELECT id FROM TipoProducto WHERE nombre='Licores'), (SELECT id FROM Estacion WHERE nombre='Barra')),
    ('Inca Kola 500ml', 'La bebida de sabor nacional.', 5.00, (SELECT id FROM TipoProducto WHERE nombre='Gaseosas'), (SELECT id FROM Estacion WHERE nombre='Barra')),
    ('Pollo a la Brasa (1/4)', 'Acompanado de papas fritas y ensalada fresca.', 22.00, (SELECT id FROM TipoProducto WHERE nombre='Platos de Fondo'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Suspiro a la Limena', 'Dulce de manjar blanco cubierto con merengue al oporto.', 18.00, (SELECT id FROM TipoProducto WHERE nombre='Postres'), (SELECT id FROM Estacion WHERE nombre='Postres')),
    ('Anticuchos de Corazon', 'Brochetas de corazon de res a la parrilla con papas doradas y choclo.', 28.00, (SELECT id FROM TipoProducto WHERE nombre='Entradas'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Arroz con Pollo', 'Clasico arroz verde con piezas de pollo y sarsa criolla.', 36.00, (SELECT id FROM TipoProducto WHERE nombre='Platos de Fondo'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Chilcano de Pisco', 'Refrescante coctel de pisco, ginger ale y limon.', 22.00, (SELECT id FROM TipoProducto WHERE nombre='Licores'), (SELECT id FROM Estacion WHERE nombre='Barra')),
    ('Cusquena Dorada', 'Cerveza lager peruana.', 12.00, (SELECT id FROM TipoProducto WHERE nombre='Licores'), (SELECT id FROM Estacion WHERE nombre='Barra')),
    ('Torta de Chocolate', 'Humeda torta de chocolate con fudge casero.', 15.00, (SELECT id FROM TipoProducto WHERE nombre='Postres'), (SELECT id FROM Estacion WHERE nombre='Postres')),
    ('Leche de Tigre', 'Extracto concentrado y potente del ceviche.', 18.00, (SELECT id FROM TipoProducto WHERE nombre='Entradas'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Picarones', 'Anillos de masa frita de zapallo y camote bañados en miel de chancaca.', 16.00, (SELECT id FROM TipoProducto WHERE nombre='Postres'), (SELECT id FROM Estacion WHERE nombre='Postres')),
    ('Agua sin Gas', 'Botella de 500ml.', 4.00, (SELECT id FROM TipoProducto WHERE nombre='Gaseosas'), (SELECT id FROM Estacion WHERE nombre='Barra')),
    ('Seco de Res con Frijoles', 'Guiso de res al culantro acompañado de frejoles y arroz.', 40.00, (SELECT id FROM TipoProducto WHERE nombre='Platos de Fondo'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Tallarin Saltado Criollo', 'Fideos salteados al wok con trozos de carne y verduras.', 39.00, (SELECT id FROM TipoProducto WHERE nombre='Platos de Fondo'), (SELECT id FROM Estacion WHERE nombre='Cocina')),
    ('Mazamorra Morada', 'Postre clasico a base de maiz morado.', 12.00, (SELECT id FROM TipoProducto WHERE nombre='Postres'), (SELECT id FROM Estacion WHERE nombre='Postres')),
    ('Coca-Cola 500ml', 'Bebida gaseosa clasica.', 5.00, (SELECT id FROM TipoProducto WHERE nombre='Gaseosas'), (SELECT id FROM Estacion WHERE nombre='Barra'));
END
GO

/********************************************************************************
 * PASO 3: GENERACION DE VENTAS HISTORICAS (VERSION FINAL CORREGIDA)
 ********************************************************************************/
PRINT '-> Iniciando la generacion de 240 ventas historicas...';

-- Pre-cargamos los IDs de las cajas fuera del bucle para mayor eficiencia
DECLARE @CajaEfectivoID INT = (SELECT id FROM Caja WHERE nombre LIKE '%Efectivo%');
DECLARE @CajaYapeID INT = (SELECT id FROM Caja WHERE nombre LIKE '%Yape%');
DECLARE @CajaPlinID INT = (SELECT id FROM Caja WHERE nombre LIKE '%Plin%');

-- <<<<<<<<<<<<<<<< CORRECCION: Declarar IDs de comprobante fuera del bucle y usar TOP 1 <<<<<<<<<<<<<<<<
DECLARE @FacturaID INT = (SELECT TOP 1 id FROM TipoComprobante WHERE nombre LIKE 'Factura%');
DECLARE @BoletaID INT = (SELECT TOP 1 id FROM TipoComprobante WHERE nombre LIKE 'Boleta%');

DECLARE @MonthCounter INT = 0;
DECLARE @StartDate DATE = '2023-08-01'; 
DECLARE @CurrentMonth DATETIME2; 

WHILE @MonthCounter < 24
BEGIN
    SET @CurrentMonth = DATEADD(MONTH, @MonthCounter, @StartDate);
    DECLARE @SalesCounter INT = 0;
    
    WHILE @SalesCounter < 10
    BEGIN
        CREATE TABLE #ProductosEnComanda (id_producto INT);

        -- Se asegura de tomar siempre un solo valor
        DECLARE @RandomMeseroID INT = (SELECT TOP 1 id FROM Empleado WHERE id_tipoempleado = (SELECT id FROM TipoEmpleado WHERE nombre='Mesero') ORDER BY NEWID());
        DECLARE @RandomCajeroID INT = (SELECT TOP 1 id FROM Empleado WHERE id_tipoempleado = (SELECT id FROM TipoEmpleado WHERE nombre='Cajero') ORDER BY NEWID());
        DECLARE @RandomMesaID INT = (SELECT TOP 1 id FROM Mesa ORDER BY NEWID());
        DECLARE @RandomClienteID INT = (SELECT TOP 1 id FROM Cliente ORDER BY NEWID());
        DECLARE @RandomTipoPagoID INT = (SELECT TOP 1 id FROM TipoPago ORDER BY NEWID());
        
        DECLARE @TipoComprobanteID INT;
        IF (SELECT tipo FROM Cliente WHERE id = @RandomClienteID) = 'Empresa'
            SET @TipoComprobanteID = @FacturaID;
        ELSE
            SET @TipoComprobanteID = @BoletaID;

        DECLARE @DaysInMonth INT = DAY(EOMONTH(@CurrentMonth));
        DECLARE @RandomDay INT = FLOOR(RAND() * @DaysInMonth) + 1;
        DECLARE @RandomSeconds INT = FLOOR(RAND() * 43200) + 43200; -- Ventas entre mediodía y medianoche
        DECLARE @VentaFecha DATETIME2 = DATEADD(SECOND, @RandomSeconds, DATEADD(DAY, @RandomDay - 1, @CurrentMonth));

        INSERT INTO Comanda (fecha_hora, id_empleado_mesero, id_mesa, estado)
        VALUES (@VentaFecha, @RandomMeseroID, @RandomMesaID, 'Cerrada');
        DECLARE @ComandaID INT = SCOPE_IDENTITY();

        DECLARE @ItemsEnVenta INT = FLOOR(RAND() * 5) + 1;
        DECLARE @ItemsCounter INT = 0;
        WHILE @ItemsCounter < @ItemsEnVenta
        BEGIN
            DECLARE @ProductoID INT = (SELECT TOP 1 id FROM Producto WHERE id NOT IN (SELECT id_producto FROM #ProductosEnComanda) ORDER BY NEWID());
            
            IF @ProductoID IS NOT NULL
            BEGIN
                INSERT INTO ComandaDetalle (id_comanda, id_producto, cantidad, nota) VALUES (@ComandaID, @ProductoID, FLOOR(RAND() * 2) + 1, NULL);
                INSERT INTO #ProductosEnComanda(id_producto) VALUES (@ProductoID);
            END
            SET @ItemsCounter = @ItemsCounter + 1;
        END

        DROP TABLE #ProductosEnComanda;

        DECLARE @SubTotal DECIMAL(18, 2) = (SELECT SUM(cd.cantidad * p.precio) FROM ComandaDetalle cd JOIN Producto p ON cd.id_producto = p.id WHERE cd.id_comanda = @ComandaID);
        DECLARE @IGV DECIMAL(18, 2) = ISNULL(@SubTotal, 0) * 0.18;
        DECLARE @Total DECIMAL(18, 2) = ISNULL(@SubTotal, 0) + @IGV;
        DECLARE @ComprobanteNumero NVARCHAR(50) = CASE WHEN @TipoComprobanteID = @FacturaID THEN 'F001-' + FORMAT((@MonthCounter * 10) + @SalesCounter + 1, '00000000') ELSE 'B001-' + FORMAT((@MonthCounter * 10) + @SalesCounter + 1, '00000000') END;

        INSERT INTO Comprobante (numero, fecha_hora, igv, total, id_tipocomprobante, id_cliente, id_empleado_cajero, id_comanda)
        VALUES (@ComprobanteNumero, @VentaFecha, @IGV, @Total, @TipoComprobanteID, @RandomClienteID, @RandomCajeroID, @ComandaID);
        DECLARE @ComprobanteID INT = SCOPE_IDENTITY();

        IF @ComprobanteID IS NOT NULL
        BEGIN
            INSERT INTO DetalleComprobante (id_comprobante, id_producto, cantidad, precio_unitario)
            SELECT @ComprobanteID, cd.id_producto, cd.cantidad, p.precio FROM ComandaDetalle cd JOIN Producto p ON cd.id_producto = p.id WHERE cd.id_comanda = @ComandaID;

            DECLARE @CajaDestinoID INT;
            DECLARE @TipoPagoNombre NVARCHAR(100) = (SELECT nombre FROM TipoPago WHERE id = @RandomTipoPagoID);
            
            SET @CajaDestinoID = CASE @TipoPagoNombre
                                    WHEN 'Efectivo' THEN @CajaEfectivoID
                                    WHEN 'Yape' THEN @CajaYapeID
                                    WHEN 'Plin' THEN @CajaPlinID
                                    WHEN 'Tarjeta de Credito/Debito' THEN @CajaEfectivoID
                                    ELSE @CajaEfectivoID
                                 END;

            IF @CajaDestinoID IS NOT NULL
            BEGIN
                INSERT INTO MovimientoCaja (fecha_hora, cantidad, id_caja, id_tipomovimiento, id_tipopago, id_empleado, id_comprobante)
                VALUES (@VentaFecha, @Total, @CajaDestinoID, (SELECT id FROM TipoMovimiento WHERE nombre='Ingreso por Venta'), @RandomTipoPagoID, @RandomCajeroID, @ComprobanteID);
            END
        END

        SET @SalesCounter = @SalesCounter + 1;
    END
    SET @MonthCounter = @MonthCounter + 1;
    PRINT '-> Mes ' + FORMAT(@MonthCounter, '00') + '/24 completado (' + FORMAT(@CurrentMonth, 'yyyy-MM') + ').';
END

PRINT 'Proceso de insercion de datos de prueba finalizado con exito!';
GO

SET NOCOUNT OFF;
GO