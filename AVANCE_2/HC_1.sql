-- =====================================================
-- PARTE 1: ESTRUCTURA BASE DE DATOS
-- SISTEMA DE HISTORIAS CLÍNICAS - CLÍNICA DERMATOLÓGICA
-- =====================================================
-- Este archivo contiene:
-- - Creación de base de datos
-- - Tipos personalizados
-- - Tablas principales
-- - Relaciones (FOREIGN KEYS)
-- - Datos iniciales básicos
-- =====================================================
-- Configuración inicial importante
SET DATEFORMAT dmy
GO
-- Eliminar base de datos si existe para empezar limpio
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SistemaHistoriasClinicas')
BEGIN
    ALTER DATABASE SistemaHistoriasClinicas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SistemaHistoriasClinicas;
END
GO
CREATE DATABASE SistemaHistoriasClinicas;
GO
USE SistemaHistoriasClinicas;
GO
PRINT 'Iniciando creación de estructura base...'
GO
-- =====================================================
-- PASO 1: CREACIÓN DE TIPOS PERSONALIZADOS
-- =====================================================
-- Crear tipos personalizados como enseñado en clase
exec sp_addtype TNoNulo,'nvarchar(15)','Not null'
exec sp_addtype TNulo,'nvarchar(15)','Null'
exec sp_addtype TTextoCorto,'nvarchar(50)','Null'
exec sp_addtype TTextoMedio,'nvarchar(100)','Not null'
exec sp_addtype TTextoLargo,'nvarchar(255)','Null'
GO
PRINT 'Tipos personalizados creados exitosamente'
GO
-- =====================================================
-- PASO 2: TABLAS DE REFERENCIA Y SOPORTE
-- =====================================================
-- Tabla de Especialidades Dermatológicas
CREATE TABLE EspecialidadesMedicas (
    id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre_especialidad TTextoMedio,
    descripcion TTextoLargo,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO
-- Tabla de Información de Contacto
CREATE TABLE InformacionContacto (
    id_contacto INT IDENTITY(1,1) PRIMARY KEY,
    telefono_principal TNoNulo,
    telefono_secundario TNulo,
    correo_electronico TTextoMedio,
    direccion TTextoLargo,
    ciudad TTextoCorto,
    codigo_postal TNulo,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO
-- Tabla de Historial de Cambios (para auditoría)
CREATE TABLE HistorialCambios (
    id_historial BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_tabla TTextoCorto NOT NULL,
    id_registro INT NOT NULL,
    accion TTextoCorto NOT NULL, -- 'CREAR', 'ACTUALIZAR', 'ELIMINAR'
    descripcion TTextoLargo,
    fecha_cambio DATETIME DEFAULT GETDATE(),
    usuario_cambio TTextoCorto DEFAULT SYSTEM_USER
);
GO
PRINT 'Tablas de soporte creadas exitosamente'
GO
-- =====================================================
-- PASO 3: TABLAS PRINCIPALES DE PERSONAS
-- =====================================================
-- Tabla de Apoderados (para menores de edad)
CREATE TABLE Apoderados (
    id_apoderado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo TTextoMedio,
    dni TNoNulo UNIQUE,
    parentesco TTextoCorto NOT NULL,
    id_contacto INT,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Apoderado_Contacto FOREIGN KEY (id_contacto) 
        REFERENCES InformacionContacto(id_contacto)
);
GO
-- Tabla de Pacientes
CREATE TABLE Pacientes (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo TTextoMedio,
    dni TNoNulo UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) CHECK (genero IN ('M', 'F')) DEFAULT 'M',
    edad_calculada AS (DATEDIFF(YEAR, fecha_nacimiento, GETDATE())),
    es_menor_edad AS (CASE WHEN DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) < 18 THEN 1 ELSE 0 END),
    id_apoderado INT NULL,
    id_contacto INT,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Paciente_Apoderado FOREIGN KEY (id_apoderado) 
        REFERENCES Apoderados(id_apoderado),
    CONSTRAINT FK_Paciente_Contacto FOREIGN KEY (id_contacto) 
        REFERENCES InformacionContacto(id_contacto)
);
GO
-- Tabla de Médicos
CREATE TABLE Medicos (
    id_medico INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo TTextoMedio,
    dni TNoNulo UNIQUE,
    id_especialidad INT NOT NULL,
    numero_colegiatura TTextoCorto NOT NULL UNIQUE,
    id_contacto INT,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Medico_Especialidad FOREIGN KEY (id_especialidad) 
        REFERENCES EspecialidadesMedicas(id_especialidad),
    CONSTRAINT FK_Medico_Contacto FOREIGN KEY (id_contacto) 
        REFERENCES InformacionContacto(id_contacto)
);
GO
PRINT 'Tablas principales de personas creadas exitosamente'
GO
-- =====================================================
-- PASO 4: TABLAS DE MEDICAMENTOS Y TRATAMIENTOS
-- =====================================================
-- Tabla de Medicamentos para dermatología
CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre TTextoMedio,
    principio_activo TTextoMedio,
    descripcion TTextoLargo,
    presentacion TTextoCorto NOT NULL, -- crema, gel, locion, etc.
    concentracion TTextoCorto,
    contraindicaciones NVARCHAR(MAX),
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO
-- Tabla de Indicaciones de Medicamentos
CREATE TABLE IndicacionesMedicamentos (
    id_indicacion INT IDENTITY(1,1) PRIMARY KEY,
    id_medicamento INT NOT NULL,
    indicacion NVARCHAR(MAX) NOT NULL,
    dosis_recomendada TTextoCorto,
    frecuencia TTextoCorto,
    duracion_maxima TTextoCorto,
    via_administracion TTextoCorto, -- topica, oral
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Indicacion_Medicamento FOREIGN KEY (id_medicamento) 
        REFERENCES Medicamentos(id_medicamento)
);
GO
PRINT 'Tablas de medicamentos creadas exitosamente'
GO
-- =====================================================
-- PASO 5: TABLAS DEL PROCESO MÉDICO
-- =====================================================
-- Tabla de Historias Clínicas
CREATE TABLE HistoriasClinicas (
    id_historia INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    alergias NVARCHAR(MAX),
    antecedentes_personales NVARCHAR(MAX),
    antecedentes_familiares NVARCHAR(MAX),
    tipo_piel TTextoCorto, -- grasa, seca, mixta, sensible
    fototipo TTextoCorto, -- I, II, III, IV, V, VI
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Historia_Paciente FOREIGN KEY (id_paciente) 
        REFERENCES Pacientes(id_paciente)
);
GO
-- Tabla de Consultas
CREATE TABLE Consultas (
    id_consulta INT IDENTITY(1,1) PRIMARY KEY,
    id_historia INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_consulta DATETIME NOT NULL,
    motivo_consulta TTextoLargo NOT NULL,
    tipo_enfermedad TTextoMedio, -- acne, dermatitis, psoriasis, etc.
    historia_enfermedad NVARCHAR(MAX) NOT NULL,
    examen_fisico NVARCHAR(MAX),
    plan_tratamiento NVARCHAR(MAX),
    observaciones NVARCHAR(MAX),
    estado_consulta TTextoCorto DEFAULT 'ACTIVA',
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Consulta_Historia FOREIGN KEY (id_historia) 
        REFERENCES HistoriasClinicas(id_historia),
    CONSTRAINT FK_Consulta_Medico FOREIGN KEY (id_medico) 
        REFERENCES Medicos(id_medico),
    CONSTRAINT CHK_Estado_Consulta CHECK (estado_consulta IN ('ACTIVA', 'CERRADA', 'CANCELADA'))
);
GO
-- Tabla de Recetas
CREATE TABLE Recetas (
    id_receta INT IDENTITY(1,1) PRIMARY KEY,
    id_consulta INT NOT NULL,
    diagnostico NVARCHAR(MAX) NOT NULL,
    fecha_emision DATETIME DEFAULT GETDATE(),
    fecha_vencimiento DATE,
    estado_receta TTextoCorto DEFAULT 'VIGENTE',
    fecha_creacion DATETIME DEFAULT GETDATE(),
    
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
    duracion_tratamiento TTextoCorto NOT NULL,
    cantidad INT NOT NULL,
    instrucciones_adicionales NVARCHAR(MAX),
    fecha_inicio_tratamiento DATE,
    fecha_fin_tratamiento DATE,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Detalle_Receta FOREIGN KEY (id_receta) 
        REFERENCES Recetas(id_receta),
    CONSTRAINT FK_Detalle_Indicacion FOREIGN KEY (id_indicacion) 
        REFERENCES IndicacionesMedicamentos(id_indicacion),
    CONSTRAINT CHK_Cantidad_Positiva CHECK (cantidad > 0)
);
GO
PRINT 'Tablas del proceso médico creadas exitosamente'
GO
-- =====================================================
-- PASO 6: DATOS INICIALES BÁSICOS
-- =====================================================
-- Insertar especialidades dermatológicas
INSERT INTO EspecialidadesMedicas (nombre_especialidad, descripcion)
VALUES 
    ('Dermatología General', 'Atención dermatológica general y diagnóstico'),
    ('Dermatología Estética', 'Tratamientos estéticos y antienvejecimiento'),
    ('Dermatología Pediátrica', 'Especialista en piel de niños y adolescentes'),
    ('Tricología', 'Especialista en problemas del cabello y cuero cabelludo'),
    ('Dermatología Quirúrgica', 'Cirugías menores dermatológicas');
