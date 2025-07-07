-- =====================================================
-- DATOS ADICIONALES PARA ANÁLISIS COMPLETO
-- SISTEMA DE HISTORIAS CLÍNICAS - CLÍNICA DERMATOLÓGICA
-- =====================================================
-- Este script añade datos realistas para análisis mejorado
-- Más de 10 registros por tabla principal
-- =====================================================

USE SistemaHistoriasClinicas;
GO

PRINT 'Insertando datos adicionales para análisis...'
GO

-- =====================================================
-- INFORMACIÓN DE CONTACTO ADICIONAL
-- =====================================================
INSERT INTO InformacionContacto (telefono_principal, telefono_secundario, correo_electronico, direccion, ciudad, codigo_postal)
VALUES 
    ('999456789', '014567890', 'ana.torres@email.com', 'Av. Brasil 234', 'Lima', '15001'),
    ('999567890', NULL, 'carlos.mendez@email.com', 'Jr. Puno 567', 'Lima', '15002'),
    ('999678901', '014678901', 'lucia.rodriguez@email.com', 'Calle Las Flores 890', 'Lima', '15003'),
    ('999789012', NULL, 'pedro.silva@email.com', 'Av. Universitaria 123', 'Lima', '15004'),
    ('999890123', '014890123', 'sofia.martinez@email.com', 'Jr. Cusco 456', 'Lima', '15005'),
    ('999901234', NULL, 'diego.vargas@email.com', 'Av. Ejercito 789', 'Lima', '15006'),
    ('999012345', '014012345', 'elena.castro@email.com', 'Calle Libertad 321', 'Lima', '15007'),
    ('999123456', NULL, 'ricardo.herrera@email.com', 'Av. Grau 654', 'Lima', '15008'),
    ('999234567', '014234567', 'valentina.ramos@email.com', 'Jr. Ayacucho 987', 'Lima', '15009'),
    ('999345678', NULL, 'fernando.gutierrez@email.com', 'Av. Colonial 147', 'Lima', '15010'),
    ('999456789', '014456789', 'isabella.morales@email.com', 'Calle San Martin 258', 'Lima', '15011'),
    ('999567890', NULL, 'gabriel.santos@email.com', 'Av. Tacna 369', 'Lima', '15012'),
    ('999678901', '014678901', 'dr.martinez@clinica.com', 'Av. Clinica 100', 'Lima', '15013'),
    ('999789012', NULL, 'dr.lopez@clinica.com', 'Av. Clinica 101', 'Lima', '15014'),
    ('999890123', '014890123', 'dr.gonzalez@clinica.com', 'Av. Clinica 102', 'Lima', '15015'),
    ('999901234', NULL, 'dr.fernandez@clinica.com', 'Av. Clinica 103', 'Lima', '15016'),
    ('999012345', '014012345', 'dr.ruiz@clinica.com', 'Av. Clinica 104', 'Lima', '15017'),
    ('999123456', NULL, 'dr.jimenez@clinica.com', 'Av. Clinica 105', 'Lima', '15018'),
    ('999234567', '014234567', 'dr.torres@clinica.com', 'Av. Clinica 106', 'Lima', '15019'),
    ('999345678', NULL, 'dr.rivera@clinica.com', 'Av. Clinica 107', 'Lima', '15020');
GO

-- =====================================================
-- APODERADOS ADICIONALES
-- =====================================================
INSERT INTO Apoderados (nombre_completo, dni, parentesco, id_contacto)
VALUES 
    ('Rosa García Mendoza', '45678901', 'Madre', 4),
    ('Miguel Pérez Torres', '56789012', 'Padre', 5),
    ('Carmen López Silva', '67890123', 'Madre', 6),
    ('José Rodríguez Vargas', '78901234', 'Padre', 7),
    ('Ana Martínez Castro', '89012345', 'Abuela', 8),
    ('Luis Vargas Herrera', '90123456', 'Padre', 9),
    ('Patricia Castro Ramos', '01234567', 'Madre', 10),
    ('Roberto Herrera Gutierrez', '12345678', 'Tío', 11),
    ('Mónica Ramos Morales', '23456789', 'Madre', 12),
    ('Fernando Santos López', '34567890', 'Padre', 13);
