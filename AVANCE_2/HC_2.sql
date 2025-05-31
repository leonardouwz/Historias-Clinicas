-- =====================================================
-- PARTE 2: FUNCIONALIDADES AVANZADAS
-- SISTEMA DE HISTORIAS CLÍNICAS - CLÍNICA DERMATOLÓGICA
-- =====================================================
-- Este archivo contiene:
-- - Índices para optimización
-- - Triggers para auditoría
-- - Procedimientos almacenados
-- - Vistas especializadas
-- - Funciones de utilidad
-- =====================================================
-- REQUISITO: Ejecutar primero 01_Estructura_Base.sql
USE SistemaHistoriasClinicas;
GO
PRINT 'Iniciando creación de funcionalidades avanzadas...'
GO
-- =====================================================
-- PASO 1: ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
-- =====================================================
-- Índices básicos para auditoría
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Historial_Tabla')
    CREATE NONCLUSTERED INDEX IX_Historial_Tabla ON HistorialCambios(nombre_tabla);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Historial_Fecha')
    CREATE NONCLUSTERED INDEX IX_Historial_Fecha ON HistorialCambios(fecha_cambio DESC);
GO
-- Índices para búsquedas frecuentes de pacientes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Pacientes_DNI')
    CREATE NONCLUSTERED INDEX IX_Pacientes_DNI ON Pacientes(dni);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Pacientes_Nombre')
    CREATE NONCLUSTERED INDEX IX_Pacientes_Nombre ON Pacientes(nombre_completo);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Pacientes_Estado')
    CREATE NONCLUSTERED INDEX IX_Pacientes_Estado ON Pacientes(estado);
GO
-- Índices para consultas médicas (fecha es muy importante para ordenamiento)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Consultas_Fecha')
    CREATE NONCLUSTERED INDEX IX_Consultas_Fecha ON Consultas(fecha_consulta DESC);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Consultas_Estado')
    CREATE NONCLUSTERED INDEX IX_Consultas_Estado ON Consultas(estado_consulta);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Consultas_Tipo')
    CREATE NONCLUSTERED INDEX IX_Consultas_Tipo ON Consultas(tipo_enfermedad);
GO
-- Índices para médicos y especialidades
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Medicos_Especialidad')
    CREATE NONCLUSTERED INDEX IX_Medicos_Especialidad ON Medicos(id_especialidad);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Medicos_Estado')
    CREATE NONCLUSTERED INDEX IX_Medicos_Estado ON Medicos(estado);
GO
-- Índices para historias clínicas
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_HistoriasClinicas_Paciente')
    CREATE NONCLUSTERED INDEX IX_HistoriasClinicas_Paciente ON HistoriasClinicas(id_paciente);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_HistoriasClinicas_TipoPiel')
    CREATE NONCLUSTERED INDEX IX_HistoriasClinicas_TipoPiel ON HistoriasClinicas(tipo_piel);
GO
-- Índices para recetas y medicamentos
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Recetas_Estado')
    CREATE NONCLUSTERED INDEX IX_Recetas_Estado ON Recetas(estado_receta);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Recetas_Fecha')
    CREATE NONCLUSTERED INDEX IX_Recetas_Fecha ON Recetas(fecha_emision DESC);
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Medicamentos_Nombre')
    CREATE NONCLUSTERED INDEX IX_Medicamentos_Nombre ON Medicamentos(nombre);
