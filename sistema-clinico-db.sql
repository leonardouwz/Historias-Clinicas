-- Creación de la base de datos
CREATE DATABASE SistemaHistoriasClinicas;
GO

USE SistemaHistoriasClinicas;
GO

-- Creación de tipos de datos personalizados
EXEC sp_addtype TNoNulo, 'nvarchar(15)', 'Not null';
EXEC sp_addtype TNulo, 'nvarchar(15)', 'Null';
GO

-- Tabla de Apoderados (para pacientes menores de edad)
CREATE TABLE Apoderados (
    id_apoderado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo NVARCHAR(100) NOT NULL,
    dni TNoNulo,
    telefono TNulo,
    correo_electronico NVARCHAR(100),
    parentesco NVARCHAR(50) NOT NULL,
    fecha_registro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Pacientes
CREATE TABLE Pacientes (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo NVARCHAR(100) NOT NULL,
    dni TNoNulo UNIQUE,
    telefono TNulo,
    correo_electronico NVARCHAR(100),
    fecha_nacimiento DATE NOT NULL,
    es_menor_edad BIT DEFAULT 0,
    id_apoderado INT NULL,
    fecha_registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Paciente_Apoderado FOREIGN KEY (id_apoderado) REFERENCES Apoderados(id_apoderado),
    CONSTRAINT CHK_Edad_Apoderado CHECK ((es_menor_edad = 1 AND id_apoderado IS NOT NULL) OR (es_menor_edad = 0))
);
GO

-- Tabla de Médicos
CREATE TABLE Medicos (
    id_medico INT IDENTITY(1,1) PRIMARY KEY,
    nombre_completo NVARCHAR(100) NOT NULL,
    dni TNoNulo UNIQUE,
    telefono TNulo,
    correo_electronico NVARCHAR(100),
    especialidad NVARCHAR(100) NOT NULL,
    numero_colegiatura NVARCHAR(50) NOT NULL UNIQUE,
    fecha_registro DATETIME DEFAULT GETDATE(),
    estado BIT DEFAULT 1
);
GO

-- Tabla de Medicamentos
CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX),
    presentacion NVARCHAR(100) NOT NULL,
    contraindicaciones NVARCHAR(MAX),
    estado BIT DEFAULT 1
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
    CONSTRAINT FK_Indicacion_Medicamento FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
);
GO

-- Tabla de Historias Clínicas
CREATE TABLE HistoriasClinicas (
    id_historia INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    alergias NVARCHAR(MAX),
    antecedentes_personales NVARCHAR(MAX),
    antecedentes_familiares NVARCHAR(MAX),
    CONSTRAINT FK_Historia_Paciente FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);
GO

-- Tabla de Consultas Médicas
CREATE TABLE Consultas (
    id_consulta INT IDENTITY(1,1) PRIMARY KEY,
    id_historia INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_consulta DATETIME NOT NULL,
    tipo_enfermedad NVARCHAR(100),
    historia_enfermedad NVARCHAR(MAX) NOT NULL,
    examen_fisico NVARCHAR(MAX),
    plan_tratamiento NVARCHAR(MAX),
    observaciones NVARCHAR(MAX),
    CONSTRAINT FK_Consulta_Historia FOREIGN KEY (id_historia) REFERENCES HistoriasClinicas(id_historia),
    CONSTRAINT FK_Consulta_Medico FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);
GO

-- Tabla de Recetas Médicas
CREATE TABLE Recetas (
    id_receta INT IDENTITY(1,1) PRIMARY KEY,
    id_consulta INT NOT NULL,
    fecha_emision DATETIME DEFAULT GETDATE(),
    diagnostico NVARCHAR(MAX) NOT NULL,
    sello_medico NVARCHAR(100),
    firma_medico NVARCHAR(100),
    CONSTRAINT FK_Receta_Consulta FOREIGN KEY (id_consulta) REFERENCES Consultas(id_consulta)
);
GO

-- Tabla de Detalles de Recetas (Medicamentos prescritos)
CREATE TABLE DetalleRecetas (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_receta INT NOT NULL,
    id_indicacion INT NOT NULL,
    duracion_tratamiento NVARCHAR(100) NOT NULL,
    cantidad INT NOT NULL,
    instrucciones_adicionales NVARCHAR(MAX),
    CONSTRAINT FK_Detalle_Receta FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta),
    CONSTRAINT FK_Detalle_Indicacion FOREIGN KEY (id_indicacion) REFERENCES IndicacionesMedicamentos(id_indicacion)
);
GO

-- Insertar datos de ejemplo
INSERT INTO Apoderados (nombre_completo, dni, telefono, correo_electronico, parentesco)
VALUES 
('María López Pérez', '12345678', '987654321', 'maria.lopez@email.com', 'Madre'),
('Juan García Ruiz', '87654321', '963852741', 'juan.garcia@email.com', 'Padre');
GO

INSERT INTO Pacientes (nombre_completo, dni, telefono, correo_electronico, fecha_nacimiento, es_menor_edad, id_apoderado)
VALUES 
('Carlos Gómez López', '11223344', '912345678', 'carlos.gomez@email.com', '1990-05-15', 0, NULL),
('Ana García López', '22334455', '923456789', 'ana.garcia@email.com', '2015-08-20', 1, 1),
('Luis Fernández García', '33445566', '934567890', 'luis.fernandez@email.com', '2005-03-10', 1, 2);
GO

INSERT INTO Medicos (nombre_completo, dni, telefono, correo_electronico, especialidad, numero_colegiatura)
VALUES ('Dr. Julio Hugo Vega Zuñiga', '44556677', '945678901', 'drvega@clinicava.com', 'Dermatologo', 'CM12345');
GO