GO

-- =====================================================
-- MÉDICOS ADICIONALES
-- =====================================================
INSERT INTO Medicos (nombre_completo, dni, id_especialidad, numero_colegiatura, id_contacto)
VALUES 
    ('Dra. María Elena Martínez', '15975346', 1, 'CMP-15975', 14),
    ('Dr. José Luis López', '26864213', 2, 'CMP-26864', 15),
    ('Dra. Carmen González', '37951468', 3, 'CMP-37951', 16),
    ('Dr. Roberto Fernández', '48628597', 4, 'CMP-48628', 17),
    ('Dra. Ana Patricia Ruiz', '59317426', 1, 'CMP-59317', 18),
    ('Dr. Diego Jiménez', '60284719', 5, 'CMP-60284', 19),
    ('Dra. Sofía Torres', '71395862', 2, 'CMP-71395', 20),
    ('Dr. Fernando Rivera', '82461573', 1, 'CMP-82461', 21),
    ('Dra. Valentina Morales', '93528614', 3, 'CMP-93528', 22),
    ('Dr. Gabriel Castro', '04617395', 4, 'CMP-04617', 23);
GO

-- =====================================================
-- PACIENTES ADICIONALES
-- =====================================================
INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, id_apoderado, id_contacto)
VALUES 
    ('Ana Torres Mendoza', '75319864', '12/05/1985', 'F', NULL, 4),
    ('Carlos Mendoza Silva', '86420975', '08/11/1978', 'M', NULL, 5),
    ('Lucía Rodríguez Vargas', '97531086', '25/02/1992', 'F', NULL, 6),
    ('Pedro Silva Martínez', '08642197', '14/09/1988', 'M', NULL, 7),
    ('Sofía Martínez Castro', '19753208', '03/06/1995', 'F', NULL, 8),
    ('Diego Vargas Herrera', '20864319', '22/12/1980', 'M', NULL, 9),
    ('Elena Castro Ramos', '31975420', '17/08/1987', 'F', NULL, 10),
    ('Ricardo Herrera Gutierrez', '42086531', '09/01/1983', 'M', NULL, 11),
    ('Valentina Ramos Morales', '53197642', '28/04/1990', 'F', NULL, 12),
    ('Fernando Gutierrez Santos', '64208753', '11/10/1986', 'M', NULL, 13),
    -- Menores de edad
    ('Isabella Morales García', '75319864', '15/03/2008', 'F', 1, 4),
    ('Gabriel Santos López', '86420975', '22/07/2009', 'M', 2, 5),
    ('Camila Torres Mendoza', '97531086', '08/12/2010', 'F', 3, 6),
    ('Sebastián Silva Vargas', '08642197', '04/05/2011', 'M', 4, 7),
    ('Emilia Martínez Castro', '19753208', '19/09/2012', 'F', 5, 8),
    ('Mateo Vargas Herrera', '20864319', '13/01/2013', 'M', 6, 9),
    ('Olivia Castro Ramos', '31975420', '26/06/2014', 'F', 7, 10),
    ('Lucas Herrera Gutierrez', '42086531', '07/11/2015', 'M', 8, 11),
    ('Sophia Ramos Morales', '53197642', '18/02/2016', 'F', 9, 12),
    ('Ethan Santos García', '64208753', '29/08/2017', 'M', 10, 13);
GO