GO
PRINT 'Índices de optimización creados exitosamente'
GO
-- =====================================================
-- PASO 2: TRIGGERS PARA AUDITORÍA AUTOMÁTICA
-- =====================================================
-- Trigger para auditoría de Pacientes
CREATE OR ALTER TRIGGER TR_Pacientes_Historial
ON Pacientes
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para INSERT (nuevos pacientes)
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', id_paciente, 'CREAR', 
               'Paciente creado: ' + nombre_completo + ' DNI: ' + dni
        FROM inserted;
        
        PRINT 'LOG: Nuevo paciente registrado en el sistema';
    END
    
    -- Para UPDATE (modificaciones)
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        -- Actualizar fecha de modificación automáticamente
        UPDATE Pacientes 
        SET fecha_modificacion = GETDATE()
        WHERE id_paciente IN (SELECT id_paciente FROM inserted);
        
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', i.id_paciente, 'ACTUALIZAR', 
               'Paciente actualizado: ' + i.nombre_completo
        FROM inserted i;
        
        PRINT 'LOG: Información de paciente actualizada';
    END
    
    -- Para DELETE (eliminaciones lógicas)
    IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', id_paciente, 'ELIMINAR', 
               'Paciente eliminado: ' + nombre_completo + ' DNI: ' + dni
        FROM deleted;
        
        PRINT 'LOG: Paciente marcado como inactivo';
    END
END;
GO
-- Trigger para auditoría de Consultas
CREATE OR ALTER TRIGGER TR_Consultas_Historial
ON Consultas
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para INSERT (nuevas consultas)
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Consultas', id_consulta, 'CREAR', 
               'Nueva consulta: ' + ISNULL(tipo_enfermedad, 'No especificado') + ' - ' + motivo_consulta
        FROM inserted;
        
        PRINT 'LOG: Nueva consulta médica registrada';
    END
    
    -- Para UPDATE (modificaciones de consultas)
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        -- Actualizar fecha de modificación automáticamente
        UPDATE Consultas 
        SET fecha_modificacion = GETDATE()
        WHERE id_consulta IN (SELECT id_consulta FROM inserted);
        
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Consultas', i.id_consulta, 'ACTUALIZAR', 
               'Consulta actualizada - Estado: ' + i.estado_consulta + ' - Tipo: ' + ISNULL(i.tipo_enfermedad, 'N/A')
        FROM inserted i;
        
        PRINT 'LOG: Consulta médica actualizada';
    END
END;
GO
-- Trigger para auditoría de Recetas
CREATE OR ALTER TRIGGER TR_Recetas_Historial
ON Recetas
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para INSERT (nuevas recetas)
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Recetas', id_receta, 'CREAR', 
               'Nueva receta creada - Diagnóstico: ' + LEFT(diagnostico, 100)
        FROM inserted;
        
        PRINT 'LOG: Nueva receta médica creada';
    END
    
    -- Para UPDATE (cambios de estado de recetas)
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Recetas', i.id_receta, 'ACTUALIZAR', 
               'Estado de receta cambiado a: ' + i.estado_receta
        FROM inserted i;
        
        PRINT 'LOG: Estado de receta actualizado';
    END
