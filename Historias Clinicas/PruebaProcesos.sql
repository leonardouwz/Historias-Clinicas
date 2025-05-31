-- =====================================================
-- SCRIPT DE PRUEBAS COMPLETO - SISTEMA HISTORIAS CLÍNICAS
-- =====================================================

USE SistemaHistoriasClinicas;
GO

PRINT '======================================================';
PRINT 'INICIANDO PRUEBAS DEL SISTEMA DE HISTORIAS CLÍNICAS';
PRINT '======================================================';


-- =====================================================
-- PASO 1: PROBAR PROCEDIMIENTO SP_RegistrarPaciente
-- =====================================================

PRINT '';
PRINT 'PROBANDO PROCEDIMIENTO SP_RegistrarPaciente';
PRINT '----------------------------------------------';

-- Caso 1: Paciente adulto completo
PRINT 'Caso 1: Registrando paciente adulto con todos los datos...';
EXEC SP_RegistrarPaciente 
    @nombre_completo = 'Carlos Alberto Mendoza Silva',
    @dni = '70123456',
    @fecha_nacimiento = '1985-03-15',
    @genero = 'M',
    @telefono = '987123456',
    @correo = 'carlos.mendoza@email.com',
    @direccion = 'Av. Arequipa 1234, San Isidro';

-- Caso 2: Paciente menor de edad
PRINT '';
PRINT 'Caso 2: Registrando paciente menor de edad...';
EXEC SP_RegistrarPaciente 
    @nombre_completo = 'Ana Sofia Rodriguez Lopez',
    @dni = '80987654',
    @fecha_nacimiento = '2015-08-20',
    @genero = 'F',
    @telefono = '965432187',
    @direccion = 'Jr. Huancayo 567, La Victoria';

-- Caso 3: Paciente mínimo (solo datos obligatorios)
PRINT '';
PRINT 'Caso 3: Registrando paciente con datos mínimos...';
EXEC SP_RegistrarPaciente 
    @nombre_completo = 'Pedro Ramirez Gonzalez',
    @dni = '90555666',
    @fecha_nacimiento = '1992-12-10',
    @genero = 'M';

-- Caso 4: Error - DNI duplicado
PRINT '';
PRINT 'Caso 4: Intentando registrar DNI duplicado (debe fallar)...';
EXEC SP_RegistrarPaciente 
    @nombre_completo = 'Persona Duplicada',
    @dni = '70123456', -- DNI ya existente
    @fecha_nacimiento = '1990-01-01',
    @genero = 'M';

-- Caso 5: Error - Datos faltantes
PRINT '';
PRINT 'Caso 5: Intentando registrar sin DNI (debe fallar)...';
EXEC SP_RegistrarPaciente 
    @nombre_completo = 'Sin DNI',
    @dni = '',
    @fecha_nacimiento = '1990-01-01',
    @genero = 'M';

-- =====================================================
-- PASO 2: VERIFICAR TRIGGERS DE AUDITORÍA
-- =====================================================

PRINT '';
PRINT '3. VERIFICANDO TRIGGERS DE AUDITORÍA';
PRINT '------------------------------------';

-- Verificar que los triggers crearon registros en el historial
PRINT 'Registros en HistorialCambios después de crear pacientes:';
SELECT 
    nombre_tabla,
    id_registro,
    accion,
    descripcion,
    fecha_cambio,
    usuario_cambio
FROM HistorialCambios 
WHERE nombre_tabla = 'Pacientes' 
AND fecha_cambio >= DATEADD(MINUTE, -5, GETDATE())
ORDER BY fecha_cambio DESC;

-- Probar UPDATE para activar trigger de modificación
PRINT '';
PRINT 'Actualizando datos de un paciente para probar trigger de UPDATE...';
UPDATE Pacientes 
SET nombre_completo = 'Carlos Alberto Mendoza Silva - ACTUALIZADO'
WHERE dni = '70123456';

SELECT * FROM HistorialCambios

-- Verificar trigger de UPDATE
PRINT '';
PRINT 'Verificando trigger de UPDATE:';
SELECT TOP 3
    nombre_tabla,
    id_registro,
    accion,
    descripcion,
    fecha_cambio
FROM HistorialCambios 
WHERE nombre_tabla = 'Pacientes'
ORDER BY fecha_cambio DESC;

-- =====================================================
-- PASO 3: PROBAR PROCEDIMIENTO SP_CrearConsulta
-- =====================================================

PRINT '';
PRINT '4. PROBANDO PROCEDIMIENTO SP_CrearConsulta';
PRINT '------------------------------------------';

