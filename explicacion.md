# Explicación Detallada del Sistema de Historias Clínicas

## Creación y Configuración Inicial de la Base de Datos

```sql
-- Creación de la base de datos
CREATE DATABASE SistemaHistoriasClinicas;
GO
```
Esta línea crea una nueva base de datos llamada "SistemaHistoriasClinicas". El comando `CREATE DATABASE` es una instrucción DDL (Data Definition Language) que genera un nuevo contenedor para almacenar todas las tablas y datos del sistema.

```sql
USE SistemaHistoriasClinicas;
GO
```
Esta instrucción selecciona la base de datos recién creada para ejecutar las siguientes operaciones en ella. `GO` es un separador de lotes que indica al motor de SQL Server que debe ejecutar todas las instrucciones anteriores antes de continuar.

## Creación de Tipos de Datos Personalizados

```sql
-- Creación de tipos de datos personalizados
EXEC sp_addtype TNoNulo, 'nvarchar(15)', 'Not null';
EXEC sp_addtype TNulo, 'nvarchar(15)', 'Null';
GO
```
Aquí se crean dos tipos de datos personalizados mediante el procedimiento almacenado `sp_addtype`:
- `TNoNulo`: Un tipo nvarchar(15) que no acepta valores nulos
- `TNulo`: Un tipo nvarchar(15) que sí acepta valores nulos

Estos tipos de datos reutilizables se emplean para estandarizar campos comunes como DNI y teléfono en todo el sistema.

## Estructura de Tablas

### Tabla de Apoderados

```sql
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
```
Esta tabla almacena información de los apoderados o tutores legales de pacientes menores de edad:
- `id_apoderado`: Clave primaria con autoincremento (IDENTITY)
- `nombre_completo`: Nombre completo del apoderado (obligatorio)
- `dni`: Documento de identidad utilizando el tipo personalizado TNoNulo
- `telefono`: Número telefónico utilizando el tipo personalizado TNulo (puede ser nulo)
- `correo_electronico`: Email de contacto
- `parentesco`: Relación con el paciente (obligatorio)
- `fecha_registro`: Fecha de creación con valor predeterminado establecido a la fecha actual

### Tabla de Pacientes

```sql
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
```
Esta tabla almacena la información básica de los pacientes:
- `id_paciente`: Clave primaria con autoincremento
- `nombre_completo`: Nombre completo del paciente
- `dni`: Documento de identidad único
- `telefono`: Número telefónico (puede ser nulo)
- `correo_electronico`: Email de contacto
- `fecha_nacimiento`: Fecha de nacimiento (obligatorio)
- `es_menor_edad`: Indicador booleano (0=adulto, 1=menor)
- `id_apoderado`: Relación con la tabla Apoderados para pacientes menores de edad
- `fecha_registro`: Fecha de creación

**Restricciones:**
- `FK_Paciente_Apoderado`: Clave foránea que vincula al paciente con su apoderado
- `CHK_Edad_Apoderado`: Restricción CHECK que valida que si el paciente es menor de edad (es_menor_edad = 1), debe tener asignado un apoderado

### Tabla de Médicos

```sql
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
```
Esta tabla almacena la información de los médicos que atienden en el sistema:
- `id_medico`: Clave primaria con autoincremento
- `nombre_completo`: Nombre completo del médico
- `dni`: Documento de identidad único
- `telefono`: Número telefónico
- `correo_electronico`: Email profesional
- `especialidad`: Área de especialización médica (obligatorio)
- `numero_colegiatura`: Número único de colegiado profesional
- `fecha_registro`: Fecha de creación
- `estado`: Estado activo (1) o inactivo (0) del médico en el sistema

### Tabla de Medicamentos

