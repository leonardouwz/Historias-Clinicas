1. Creación de Logins (nivel servidor)

-- Login para administrador
CREATE LOGIN admin_clinica WITH PASSWORD = 'AdminSecure123!';
GO

-- Login para médicos
CREATE LOGIN medico_general WITH PASSWORD = 'MedicoSecure123!';
GO

-- Login para recepcionistas
CREATE LOGIN recepcion_principal WITH PASSWORD = 'RecepSecure123!';
GO
2. Creación de Usuarios en la Base de Datos

USE SistemaHistoriasClinicas;
GO

-- Usuario administrador
CREATE USER admin_db FOR LOGIN admin_clinica;
GO

-- Usuario médico
CREATE USER medico_db FOR LOGIN medico_general;
GO

-- Usuario recepcionista
CREATE USER recepcion_db FOR LOGIN recepcion_principal;
GO
3. Asignación de Roles y Permisos
sql
-- Administrador: acceso completo
ALTER ROLE db_owner ADD MEMBER admin_db;
GO

-- Médicos: lectura/escritura en tablas clínicas
EXEC sp_addrolemember 'db_datareader', 'medico_db';
EXEC sp_addrolemember 'db_datawriter', 'medico_db';
GO

-- Permisos adicionales para médicos
GRANT EXECUTE ON SCHEMA::dbo TO medico_db;
GRANT SELECT, INSERT, UPDATE ON Pacientes TO medico_db;
GRANT SELECT, INSERT, UPDATE ON HistoriasClinicas TO medico_db;
GRANT SELECT, INSERT, UPDATE ON Consultas TO medico_db;
GRANT SELECT, INSERT, UPDATE ON Recetas TO medico_db;
GO

-- Recepcionistas: acceso limitado
EXEC sp_addrolemember 'db_datareader', 'recepcion_db';
GO

-- Permisos específicos para recepcionistas
GRANT SELECT, INSERT, UPDATE ON Pacientes TO recepcion_db;
GRANT SELECT, INSERT ON Consultas TO recepcion_db;
GRANT SELECT ON Medicos TO recepcion_db;
GO
4. Permisos Especiales para Procedimientos

-- Permitir a recepcionistas ejecutar SP específicos
GRANT EXECUTE ON SP_RegistrarPaciente TO recepcion_db;
GRANT EXECUTE ON SP_CrearConsulta TO recepcion_db;
GO

-- Permitir a médicos ejecutar SP clínicos
GRANT EXECUTE ON SP_BuscarHistorialPaciente TO medico_db;
GRANT EXECUTE ON SP_CrearReceta TO medico_db;
GO
5. Verificación de Permisos

-- Ver permisos de un usuario
EXEC sp_helprotect NULL, 'medico_db';
GO

-- Ver roles de un usuario
EXEC sp_helpuser 'recepcion_db';
GO
6. Eliminación de Accesos (si es necesario)
sql
-- Revocar permisos
REVOKE SELECT ON Pacientes FROM recepcion_db;
GO

-- Quitar de roles
EXEC sp_droprolemember 'db_datareader', 'recepcion_db';
GO

-- Eliminar usuario y login
DROP USER recepcion_db;
DROP LOGIN recepcion_principal;
GO
