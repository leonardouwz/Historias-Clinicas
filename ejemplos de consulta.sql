-- 1. SELECT con WHERE usando diferentes operadores --
-- Pacientes menores de edad (nacidos después del 2005)
SELECT * FROM Pacientes WHERE YEAR(fecha_nacimiento) > 2005 AND es_menor_edad = 1;

-- Médicos dermatólogos activos
SELECT nombre_completo, dni FROM Medicos WHERE estado = 1 AND especialidad LIKE '%Dermatolog%';

-- Consultas realizadas en octubre 2023
SELECT * FROM Consultas 
WHERE fecha_consulta BETWEEN '2023-10-01' AND '2023-10-31'
ORDER BY fecha_consulta DESC;

-- Medicamentos específicos para dermatitis y psoriasis
SELECT * FROM Medicamentos 
WHERE id_medicamento IN (1, 5) OR nombre LIKE '%crema%' OR nombre LIKE '%ungüento%';
GO


-- 2. UPDATE con WHERE --
-- Actualizar teléfono de un paciente específico
UPDATE Pacientes SET telefono = '999888777' WHERE id_paciente = 1;

-- Desactivar medicamentos con contraindicaciones importantes
UPDATE Medicamentos SET estado = 0 
WHERE contraindicaciones LIKE '%Embarazo%' OR contraindicaciones LIKE '%insuficiencia hepática%';
GO

-- 3. DELETE con WHERE --
-- Eliminar detalles de recetas con medicamento específico
DELETE FROM DetalleRecetas 
WHERE id_receta = 3 AND id_medicamento = 3;

-- Eliminar indicaciones de medicamentos desactivados
DELETE FROM IndicacionesMedicamentos
WHERE id_medicamento IN (SELECT id_medicamento FROM Medicamentos WHERE estado = 0);
GO

-- 4. ALTER TABLE para agregar columnas --
-- Agregar área afectada a las consultas dermatológicas
ALTER TABLE Consultas ADD area_afectada NVARCHAR(100) NULL;

-- Agregar tipo de piel a pacientes
ALTER TABLE Pacientes ADD tipo_piel NVARCHAR(50) NULL 
CHECK (tipo_piel IN ('Normal', 'Seca', 'Grasa', 'Mixta', 'Sensible'));
GO


-- 5. JOINs adaptados a dermatología --
-- LEFT JOIN: Todos los pacientes y sus apoderados (si tienen)
SELECT 
    p.nombre_completo AS paciente,
    p.fecha_nacimiento,
    DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE()) AS edad,
    a.nombre_completo AS apoderado,
    a.parentesco
FROM Pacientes p
LEFT JOIN Apoderados a ON p.id_apoderado = a.id_apoderado
ORDER BY edad DESC;
GO

-- RIGHT JOIN: Medicamentos y cuántas veces se han recetado
SELECT 
    m.nombre AS medicamento_dermatologico,
    m.presentacion,
    COUNT(dr.id_detalle) AS veces_recetado
FROM DetalleRecetas dr
RIGHT JOIN Medicamentos m ON dr.id_medicamento = m.id_medicamento
GROUP BY m.nombre, m.presentacion
ORDER BY veces_recetado DESC;
GO

-- 6. ORDER BY con datos dermatológicos --
-- Consultas ordenadas por fecha descendente
SELECT 
    c.id_consulta,
    p.nombre_completo AS paciente,
    c.tipo_enfermedad,
    c.fecha_consulta
FROM Consultas c
JOIN HistoriasClinicas h ON c.id_historia = h.id_historia
JOIN Pacientes p ON h.id_paciente = p.id_paciente
ORDER BY c.fecha_consulta DESC;

-- Medicamentos más utilizados en recetas
SELECT 
    m.nombre,
    m.presentacion,
    COUNT(*) AS cantidad_recetas
FROM DetalleRecetas dr
JOIN Medicamentos m ON dr.id_medicamento = m.id_medicamento
GROUP BY m.nombre, m.presentacion
ORDER BY cantidad_recetas DESC;
GO

-- 7. DISTINCT para datos únicos --
-- Tipos de enfermedades atendidas
SELECT DISTINCT tipo_enfermedad FROM Consultas;

-- Medicamentos con indicaciones específicas
SELECT DISTINCT 
    m.nombre AS medicamento,
    i.indicacion
FROM Medicamentos m
JOIN IndicacionesMedicamentos i ON m.id_medicamento = i.id_medicamento;
GO

-- 8. CROSS JOIN para combinaciones --
-- Combinar pacientes con posibles tratamientos (ejemplo hipotético)
SELECT 
    p.nombre_completo AS paciente,
    m.nombre AS tratamiento_posible
FROM Pacientes p
CROSS JOIN Medicamentos m
WHERE p.id_paciente IN (1, 2, 3) 
AND m.nombre IN ('Clobetasol crema', 'Tacrolimus ungüento');
GO

-- 9. SET DATEFORMAT --
-- Configurar formato de fecha día/mes/año
SET DATEFORMAT dmy;

-- Insertar nueva consulta con formato de fecha específico
INSERT INTO Consultas (id_historia, id_medico, fecha_consulta, tipo_enfermedad)
VALUES (1, 1, '15/11/2023 10:30:00', 'Dermatitis de contacto');
GO

-- 10. Vista especializada para dermatología --
-- Crear vista para historial dermatológico completo
CREATE VIEW VistaHistorialDermatologico AS
SELECT 
    p.id_paciente,
    p.nombre_completo AS paciente,
    p.dni,
    DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE()) AS edad,
    c.id_consulta,
    c.fecha_consulta,
    c.tipo_enfermedad,
    c.diagnostico,
    STRING_AGG(m.nombre, ', ') AS medicamentos_recetados,
    COUNT(dr.id_detalle) AS cantidad_medicamentos
FROM Pacientes p
JOIN HistoriasClinicas h ON p.id_paciente = h.id_paciente
JOIN Consultas c ON h.id_historia = c.id_historia
LEFT JOIN Recetas r ON c.id_consulta = r.id_consulta
LEFT JOIN DetalleRecetas dr ON r.id_receta = dr.id_receta
LEFT JOIN Medicamentos m ON dr.id_medicamento = m.id_medicamento
GROUP BY 
    p.id_paciente, p.nombre_completo, p.dni, p.fecha_nacimiento,
    c.id_consulta, c.fecha_consulta, c.tipo_enfermedad, c.diagnostico;
GO

-- Consultar la vista para un paciente específico
SELECT * FROM VistaHistorialDermatologico 
WHERE id_paciente = 1 
ORDER BY fecha_consulta DESC;
GO
