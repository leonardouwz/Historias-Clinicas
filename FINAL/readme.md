# Sistema de Historias Clínicas para Clínica Dermatológica - Explicación Completa

## Introducción

Este documento explica en detalle el sistema de historias clínicas para una clínica dermatológica, compuesto por dos archivos SQL principales:

1. `HC_1.sql` - Contiene la estructura base de la base de datos
2. `HC_2.sql` - Contiene las funcionalidades avanzadas
3.  usar inser services.msc en la terminal 
Voy a explicar todo el sistema paso a paso, desde la creación de la base de datos hasta las funcionalidades más complejas.

## Estructura Base (HC_1.sql)

### 1. Configuración Inicial

```sql
SET DATEFORMAT dmy
GO
CREATE DATABASE SistemaHistoriasClinicas;
GO
USE SistemaHistoriasClinicas;
```

- **SET DATEFORMAT dmy**: Establece el formato de fecha como día/mes/año (importante para evitar confusiones con formatos de fecha)
- **CREATE DATABASE**: Crea la base de datos llamada "SistemaHistoriasClinicas"
- **USE**: Selecciona esta base de datos para trabajar con ella

### 2. Tipos Personalizados

```sql
exec sp_addtype TNoNulo,'nvarchar(15)','Not null'
exec sp_addtype TNulo,'nvarchar(15)','Null'
exec sp_addtype TTextoCorto,'nvarchar(50)','Null'
exec sp_addtype TTextoMedio,'nvarchar(100)','Not null'
exec sp_addtype TTextoLargo,'nvarchar(255)','Null'
```

Estos son tipos de datos personalizados que se usan para estandarizar los campos en toda la base de datos:

- **TNoNulo**: Texto de hasta 15 caracteres que no puede ser nulo
- **TNulo**: Texto de hasta 15 caracteres que puede ser nulo
- **TTextoCorto**: Texto de hasta 50 caracteres (puede ser nulo)
- **TTextoMedio**: Texto de hasta 100 caracteres (no puede ser nulo)
- **TTextoLargo**: Texto de hasta 255 caracteres (puede ser nulo)

### 3. Tablas de Soporte

#### EspecialidadesMedicas

```sql
CREATE TABLE EspecialidadesMedicas (
    id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre_especialidad TTextoMedio,
    descripcion TTextoLargo,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
```

- Almacena las especialidades médicas (Dermatología General, Estética, etc.)
- **id_especialidad**: Clave primaria autoincremental
- **estado**: 1 para activo, 0 para inactivo (DEFAULT 1)
- **fecha_creacion**: Se llena automáticamente con la fecha actual

#### InformacionContacto

```sql
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
```

- Almacena información de contacto reutilizable para pacientes, médicos y apoderados
- **telefono_principal**: Obligatorio (no nulo)
- Los demás campos son opcionales (pueden ser nulos)

#### HistorialCambios

```sql
CREATE TABLE HistorialCambios (
    id_historial BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_tabla TTextoCorto NOT NULL,
    id_registro INT NOT NULL,
    accion TTextoCorto NOT NULL, -- 'CREAR', 'ACTUALIZAR', 'ELIMINAR'
    descripcion TTextoLargo,
    fecha_cambio DATETIME DEFAULT GETDATE(),
    usuario_cambio TTextoCorto DEFAULT SYSTEM_USER
);
```

- Tabla de auditoría que registra todos los cambios importantes en el sistema
- **nombre_tabla**: En qué tabla ocurrió el cambio
- **id_registro**: ID del registro modificado
- **accion**: Tipo de acción (crear, actualizar, eliminar)
- **usuario_cambio**: Se llena automáticamente con el usuario que hizo el cambio

### 4. Tablas Principales de Personas

#### Apoderados

```sql
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
```

- Almacena información de los apoderados (para pacientes menores de edad)
- **dni**: Debe ser único (no puede haber dos apoderados con mismo DNI)
- **parentesco**: Relación con el paciente (padre, madre, tutor, etc.)
- Relacionada con InformacionContacto

#### Pacientes

```sql
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
```

- **Campos calculados**:
  - **edad_calculada**: Calcula la edad automáticamente basado en fecha_nacimiento
  - **es_menor_edad**: 1 si es menor de 18, 0 si es mayor
- **genero**: Solo permite 'M' (masculino) o 'F' (femenino)
- **id_apoderado**: Solo requerido para menores de edad
- **estado**: 1 para activo, 0 para inactivo

#### Medicos

```sql
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
```

- **numero_colegiatura**: Número único de colegiatura médica
- Relacionado con EspecialidadesMedicas e InformacionContacto