-- =====================================================
-- HISTORIAS CLÍNICAS ADICIONALES
-- =====================================================
INSERT INTO HistoriasClinicas (id_paciente, alergias, antecedentes_personales, antecedentes_familiares, tipo_piel, fototipo)
VALUES 
    (3, 'Níquel, perfumes', 'Dermatitis atópica en la infancia', 'Madre con psoriasis', 'sensible', 'II'),
    (4, 'Ninguna conocida', 'Acné juvenil severo', 'Padre con rosácea', 'grasa', 'III'),
    (5, 'Látex, medicamentos sulfa', 'Urticaria crónica', 'Hermana con dermatitis', 'seca', 'IV'),
    (6, 'Polen, ácaros', 'Eccema en manos', 'Abuelo con cáncer de piel', 'mixta', 'III'),
    (7, 'Ninguna conocida', 'Melasma post-embarazo', 'Madre con vitiligo', 'grasa', 'IV'),
    (8, 'Crustáceos', 'Foliculitis recurrente', 'Padre con alopecia', 'grasa', 'II'),
    (9, 'Níquel, conservantes', 'Dermatitis de contacto', 'Madre con eccema', 'sensible', 'III'),
    (10, 'Ninguna conocida', 'Queratosis pilaris', 'Hermano con psoriasis', 'seca', 'IV'),
    (11, 'Medicamentos tópicos', 'Rosácea papulopustular', 'Padre con dermatitis seborreica', 'sensible', 'I'),
    (12, 'Ninguna conocida', 'Hiperhidrosis palmar', 'Madre con acné', 'grasa', 'III'),
    (13, 'Colorantes, fragancias', 'Dermatitis atópica', 'Padre con eccema', 'sensible', 'II'),
    (14, 'Ninguna conocida', 'Acné comedogénico', 'Hermana con rosácea', 'grasa', 'IV'),
    (15, 'Polvo, ácaros', 'Urticaria por frío', 'Madre con urticaria', 'seca', 'III'),
    (16, 'Ninguna conocida', 'Dermatitis seborreica', 'Padre con psoriasis', 'grasa', 'II'),
    (17, 'Medicamentos AINES', 'Eccema dishidrótico', 'Abuela con dermatitis', 'sensible', 'IV'),
    (18, 'Ninguna conocida', 'Foliculitis', 'Padre con alopecia', 'grasa', 'III'),
    (19, 'Látex, níquel', 'Dermatitis de contacto', 'Madre con eccema', 'sensible', 'II'),
    (20, 'Ninguna conocida', 'Acné juvenil', 'Hermano con acné', 'grasa', 'IV'),
    (21, 'Perfumes, conservantes', 'Dermatitis atópica', 'Madre con dermatitis', 'sensible', 'III'),
    (22, 'Ninguna conocida', 'Queratosis pilaris', 'Padre con piel seca', 'seca', 'II');
GO