```sql
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
```
Esta tabla contiene el catálogo de medicamentos disponibles para prescripción:
- `id_medicamento`: Clave primaria con autoincremento
- `nombre`: Nombre comercial o genérico del medicamento
- `descripcion`: Información detallada sobre el medicamento
- `presentacion`: Forma farmacéutica y dosis (ej. "Crema 0.05% 30g")
- `contraindicaciones`: Situaciones donde no debe administrarse el medicamento
- `estado`: Indica si el medicamento está activo (1) o descontinuado (0)

### Tabla de Indicaciones de Medicamentos

```sql
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
```
Esta tabla almacena las indicaciones terapéuticas específicas para cada medicamento:
- `id_indicacion`: Clave primaria con autoincremento
- `id_medicamento`: Clave foránea que referencia a la tabla Medicamentos
- `indicacion`: Descripción de la condición médica para la que se prescribe
- `dosis_recomendada`: Cantidad recomendada por aplicación
- `frecuencia`: Intervalo de tiempo entre dosis
- `duracion_maxima`: Tiempo máximo de uso recomendado

**Restricciones:**
- `FK_Indicacion_Medicamento`: Clave foránea que vincula la indicación con su medicamento correspondiente

### Tabla de Historias Clínicas

```sql
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
```
Esta tabla almacena el expediente médico principal de cada paciente:
- `id_historia`: Clave primaria con autoincremento
- `id_paciente`: Clave foránea que referencia a la tabla Pacientes
- `fecha_creacion`: Fecha en que se abrió el expediente
- `alergias`: Registro de alergias conocidas del paciente
- `antecedentes_personales`: Historial médico personal relevante
- `antecedentes_familiares`: Historial médico familiar relevante

**Restricciones:**
- `FK_Historia_Paciente`: Clave foránea que vincula la historia clínica con el paciente

### Tabla de Consultas Médicas

```sql
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
```
Esta tabla registra cada visita o consulta médica:
- `id_consulta`: Clave primaria con autoincremento
- `id_historia`: Clave foránea que referencia a la tabla HistoriasClinicas
- `id_medico`: Clave foránea que identifica al médico tratante
- `fecha_consulta`: Fecha y hora de la consulta
- `tipo_enfermedad`: Clasificación o categoría de la enfermedad
- `historia_enfermedad`: Relato detallado del paciente sobre su dolencia
- `examen_fisico`: Hallazgos del examen físico realizado
- `plan_tratamiento`: Plan terapéutico recomendado
- `observaciones`: Notas adicionales del médico

**Restricciones:**
- `FK_Consulta_Historia`: Vincula la consulta con la historia clínica correspondiente
- `FK_Consulta_Medico`: Vincula la consulta con el médico que la realizó

### Tabla de Recetas Médicas

```sql
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
```
Esta tabla registra las prescripciones médicas emitidas:
- `id_receta`: Clave primaria con autoincremento
- `id_consulta`: Clave foránea que referencia a la tabla Consultas
- `fecha_emision`: Fecha de emisión de la receta
- `diagnostico`: Diagnóstico oficial que justifica la medicación
- `sello_medico`: Información del sello profesional
- `firma_medico`: Registro de la firma del médico

**Restricciones:**
- `FK_Receta_Consulta`: Vincula la receta con la consulta que la originó

### Tabla de Detalles de Recetas

```sql
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
```
Esta tabla contiene los detalles específicos de los medicamentos prescritos en cada receta:
- `id_detalle`: Clave primaria con autoincremento
- `id_receta`: Clave foránea que referencia a la tabla Recetas
- `id_indicacion`: Clave foránea que referencia a la tabla IndicacionesMedicamentos
- `duracion_tratamiento`: Periodo específico para el tratamiento prescrito
- `cantidad`: Número de unidades prescritas
- `instrucciones_adicionales`: Instrucciones especiales para el paciente

**Restricciones:**
- `FK_Detalle_Receta`: Vincula el detalle con su receta correspondiente
- `FK_Detalle_Indicacion`: Vincula el detalle con la indicación médica correspondiente

## Datos de Muestra

### Inserción de Apoderados