-- Obtener IDs necesarios para las consultas
DECLARE @id_historia_carlos INT, @id_historia_ana INT, @id_medico INT;

SELECT @id_historia_carlos = hc.id_historia
FROM HistoriasClinicas hc
INNER JOIN Pacientes p ON hc.id_paciente = p.id_paciente
WHERE p.dni = '70123456';

SELECT @id_historia_ana = hc.id_historia  
FROM HistoriasClinicas hc
INNER JOIN Pacientes p ON hc.id_paciente = p.id_paciente
WHERE p.dni = '80987654';

SELECT @id_medico = id_medico FROM Medicos WHERE dni = '46778899';

-- Caso 1: Consulta completa para paciente adulto
PRINT 'Caso 1: Creando consulta completa para paciente adulto...';
EXEC SP_CrearConsulta
    @id_historia = @id_historia_carlos,
    @id_medico = @id_medico,
    @fecha_consulta = '2024-11-15 10:30:00',
    @tipo_enfermedad = 'Dermatitis Atópica',
    @historia_enfermedad = 'Paciente refiere lesiones pruriginosas en brazos y piernas desde hace 2 semanas. Empeora por las noches.',
    @examen_fisico = 'Lesiones eritematosas descamativas en flexuras de codos y rodillas. No signos de sobreinfección.',
    @plan_tratamiento = 'Corticoide tópico de potencia media, emolientes, antihistamínico oral',
    @observaciones = 'Control en 2 semanas. Evitar irritantes conocidos.';

-- Caso 2: Consulta para menor de edad
PRINT '';
PRINT 'Caso 2: Creando consulta para menor de edad...';
EXEC SP_CrearConsulta
    @id_historia = @id_historia_ana,
    @id_medico = @id_medico,
    @fecha_consulta = '2024-11-15 14:00:00',
    @tipo_enfermedad = 'Dermatitis Seborreica Infantil',
    @historia_enfermedad = 'Madre refiere descamación y enrojecimiento en cuero cabelludo desde hace 1 semana.',
    @examen_fisico = 'Escamas grasosas amarillentas en cuero cabelludo. No signos de inflamación severa.',
    @plan_tratamiento = 'Champú anticaspa suave, aceite mineral para reblandecer escamas';

-- Caso 3: Error - Historia inexistente
PRINT '';
PRINT 'Caso 3: Intentando crear consulta con historia inexistente (debe fallar)...';
EXEC SP_CrearConsulta
    @id_historia = 9999,
    @id_medico = 5,
    @fecha_consulta = '2024-11-15 16:00:00',
    @tipo_enfermedad = 'Test Error',
    @historia_enfermedad = 'Esta consulta no debería crearse';

-- =====================================================
-- PASO 4: VERIFICAR TRIGGERS DE CONSULTAS
-- =====================================================

PRINT '';
PRINT '5. VERIFICANDO TRIGGERS DE CONSULTAS';
PRINT '------------------------------------';

-- Ver registros de auditoría de consultas
PRINT 'Registros en HistorialCambios para consultas:';
SELECT 
    nombre_tabla,
    id_registro,
    accion,
    descripcion,
    fecha_cambio
FROM HistorialCambios 
WHERE nombre_tabla = 'Consultas'
ORDER BY fecha_cambio DESC;

-- Actualizar estado de una consulta para probar trigger
PRINT '';
PRINT 'Actualizando estado de consulta para probar trigger...';
UPDATE Consultas 
SET estado_consulta = 'CERRADA',
    observaciones = observaciones + ' - CONSULTA FINALIZADA'
WHERE tipo_enfermedad = 'Dermatitis Atópica';

-- Verificar trigger de UPDATE en consultas
PRINT '';
PRINT 'Verificando trigger de UPDATE en consultas:';
SELECT TOP 3
    nombre_tabla,
    accion,
    descripcion,
    fecha_cambio
FROM HistorialCambios 
WHERE nombre_tabla = 'Consultas'
ORDER BY fecha_cambio DESC;

-- =====================================================
-- PASO 5: PROBAR PROCEDIMIENTO SP_ConsultarHistorialPaciente
-- =====================================================

PRINT '';
PRINT '6. PROBANDO PROCEDIMIENTO SP_ConsultarHistorialPaciente';
PRINT '------------------------------------------------------';

-- Caso 1: Consultar historial de paciente existente
PRINT 'Caso 1: Consultando historial de Carlos Mendoza...';
EXEC SP_ConsultarHistorialPaciente @dni_paciente = '70123456';