-- =====================================================
-- CONSULTAS ADICIONALES
-- =====================================================
INSERT INTO Consultas (id_historia, id_medico, fecha_consulta, motivo_consulta, tipo_enfermedad, historia_enfermedad, examen_fisico, plan_tratamiento, observaciones)
VALUES 
    (3, 2, '2024-01-15 09:00:00', 'Erupciones en cara y cuello', 'Dermatitis de contacto', 'Paciente refiere aparición de lesiones eritematosas pruriginosas hace 1 semana tras uso de nuevo cosmético', 'Eritema y descamación en mejillas bilaterales', 'Suspender cosmético, aplicar hidrocortisona 1%', 'Evitar contacto con alérgenos conocidos'),
    (4, 3, '2024-01-20 10:30:00', 'Acné persistente', 'Acné vulgar', 'Paciente masculino con acné moderado desde hace 6 meses, sin mejoría con tratamientos previos', 'Comedones y pápulas en frente y mejillas', 'Tretinoína 0.025% nocturna + clindamicina gel', 'Control en 6 semanas'),
    (5, 1, '2024-01-25 14:00:00', 'Ronchas recurrentes', 'Urticaria crónica', 'Episodios de urticaria de 3 meses de evolución, sin desencadenante identificado', 'Habones eritematosos en tronco y extremidades', 'Antihistamínicos H1 de segunda generación', 'Llevar diario de síntomas'),
    (6, 4, '2024-02-01 11:15:00', 'Descamación en manos', 'Eccema dishidrótico', 'Vesículas y descamación en palmas y dedos, exacerbación con estrés', 'Vesículas y fisuras en región palmar', 'Corticoide tópico potente + emolientes', 'Manejo del estrés'),
    (7, 2, '2024-02-05 15:45:00', 'Manchas en rostro', 'Melasma', 'Hiperpigmentación facial post-embarazo de 8 meses de evolución', 'Máculas hiperpigmentadas simétricas en mejillas', 'Hidroquinona 4% + tretinoína + protector solar', 'Uso estricto de protector solar'),
    (8, 5, '2024-02-10 08:30:00', 'Granitos en espalda', 'Foliculitis', 'Lesiones inflamatorias en espalda de 2 semanas de evolución', 'Pápulas y pústulas foliculares en región dorsal', 'Clindamicina tópica + jabón antibacterial', 'Evitar ropa ajustada'),
    (9, 3, '2024-02-15 13:00:00', 'Alergia en brazos', 'Dermatitis de contacto', 'Reacción alérgica tras contacto con plantas durante jardinería', 'Eritema y vesículas en antebrazos', 'Corticoide tópico + antihistamínico oral', 'Usar guantes para jardinería'),
    (10, 1, '2024-02-20 16:20:00', 'Piel áspera en brazos', 'Queratosis pilaris', 'Pápulas queratósicas en brazos desde la adolescencia', 'Pápulas foliculares queratósicas en brazos', 'Urea 10% + ácido salicílico', 'Hidratación constante'),
    (11, 4, '2024-02-25 09:45:00', 'Enrojecimiento facial', 'Rosácea', 'Eritema facial persistente con episodios de empeoramiento', 'Eritema centrofacial con pápulas', 'Metronidazol tópico + protector solar', 'Evitar desencadenantes'),
    (12, 2, '2024-03-01 12:10:00', 'Sudoración excesiva', 'Hiperhidrosis', 'Sudoración excesiva en palmas interfiriendo con actividades diarias', 'Hiperhidrosis palmar severa', 'Antitranspirante específico', 'Derivar a tratamiento especializado'),
    (13, 5, '2024-03-05 14:30:00', 'Picazón generalizada', 'Dermatitis atópica', 'Exacerbación de dermatitis atópica en menor de edad', 'Xerosis y eritema en pliegues', 'Hidratación + corticoide suave', 'Evitar irritantes'),
    (14, 3, '2024-03-10 10:00:00', 'Espinillas en cara', 'Acné', 'Acné comedogénico en adolescente', 'Comedones abiertos y cerrados en zona T', 'Adapaleno + limpiador suave', 'Educación sobre cuidado facial'),
    (15, 1, '2024-03-15 11:30:00', 'Ronchas por frío', 'Urticaria por frío', 'Urticaria desencadenada por cambios de temperatura', 'Habones tras exposición al frío', 'Antihistamínicos + protección térmica', 'Evitar cambios bruscos de temperatura'),
    (16, 4, '2024-03-20 15:00:00', 'Caspa persistente', 'Dermatitis seborreica', 'Descamación y eritema en cuero cabelludo', 'Eritema y descamación en cuero cabelludo', 'Ketoconazol shampoo + corticoide tópico', 'Uso regular de shampoo medicado'),
    (17, 2, '2024-03-25 08:15:00', 'Ampollas en manos', 'Eccema dishidrótico', 'Vesículas pruriginosas en manos de aparición reciente', 'Vesículas en palmas y dedos', 'Corticoide potente + protección', 'Evitar contacto con irritantes'),
    (18, 5, '2024-04-01 13:45:00', 'Granitos en barba', 'Foliculitis', 'Lesiones inflamatorias en área de barba post-afeitado', 'Pápulas y pústulas perifoliculares', 'Técnica de afeitado + antibiótico tópico', 'Mejora en técnica de afeitado'),
    (19, 3, '2024-04-05 09:30:00', 'Alergia en muñecas', 'Dermatitis de contacto', 'Reacción alérgica por uso de pulsera metálica', 'Eritema y descamación en muñecas', 'Evitar níquel + tratamiento sintomático', 'Usar accesorios hipoalergénicos'),
    (20, 1, '2024-04-10 12:00:00', 'Acné en adolescente', 'Acné vulgar', 'Acné inflamatorio en adolescente varón', 'Pápulas y pústulas en rostro', 'Benzoil peróxido + retinoide tópico', 'Seguimiento mensual'),
    (21, 4, '2024-04-15 16:30:00', 'Picazón en niña', 'Dermatitis atópica', 'Exacerbación de dermatitis atópica en menor', 'Xerosis y liquenificación en pliegues', 'Emolientes + corticoide suave', 'Cuidados de la piel atópica'),
    (22, 2, '2024-04-20 10:45:00', 'Piel seca y áspera', 'Queratosis pilaris', 'Pápulas queratósicas en extremidades', 'Pápulas foliculares en brazos y muslos', 'Urea + ácido láctico', 'Hidratación diaria');
