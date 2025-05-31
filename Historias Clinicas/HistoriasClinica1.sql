-- =====================================================
-- SISTEMA DE HISTORIAS CLÍNICAS NORMALIZADO SIMPLE
-- =====================================================

CREATE DATABASE SistemaHistoriasClinicas;
GO

USE SistemaHistoriasClinicas;
GO

-- =====================================================
-- PASO 1: TABLA DE ESPECIALIDADES (ÚNICA TABLA DE REFERENCIA)
-- =====================================================

CREATE TABLE EspecialidadesMedicas (
    id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre_especialidad NVARCHAR(100) NOT NULL UNIQUE,
    descripcion NVARCHAR(255),
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER
);
GO

-- =====================================================
-- PASO 2: TABLA DE INFORMACIÓN DE CONTACTO NORMALIZADA
-- =====================================================

CREATE TABLE InformacionContacto (
    id_contacto INT IDENTITY(1,1) PRIMARY KEY,
    telefono_principal NVARCHAR(15),
    telefono_secundario NVARCHAR(15),
    correo_electronico NVARCHAR(100),
    direccion NVARCHAR(255),
    ciudad NVARCHAR(100),
    codigo_postal NVARCHAR(10),
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER
);
GO

-- =====================================================
-- PASO 3: TABLA DE HISTORIAL SIMPLE
-- =====================================================

CREATE TABLE HistorialCambios (
    id_historial BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_tabla NVARCHAR(50) NOT NULL,
    id_registro INT NOT NULL,
    accion NVARCHAR(20) NOT NULL, -- 'CREAR', 'ACTUALIZAR', 'ELIMINAR'
    descripcion NVARCHAR(500),
    datos_anteriores NVARCHAR(MAX),
    datos_nuevos NVARCHAR(MAX),
    fecha_cambio DATETIME DEFAULT GETDATE(),
    usuario_cambio NVARCHAR(50) DEFAULT SYSTEM_USER,
    ip_usuario NVARCHAR(45)
);
GO

-- Índice para consultas rápidas del historial
CREATE INDEX IX_Historial_Tabla_Registro ON HistorialCambios(nombre_tabla, id_registro);
CREATE INDEX IX_Historial_Fecha ON HistorialCambios(fecha_cambio DESC);

-- =====================================================
-- PASO 4: TABLAS PRINCIPALES NORMALIZADAS
-- =====================================================

-- Tabla de Apoderados Simplificada
CREATE TABLE Apoderados (
    id_apoderado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo NVARCHAR(100) NOT NULL,
    dni NVARCHAR(15) NOT NULL UNIQUE,
    parentesco NVARCHAR(50) NOT NULL, -- Campo directo sin tabla de referencia
    id_contacto INT,
    estado BIT DEFAULT 1,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Apoderado_Contacto FOREIGN KEY (id_contacto) 
        REFERENCES InformacionContacto(id_contacto)
);
GO

-- Tabla de Pacientes Simplificada
CREATE TABLE Pacientes (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    codigo_paciente AS ('PAC-' + RIGHT('000000' + CAST(id_paciente AS VARCHAR), 6)) PERSISTED,
    nombre_completo NVARCHAR(100) NOT NULL,
    dni NVARCHAR(15) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) CHECK (genero IN ('M', 'F', 'O')) DEFAULT 'M',
    es_menor_edad AS (CASE WHEN DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) < 18 THEN 1 ELSE 0 END),
    id_apoderado INT NULL,
    id_contacto INT,
    estado BIT DEFAULT 1,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Paciente_Apoderado FOREIGN KEY (id_apoderado) 
        REFERENCES Apoderados(id_apoderado),
    CONSTRAINT FK_Paciente_Contacto FOREIGN KEY (id_contacto) 
        REFERENCES InformacionContacto(id_contacto)
);
GO

-- Tabla de Médicos Simplificada
CREATE TABLE Medicos (
    id_medico INT IDENTITY(1,1) PRIMARY KEY,
    codigo_medico AS ('MED-' + RIGHT('000000' + CAST(id_medico AS VARCHAR), 6)) PERSISTED,
    nombre_completo NVARCHAR(100) NOT NULL,
    dni NVARCHAR(15) NOT NULL UNIQUE,
    id_especialidad INT NOT NULL,
    numero_colegiatura NVARCHAR(50) NOT NULL UNIQUE,
    id_contacto INT,
    estado BIT DEFAULT 1,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Medico_Especialidad FOREIGN KEY (id_especialidad) 
        REFERENCES EspecialidadesMedicas(id_especialidad),
    CONSTRAINT FK_Medico_Contacto FOREIGN KEY (id_contacto) 
        REFERENCES InformacionContacto(id_contacto)
);
GO

