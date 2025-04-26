-- Creación de la base de datos
CREATE DATABASE SistemaHistoriasClinicas;
GO

USE SistemaHistoriasClinicas;
GO

-- Tabla de Usuarios (personal médico y administrativo)
CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    dni NVARCHAR(20) NOT NULL UNIQUE,
    correo_electronico NVARCHAR(100) NOT NULL UNIQUE,
    telefono NVARCHAR(20),
    nombre_usuario NVARCHAR(50) NOT NULL UNIQUE,
    contrasena NVARCHAR(255) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    ultimo_acceso DATETIME,
    estado NVARCHAR(10) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo')),
    intentos_fallidos INT DEFAULT 0,
    codigo_recuperacion NVARCHAR(10),
    fecha_codigo_recuperacion DATETIME
);
GO

-- Tabla de Roles de usuario
CREATE TABLE Roles (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    nombre_rol NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(MAX)
);
GO

-- Tabla de relación Usuario-Rol (muchos a muchos)
CREATE TABLE UsuarioRoles (
    id_usuario INT,
    id_rol INT,
    fecha_asignacion DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
);
GO

-- Tabla de Pacientes
CREATE TABLE Pacientes (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    dni NVARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    genero NVARCHAR(10) CHECK (genero IN ('masculino', 'femenino', 'otro')),
    direccion NVARCHAR(MAX),
    telefono NVARCHAR(20),
    correo_electronico NVARCHAR(100),
    contacto_emergencia NVARCHAR(100),
    telefono_emergencia NVARCHAR(20),
    fecha_registro DATETIME DEFAULT GETDATE(),
    estado NVARCHAR(10) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo', 'fallecido'))
);
GO

-- Tabla de Historias Clínicas (principal)
CREATE TABLE HistoriasClinicas (
    id_historia INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    alergias NVARCHAR(MAX),
    antecedentes_familiares NVARCHAR(MAX),
    grupo_sanguineo NVARCHAR(5),
    factor_rh NCHAR(1),
    enfermedades_cronicas NVARCHAR(MAX),
    ultima_actualizacion DATETIME,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);
GO

-- Tabla de Consultas Médicas
CREATE TABLE Consultas (
    id_consulta INT IDENTITY(1,1) PRIMARY KEY,
    id_historia INT NOT NULL,
    id_usuario INT NOT NULL, -- médico que realiza la consulta
    fecha_consulta DATETIME NOT NULL,
    motivo_consulta NVARCHAR(MAX) NOT NULL,
    sintomas NVARCHAR(MAX),
    diagnostico NVARCHAR(MAX),
    tratamiento NVARCHAR(MAX),
    observaciones NVARCHAR(MAX),
    estado NVARCHAR(20) DEFAULT 'programada' CHECK (estado IN ('programada', 'en_proceso', 'completada', 'cancelada')),
    FOREIGN KEY (id_historia) REFERENCES HistoriasClinicas(id_historia),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);
GO

-- Tabla de Documentos Adjuntos
CREATE TABLE Documentos (
    id_documento INT IDENTITY(1,1) PRIMARY KEY,
    id_consulta INT,
    id_historia INT,
    nombre_archivo NVARCHAR(255) NOT NULL,
    tipo_archivo NVARCHAR(50) NOT NULL,
    ruta_archivo NVARCHAR(255) NOT NULL,
    fecha_carga DATETIME DEFAULT GETDATE(),
    descripcion NVARCHAR(MAX),
    tamaño_archivo INT, -- en bytes
    id_usuario_carga INT, -- usuario que sube el documento
    FOREIGN KEY (id_consulta) REFERENCES Consultas(id_consulta),
    FOREIGN KEY (id_historia) REFERENCES HistoriasClinicas(id_historia),
    FOREIGN KEY (id_usuario_carga) REFERENCES Usuarios(id_usuario)
);
GO

-- Tabla de Plantillas de Documentos
CREATE TABLE Plantillas (
    id_plantilla INT IDENTITY(1,1) PRIMARY KEY,
    nombre_plantilla NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX),
    contenido_html NVARCHAR(MAX) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    id_usuario_creador INT,
    estado NVARCHAR(10) DEFAULT 'activa' CHECK (estado IN ('activa', 'inactiva')),
    FOREIGN KEY (id_usuario_creador) REFERENCES Usuarios(id_usuario)
);
GO

-- Tabla de Notificaciones
CREATE TABLE Notificaciones (
    id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT, -- destinatario
    id_paciente INT, -- paciente relacionado
    titulo NVARCHAR(100) NOT NULL,
    mensaje NVARCHAR(MAX) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_programada DATETIME, -- fecha para mostrar la notificación
    estado NVARCHAR(10) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'vista', 'eliminada')),
    tipo NVARCHAR(20) NOT NULL CHECK (tipo IN ('cita', 'seguimiento', 'sistema', 'otro')),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);
GO

-- Tabla de Historial de Cambios (para auditoría)
CREATE TABLE HistorialCambios (
    id_cambio INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada NVARCHAR(50) NOT NULL,
    id_registro INT NOT NULL, -- ID del registro modificado
    id_usuario INT NOT NULL, -- usuario que realizó el cambio
    tipo_cambio NVARCHAR(20) NOT NULL CHECK (tipo_cambio IN ('creacion', 'modificacion', 'eliminacion')),
    fecha_cambio DATETIME DEFAULT GETDATE(),
    detalle_cambio NVARCHAR(MAX), -- JSON con los cambios realizados
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);
GO

-- Tabla de Respaldos
CREATE TABLE Respaldos (
    id_respaldo INT IDENTITY(1,1) PRIMARY KEY,
    fecha_respaldo DATETIME DEFAULT GETDATE(),
    ruta_archivo NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(MAX),
    tamaño_archivo INT, -- en bytes
    estado NVARCHAR(10) NOT NULL CHECK (estado IN ('completo', 'parcial', 'error')),
    id_usuario_responsable INT,
    FOREIGN KEY (id_usuario_responsable) REFERENCES Usuarios(id_usuario)
);
GO

-- Insertar roles básicos
INSERT INTO Roles (nombre_rol, descripcion) VALUES 
('administrador', 'Control total del sistema'),
('médico', 'Acceso a historias clínicas y consultas'),
('enfermero', 'Acceso limitado a historias clínicas'),
('recepcionista', 'Gestión de pacientes y citas');
GO

-- Crear usuario administrador inicial
INSERT INTO Usuarios (nombre, apellido, dni, correo_electronico, telefono, nombre_usuario, contrasena, estado)
VALUES ('Admin', 'Sistema', '00000000', 'admin@sistemaclinico.com', '000000000', 'admin', '$2y$10$abcdefghijklmnopqrstuv', 'activo');
GO

-- Asignar rol de administrador
INSERT INTO UsuarioRoles (id_usuario, id_rol)
VALUES (1, 1);
GO