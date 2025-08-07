USE RestaurantePOS;
GO

-- Desactivar restricciones de clave externa
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

-- Eliminar datos de tablas (excepto las que tienen datos iniciales)
DELETE FROM DetalleComprobante;
DELETE FROM Comprobante;
DELETE FROM ComandaDetalle;
DELETE FROM Comanda;
DELETE FROM Producto;
DELETE FROM Empleado;
DELETE FROM MovimientoCaja;

-- Reactivar restricciones de clave externa
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";

-- Opcional: Reiniciar los IDENTITY (autonuméricos) de las tablas vaciadas
DBCC CHECKIDENT ('DetalleComprobante', RESEED, 0);
DBCC CHECKIDENT ('Comprobante', RESEED, 0);
DBCC CHECKIDENT ('ComandaDetalle', RESEED, 0);
DBCC CHECKIDENT ('Comanda', RESEED, 0);
DBCC CHECKIDENT ('Producto', RESEED, 0);
DBCC CHECKIDENT ('Empleado', RESEED, 0);
DBCC CHECKIDENT ('MovimientoCaja', RESEED, 0);

PRINT 'Base de datos vaciada exitosamente, preservando datos de configuración inicial.';
GO