-- Tabla de Medicamentos Simplificada
CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    codigo_medicamento AS ('MED-' + RIGHT('000000' + CAST(id_medicamento AS VARCHAR), 6)) PERSISTED,
    nombre NVARCHAR(100) NOT NULL,
    principio_activo NVARCHAR(100),
    descripcion NVARCHAR(500),
    presentacion NVARCHAR(100) NOT NULL, -- Campo directo sin tabla de referencia
    concentracion NVARCHAR(50),
    contraindicaciones NVARCHAR(MAX),
    estado BIT DEFAULT 1,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1
);
GO

-- =====================================================
-- PASO 5: TABLAS DE PROCESO MÉDICO SIMPLIFICADAS
-- =====================================================

-- Tabla de Historias Clínicas
CREATE TABLE HistoriasClinicas (
    id_historia INT IDENTITY(1,1) PRIMARY KEY,
    numero_historia AS ('HC-' + RIGHT('000000' + CAST(id_historia AS VARCHAR), 6)) PERSISTED,
    id_paciente INT NOT NULL,
    alergias NVARCHAR(MAX),
    antecedentes_personales NVARCHAR(MAX),
    antecedentes_familiares NVARCHAR(MAX),
    estado BIT DEFAULT 1,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Historia_Paciente FOREIGN KEY (id_paciente) 
        REFERENCES Pacientes(id_paciente)
);
GO

-- Tabla de Consultas Simplificada
CREATE TABLE Consultas (
    id_consulta INT IDENTITY(1,1) PRIMARY KEY,
    numero_consulta AS ('CON-' + RIGHT('000000' + CAST(id_consulta AS VARCHAR), 6)) PERSISTED,
    id_historia INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_consulta DATETIME NOT NULL,
    tipo_enfermedad NVARCHAR(100), -- Campo directo sin tabla de referencia
    historia_enfermedad NVARCHAR(MAX) NOT NULL,
    examen_fisico NVARCHAR(MAX),
    plan_tratamiento NVARCHAR(MAX),
    observaciones NVARCHAR(MAX),
    estado_consulta NVARCHAR(20) DEFAULT 'ACTIVA',
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    usuario_modificacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Consulta_Historia FOREIGN KEY (id_historia) 
        REFERENCES HistoriasClinicas(id_historia),
    CONSTRAINT FK_Consulta_Medico FOREIGN KEY (id_medico) 
        REFERENCES Medicos(id_medico),
    CONSTRAINT CHK_Estado_Consulta CHECK (estado_consulta IN ('ACTIVA', 'CERRADA', 'CANCELADA'))
);
GO

-- Tabla de Indicaciones de Medicamentos
CREATE TABLE IndicacionesMedicamentos (
    id_indicacion INT IDENTITY(1,1) PRIMARY KEY,
    id_medicamento INT NOT NULL,
    indicacion NVARCHAR(MAX) NOT NULL,
    dosis_recomendada NVARCHAR(100),
    frecuencia NVARCHAR(100),
    duracion_maxima NVARCHAR(100),
    via_administracion NVARCHAR(50),
    estado BIT DEFAULT 1,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Indicacion_Medicamento FOREIGN KEY (id_medicamento) 
        REFERENCES Medicamentos(id_medicamento)
);
GO

-- Tabla de Recetas
CREATE TABLE Recetas (
    id_receta INT IDENTITY(1,1) PRIMARY KEY,
    numero_receta AS ('REC-' + RIGHT('000000' + CAST(id_receta AS VARCHAR), 6)) PERSISTED,
    id_consulta INT NOT NULL,
    diagnostico NVARCHAR(MAX) NOT NULL,
    fecha_emision DATETIME DEFAULT GETDATE(),
    fecha_vencimiento DATE,
    sello_medico NVARCHAR(100),
    firma_medico NVARCHAR(100),
    estado_receta NVARCHAR(20) DEFAULT 'VIGENTE',
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    version INT DEFAULT 1,
    
    CONSTRAINT FK_Receta_Consulta FOREIGN KEY (id_consulta) 
        REFERENCES Consultas(id_consulta),
    CONSTRAINT CHK_Estado_Receta CHECK (estado_receta IN ('VIGENTE', 'UTILIZADA', 'VENCIDA', 'CANCELADA'))
);
GO