GO

-- =====================================================
-- RECETAS ADICIONALES
-- =====================================================
INSERT INTO Recetas (id_consulta, diagnostico, fecha_vencimiento)
VALUES 
    (3, 'Dermatitis de contacto por cosméticos', '2024-03-15'),
    (4, 'Acné vulgar moderado', '2024-03-20'),
    (5, 'Urticaria crónica idiopática', '2024-03-25'),
    (6, 'Eccema dishidrótico', '2024-04-01'),
    (7, 'Melasma facial', '2024-04-05'),
    (8, 'Foliculitis bacteriana', '2024-04-10'),
    (9, 'Dermatitis de contacto por plantas', '2024-04-15'),
    (10, 'Queratosis pilaris', '2024-04-20'),
    (11, 'Rosácea papulopustular', '2024-04-25'),
    (12, 'Hiperhidrosis palmar', '2024-05-01'),
    (13, 'Dermatitis atópica moderada', '2024-05-05'),
    (14, 'Acné comedogénico', '2024-05-10'),
    (15, 'Urticaria física por frío', '2024-05-15'),
    (16, 'Dermatitis seborreica', '2024-05-20'),
    (17, 'Eccema dishidrótico recurrente', '2024-05-25'),
    (18, 'Foliculitis por afeitado', '2024-06-01'),
    (19, 'Dermatitis de contacto por níquel', '2024-06-05'),
    (20, 'Acné vulgar en adolescente', '2024-06-10'),
    (21, 'Dermatitis atópica pediátrica', '2024-06-15'),
    (22, 'Queratosis pilaris generalizada', '2024-06-20');
GO