### 5. Tablas de Medicamentos y Tratamientos

#### Medicamentos

```sql
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
```

- Almacena información de medicamentos dermatológicos
- **presentacion**: Forma física del medicamento (crema, gel, etc.)
- **contraindicaciones**: Texto largo con advertencias

#### IndicacionesMedicamentos

```sql
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
```

- Contiene las indicaciones para cada medicamento
- **via_administracion**: Cómo se aplica el medicamento (tópica, oral)
- Relacionada con Medicamentos

### 6. Tablas del Proceso Médico

#### HistoriasClinicas

```sql
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
```

- **tipo_piel**: Clasificación dermatológica de la piel
- **fototipo**: Clasificación de sensibilidad al sol (I-VI)
- Relacionada con Pacientes

#### Consultas

```sql
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
```

- Registra cada consulta médica
- **estado_consulta**: Solo puede ser 'ACTIVA', 'CERRADA' o 'CANCELADA'
- Relacionada con HistoriasClinicas y Medicos

#### Recetas

```sql
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
```

- **fecha_vencimiento**: Fecha en que la receta ya no es válida
- **estado_receta**: Solo puede ser 'VIGENTE', 'UTILIZADA', 'VENCIDA' o 'CANCELADA'
- Relacionada con Consultas

#### DetalleRecetas

```sql
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
```

- Contiene los medicamentos específicos de cada receta
- **cantidad**: Debe ser mayor que 0
- Relacionada con Recetas e IndicacionesMedicamentos

### 7. Datos Iniciales

El script inserta datos básicos para que el sistema pueda funcionar desde el principio:

- 5 especialidades médicas dermatológicas
- 10 medicamentos comunes en dermatología
- Indicaciones para cada medicamento
- Datos de ejemplo para testing (1 médico, 2 pacientes)

## Funcionalidades Avanzadas (HC_2.sql)

### 1. Índices para Optimización

Los índices mejoran el rendimiento de las consultas frecuentes:

```sql
-- Índices para búsquedas frecuentes de pacientes
CREATE NONCLUSTERED INDEX IX_Pacientes_DNI ON Pacientes(dni);
CREATE NONCLUSTERED INDEX IX_Pacientes_Nombre ON Pacientes(nombre_completo);
CREATE NONCLUSTERED INDEX IX_Pacientes_Estado ON Pacientes(estado);

-- Índices para consultas médicas
CREATE NONCLUSTERED INDEX IX_Consultas_Fecha ON Consultas(fecha_consulta DESC);
CREATE NONCLUSTERED INDEX IX_Consultas_Estado ON Consultas(estado_consulta);
```

Estos índices aceleran búsquedas por DNI, nombre de paciente, estado, fechas de consulta, etc.

### 2. Triggers para Auditoría

Los triggers son acciones automáticas que se ejecutan cuando ocurren ciertos eventos:

#### Trigger para Pacientes

```sql
CREATE OR ALTER TRIGGER TR_Pacientes_Historial
ON Pacientes
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    -- Para INSERT (nuevos pacientes)
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', id_paciente, 'CREAR', 
               'Paciente creado: ' + nombre_completo + ' DNI: ' + dni
        FROM inserted;
    END
    
    -- Para UPDATE (modificaciones)
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE Pacientes 
        SET fecha_modificacion = GETDATE()
        WHERE id_paciente IN (SELECT id_paciente FROM inserted);
        
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', i.id_paciente, 'ACTUALIZAR', 
               'Paciente actualizado: ' + i.nombre_completo
        FROM inserted i;
    END
    
    -- Para DELETE (eliminaciones lógicas)
    IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
    BEGIN
        INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion)
        SELECT 'Pacientes', id_paciente, 'ELIMINAR', 
               'Paciente eliminado: ' + nombre_completo + ' DNI: ' + dni
        FROM deleted;
    END
END;
```

Este trigger:
1. Detecta si se está insertando, actualizando o eliminando un paciente
2. Registra automáticamente el cambio en HistorialCambios
3. Actualiza la fecha_modificacion cuando hay cambios

Hay triggers similares para Consultas y Recetas.

### 3. Procedimientos Almacenados

Son conjuntos de instrucciones SQL que se pueden ejecutar como una unidad.

#### SP_RegistrarPaciente