-- Tabla de Detalles de Recetas
CREATE TABLE DetalleRecetas (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_receta INT NOT NULL,
    id_indicacion INT NOT NULL,
    duracion_tratamiento NVARCHAR(100) NOT NULL,
    cantidad INT NOT NULL,
    instrucciones_adicionales NVARCHAR(MAX),
    fecha_inicio_tratamiento DATE,
    fecha_fin_tratamiento DATE,
    -- Campos de auditoría básicos
    fecha_creacion DATETIME DEFAULT GETDATE(),
    usuario_creacion NVARCHAR(50) DEFAULT SYSTEM_USER,
    
    CONSTRAINT FK_Detalle_Receta FOREIGN KEY (id_receta) 
        REFERENCES Recetas(id_receta),
    CONSTRAINT FK_Detalle_Indicacion FOREIGN KEY (id_indicacion) 
        REFERENCES IndicacionesMedicamentos(id_indicacion),
    CONSTRAINT CHK_Cantidad_Positiva CHECK (cantidad > 0)
);
GO

-- =====================================================
-- PASO 6: TRIGGERS SIMPLES PARA AUDITORÍA
-- =====================================================

-- Trigger simple para Pacientes
CREATE OR ALTER TRIGGER TR_Pacientes_Historial
ON Pacientes
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para INSERT
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion, datos_nuevos)
        SELECT 'Pacientes', id_paciente, 'CREAR', 
               'Paciente creado: ' + nombre_completo,
               'DNI: ' + dni + ', Nacimiento: ' + CONVERT(VARCHAR, fecha_nacimiento, 103)
        FROM inserted;
        
        PRINT 'LOG: Nuevo paciente registrado exitosamente';
    END
    
    -- Para UPDATE
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE Pacientes 
        SET fecha_modificacion = GETDATE(),
            usuario_modificacion = SYSTEM_USER,
            version = version + 1
        WHERE id_paciente IN (SELECT id_paciente FROM inserted);
        
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', i.id_paciente, 'ACTUALIZAR', 
               'Paciente actualizado: ' + i.nombre_completo
        FROM inserted i;
        
        PRINT 'LOG: Información de paciente actualizada exitosamente';
    END
    
    -- Para DELETE
    IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion, datos_anteriores)
        SELECT 'Pacientes', id_paciente, 'ELIMINAR', 
               'Paciente eliminado: ' + nombre_completo,
               'DNI: ' + dni + ', Estado: Inactivo'
        FROM deleted;
        
        PRINT 'LOG: Paciente marcado como inactivo';
    END
END;
GO

-- Trigger simple para Consultas
CREATE OR ALTER TRIGGER TR_Consultas_Historial
ON Consultas
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para INSERT
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Consultas', id_consulta, 'CREAR', 
               'Nueva consulta creada - Tipo: ' + ISNULL(tipo_enfermedad, 'No especificado')
        FROM inserted;
        
        PRINT 'LOG: Nueva consulta médica registrada';
    END
    
    -- Para UPDATE
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE Consultas 
        SET fecha_modificacion = GETDATE(),
            usuario_modificacion = SYSTEM_USER,
            version = version + 1
        WHERE id_consulta IN (SELECT id_consulta FROM inserted);
        
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Consultas', i.id_consulta, 'ACTUALIZAR', 
               'Consulta actualizada - Estado: ' + i.estado_consulta
        FROM inserted i;
        
        PRINT 'LOG: Consulta médica actualizada';
    END
END;
GO

-- =====================================================
-- PASO 7: ÍNDICES BÁSICOS PARA OPTIMIZACIÓN
-- =====================================================

CREATE INDEX IX_Pacientes_DNI ON Pacientes(dni);
CREATE INDEX IX_Pacientes_Nombre ON Pacientes(nombre_completo);
CREATE INDEX IX_Consultas_Fecha ON Consultas(fecha_consulta DESC);
CREATE INDEX IX_Consultas_Estado ON Consultas(estado_consulta);
CREATE INDEX IX_Medicos_Especialidad ON Medicos(id_especialidad);
CREATE INDEX IX_HistoriasClinicas_Paciente ON HistoriasClinicas(id_paciente);
GO