-- =====================================================
-- DETALLES DE RECETAS ADICIONALES
-- =====================================================
INSERT INTO DetalleRecetas (id_receta, id_indicacion, duracion_tratamiento, cantidad, instrucciones_adicionales, fecha_inicio_tratamiento, fecha_fin_tratamiento)
VALUES 
    (3, 2, '2 semanas', 1, 'Aplicar solo en áreas afectadas', '2024-01-15', '2024-01-29'),
    (4, 1, '8 semanas', 2, 'Iniciar gradualmente', '2024-01-20', '2024-03-15'),
    (4, 6, '8 semanas', 2, 'Aplicar en la mañana', '2024-01-20', '2024-03-15'),
    (5, 2, '4 semanas', 1, 'Para crisis agudas', '2024-01-25', '2024-02-22'),
    (6, 2, '3 semanas', 1, 'Corticoide potente', '2024-02-01', '2024-02-22'),
    (6, 9, '8 semanas', 2, 'Mantener hidratación', '2024-02-01', '2024-03-28'),
    (7, 1, '12 semanas', 3, 'Uso nocturno estricto', '2024-02-05', '2024-04-28'),
    (7, 4, '12 semanas', 3, 'Reaplicar cada 2 horas', '2024-02-05', '2024-04-28'),
    (8, 6, '4 semanas', 2, 'Aplicar después del baño', '2024-02-10', '2024-03-09'),
    (9, 2, '2 semanas', 1, 'Reducir gradualmente', '2024-02-15', '2024-03-01'),
    (10, 5, '8 semanas', 2, 'Aplicar en piel húmeda', '2024-02-20', '2024-04-15'),
    (10, 9, '8 semanas', 2, 'Uso diario', '2024-02-20', '2024-04-15'),
    (11, 8, '6 semanas', 2, 'Aplicar capa fina', '2024-02-25', '2024-04-07'),
    (11, 4, '6 semanas', 2, 'Protección diaria', '2024-02-25', '2024-04-07'),
    (12, 9, '4 semanas', 1, 'Aplicar en palmas secas', '2024-03-01', '2024-03-29'),
    (13, 2, '3 semanas', 1, 'Uso intermitente', '2024-03-05', '2024-03-26'),
    (13, 9, '8 semanas', 2, 'Aplicar 2 veces al día', '2024-03-05', '2024-04-30'),
    (14, 7, '8 semanas', 2, 'Iniciar cada 3 días', '2024-03-10', '2024-05-05'),
    (15, 2, '2 semanas', 1, 'Para episodios agudos', '2024-03-15', '2024-03-29'),
    (16, 3, '4 semanas', 2, 'Alternar con shampoo suave', '2024-03-20', '2024-04-17'),
    (16, 2, '2 semanas', 1, 'Solo en cuero cabelludo', '2024-03-20', '2024-04-03'),
    (17, 2, '2 semanas', 1, 'Evitar área periocular', '2024-03-25', '2024-04-08'),
    (18, 6, '4 semanas', 2, 'Aplicar post-afeitado', '2024-04-01', '2024-04-29'),
    (19, 2, '2 semanas', 1, 'Hasta resolución', '2024-04-05', '2024-04-19'),
    (20, 1, '12 semanas', 3, 'Uso nocturno', '2024-04-10', '2024-07-03'),
    (20, 6, '12 semanas', 3, 'Uso matutino', '2024-04-10', '2024-07-03'),
    (21, 9, '8 semanas', 2, 'Aplicar en piel húmeda', '2024-04-15', '2024-06-10'),
    (21, 2, '2 semanas', 1, 'Para brotes agudos', '2024-04-15', '2024-04-29'),
    (22, 9, '8 semanas', 2, 'Uso diario continuo', '2024-04-20', '2024-06-15'),
    (22, 5, '8 semanas', 2, 'Aplicar en piel húmeda', '2024-04-20', '2024-06-15');
GO

-- =====================================================
-- REGISTROS DE AUDITORÍA
-- =====================================================
INSERT INTO HistorialCambios (nombre_tabla, id_registro, accion, descripcion, usuario_cambio)
VALUES 
    ('Pacientes', 1, 'CREAR', 'Registro inicial de paciente', 'admin'),
    ('Pacientes', 2, 'CREAR', 'Registro inicial de paciente menor', 'admin'),
    ('HistoriasClinicas', 1, 'CREAR', 'Creación de historia clínica', 'admin'),
    ('HistoriasClinicas', 2, 'CREAR', 'Creación de historia clínica', 'admin'),
    ('Consultas', 1, 'CREAR', 'Primera consulta registrada', 'dr.smith'),
    ('Consultas', 2, 'CREAR', 'Consulta de seguimiento', 'dr.martinez'),
    ('Recetas', 1, 'CREAR', 'Receta médica emitida', 'dr.smith'),
    ('Recetas', 2, 'CREAR', 'Receta médica emitida', 'dr.martinez'),
    ('Pacientes', 3, 'ACTUALIZAR', 'Actualización de datos de contacto', 'admin'),
    ('HistoriasClinicas', 3, 'ACTUALIZAR', 'Actualización de antecedentes', 'dr.lopez'),
    ('Consultas', 3, 'CERRAR', 'Consulta finalizada', 'dr.lopez'),
    ('Recetas', 3, 'UTILIZADA', 'Receta dispensada', 'farmacia'),
    ('Pacientes', 4, 'CREAR', 'Nuevo paciente registrado', 'recepcion'),
    ('Medicos', 2, 'CREAR', 'Nuevo médico en el sistema', 'admin'),
    ('Medicamentos', 1, 'ACTUALIZAR', 'Actualización de concentración', 'admin');
GO