END;
GO
PRINT 'Triggers de auditoría creados exitosamente'
GO
-- =====================================================
-- PASO 3: PROCEDIMIENTOS ALMACENADOS PRINCIPALES
-- =====================================================
-- Procedimiento para registrar paciente completo
CREATE OR ALTER PROCEDURE SP_RegistrarPaciente
    @nombre_completo NVARCHAR(100),
    @dni NVARCHAR(15),
    @fecha_nacimiento DATE,
    @genero CHAR(1),
    @telefono NVARCHAR(15) = NULL,
    @correo NVARCHAR(100) = NULL,
    @direccion NVARCHAR(255) = NULL,
    @ciudad NVARCHAR(50) = NULL,
    @tipo_piel NVARCHAR(50) = NULL,
    @fototipo NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_contacto INT;
    DECLARE @id_paciente INT;
    DECLARE @id_historia INT;
    DECLARE @mensaje NVARCHAR(200);
    
    -- Validaciones básicas
    IF @nombre_completo IS NULL OR LEN(TRIM(@nombre_completo)) = 0
    BEGIN
        PRINT 'ERROR: El nombre completo es obligatorio';
        RETURN -1;
    END
    
    IF @dni IS NULL OR LEN(TRIM(@dni)) = 0
    BEGIN
        PRINT 'ERROR: El DNI es obligatorio';
        RETURN -1;
    END
    
    -- Verificar si el DNI ya existe
    IF EXISTS(SELECT 1 FROM Pacientes WHERE dni = @dni)
    BEGIN
        PRINT 'ERROR: Ya existe un paciente con ese DNI';
        RETURN -1;
    END
    
    -- Verificar formato de género
    IF @genero NOT IN ('M', 'F')
    BEGIN
        PRINT 'ERROR: El género debe ser M o F';
        RETURN -1;
    END
    
    -- Crear información de contacto si se proporciona
    IF @telefono IS NOT NULL OR @correo IS NOT NULL OR @direccion IS NOT NULL
    BEGIN
        INSERT INTO InformacionContacto (telefono_principal, correo_electronico, direccion, ciudad)
        VALUES (@telefono, @correo, @direccion, @ciudad);
        SET @id_contacto = SCOPE_IDENTITY();
        PRINT 'INFO: Información de contacto registrada';
    END
    
    -- Crear el paciente
    INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, id_contacto)
    VALUES (@nombre_completo, @dni, @fecha_nacimiento, @genero, @id_contacto);
    SET @id_paciente = SCOPE_IDENTITY();
    
    -- Crear historia clínica automáticamente
    INSERT INTO HistoriasClinicas (id_paciente, tipo_piel, fototipo)
    VALUES (@id_paciente, @tipo_piel, @fototipo);
    SET @id_historia = SCOPE_IDENTITY();
    
    SET @mensaje = 'ÉXITO: Paciente registrado - ID: ' + CAST(@id_paciente AS VARCHAR) + ', Historia: ' + CAST(@id_historia AS VARCHAR);
    PRINT @mensaje;
    
    -- Retornar IDs creados
    SELECT @id_paciente as id_paciente_creado, @id_historia as id_historia_creada;
END;
GO
-- Procedimiento para crear consulta completa
CREATE OR ALTER PROCEDURE SP_CrearConsulta
    @dni_paciente NVARCHAR(15),
    @id_medico INT,
    @fecha_consulta DATETIME,
    @motivo_consulta NVARCHAR(255),
    @tipo_enfermedad NVARCHAR(100),
    @historia_enfermedad NVARCHAR(MAX),
    @examen_fisico NVARCHAR(MAX) = NULL,
    @plan_tratamiento NVARCHAR(MAX) = NULL,
    @observaciones NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_historia INT;
    DECLARE @id_consulta INT;
    DECLARE @mensaje NVARCHAR(200);
    
    -- Buscar historia clínica del paciente
    SELECT @id_historia = h.id_historia
    FROM HistoriasClinicas h
    INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
    WHERE p.dni = @dni_paciente AND p.estado = 1 AND h.estado = 1;
    
    -- Validaciones
    IF @id_historia IS NULL
    BEGIN
        PRINT 'ERROR: No se encontró paciente activo con ese DNI';
        RETURN -1;
    END
    
    IF NOT EXISTS(SELECT 1 FROM Medicos WHERE id_medico = @id_medico AND estado = 1)
    BEGIN
        PRINT 'ERROR: El médico no existe o está inactivo';
        RETURN -1;
    END
    
    IF @historia_enfermedad IS NULL OR LEN(TRIM(@historia_enfermedad)) = 0
    BEGIN
        PRINT 'ERROR: La historia de enfermedad es obligatoria';
        RETURN -1;
    END
    
    -- Crear la consulta
    INSERT INTO Consultas (
        id_historia, id_medico, fecha_consulta, motivo_consulta,
        tipo_enfermedad, historia_enfermedad, examen_fisico, 
        plan_tratamiento, observaciones
    )
    VALUES (
        @id_historia, @id_medico, @fecha_consulta, @motivo_consulta,
        @tipo_enfermedad, @historia_enfermedad, @examen_fisico, 
        @plan_tratamiento, @observaciones
    );
    
    SET @id_consulta = SCOPE_IDENTITY();
    SET @mensaje = 'ÉXITO: Consulta creada con ID: ' + CAST(@id_consulta AS VARCHAR);
    PRINT @mensaje;
    
    SELECT @id_consulta as id_consulta_creada;