-- =====================================================
-- PASO 8: PROCEDIMIENTOS ALMACENADOS SIMPLES
-- =====================================================

-- Procedimiento simple para registrar un nuevo paciente
CREATE OR ALTER PROCEDURE SP_RegistrarPaciente
    @nombre_completo NVARCHAR(100),
    @dni NVARCHAR(15),
    @fecha_nacimiento DATE,
    @genero CHAR(1),
    @telefono NVARCHAR(15) = NULL,
    @correo NVARCHAR(100) = NULL,
    @direccion NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_contacto INT;
    DECLARE @id_paciente INT;
    DECLARE @mensaje NVARCHAR(200);
    
    -- Validaciones básicas
    IF @nombre_completo IS NULL OR LEN(@nombre_completo) = 0
    BEGIN
        SET @mensaje = 'ERROR: El nombre completo es obligatorio';
        PRINT @mensaje;
        RETURN -1;
    END
    
    IF @dni IS NULL OR LEN(@dni) = 0
    BEGIN
        SET @mensaje = 'ERROR: El DNI es obligatorio';
        PRINT @mensaje;
        RETURN -1;
    END
    
    -- Verificar si el DNI ya existe
    IF EXISTS(SELECT 1 FROM Pacientes WHERE dni = @dni)
    BEGIN
        SET @mensaje = 'ERROR: Ya existe un paciente con el DNI: ' + @dni;
        PRINT @mensaje;
        RETURN -1;
    END
    
    -- Crear información de contacto si se proporciona
    IF @telefono IS NOT NULL OR @correo IS NOT NULL OR @direccion IS NOT NULL
    BEGIN
        INSERT INTO InformacionContacto (telefono_principal, correo_electronico, direccion)
        VALUES (@telefono, @correo, @direccion);
        
        SET @id_contacto = SCOPE_IDENTITY();
        PRINT 'LOG: Información de contacto creada';
    END
    
    -- Crear el paciente
    INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, id_contacto)
    VALUES (@nombre_completo, @dni, @fecha_nacimiento, @genero, @id_contacto);
    
    SET @id_paciente = SCOPE_IDENTITY();
    
    -- Crear historia clínica automáticamente
    INSERT INTO HistoriasClinicas (id_paciente)
    VALUES (@id_paciente);
    
    SET @mensaje = 'ÉXITO: Paciente registrado con ID: ' + CAST(@id_paciente AS VARCHAR);
    PRINT @mensaje;
    
    SELECT @id_paciente as id_paciente_creado;
END;
GO

-- Procedimiento simple para crear una consulta
CREATE OR ALTER PROCEDURE SP_CrearConsulta
    @id_historia INT,
    @id_medico INT,
    @fecha_consulta DATETIME,
    @tipo_enfermedad NVARCHAR(100),
    @historia_enfermedad NVARCHAR(MAX),
    @examen_fisico NVARCHAR(MAX) = NULL,
    @plan_tratamiento NVARCHAR(MAX) = NULL,
    @observaciones NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_consulta INT;
    DECLARE @mensaje NVARCHAR(200);
    
    -- Validaciones básicas
    IF NOT EXISTS(SELECT 1 FROM HistoriasClinicas WHERE id_historia = @id_historia AND estado = 1)
    BEGIN
        SET @mensaje = 'ERROR: La historia clínica no existe o está inactiva';
        PRINT @mensaje;
        RETURN -1;
    END
    
    IF NOT EXISTS(SELECT 1 FROM Medicos WHERE id_medico = @id_medico AND estado = 1)
    BEGIN
        SET @mensaje = 'ERROR: El médico no existe o está inactivo';
        PRINT @mensaje;
        RETURN -1;
    END
    
    IF @historia_enfermedad IS NULL OR LEN(@historia_enfermedad) = 0
    BEGIN
        SET @mensaje = 'ERROR: La historia de enfermedad es obligatoria';
        PRINT @mensaje;
        RETURN -1;
    END
    
    -- Crear la consulta
    INSERT INTO Consultas (
        id_historia, id_medico, fecha_consulta, tipo_enfermedad,
        historia_enfermedad, examen_fisico, plan_tratamiento, observaciones
    )
    VALUES (
        @id_historia, @id_medico, @fecha_consulta, @tipo_enfermedad,
        @historia_enfermedad, @examen_fisico, @plan_tratamiento, @observaciones
    );
    
    SET @id_consulta = SCOPE_IDENTITY();
    SET @mensaje = 'ÉXITO: Consulta creada con ID: ' + CAST(@id_consulta AS VARCHAR);
    PRINT @mensaje;
    
    SELECT @id_consulta as id_consulta_creada;
