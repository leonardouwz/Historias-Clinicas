# Sistema de Historias Clínicas

## Descripción
Sistema de gestión de historias clínicas desarrollado para facilitar el manejo de información médica de pacientes, consultas, diagnósticos y tratamientos en centros de salud.

## Características Principales

### Entidades Principales
- **Pacientes**: Gestión completa de información personal y médica
- **Médicos**: Registro de profesionales de la salud
- **Consultas**: Registro de citas y consultas médicas
- **Historias Clínicas**: Expedientes médicos completos
- **Diagnósticos**: Catálogo de diagnósticos médicos
- **Medicamentos**: Base de datos de medicamentos
- **Tratamientos**: Prescripciones y seguimientos

### Funcionalidades del Sistema

#### Gestión de Pacientes
- Registro de nuevos pacientes
- Actualización de información personal
- Consulta de historial médico
- Búsqueda por diferentes criterios

#### Gestión de Consultas
- Programación de citas
- Registro de consultas médicas
- Seguimiento de tratamientos
- Generación de reportes

#### Historias Clínicas
- Creación automática de expedientes
- Actualización continua de información
- Acceso controlado por permisos
- Historial completo de consultas

## Estructura de la Base de Datos

### Tablas Principales

#### pacientes
```sql
- id_paciente (PK)
- nombres
- apellidos
- fecha_nacimiento
- sexo
- documento_identidad
- telefono
- email
- direccion
- fecha_registro
- estado
```

#### medicos
```sql
- id_medico (PK)
- nombres
- apellidos
- especialidad
- numero_colegiado
- telefono
- email
- estado
```

#### consultas
```sql
- id_consulta (PK)
- id_paciente (FK)
- id_medico (FK)
- fecha_consulta
- motivo_consulta
- diagnostico
- observaciones
- estado
```

#### historias_clinicas
```sql
- id_historia (PK)
- id_paciente (FK)
- fecha_creacion
- antecedentes_personales
- antecedentes_familiares
- alergias
- medicamentos_actuales
- observaciones_generales
```

## Procedimientos Almacenados

### sp_RegistrarPaciente
Registra un nuevo paciente en el sistema con validaciones de datos únicos.

### sp_ProgramarConsulta
Programa una nueva consulta verificando disponibilidad del médico.

### sp_ActualizarHistoriaClinica
Actualiza la historia clínica después de cada consulta.

### sp_BuscarPaciente
Búsqueda de pacientes por diferentes criterios (nombre, documento, etc.).

### sp_GenerarReporteConsultas
Genera reportes de consultas por período y médico.

## Funciones

### fn_CalcularEdad
Calcula la edad actual del paciente basada en su fecha de nacimiento.

### fn_ValidarDocumento
Valida el formato del documento de identidad según el tipo.

### fn_ConsultasDelMes
Cuenta las consultas realizadas en un mes específico.

### fn_PacientesActivos
Retorna el número de pacientes activos en el sistema.

## Vistas

### v_ResumenPacientes
Vista que muestra información resumida de pacientes con su última consulta.

### v_ConsultasDetalladas
Vista detallada de consultas con información de paciente y médico.

### v_HistorialesCompletos
Vista que combina historia clínica con todas las consultas del paciente.

### v_EstadisticasMedicos
Vista con estadísticas de consultas por médico.

## Validaciones y Restricciones

### Integridad Referencial
- Todas las consultas deben tener un paciente y médico válidos
- Las historias clínicas están vinculadas a pacientes existentes

### Validaciones de Datos
- Documentos de identidad únicos
- Fechas de nacimiento coherentes
- Formatos de email válidos
- Números de teléfono en formato correcto

### Triggers

#### trg_CrearHistoriaClinica
Se ejecuta automáticamente al registrar un nuevo paciente.

#### trg_ActualizarUltimaConsulta
Actualiza la fecha de última consulta en la tabla de pacientes.

#### trg_ValidarFechaConsulta
Valida que las fechas de consulta no sean futuras ni muy antiguas.

## Índices y Optimización

### Índices Principales
- idx_paciente_documento: Búsqueda rápida por documento
- idx_consulta_fecha: Consultas por rango de fechas
- idx_medico_especialidad: Búsqueda de médicos por especialidad

## Seguridad

### Control de Acceso
- Roles diferenciados: Administrador, Médico, Recepcionista
- Acceso restringido a información sensible
- Auditoría de cambios en registros críticos

### Encriptación
- Datos sensibles encriptados
- Contraseñas hasheadas
- Comunicación segura con la base de datos

## Backup y Recuperación

### Respaldos Automáticos
- Backup completo semanal
- Backup incremental diario
- Log de transacciones cada hora

### Procedimientos de Recuperación
- Plan de recuperación ante desastres
- Pruebas regulares de restauración

## Instalación y Configuración

### Requisitos del Sistema
- SQL Server 2019 o superior
- 4GB RAM mínimo
- 100GB espacio en disco

### Scripts de Instalación
1. Ejecutar `01_crear_base_datos.sql`
2. Ejecutar `02_crear_tablas.sql`
3. Ejecutar `03_procedimientos.sql`
4. Ejecutar `04_datos_iniciales.sql`

## Uso del Sistema

### Registro de Nuevo Paciente
```sql
EXEC sp_RegistrarPaciente 
    @nombres = 'Juan Carlos',
    @apellidos = 'Pérez García',
    @documento = '12345678',
    @fecha_nac = '1985-05-15'
```

### Programar Consulta
```sql
EXEC sp_ProgramarConsulta
    @id_paciente = 1,
    @id_medico = 2,
    @fecha = '2024-12-15 10:00:00',
    @motivo = 'Control general'
```

## Mantenimiento

### Tareas Regulares
- Limpieza de logs antiguos
- Reindexación mensual
- Actualización de estadísticas
- Verificación de integridad

### Monitoreo
- Alertas por espacio en disco
- Monitoreo de rendimiento
- Logs de errores automáticos

## Documentación Técnica

### Diagramas
- Diagrama Entidad-Relación (incluir archivo)
- Diagrama de Arquitectura
- Flujos de Procesos

### Manuales
- Manual de Usuario
- Manual de Administrador
- Guía de Troubleshooting

## Contacto y Soporte

**Desarrollador**: [Tu Nombre]  
**Email**: [tu.email@ejemplo.com]  
**Versión**: 1.0  
**Última Actualización**: Diciembre 2024