```sql
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
    -- Validaciones
    IF @nombre_completo IS NULL OR LEN(TRIM(@nombre_completo)) = 0
    BEGIN
        PRINT 'ERROR: El nombre completo es obligatorio';
        RETURN -1;
    END
    
    -- Verificar si el DNI ya existe
    IF EXISTS(SELECT 1 FROM Pacientes WHERE dni = @dni)
    BEGIN
        PRINT 'ERROR: Ya existe un paciente con ese DNI';
        RETURN -1;
    END
    
    -- Crear información de contacto
    INSERT INTO InformacionContacto (telefono_principal, correo_electronico, direccion, ciudad)
    VALUES (@telefono, @correo, @direccion, @ciudad);
    SET @id_contacto = SCOPE_IDENTITY();
    
    -- Crear el paciente
    INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, id_contacto)
    VALUES (@nombre_completo, @dni, @fecha_nacimiento, @genero, @id_contacto);
    SET @id_paciente = SCOPE_IDENTITY();
    
    -- Crear historia clínica automáticamente
    INSERT INTO HistoriasClinicas (id_paciente, tipo_piel, fototipo)
    VALUES (@id_paciente, @tipo_piel, @fototipo);
    SET @id_historia = SCOPE_IDENTITY();
END;
```

Este procedimiento:
1. Valida los datos de entrada
2. Crea automáticamente:
   - Información de contacto
   - Registro de paciente
   - Historia clínica asociada
3. Retorna los IDs creados

#### SP_CrearConsulta

```sql
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
END;
```

Este procedimiento:
1. Busca al paciente por DNI
2. Valida que exista y esté activo
3. Crea una nueva consulta asociada a su historia clínica

#### SP_BuscarHistorialPaciente

```sql
CREATE OR ALTER PROCEDURE SP_BuscarHistorialPaciente
    @dni_paciente NVARCHAR(15)
AS
BEGIN
    -- Buscar paciente por DNI
    SELECT @id_paciente = id_paciente 
    FROM Pacientes 
    WHERE dni = @dni_paciente AND estado = 1;
    
    -- Información básica del paciente
    SELECT 
        'INFORMACIÓN DEL PACIENTE' as seccion,
        p.nombre_completo,
        p.dni,
        p.fecha_nacimiento,
        p.edad_calculada as edad,
        CASE p.genero WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Femenino' END as genero
    FROM Pacientes p
    WHERE p.id_paciente = @id_paciente;
    
    -- Historial de consultas
    SELECT 
        'HISTORIAL DE CONSULTAS' as seccion,
        c.fecha_consulta,
        m.nombre_completo as medico,
        em.nombre_especialidad,
        c.motivo_consulta,
        c.tipo_enfermedad
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
        med.nombre as medicamento
    FROM DetalleRecetas dr
    INNER JOIN Recetas r ON dr.id_receta = r.id_receta
    INNER JOIN Consultas c ON r.id_consulta = c.id_consulta
    INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
    INNER JOIN IndicacionesMedicamentos im ON dr.id_indicacion = im.id_indicacion
    INNER JOIN Medicamentos med ON im.id_medicamento = med.id_medicamento
    WHERE h.id_paciente = @id_paciente
      AND r.estado_receta = 'VIGENTE'
    ORDER BY r.fecha_emision DESC;
END;
```

Este procedimiento muestra:
1. Información básica del paciente
2. Todas sus consultas ordenadas por fecha
3. Todas sus recetas vigentes

### 4. Vistas Especializadas

Las vistas son consultas predefinidas que simplifican el acceso a información compleja.

#### VW_PacientesActivos

```sql
CREATE OR ALTER VIEW VW_PacientesActivos AS
SELECT 
    p.id_paciente,
    p.nombre_completo,
    p.dni,
    p.fecha_nacimiento,
    p.edad_calculada as edad,
    CASE p.genero WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Femenino' END as genero,
    ic.telefono_principal,
    h.tipo_piel,
    h.fototipo,
    (SELECT COUNT(*) FROM Consultas c 
     INNER JOIN HistoriasClinicas hc ON c.id_historia = hc.id_historia 
     WHERE hc.id_paciente = p.id_paciente) as total_consultas
FROM Pacientes p
LEFT JOIN InformacionContacto ic ON p.id_contacto = ic.id_contacto
LEFT JOIN HistoriasClinicas h ON p.id_paciente = h.id_paciente
WHERE p.estado = 1;
```

Muestra todos los pacientes activos con información relevante y conteo de consultas.

#### VW_ConsultasRecientes