END;
GO
-- Procedimiento para buscar historial completo de paciente
CREATE OR ALTER PROCEDURE SP_BuscarHistorialPaciente
    @dni_paciente NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_paciente INT;
    DECLARE @mensaje NVARCHAR(200);
    
    -- Buscar paciente por DNI
    SELECT @id_paciente = id_paciente 
    FROM Pacientes 
    WHERE dni = @dni_paciente AND estado = 1;
    
    IF @id_paciente IS NULL
    BEGIN
        PRINT 'ERROR: No se encontró paciente con ese DNI';
        RETURN -1;
    END
    
    -- Información básica del paciente
    SELECT 
        'INFORMACIÓN DEL PACIENTE' as seccion,
        p.nombre_completo,
        p.dni,
        p.fecha_nacimiento,
        p.edad_calculada as edad,
        CASE p.genero WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Femenino' END as genero,
        CASE WHEN p.es_menor_edad = 1 THEN 'Sí' ELSE 'No' END as es_menor,
        ic.telefono_principal,
        ic.correo_electronico,
        ic.direccion,
        h.tipo_piel,
        h.fototipo,
        h.alergias,
        h.antecedentes_personales,
        h.antecedentes_familiares
    FROM Pacientes p
    LEFT JOIN InformacionContacto ic ON p.id_contacto = ic.id_contacto
    LEFT JOIN HistoriasClinicas h ON p.id_paciente = h.id_paciente
    WHERE p.id_paciente = @id_paciente;
    
    -- Historial de consultas
    SELECT 
        'HISTORIAL DE CONSULTAS' as seccion,
        c.fecha_consulta,
        m.nombre_completo as medico,
        em.nombre_especialidad,
        c.motivo_consulta,
        c.tipo_enfermedad,
        c.historia_enfermedad,
        c.examen_fisico,
        c.plan_tratamiento,
        c.observaciones,
        c.estado_consulta
    FROM Consultas c
    INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
    INNER JOIN Medicos m ON c.id_medico = m.id_medico
    INNER JOIN EspecialidadesMedicas em ON m.id_especialidad = em.id_especialidad
    WHERE h.id_paciente = @id_paciente
    ORDER BY c.fecha_consulta DESC;
    
    -- Recetas activas
    SELECT 
        'RECETAS ACTIVAS' as seccion,
        r.fecha_emision,
        r.diagnostico,
        med.nombre as medicamento,
        med.principio_activo,
        im.dosis_recomendada,
        im.frecuencia,
        dr.duracion_tratamiento,
        dr.instrucciones_adicionales,
        r.estado_receta
    FROM DetalleRecetas dr
    INNER JOIN Recetas r ON dr.id_receta = r.id_receta
    INNER JOIN Consultas c ON r.id_consulta = c.id_consulta
    INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
    INNER JOIN IndicacionesMedicamentos im ON dr.id_indicacion = im.id_indicacion
    INNER JOIN Medicamentos med ON im.id_medicamento = med.id_medicamento
    WHERE h.id_paciente = @id_paciente
      AND r.estado_receta = 'VIGENTE'
      AND (dr.fecha_fin_tratamiento IS NULL OR dr.fecha_fin_tratamiento >= GETDATE())
    ORDER BY r.fecha_emision DESC;
    
    SET @mensaje = 'ÉXITO: Historial completo mostrado para paciente: ' + @dni_paciente;
    PRINT @mensaje;