-- =====================================================
-- MEDICAMENTOS ADICIONALES ESPECIALIZADOS
-- =====================================================
INSERT INTO Medicamentos (nombre, principio_activo, presentacion, concentracion, descripcion, contraindicaciones)
VALUES 
    ('Minoxidil Solución', 'Minoxidil', 'Solución', '5%', 'Estimulante del crecimiento capilar', 'Hipersensibilidad, dermatitis del cuero cabelludo'),
    ('Isotretinoína Cápsulas', 'Isotretinoína', 'Cápsulas', '20mg', 'Retinoide oral para acné severo', 'Embarazo, lactancia, hepatopatía'),
    ('Finasterida Comprimidos', 'Finasterida', 'Comprimidos', '1mg', 'Inhibidor 5-alfa reductasa', 'Mujeres embarazadas, niños'),
    ('Imiquimod Crema', 'Imiquimod', 'Crema', '5%', 'Inmunomodulador tópico', 'Heridas abiertas, dermatitis severa'),
    ('Tacrolimus Ungüento', 'Tacrolimus', 'Ungüento', '0.1%', 'Inmunosupresor tópico', 'Inmunodeficiencia, infecciones virales'),
    ('Fluconazol Comprimidos', 'Fluconazol', 'Comprimidos', '150mg', 'Antifúngico sistémico', 'Hepatopatía, embarazo'),
    ('Doxiciclina Cápsulas', 'Doxiciclina', 'Cápsulas', '100mg', 'Antibiótico tetraciclina', 'Embarazo, lactancia, niños <8 años'),
    ('Betametasona Crema', 'Betametasona', 'Crema', '0.05%', 'Corticoide potente', 'Infecciones cutáneas, rosácea'),
    ('Azelaic Acid Gel', 'Ácido Azelaico', 'Gel', '15%', 'Queratolítico y antimicrobiano', 'Hipersensibilidad al ácido azelaico'),
    ('Ciclopirox Crema', 'Ciclopirox', 'Crema', '1%', 'Antifúngico de amplio espectro', 'Hipersensibilidad, dermatitis aguda');
GO

-- =====================================================
-- INDICACIONES PARA MEDICAMENTOS ADICIONALES
-- =====================================================
INSERT INTO IndicacionesMedicamentos (id_medicamento, indicacion, dosis_recomendada, frecuencia, duracion_maxima, via_administracion)
VALUES 
    (11, 'Alopecia androgénica', 'Aplicar 1ml', 'Dos veces al día', '6 meses', 'Tópica'),
    (12, 'Acné noduloquístico severo', '1 comprimido', 'Una vez al día', '6 meses', 'Oral'),
    (13, 'Alopecia androgénica masculina', '1 comprimido', 'Una vez al día', 'Tratamiento prolongado', 'Oral'),
    (14, 'Queratosis actínicas', 'Aplicar capa fina', 'Tres veces por semana', '16 semanas', 'Tópica'),
    (15, 'Dermatitis atópica moderada-severa', 'Aplicar capa fina', 'Dos veces al día', '6 semanas', 'Tópica'),
    (16, 'Candidiasis cutánea', '1 comprimido', 'Dosis única', '1 día', 'Oral'),
    (17, 'Acné inflamatorio', '1 cápsula', 'Dos veces al día', '12 semanas', 'Oral'),
    (18, 'Psoriasis localizada', 'Aplicar capa fina', 'Dos veces al día', '4 semanas', 'Tópica'),
    (19, 'Melasma y hiperpigmentación', 'Aplicar capa fina', 'Dos veces al día', '6 meses', 'Tópica'),
    (20, 'Dermatofitosis', 'Aplicar capa fina', 'Dos veces al día', '4 semanas', 'Tópica');
GO