```sql
-- Insertar datos de ejemplo
INSERT INTO Apoderados (nombre_completo, dni, telefono, correo_electronico, parentesco)
VALUES 
('María López Pérez', '12345678', '987654321', 'maria.lopez@email.com', 'Madre'),
('Juan García Ruiz', '87654321', '963852741', 'juan.garcia@email.com', 'Padre');
GO
```
Se insertan dos registros de apoderados para pacientes menores de edad.

### Inserción de Pacientes

```sql
INSERT INTO Pacientes (nombre_completo, dni, telefono, correo_electronico, fecha_nacimiento, es_menor_edad, id_apoderado)
VALUES 
('Carlos Gómez López', '11223344', '912345678', 'carlos.gomez@email.com', '1990-05-15', 0, NULL),
('Ana García López', '22334455', '923456789', 'ana.garcia@email.com', '2015-08-20', 1, 1),
('Luis Fernández García', '33445566', '934567890', 'luis.fernandez@email.com', '2005-03-10', 1, 2);
GO
```
Se insertan tres pacientes:
- Un adulto sin apoderado
- Dos menores de edad, cada uno vinculado a un apoderado diferente

### Inserción de Médicos

```sql
INSERT INTO Medicos (nombre_completo, dni, telefono, correo_electronico, especialidad, numero_colegiatura)
VALUES ('Dr. Julio Hugo Vega Zuñiga', '44556677', '945678901', 'drvega@clinicava.com', 'Dermatologo', 'CM12345');
GO
```
Se inserta un registro de médico dermatólogo.

### Inserción de Medicamentos

```sql
INSERT INTO Medicamentos (nombre, descripcion, presentacion, contraindicaciones)
VALUES 
('Clobetasol crema', 'Corticoide tópico de alta potencia', 'Crema 0.05% 30g', 'Hipersensibilidad a corticosteroides, infecciones fúngicas'),
('Aciclovir crema', 'Antiviral para herpes simple', 'Crema 5% 10g', 'Hipersensibilidad al aciclovir'),
('Isotretinoína oral', 'Retinoide sistémico para acné severo', 'Cápsulas 20mg', 'Embarazo, lactancia, insuficiencia hepática'),
('Minoxidil solución', 'Vasodilatador para alopecia', 'Solución 5% 60ml', 'Hipersensibilidad al minoxidil'),
('Tacrolimus ungüento', 'Inmunomodulador tópico', 'Ungüento 0.1% 30g', 'Hipersensibilidad al tacrolimus');
GO
```
Se insertan cinco medicamentos dermatológicos con sus respectivas descripciones y contraindicaciones.

### Inserción de Indicaciones de Medicamentos

```sql
INSERT INTO IndicacionesMedicamentos (id_medicamento, indicacion, dosis_recomendada, frecuencia, duracion_maxima)
VALUES 
(1, 'Dermatitis severa, psoriasis', 'Aplicar capa fina', '2 veces al día', '2 semanas continuas'),
(2, 'Herpes labial recurrente', 'Aplicar sobre lesión', '5 veces al día', '10 días'),
(3, 'Acné noduloquístico severo', '0.5-1 mg/kg/día', '1 vez al día con alimentos', '16-20 semanas'),
(4, 'Alopecia androgénica', '1ml por aplicación', '2 veces al día', 'Uso continuado'),
(5, 'Dermatitis atópica', 'Aplicar capa fina', '2 veces al día', 'Hasta resolución');
GO
```
Se insertan las indicaciones específicas para cada medicamento, incluyendo dosis, frecuencia y duración.

### Inserción de Historias Clínicas

```sql
-- Crear historias clínicas dermatológicas
INSERT INTO HistoriasClinicas (id_paciente, alergias, antecedentes_personales, antecedentes_familiares)
VALUES 
(1, 'Sulfamidas, fragancias', 'Psoriasis desde los 25 años', 'Melanoma en tío materno'),
(2, 'Lanolina, neomicina', 'Dermatitis atópica desde la infancia', 'Vitíligo en madre'),
(3, 'Yodo, perfumes', 'Acné quístico en adolescencia', 'Esclerosis sistémica en abuela');
GO
```
Se crean historias clínicas para los tres pacientes, cada una con sus respectivas alergias y antecedentes.

