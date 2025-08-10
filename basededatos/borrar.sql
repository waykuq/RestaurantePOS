USE RestaurantePOS;
GO

-- Desactivar restricciones de clave externa
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

-- Eliminar datos de tablas (excepto las que tienen datos iniciales)
DELETE FROM ComprobanteDetalle;
DELETE FROM Comprobante;
DELETE FROM ComandaDetalle;
DELETE FROM Comanda;
DELETE FROM Producto;
DELETE FROM Empleado;
DELETE FROM CajaMovimiento;

-- Reactivar restricciones de clave externa
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";

-- Opcional: Reiniciar los IDENTITY (autonum�ricos) de las tablas vaciadas
DBCC CHECKIDENT ('ComprobanteDetalle', RESEED, 0);
DBCC CHECKIDENT ('Comprobante', RESEED, 0);
DBCC CHECKIDENT ('ComandaDetalle', RESEED, 0);
DBCC CHECKIDENT ('Comanda', RESEED, 0);
DBCC CHECKIDENT ('Producto', RESEED, 0);
DBCC CHECKIDENT ('Empleado', RESEED, 0);
DBCC CHECKIDENT ('CajaMovimiento', RESEED, 0);

PRINT 'Base de datos vaciada exitosamente, preservando datos de configuraci�n inicial.';
GO