-- =====================================================
-- CONSULTAS ADICIONALES DE SEGUIMIENTO
-- =====================================================
INSERT INTO Consultas (id_historia, id_medico, fecha_consulta, motivo_consulta, tipo_enfermedad, historia_enfermedad, examen_fisico, plan_tratamiento, observaciones, estado_consulta)
VALUES 
    -- Consultas de seguimiento
    (3, 2, '2024-02-15 09:00:00', 'Control de dermatitis', 'Dermatitis de contacto', 'Mejoría parcial con tratamiento, persiste leve eritema', 'Eritema residual mínimo', 'Continuar hidrocortisona 2 semanas más', 'Evolución favorable', 'CERRADA'),
    (4, 3, '2024-03-15 10:30:00', 'Seguimiento acné', 'Acné vulgar', 'Mejoría significativa, reducción de lesiones inflamatorias', 'Disminución notable de pápulas', 'Continuar tratamiento actual', 'Excelente respuesta', 'CERRADA'),
    (5, 1, '2024-03-20 14:00:00', 'Control urticaria', 'Urticaria crónica', 'Episodios menos frecuentes con antihistamínicos', 'Sin lesiones activas al momento', 'Mantener antihistamínicos', 'Mejoría clínica', 'ACTIVA'),
    -- Nuevas consultas especializadas
    (6, 4, '2024-04-25 11:15:00', 'Caída de cabello', 'Alopecia androgénica', 'Paciente refiere pérdida progresiva de cabello frontal y coronilla', 'Alopecia patrón masculino grado III', 'Iniciar minoxidil 5% + finasterida', 'Explicar cronicidad del tratamiento'),
    (7, 2, '2024-05-01 15:45:00', 'Control melasma', 'Melasma', 'Leve mejoría en pigmentación con tratamiento actual', 'Hiperpigmentación facial persistente', 'Añadir ácido azelaico al régimen', 'Reforzar uso de protector solar'),
    (8, 5, '2024-05-10 08:30:00', 'Foliculitis recurrente', 'Foliculitis', 'Episodios recurrentes pese a tratamiento tópico', 'Nuevas lesiones en área dorsal', 'Antibioterapia sistémica', 'Considerar cultivo si no mejora'),
    (13, 5, '2024-04-20 14:30:00', 'Control dermatitis atópica', 'Dermatitis atópica', 'Mejoría con tratamiento, padres reportan menos prurito', 'Disminución del eritema', 'Continuar emolientes', 'Educación a padres reforzada'),
    (14, 3, '2024-04-25 10:00:00', 'Seguimiento acné adolescente', 'Acné', 'Buena adherencia al tratamiento, mejoría visible', 'Reducción de comedones', 'Mantener adapaleno', 'Motivar continuidad');
GO

-- =====================================================
-- RECETAS PARA NUEVAS CONSULTAS
-- =====================================================
INSERT INTO Recetas (id_consulta, diagnostico, fecha_vencimiento, estado_receta)
VALUES 
    (27, 'Alopecia androgénica masculina', '2024-07-25', 'VIGENTE'),
    (28, 'Melasma facial refractario', '2024-08-01', 'VIGENTE'),
    (29, 'Foliculitis bacteriana recurrente', '2024-08-10', 'VIGENTE'),
    (30, 'Dermatitis atópica en remisión', '2024-07-20', 'VIGENTE'),
    (31, 'Acné comedogénico en mejoría', '2024-07-25', 'VIGENTE');
GO

-- =====================================================
-- DETALLES DE RECETAS ESPECIALIZADAS
-- =====================================================
INSERT INTO DetalleRecetas (id_receta, id_indicacion, duracion_tratamiento, cantidad, instrucciones_adicionales, fecha_inicio_tratamiento, fecha_fin_tratamiento)
VALUES 
    (27, 11, '6 meses', 3, 'Aplicar en cuero cabelludo seco', '2024-04-25', '2024-10-25'),
    (27, 13, '6 meses', 6, 'Tomar con las comidas', '2024-04-25', '2024-10-25'),
    (28, 19, '3 meses', 3, 'Aplicar solo por la noche', '2024-05-01', '2024-08-01'),
    (28, 4, '3 meses', 3, 'Uso diario obligatorio', '2024-05-01', '2024-08-01'),
    (29, 17, '8 semanas', 2, 'Tomar con abundante agua', '2024-05-10', '2024-07-05'),
    (30, 9, '4 semanas', 2, 'Aplicar en piel húmeda', '2024-04-20', '2024-05-18'),
    (31, 7, '6 semanas', 2, 'Uso nocturno exclusivo', '2024-04-25', '2024-06-06');
GO