### Inserción de Consultas

```sql
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
```
Se registran tres consultas médicas diferentes, cada una para un paciente, con el mismo médico dermatólogo. Se incluye el formato especial para fechas `YYYY-MM-DDThh:mm:ss` para evitar errores de conversión.

### Inserción de Recetas

```sql
-- Crear recetas dermatológicas
-- Asegúrate de que las consultas existan antes de crear las recetas
INSERT INTO Recetas (id_consulta, diagnostico, sello_medico, firma_medico)
VALUES 
(1, 'Psoriasis en placas crónica exacerbada', 'Clínica Dermatológica Especializada', 'Dr. Julio Hugo Vega Zuñiga'),
(2, 'Dermatitis atópica moderada con sobreinfección bacteriana', 'Clínica Dermatológica Especializada', 'Dr. Julio Hugo Vega Zuñiga'),
(3, 'Acné conglobata resistente a tratamiento convencional', 'Clínica Dermatológica Especializada', 'Dr. Julio Hugo Vega Zuñiga');
GO
```
Se crean tres recetas médicas, una para cada consulta previamente registrada.

### Inserción de Detalles de Recetas

```sql
-- Agregar detalles de recetas dermatológicas
-- Asegúrate de que las recetas existan antes de agregar los detalles
INSERT INTO DetalleRecetas (id_receta, id_indicacion, duracion_tratamiento, cantidad, instrucciones_adicionales)
VALUES 
(1, 1, '4 semanas', 2, 'Aplicar en capa fina solo en áreas afectadas, evitar uso facial'),
(1, 5, '8 semanas', 1, 'Usar como mantenimiento después de controlar brote agudo'),

(2, 5, '6 semanas', 1, 'Aplicar en pliegues afectados dos veces al día'),
(2, 4, 'Continuo', 2, 'Usar en cuero cabelludo en áreas de alopecia'),

(3, 3, '20 semanas', 60, 'Tomar con alimentos grasos para mejorar absorción'),
(3, 2, '2 semanas', 1, 'Aplicar en lesiones inflamatorias como coadyuvante');
GO
```
Se añaden los detalles específicos de medicamentos para cada receta, incluyendo dos medicamentos diferentes por receta.

## Diagrama de Relaciones entre Tablas

El sistema presenta las siguientes relaciones clave:

1. **Apoderados → Pacientes**
   - Un apoderado puede tener varios pacientes (menores) a su cargo
   - Un paciente menor debe tener exactamente un apoderado

2. **Pacientes → Historias Clínicas**
   - Un paciente tiene exactamente una historia clínica
   - Una historia clínica pertenece a un único paciente

3. **Historias Clínicas → Consultas**
   - Una historia clínica puede tener múltiples consultas
   - Cada consulta está asociada a una única historia clínica

4. **Médicos → Consultas**
   - Un médico puede realizar múltiples consultas
   - Cada consulta es realizada por un único médico

5. **Consultas → Recetas**
   - Una consulta puede generar una receta
   - Cada receta está asociada a una única consulta

6. **Recetas → DetalleRecetas**
   - Una receta puede tener múltiples detalles (medicamentos)
   - Cada detalle pertenece a una única receta

7. **Medicamentos → IndicacionesMedicamentos**
   - Un medicamento puede tener múltiples indicaciones
   - Cada indicación está asociada a un único medicamento

8. **IndicacionesMedicamentos → DetalleRecetas**
   - Una indicación puede aparecer en múltiples detalles de recetas
   - Cada detalle de receta tiene una única indicación

Este modelo relacional garantiza la integridad de los datos y refleja adecuadamente el flujo de trabajo en un entorno médico real, desde el registro del paciente hasta la prescripción de medicamentos.