```sql
CREATE OR ALTER VIEW VW_ConsultasRecientes AS
SELECT 
    c.id_consulta,
    c.fecha_consulta,
    p.nombre_completo as paciente,
    p.dni as dni_paciente,
    m.nombre_completo as medico,
    em.nombre_especialidad as especialidad,
    c.motivo_consulta,
    c.tipo_enfermedad,
    DATEDIFF(DAY, c.fecha_consulta, GETDATE()) as dias_desde_consulta
FROM Consultas c
INNER JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
INNER JOIN Pacientes p ON h.id_paciente = p.id_paciente
INNER JOIN Medicos m ON c.id_medico = m.id_medico
INNER JOIN EspecialidadesMedicas em ON m.id_especialidad = em.id_especialidad
WHERE c.fecha_consulta >= DATEADD(MONTH, -6, GETDATE());
```

Muestra las consultas de los últimos 6 meses con información relevante.

#### VW_EstadisticasDermatologicas

```sql
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
```

Proporciona estadísticas sobre tipos de piel y fototipos de los pacientes.

### 5. Funciones de Utilidad

#### FN_CalcularEdadExacta

```sql
CREATE OR ALTER FUNCTION FN_CalcularEdadExacta(@fecha_nacimiento DATE)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @edad_anos INT;
    DECLARE @edad_meses INT;
    
    SET @edad_anos = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());
    SET @edad_meses = DATEDIFF(MONTH, @fecha_nacimiento, GETDATE()) % 12;
    
    IF @edad_anos >= 1
        RETURN CAST(@edad_anos AS VARCHAR) + ' años';
    ELSE
        RETURN CAST(@edad_meses AS VARCHAR) + ' meses';
END;
```

Calcula la edad exacta en años o meses según corresponda.

#### FN_RiesgoSolar

```sql
CREATE OR ALTER FUNCTION FN_RiesgoSolar(@fototipo NVARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    RETURN CASE @fototipo
        WHEN 'I' THEN 'Muy Alto - Protección extrema'
        WHEN 'II' THEN 'Alto - Protección alta'
        WHEN 'III' THEN 'Moderado - Protección moderada'
        WHEN 'IV' THEN 'Bajo - Protección básica'
        WHEN 'V' THEN 'Muy Bajo - Protección mínima'
        WHEN 'VI' THEN 'Mínimo - Protección ocasional'
        ELSE 'No determinado'
    END;
END;
```

Clasifica el riesgo solar según el fototipo de piel (I-VI).

## Relaciones entre Tablas

El sistema está diseñado con relaciones bien definidas:

1. **Pacientes**:
   - Tienen una **HistoriaClínica** (1 a 1)
   - Pueden tener un **Apoderado** (1 a 0..1)
   - Tienen **InformacionContacto** (1 a 0..1)
   - Pueden tener múltiples **Consultas** (1 a muchos)

2. **Consultas**:
   - Pertenecen a una **HistoriaClínica** (muchos a 1)
   - Son atendidas por un **Médico** (muchos a 1)
   - Pueden generar **Recetas** (1 a muchos)

3. **Recetas**:
   - Contienen múltiples **DetalleRecetas** (1 a muchos)
   - Referencian **IndicacionesMedicamentos** (muchos a 1)

4. **Medicamentos**:
   - Tienen múltiples **IndicacionesMedicamentos** (1 a muchos)
   - Pertenecen a una **EspecialidadMedica** (muchos a 1)

## Flujo del Sistema

1. **Registro de Paciente**:
   - Se crea un paciente con SP_RegistrarPaciente
   - Automáticamente se crea su historia clínica
   - El trigger registra la acción en el historial

2. **Consulta Médica**:
   - Se agenda con SP_CrearConsulta
   - Se registra toda la información clínica
   - El trigger registra la acción

3. **Receta Médica**:
   - Se crea con SP_CrearReceta
   - Se agregan los medicamentos necesarios
   - El trigger registra la acción

4. **Seguimiento**:
   - Se puede consultar el historial completo con SP_BuscarHistorialPaciente
   - Se pueden ver estadísticas con las vistas especializadas

## Consideraciones Finales

Este sistema está diseñado para:

1. **Seguridad**: 
   - Validaciones en todos los procedimientos
   - Auditoría automática de cambios
   - Estados controlados (CHECK constraints)

2. **Rendimiento**:
   - Índices en campos de búsqueda frecuente
   - Vistas optimizadas para reportes

3. **Usabilidad**:
   - Procedimientos que simplifican operaciones complejas
   - Funciones de utilidad para cálculos comunes

4. **Integridad**:
   - Relaciones bien definidas con FOREIGN KEY
   - Restricciones para asegurar calidad de datos

El sistema cubre todo el flujo de trabajo de una clínica dermatológica, desde el registro de pacientes hasta la generación de recetas y estadísticas médicas.