GO
PRINT 'Especialidades dermatológicas insertadas'
GO
-- Insertar medicamentos comunes en dermatología
INSERT INTO Medicamentos (nombre, principio_activo, presentacion, concentracion, descripcion)
VALUES 
    ('Tretinoína Crema', 'Tretinoína', 'Crema', '0.025%', 'Para tratamiento del acné'),
    ('Hidrocortisona Crema', 'Hidrocortisona', 'Crema', '1%', 'Antiinflamatorio tópico'),
    ('Ketoconazol Shampoo', 'Ketoconazol', 'Shampoo', '2%', 'Antifúngico para caspa'),
    ('Protector Solar', 'Óxido de Zinc', 'Loción', 'SPF 50', 'Protección solar facial'),
    ('Ácido Salicílico Gel', 'Ácido Salicílico', 'Gel', '2%', 'Exfoliante para acné'),
    ('Clindamicina Gel', 'Clindamicina', 'Gel', '1%', 'Antibiótico tópico para acné'),
    ('Adapaleno Crema', 'Adapaleno', 'Crema', '0.1%', 'Retinoide para acné y fotoenvejecimiento'),
    ('Metronidazol Crema', 'Metronidazol', 'Crema', '0.75%', 'Para rosácea y dermatitis'),
    ('Urea Crema', 'Urea', 'Crema', '10%', 'Hidratante para piel seca'),
    ('Calcipotriol Crema', 'Calcipotriol', 'Crema', '50mcg/g', 'Para psoriasis');