INSERT INTO Medicamentos (nombre, descripcion, presentacion, contraindicaciones)
VALUES 
('Clobetasol crema', 'Corticoide tópico de alta potencia', 'Crema 0.05% 30g', 'Hipersensibilidad a corticosteroides, infecciones fúngicas'),
('Aciclovir crema', 'Antiviral para herpes simple', 'Crema 5% 10g', 'Hipersensibilidad al aciclovir'),
('Isotretinoína oral', 'Retinoide sistémico para acné severo', 'Cápsulas 20mg', 'Embarazo, lactancia, insuficiencia hepática'),
('Minoxidil solución', 'Vasodilatador para alopecia', 'Solución 5% 60ml', 'Hipersensibilidad al minoxidil'),
('Tacrolimus ungüento', 'Inmunomodulador tópico', 'Ungüento 0.1% 30g', 'Hipersensibilidad al tacrolimus');
GO

INSERT INTO IndicacionesMedicamentos (id_medicamento, indicacion, dosis_recomendada, frecuencia, duracion_maxima)
VALUES 
(1, 'Dermatitis severa, psoriasis', 'Aplicar capa fina', '2 veces al día', '2 semanas continuas'),
(2, 'Herpes labial recurrente', 'Aplicar sobre lesión', '5 veces al día', '10 días'),
(3, 'Acné noduloquístico severo', '0.5-1 mg/kg/día', '1 vez al día con alimentos', '16-20 semanas'),
(4, 'Alopecia androgénica', '1ml por aplicación', '2 veces al día', 'Uso continuado'),
(5, 'Dermatitis atópica', 'Aplicar capa fina', '2 veces al día', 'Hasta resolución');
GO

-- Crear historias clínicas dermatológicas
INSERT INTO HistoriasClinicas (id_paciente, alergias, antecedentes_personales, antecedentes_familiares)
VALUES 
(1, 'Sulfamidas, fragancias', 'Psoriasis desde los 25 años', 'Melanoma en tío materno'),
(2, 'Lanolina, neomicina', 'Dermatitis atópica desde la infancia', 'Vitíligo en madre'),
(3, 'Yodo, perfumes', 'Acné quístico en adolescencia', 'Esclerosis sistémica en abuela');
GO

-- Crear consultas dermatológicas (corregido formato de fecha)
INSERT INTO Consultas (id_historia, id_medico, fecha_consulta, tipo_enfermedad, historia_enfermedad, examen_fisico, plan_tratamiento)
VALUES 
(1, 1, '2023-10-15T09:30:00', 'Psoriasis en placas', 
 'Paciente refiere exacerbación de placas en codos y rodillas con picor intenso desde hace 3 semanas', 
 'Placas eritematoescamosas bien delimitadas de 2-5 cm en superficies extensoras. Signo de Auspitz positivo.', 
 'Corticoides tópicos potentes, emolientes y fototerapia UVB'),

(2, 1, '2023-10-16T11:00:00', 'Dermatitis atópica moderada', 
 'Niña de 8 años con brote de eccema en pliegues y prurito intenso que interfiere con el sueño', 
 'Piel eritematosa, liquenificada en pliegues antecubitales y poplíteos. Xerosis generalizada.', 
 'Inmunomoduladores tópicos, antihistamínicos orales y plan de hidratación cutánea'),

(3, 1, '2023-10-17T16:45:00', 'Acné quístico severo', 
 'Adolescente de 16 años con lesiones noduloquísticas en cara y espalda resistentes a tratamientos previos', 
 'Múltiples pápulas, pústulas y nódulos inflamatorios en zona T y espalda. Cicatrices hipertróficas incipientes.', 
 'Isotretinoína oral con monitoreo mensual, protección solar estricta y cuidados dermocosméticos');
GO

-- Crear recetas dermatológicas
-- Asegúrate de que las consultas existan antes de crear las recetas
INSERT INTO Recetas (id_consulta, diagnostico, sello_medico, firma_medico)
VALUES 
(1, 'Psoriasis en placas crónica exacerbada', 'Clínica Dermatológica Especializada', 'Dr. Julio Hugo Vega Zuñiga'),
(2, 'Dermatitis atópica moderada con sobreinfección bacteriana', 'Clínica Dermatológica Especializada', 'Dr. Julio Hugo Vega Zuñiga'),
(3, 'Acné conglobata resistente a tratamiento convencional', 'Clínica Dermatológica Especializada', 'Dr. Julio Hugo Vega Zuñiga');
GO

-- Agregar detalles de recetas dermatológicas
-- Asegúrate de que las recetas existan antes de agregar los detalles
INSERT INTO DetalleRecetas (id_receta, id_medicamento, id_indicacion, duracion_tratamiento, cantidad, instrucciones_adicionales)
VALUES 
(1, 1, 1, '4 semanas', 2, 'Aplicar en capa fina solo en áreas afectadas, evitar uso facial'),
(1, 5, 5, '8 semanas', 1, 'Usar como mantenimiento después de controlar brote agudo'),

(2, 5, 5, '6 semanas', 1, 'Aplicar en pliegues afectados dos veces al día'),
(2, 4, 4, 'Continuo', 2, 'Usar en cuero cabelludo en áreas de alopecia'),

(3, 3, 3, '20 semanas', 60, 'Tomar con alimentos grasos para mejorar absorción'),
(3, 2, 2, '2 semanas', 1, 'Aplicar en lesiones inflamatorias como coadyuvante');
GO