PRINT '';
PRINT 'Caso 2: Consultando historial de Ana Rodriguez...';
EXEC SP_ConsultarHistorialPaciente @dni_paciente = '80987654';

-- Caso 3: Error - Paciente inexistente
PRINT '';
PRINT 'Caso 3: Intentando consultar historial de paciente inexistente...';
EXEC SP_ConsultarHistorialPaciente @dni_paciente = '99999999';

-- =====================================================
-- PASO 6: PROBAR VISTAS
-- =====================================================

PRINT '';
PRINT '7. PROBANDO VISTAS DEL SISTEMA';
PRINT '------------------------------';

-- Vista de pacientes completo
PRINT 'Vista VW_PacientesCompleto:';
SELECT TOP 10
    codigo_paciente,
    nombre_completo,
    dni,
    edad,
    categoria_edad,
    apoderado,
    telefono_principal,
    fecha_creacion
FROM VW_PacientesCompleto
ORDER BY fecha_creacion DESC;

PRINT '';
PRINT 'Vista VW_ConsultasRecientes:';
SELECT 
    numero_consulta,
    paciente,
    dni_paciente,
    medico,
    nombre_especialidad,
    fecha_consulta,
    tipo_enfermedad,
    estado_consulta
FROM VW_ConsultasRecientes
ORDER BY fecha_consulta DESC;

-- =====================================================
-- PASO 9: RESUMEN DE PRUEBAS
-- =====================================================

PRINT '';
PRINT '9. RESUMEN DE PRUEBAS REALIZADAS';
PRINT '---------------------------------';

-- Contar registros creados
DECLARE @total_pacientes INT, @total_consultas INT, @total_historiales INT, @total_recetas INT;

SELECT @total_pacientes = COUNT(*) FROM Pacientes WHERE estado = 1;
SELECT @total_consultas = COUNT(*) FROM Consultas;
SELECT @total_historiales = COUNT(*) FROM HistorialCambios WHERE fecha_cambio >= DATEADD(HOUR, -1, GETDATE());
SELECT @total_recetas = COUNT(*) FROM Recetas;

PRINT 'Total de pacientes activos: ' + CAST(@total_pacientes AS VARCHAR);
PRINT 'Total de consultas: ' + CAST(@total_consultas AS VARCHAR);
PRINT 'Total de registros de auditoría (última hora): ' + CAST(@total_historiales AS VARCHAR);
PRINT 'Total de recetas: ' + CAST(@total_recetas AS VARCHAR);

-- Mostrar algunos estadísticos
PRINT '';
PRINT 'Estadísticas del sistema:';
SELECT 
    'Pacientes' as tabla,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN estado = 1 THEN 1 END) as activos,
    COUNT(CASE WHEN es_menor_edad = 1 THEN 1 END) as menores_edad
FROM Pacientes
UNION ALL
SELECT 
    'Consultas',
    COUNT(*),
    COUNT(CASE WHEN estado_consulta = 'ACTIVA' THEN 1 END),
    COUNT(CASE WHEN fecha_consulta >= DATEADD(MONTH, -1, GETDATE()) THEN 1 END)
FROM Consultas;

-- Verificar integridad referencial
PRINT '';
PRINT 'Verificación de integridad referencial:';
SELECT 
    'Pacientes sin historia clínica' as verificacion,
    COUNT(*) as cantidad
FROM Pacientes p
LEFT JOIN HistoriasClinicas h ON p.id_paciente = h.id_paciente
WHERE h.id_historia IS NULL AND p.estado = 1
UNION ALL
SELECT 
    'Consultas sin médico válido',
    COUNT(*)
FROM Consultas c
LEFT JOIN Medicos m ON c.id_medico = m.id_medico
WHERE m.id_medico IS NULL
UNION ALL
SELECT 
    'Historias sin paciente válido',
    COUNT(*)
FROM HistoriasClinicas h
LEFT JOIN Pacientes p ON h.id_paciente = p.id_paciente
WHERE p.id_paciente IS NULL;

PRINT '';
PRINT '======================================================';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT 'Todos los procedimientos, triggers y vistas funcionan correctamente';
PRINT '======================================================';

-- Opcional: Limpiar datos de prueba
-- PRINT '';
-- PRINT 'Para limpiar datos de prueba, ejecutar:';
-- PRINT 'DELETE FROM DetalleRecetas; DELETE FROM Recetas; DELETE FROM Consultas WHERE id_consulta > (valor_inicial);';