END;
GO
-- Procedimiento para crear receta con medicamentos
CREATE OR ALTER PROCEDURE SP_CrearReceta
    @id_consulta INT,
    @diagnostico NVARCHAR(MAX),
    @medicamentos_json NVARCHAR(MAX) -- Lista de medicamentos en formato simple
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @id_receta INT;
    DECLARE @mensaje NVARCHAR(200);
    
    -- Validaciones
    IF NOT EXISTS(SELECT 1 FROM Consultas WHERE id_consulta = @id_consulta)
    BEGIN
        PRINT 'ERROR: La consulta no existe';
        RETURN -1;
    END
    
    IF @diagnostico IS NULL OR LEN(TRIM(@diagnostico)) = 0
    BEGIN
        PRINT 'ERROR: El diagnóstico es obligatorio';
        RETURN -1;
    END
    
    -- Crear la receta
    INSERT INTO Recetas (id_consulta, diagnostico, fecha_vencimiento)
    VALUES (@id_consulta, @diagnostico, DATEADD(MONTH, 3, GETDATE()));
    
    SET @id_receta = SCOPE_IDENTITY();
    SET @mensaje = 'ÉXITO: Receta creada con ID: ' + CAST(@id_receta AS VARCHAR);
    PRINT @mensaje;
    
    SELECT @id_receta as id_receta_creada;
END;
GO
PRINT 'Procedimientos almacenados creados exitosamente'
GO
-- =====================================================
-- PASO 4: VISTAS ESPECIALIZADAS
-- =====================================================
-- Vista completa de pacientes activos
CREATE OR ALTER VIEW VW_PacientesActivos AS
SELECT 
    p.id_paciente,
    p.nombre_completo,
    p.dni,
    p.fecha_nacimiento,
    p.edad_calculada as edad,
    CASE p.genero WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Femenino' END as genero,
    CASE WHEN p.es_menor_edad = 1 THEN 'Menor' ELSE 'Adulto' END as categoria_edad,
    ic.telefono_principal,
    ic.correo_electronico,
    ic.direccion,
    h.tipo_piel,
    h.fototipo,
    p.fecha_creacion,
    (SELECT COUNT(*) FROM Consultas c 
     INNER JOIN HistoriasClinicas hc ON c.id_historia = hc.id_historia 
     WHERE hc.id_paciente = p.id_paciente) as total_consultas
FROM Pacientes p
LEFT JOIN InformacionContacto ic ON p.id_contacto = ic.id_contacto
LEFT JOIN HistoriasClinicas h ON p.id_paciente = h.id_paciente
WHERE p.estado = 1;
GO
-- Vista de consultas recientes con información completa
CREATE OR ALTER VIEW VW_ConsultasRecientes AS
SELECT 
    c.id_consulta,
    c.fecha_consulta,
    p.nombre_completo as paciente,
    p.dni as dni_paciente,
    p.edad_calculada as edad_paciente,
    m.nombre_completo as medico,
    em.nombre_especialidad as especialidad,
    c.motivo_consulta,
    c.tipo_enfermedad,
    c.estado_consulta,
    DATEDIFF(DAY, c.fecha_consulta, GETDATE()) as dias_desde_consulta
FROM Consultas c
INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
INNER JOIN Medicos m ON c.id_medico = m.id_medico
INNER JOIN EspecialidadesMedicas em ON m.id_especialidad = em.id_especialidad
WHERE c.fecha_consulta >= DATEADD(MONTH, -6, GETDATE());
GO
-- Vista de estadísticas dermatológicas
CREATE OR ALTER VIEW VW_EstadisticasDermatologicas AS
SELECT 
    'Distribución por tipo de piel' as categoria,
    h.tipo_piel as valor,
    COUNT(*) as cantidad,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HistoriasClinicas WHERE tipo_piel IS NOT NULL) AS DECIMAL(5,2)) as porcentaje
