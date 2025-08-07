/********************************************************************************
 * SCRIPT DE CREACIÓN DE BASE DE DATOS PARA EL SISTEMA POS DE RESTAURANTE
 * Destino: Microsoft SQL Server
 * Fecha de Creación: 07 de agosto de 2025
 ********************************************************************************/
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'RestaurantePOS')
BEGIN
    DROP DATABASE RestaurantePOS;
END
-- Paso 1: Crear la base de datos (si no existe) y seleccionarla
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'RestaurantePOS')
BEGIN
    CREATE DATABASE RestaurantePOS;
END
GO

USE RestaurantePOS;
GO

/********************************************************************************
 * MÓDULO: PRODUCTOS (Tablas de configuración de productos e inventario)
 ********************************************************************************/

-- Tabla para agrupar tipos de productos (Ej: 'Comidas', 'Bebidas')
CREATE TABLE GrupoProducto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- Tabla para las estaciones de preparación (Ej: 'Cocina', 'Barra', 'Parrilla')
CREATE TABLE Estacion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- Tabla para los tipos de producto, dependiente de un grupo (Ej: 'Entradas', 'Platos de Fondo', 'Gaseosas')
CREATE TABLE TipoProducto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    id_grupoproducto INT NOT NULL,
    FOREIGN KEY (id_grupoproducto) REFERENCES GrupoProducto(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabla principal de productos
CREATE TABLE Producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    precio DECIMAL(18, 2) NOT NULL,
    id_tipoproducto INT NOT NULL,
    id_estacion INT NOT NULL,
    FOREIGN KEY (id_tipoproducto) REFERENCES TipoProducto(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_estacion) REFERENCES Estacion(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


/********************************************************************************
 * MÓDULO: PERSONAL (Tablas de gestión de empleados y roles)
 ********************************************************************************/

-- Tabla para los roles de los empleados (Ej: 'Administrador', 'Cajero', 'Mesero')
CREATE TABLE TipoEmpleado (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- Tabla de empleados
CREATE TABLE Empleado (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    dni NVARCHAR(15) NOT NULL UNIQUE,
    usuario NVARCHAR(50) NOT NULL UNIQUE,
    -- En una aplicación real, la contraseña debe ser un HASH, no texto plano.
    -- El tamaño NVARCHAR(255) es adecuado para almacenar hashes.
    password_hash NVARCHAR(255) NOT NULL,
    id_tipoempleado INT NOT NULL,
    FOREIGN KEY (id_tipoempleado) REFERENCES TipoEmpleado(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


/********************************************************************************
 * MÓDULO: VENTAS (Tablas de Clientes, Comprobantes y Pedidos)
 ********************************************************************************/

-- Tabla de clientes
CREATE TABLE Cliente (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(150) NOT NULL,
    dni_ruc NVARCHAR(15) NOT NULL,
    correo NVARCHAR(100) NULL,
    telefono NVARCHAR(20) NULL,
    -- Tipo: 'Persona' o 'Empresa'
    tipo NVARCHAR(20) NOT NULL
);

-- Tabla de los tipos de comprobante fiscal (Ej: 'Boleta', 'Factura', 'Nota de Venta')
CREATE TABLE TipoComprobante (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- Tabla de Mesas
CREATE TABLE Mesa (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL, -- Ej: 'Mesa 1', 'Barra 1'
    -- Estado: 'Libre', 'Ocupada', 'Reservada'
    estado NVARCHAR(20) NOT NULL
);

-- Tabla de Comandas (Pedidos internos)
CREATE TABLE Comanda (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_hora DATETIME2 NOT NULL DEFAULT GETDATE(),
	-- Estado: 'Pendiente', 'Listo', 'Anulada'
    estado NVARCHAR(20) NOT NULL DEFAULT 'Pendiente',  
	fecha_hora_listo DATETIME2 NULL,
	fecha_hora_anulacion DATETIME2 NULL,
    id_empleado_mesero INT NOT NULL,
    id_mesa INT NOT NULL,
    FOREIGN KEY (id_empleado_mesero) REFERENCES Empleado(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabla de detalle de las comandas
CREATE TABLE ComandaDetalle (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_comanda INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10, 3) NOT NULL, -- DECIMAL por si se venden productos por peso/litro
    nota NVARCHAR(255) NULL, -- Ej: 'Sin ají', 'Término medio'
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id) ON DELETE CASCADE, -- Si se elimina la comanda, se elimina el detalle
    FOREIGN KEY (id_producto) REFERENCES Producto(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabla de Comprobantes (documentos fiscales)
CREATE TABLE Comprobante (
    id INT IDENTITY(1,1) PRIMARY KEY,
    numero NVARCHAR(50) NOT NULL,
    fecha_hora DATETIME2 NOT NULL DEFAULT GETDATE(),
    igv DECIMAL(18, 2) NOT NULL,
    total DECIMAL(18, 2) NOT NULL,
    id_tipocomprobante INT NOT NULL,
    id_cliente INT NOT NULL,
    id_empleado_cajero INT NOT NULL,
    id_comanda INT NULL, -- Una venta puede ser directa sin comanda previa
    FOREIGN KEY (id_tipocomprobante) REFERENCES TipoComprobante(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_empleado_cajero) REFERENCES Empleado(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabla de detalle de los comprobantes
CREATE TABLE DetalleComprobante (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_comprobante INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10, 3) NOT NULL,
    precio_unitario DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (id_comprobante) REFERENCES Comprobante(id) ON DELETE CASCADE, -- Si se elimina el comprobante, se elimina su detalle
    FOREIGN KEY (id_producto) REFERENCES Producto(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


/********************************************************************************
 * MÓDULO: CAJA (Tablas de gestión de cuentas y movimientos financieros)
 ********************************************************************************/

-- Tabla de Cajas/Cuentas (Ej: 'Efectivo Principal', 'Cuenta Yape', 'Cuenta Plin')
CREATE TABLE Caja (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- Tabla de tipos de movimiento (Ej: 'Ingreso por Venta', 'Egreso por Gasto', 'Apertura')
CREATE TABLE TipoMovimiento (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NULL
);

-- Tabla de tipos de pago (Ej: 'Efectivo', 'Yape', 'Tarjeta de Crédito')
CREATE TABLE TipoPago (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- Tabla central de movimientos de las cajas/cuentas
CREATE TABLE MovimientoCaja (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_hora DATETIME2 NOT NULL DEFAULT GETDATE(),
    cantidad DECIMAL(18, 2) NOT NULL, -- Positivo para ingresos, negativo para egresos
    id_caja INT NOT NULL, -- La cuenta que se afecta
    id_tipomovimiento INT NOT NULL,
    id_tipopago INT NOT NULL, -- El método con que se hizo el movimiento
    id_empleado INT NOT NULL, -- El empleado que registra el movimiento
    id_comprobante INT NULL, -- Opcional, solo para movimientos asociados a una venta
    FOREIGN KEY (id_caja) REFERENCES Caja(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_tipomovimiento) REFERENCES TipoMovimiento(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_tipopago) REFERENCES TipoPago(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (id_comprobante) REFERENCES Comprobante(id) ON DELETE SET NULL -- Si se borra el comprobante, no se borra el movimiento, solo se desvincula
);

GO

/********************************************************************************
 * INSERCIÓN DE DATOS INICIALES (Datos de configuración básicos)
 ********************************************************************************/
PRINT 'Insertando datos de configuración iniciales...';

-- Tipos de Empleado
INSERT INTO TipoEmpleado (nombre) VALUES ('Administrador'), ('Cajero'), ('Mesero'), ('Cocinero');

-- Estaciones de Preparación
INSERT INTO Estacion (nombre) VALUES ('Cocina'), ('Barra'), ('Parrilla'), ('Postres');

-- Grupos de Producto
INSERT INTO GrupoProducto (nombre) VALUES ('Comidas'), ('Bebidas'), ('Postres');

-- Tipos de Producto
INSERT INTO TipoProducto (nombre, id_grupoproducto) VALUES
('Entradas', (SELECT id FROM GrupoProducto WHERE nombre='Comidas')),
('Platos de Fondo', (SELECT id FROM GrupoProducto WHERE nombre='Comidas')),
('Gaseosas', (SELECT id FROM GrupoProducto WHERE nombre='Bebidas')),
('Licores', (SELECT id FROM GrupoProducto WHERE nombre='Bebidas')),
('Helados', (SELECT id FROM GrupoProducto WHERE nombre='Postres'));

-- Tipos de Comprobante
INSERT INTO TipoComprobante (nombre) VALUES ('Boleta de Venta Electrónica'), ('Factura Electrónica'), ('Nota de Venta Interna');

-- Tipos de Movimiento de Caja
INSERT INTO TipoMovimiento (nombre, descripcion) VALUES
('Apertura de Caja', 'Monto inicial al comenzar el turno'),
('Ingreso por Venta', 'Ingreso generado por un comprobante de venta'),
('Egreso por Gasto', 'Salida de dinero para pagar a proveedores, servicios, etc.'),
('Cierre de Caja', 'Monto final al cerrar el turno');

-- Tipos de Pago
INSERT INTO TipoPago (nombre) VALUES ('Efectivo'), ('Yape'), ('Plin'), ('Tarjeta de Crédito/Débito');

-- Cajas/Cuentas
INSERT INTO Caja (nombre) VALUES ('Caja Efectivo Principal');

-- Mesas
INSERT INTO Mesa (nombre, estado) VALUES
('Mesa 01', 'Libre'),
('Mesa 02', 'Libre'),
('Mesa 03', 'Libre'),
('Mesa 04', 'Libre'),
('Barra 01', 'Libre');

-- Cliente por defecto (para ventas rápidas)
INSERT INTO Cliente (nombre, dni_ruc, tipo) VALUES ('Varios', '00000000', 'Persona');

PRINT '¡Base de datos y datos iniciales creados exitosamente!';
GO