GO
PRINT 'Medicamentos dermatológicos insertados'
GO
-- Crear indicaciones para los medicamentos
INSERT INTO IndicacionesMedicamentos (id_medicamento, indicacion, dosis_recomendada, frecuencia, via_administracion)
VALUES 
    (1, 'Acné vulgar', 'Aplicar capa fina', 'Una vez al día por la noche', 'Tópica'),
    (2, 'Dermatitis atópica', 'Aplicar capa fina', 'Dos veces al día', 'Tópica'),
    (3, 'Dermatitis seborreica', 'Aplicar en cuero cabelludo', 'Tres veces por semana', 'Tópica'),
    (4, 'Protección solar diaria', 'Aplicar 30 min antes de exposición', 'Según necesidad', 'Tópica'),
    (5, 'Comedones y poros obstruidos', 'Aplicar en zona afectada', 'Una vez al día', 'Tópica'),
    (6, 'Acné inflamatorio', 'Aplicar capa fina', 'Dos veces al día', 'Tópica'),
    (7, 'Acné comedogénico', 'Aplicar capa fina', 'Una vez al día por la noche', 'Tópica'),
    (8, 'Rosácea papulopustular', 'Aplicar capa fina', 'Dos veces al día', 'Tópica'),
    (9, 'Xerosis cutánea', 'Aplicar en piel húmeda', 'Dos veces al día', 'Tópica'),
    (10, 'Psoriasis en placas', 'Aplicar capa fina', 'Dos veces al día', 'Tópica');
GO
PRINT 'Indicaciones de medicamentos insertadas'
GO
-- =====================================================
-- PASO 7: DATOS DE EJEMPLO PARA TESTING
-- =====================================================
-- Insertar información de contacto de ejemplo
INSERT INTO InformacionContacto (telefono_principal, correo_electronico, direccion, ciudad)
VALUES 
    ('999123456', 'drsmith@clinica.com', 'Av. Salud 123', 'Lima'),
    ('999234567', 'maria.garcia@email.com', 'Jr. Flores 456', 'Lima'),
    ('999345678', 'juan.perez@email.com', 'Av. Central 789', 'Lima');
GO
-- Insertar médico de ejemplo
INSERT INTO Medicos (nombre_completo, dni, id_especialidad, numero_colegiatura, id_contacto)
VALUES ('Dr. Carlos Smith Rodriguez', '12345678', 1, 'CMP-12345', 1);
GO
-- Insertar paciente de ejemplo
INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, id_contacto)
VALUES 
    ('María García López', '87654321', '15/03/1990', 'F', 2),
    ('Juan Pérez Mendoza', '11223344', '20/07/2010', 'M', 3); -- Menor de edad
GO
-- Crear historias clínicas para los pacientes de ejemplo
INSERT INTO HistoriasClinicas (id_paciente, tipo_piel, fototipo)
VALUES 
    (1, 'mixta', 'III'),
    (2, 'grasa', 'IV');
GO