FROM HistoriasClinicas h
INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
WHERE h.tipo_piel IS NOT NULL AND p.estado = 1
GROUP BY h.tipo_piel
UNION ALL
SELECT 
    'Distribución por fototipo' as categoria,
    h.fototipo as valor,
    COUNT(*) as cantidad,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HistoriasClinicas WHERE fototipo IS NOT NULL) AS DECIMAL(5,2)) as porcentaje
FROM HistoriasClinicas h
INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
WHERE h.fototipo IS NOT NULL AND p.estado = 1
GROUP BY h.fototipo;
GO
-- Vista de medicamentos más utilizados
CREATE OR ALTER VIEW VW_MedicamentosMasUtilizados AS
SELECT 
    med.nombre as medicamento,
    med.principio_activo,
    med.presentacion,
    med.concentracion,
    COUNT(dr.id_detalle) as veces_recetado,
    COUNT(DISTINCT r.id_consulta) as consultas_diferentes
FROM Medicamentos med
INNER JOIN IndicacionesMedicamentos im ON med.id_medicamento = im.id_medicamento
INNER JOIN DetalleRecetas dr ON im.id_indicacion = dr.id_indicacion
INNER JOIN Recetas r ON dr.id_receta = r.id_receta
WHERE r.fecha_emision >= DATEADD(MONTH, -12, GETDATE())
  AND med.estado = 1
GROUP BY med.nombre, med.principio_activo, med.presentacion, med.concentracion;
GO
-- Vista de agenda diaria
CREATE OR ALTER VIEW VW_AgendaDiaria AS
SELECT 
    c.fecha_consulta,
    CONVERT(VARCHAR(5), c.fecha_consulta, 108) as hora,
    p.nombre_completo as paciente,
    p.dni,
    p.edad_calculada as edad,
    ic.telefono_principal,
    m.nombre_completo as medico,
    c.motivo_consulta,
    c.estado_consulta
FROM Consultas c
INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
INNER JOIN Medicos m ON c.id_medico = m.id_medico
LEFT JOIN InformacionContacto ic ON p.id_contacto = ic.id_contacto
WHERE CAST(c.fecha_consulta AS DATE) = CAST(GETDATE() AS DATE)
  AND c.estado_consulta = 'ACTIVA';
GO
PRINT 'Vistas especializadas creadas exitosamente'
GO
-- =====================================================
-- PASO 5: FUNCIONES DE UTILIDAD
-- =====================================================
-- Función para calcular edad exacta
CREATE OR ALTER FUNCTION FN_CalcularEdadExacta(@fecha_nacimiento DATE)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @edad_anos INT;
    DECLARE @edad_meses INT;
    DECLARE @resultado NVARCHAR(50);
    
    SET @edad_anos = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());
    SET @edad_meses = DATEDIFF(MONTH, @fecha_nacimiento, GETDATE()) % 12;
    
    IF @edad_anos >= 1
        SET @resultado = CAST(@edad_anos AS VARCHAR) + ' años';
    ELSE
        SET @resultado = CAST(@edad_meses AS VARCHAR) + ' meses';
    
    RETURN @resultado;
END;
GO
-- Función para determinar categoría de riesgo solar según fototipo
CREATE OR ALTER FUNCTION FN_RiesgoSolar(@fototipo NVARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @riesgo NVARCHAR(50);
    
    SET @riesgo = CASE @fototipo
        WHEN 'I' THEN 'Muy Alto - Protección extrema'
        WHEN 'II' THEN 'Alto - Protección alta'
        WHEN 'III' THEN 'Moderado - Protección moderada'
        WHEN 'IV' THEN 'Bajo - Protección básica'
        WHEN 'V' THEN 'Muy Bajo - Protección mínima'
        WHEN 'VI' THEN 'Mínimo - Protección ocasional'
        ELSE 'No determinado'
    END;
    
    RETURN @riesgo;
END;
GO
PRINT 'Funciones de utilidad creadas exitosamente'
GO