END;
GO

-- Procedimiento para consultar historial de un paciente
CREATE OR ALTER PROCEDURE SP_ConsultarHistorialPaciente
    @dni_paciente NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @mensaje NVARCHAR(200);
    DECLARE @id_paciente INT;
    
    -- Buscar paciente por DNI
    SELECT @id_paciente = id_paciente 
    FROM Pacientes 
    WHERE dni = @dni_paciente AND estado = 1;
    
    IF @id_paciente IS NULL
    BEGIN
        SET @mensaje = 'ERROR: No se encontró paciente con DNI: ' + @dni_paciente;
        PRINT @mensaje;
        RETURN -1;
    END
    
    -- Mostrar información del paciente
    SELECT 
        p.codigo_paciente,
        p.nombre_completo,
        p.dni,
        p.fecha_nacimiento,
        p.genero,
        CASE WHEN p.es_menor_edad = 1 THEN 'Sí' ELSE 'No' END as es_menor,
        ic.telefono_principal,
        ic.correo_electronico
    FROM Pacientes p
    LEFT JOIN InformacionContacto ic ON p.id_contacto = ic.id_contacto
    WHERE p.id_paciente = @id_paciente;
    
    -- Mostrar consultas
    SELECT 
        c.numero_consulta,
        c.fecha_consulta,
        m.nombre_completo as medico,
        em.nombre_especialidad,
        c.tipo_enfermedad,
        c.estado_consulta
    FROM Consultas c
    INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
    INNER JOIN Medicos m ON c.id_medico = m.id_medico
    INNER JOIN EspecialidadesMedicas em ON m.id_especialidad = em.id_especialidad
    WHERE h.id_paciente = @id_paciente
    ORDER BY c.fecha_consulta DESC;
    
    SET @mensaje = 'ÉXITO: Historial consultado para paciente: ' + @dni_paciente;
    PRINT @mensaje;
END;
GO

-- =====================================================
-- PASO 9: VISTAS SIMPLIFICADAS
-- =====================================================

-- Vista de pacientes completa
CREATE OR ALTER VIEW VW_PacientesCompleto AS
SELECT 
    p.id_paciente,
    p.codigo_paciente,
    p.nombre_completo,
    p.dni,
    p.fecha_nacimiento,
    DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE()) as edad,
    p.genero,
    CASE WHEN p.es_menor_edad = 1 THEN 'Menor' ELSE 'Adulto' END as categoria_edad,
    CASE WHEN p.es_menor_edad = 1 THEN a.nombre_completo ELSE NULL END as apoderado,
    CASE WHEN p.es_menor_edad = 1 THEN a.parentesco ELSE NULL END as parentesco,
    ic.telefono_principal,
    ic.correo_electronico,
    p.fecha_creacion
FROM Pacientes p
LEFT JOIN Apoderados a ON p.id_apoderado = a.id_apoderado
LEFT JOIN InformacionContacto ic ON p.id_contacto = ic.id_contacto
WHERE p.estado = 1;
GO

-- Vista de consultas recientes
CREATE OR ALTER VIEW VW_ConsultasRecientes AS
SELECT TOP 100
    c.numero_consulta,
    p.nombre_completo as paciente,
    p.dni as dni_paciente,
    m.nombre_completo as medico,
    em.nombre_especialidad,
    c.fecha_consulta,
    c.tipo_enfermedad,
    c.estado_consulta
FROM Consultas c
INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
INNER JOIN Medicos m ON c.id_medico = m.id_medico
INNER JOIN EspecialidadesMedicas em ON m.id_especialidad = em.id_especialidad
WHERE c.fecha_consulta >= DATEADD(MONTH, -3, GETDATE())
ORDER BY c.fecha_consulta DESC;
GO

PRINT '=================================================';
PRINT 'BASE DE DATOS NORMALIZADA CREADA EXITOSAMENTE';
PRINT 'Sistema listo para usar con manejo de historial';
PRINT '=================================================';


