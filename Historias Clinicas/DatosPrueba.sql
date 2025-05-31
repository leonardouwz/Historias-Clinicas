-- =====================================================
-- DATOS DE EJEMPLO COMPLETOS - SISTEMA HISTORIAS CLÍNICAS
-- =====================================================
USE SistemaHistoriasClinicas;
GO
PRINT '======================================================';
PRINT 'INSERTANDO DATOS DE EJEMPLO COMPLETOS';
PRINT '======================================================';
-- =====================================================
-- PASO 1: ESPECIALIDADES MÉDICAS COMPLETAS
-- =====================================================
PRINT '';
PRINT '1. INSERTANDO ESPECIALIDADES MÉDICAS...';
PRINT '---------------------------------------';
INSERT INTO EspecialidadesMedicas (nombre_especialidad, descripcion) VALUES
('Dermatología', 'Especialidad médica que se encarga del estudio de la piel'),
('Medicina General', 'Atención médica general y preventiva'),
('Pediatría', 'Especialidad médica que se encarga de niños y adolescentes'),
('Cardiología', 'Especialidad médica que se encarga del estudio, diagnóstico y tratamiento de las enfermedades del corazón'),
('Neurología', 'Especialidad médica que trata los trastornos del sistema nervioso'),
('Traumatología', 'Especialidad médica que se dedica al estudio de las lesiones del aparato locomotor'),
('Ginecología', 'Especialidad médica que trata las enfermedades del sistema reproductor femenino'),
('Oftalmología', 'Especialidad médica que estudia las enfermedades de los ojos'),
('Otorrinolaringología', 'Especialidad médica que trata las enfermedades del oído, nariz y garganta'),
('Psiquiatría', 'Especialidad médica dedicada al estudio de los trastornos mentales'),
('Endocrinología', 'Especialidad médica que estudia las hormonas y las glándulas endocrinas'),
('Gastroenterología', 'Especialidad médica que estudia el aparato digestivo'),
('Neumología', 'Especialidad médica que se encarga de las enfermedades del aparato respiratorio'),
('Oncología', 'Especialidad médica que estudia y trata los tumores benignos y malignos'),
('Urología', 'Especialidad médica que se encarga del estudio del aparato genitourinario'),
('Reumatología', 'Especialidad médica dedicada a los trastornos médicos del aparato locomotor'),
('Medicina Interna', 'Especialidad médica que se dedica a la atención integral del adulto enfermo'),
('Cirugía General', 'Especialidad médica que abarca las operaciones del abdomen y sistema digestivo');
GO
PRINT 'Especialidades médicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 2: INFORMACIÓN DE CONTACTO MASIVA
-- =====================================================
PRINT '';
PRINT '2. INSERTANDO INFORMACIÓN DE CONTACTO...';
PRINT '----------------------------------------';
INSERT INTO InformacionContacto (telefono_principal, telefono_secundario, correo_electronico, direccion, ciudad, codigo_postal) VALUES
-- Contactos de Pacientes
('987654321', '01-2345678', 'ana.martinez@email.com', 'Av. Javier Prado 1234, San Isidro', 'Lima', '15036'),
('965432189', '01-3456789', 'carlos.rodriguez@gmail.com', 'Jr. Lampa 567, Cercado de Lima', 'Lima', '15001'),
('954321876', NULL, 'maria.gonzalez@outlook.com', 'Av. Arequipa 2345, Lince', 'Lima', '15046'),
('943218765', '01-4567890', 'luis.fernandez@yahoo.com', 'Calle Los Olivos 890, Los Olivos', 'Lima', '15304'),
('932187654', NULL, 'sofia.lopez@email.com', 'Av. Brasil 1122, Magdalena', 'Lima', '15076'),
('921876543', '01-5678901', 'diego.herrera@gmail.com', 'Jr. Ica 334, La Victoria', 'Lima', '15033'),
('910765432', NULL, 'carmen.torres@outlook.com', 'Av. Universitaria 445, San Martin de Porres', 'Lima', '15311'),
('987123456', '01-6789012', 'roberto.silva@email.com', 'Calle Las Flores 556, San Juan de Lurigancho', 'Lima', '15408'),
('976543210', NULL, 'patricia.morales@gmail.com', 'Av. Tupac Amaru 667, Independencia', 'Lima', '15311'),
('965432108', '01-7890123', 'fernando.castillo@yahoo.com', 'Jr. Huancayo 778, Breña', 'Lima', '15083'),
('954321097', NULL, 'isabella.ruiz@email.com', 'Av. Colonial 889, Callao', 'Callao', '15054'),
('943210986', '01-8901234', 'alejandro.mendoza@gmail.com', 'Calle San Martin 990, Miraflores', 'Lima', '15074'),
('932109875', NULL, 'valentina.jimenez@outlook.com', 'Av. Salaverry 1101, San Isidro', 'Lima', '15036'),
('921098764', '01-9012345', 'gabriel.vargas@email.com', 'Jr. Ancash 1212, Rimac', 'Lima', '15081'),
('910987653', NULL, 'camila.cruz@gmail.com', 'Av. Abancay 1323, Cercado de Lima', 'Lima', '15001'),
-- Contactos de Médicos
('987000001', '01-2000001', 'dr.cardiologo@clinica.com', 'Clínica San Pablo, Surco', 'Lima', '15023'),
('987000002', '01-2000002', 'dr.neurologo@hospital.com', 'Hospital Nacional, Jesus Maria', 'Lima', '15072'),
('987000003', '01-2000003', 'dr.traumatologo@clinica.com', 'Centro Médico, San Borja', 'Lima', '15037'),
('987000004', '01-2000004', 'dra.ginecologa@hospital.com', 'Hospital de la Mujer, Lima', 'Lima', '15001'),
('987000005', '01-2000005', 'dr.oftalmologo@clinica.com', 'Clínica de Ojos, Miraflores', 'Lima', '15074'),
('987000006', '01-2000006', 'dr.otorrino@hospital.com', 'Hospital Central, Lima', 'Lima', '15001'),
('987000007', '01-2000007', 'dr.psiquiatra@clinica.com', 'Centro de Salud Mental, San Isidro', 'Lima', '15036'),
('987000008', '01-2000008', 'dr.endocrinologo@hospital.com', 'Hospital Rebagliati, Jesus Maria', 'Lima', '15072'),
('987000009', '01-2000009', 'dr.gastroenterologo@clinica.com', 'Clínica Especializada, San Borja', 'Lima', '15037'),
('987000010', '01-2000010', 'dr.neumologo@hospital.com', 'Hospital del Tórax, Cercado', 'Lima', '15001'),
-- Contactos de Apoderados
('987555001', '01-3555001', 'madre.ana@email.com', 'Av. Javier Prado 1234, San Isidro', 'Lima', '15036'),
('987555002', '01-3555002', 'padre.carlos@gmail.com', 'Jr. Lampa 567, Cercado de Lima', 'Lima', '15001'),
('987555003', NULL, 'abuela.maria@outlook.com', 'Av. Arequipa 2345, Lince', 'Lima', '15046'),
('987555004', '01-3555004', 'tio.luis@yahoo.com', 'Calle Los Olivos 890, Los Olivos', 'Lima', '15304'),
('987555005', NULL, 'madre.sofia@email.com', 'Av. Brasil 1122, Magdalena', 'Lima', '15076');
GO
PRINT 'Información de contacto insertada: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 3: APODERADOS AMPLIADOS
-- =====================================================
PRINT '';
PRINT '3. INSERTANDO APODERADOS...';
PRINT '---------------------------';
INSERT INTO Apoderados (nombre_completo, dni, parentesco, id_contacto) VALUES
('Ana Isabel Martinez Ruiz', '40123456', 'Madre', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555001')),
('Carlos Eduardo Rodriguez Gomez', '41234567', 'Padre', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555002')),
('Maria Elena Gonzalez Perez', '42345678', 'Abuela', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555003')),
('Luis Alberto Fernandez Castro', '43456789', 'Tío', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555004')),
('Sofia Carmen Lopez Diaz', '44567890', 'Madre', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555005')),
('Diego Alejandro Herrera Morales', '45678901', 'Padre', NULL),
('Carmen Rosa Torres Vargas', '46789012', 'Abuela', NULL),
('Roberto Miguel Silva Jimenez', '47890123', 'Abuelo', NULL);
GO
PRINT 'Apoderados insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 4: MÉDICOS COMPLETOS POR ESPECIALIDAD
-- =====================================================
PRINT '';
PRINT '4. INSERTANDO MÉDICOS...';
PRINT '------------------------';
INSERT INTO Medicos (nombre_completo, dni, id_especialidad, numero_colegiatura, id_contacto) VALUES
-- Dermatología (id_especialidad = 1)
('Dr. Julio Hugo Vega Zuñiga', '22556677', 1, 'CMP12345', NULL),
('Dra. Carmen Elena Rodriguez Paz', '22667788', 1, 'CMP12346', NULL),
-- Medicina General (id_especialidad = 2)  
('Dr. Luis Alberto Mendoza Silva', '46778899', 2, 'CMP12347', NULL),
('Dra. Ana Maria Gonzalez Torres', '47889900', 2, 'CMP12348', NULL),
-- Pediatría (id_especialidad = 3)
('Dr. Roberto Carlos Fernandez Lopez', '48990011', 3, 'CMP12349', NULL),
('Dra. Sofia Isabel Martinez Ruiz', '49001122', 3, 'CMP12350', NULL),
-- Cardiología (id_especialidad = 4)
('Dr. Diego Fernando Herrera Castro', '50112233', 4, 'CMP12351', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000001')),
('Dra. Patricia Carmen Torres Diaz', '51223344', 4, 'CMP12352', NULL),
-- Neurología (id_especialidad = 5)
('Dr. Fernando Gabriel Castillo Morales', '52334455', 5, 'CMP12353', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000002')),
('Dra. Isabella Maria Ruiz Vargas', '53445566', 5, 'CMP12354', NULL),
-- Traumatología (id_especialidad = 6)
('Dr. Alejandro Miguel Mendoza Jimenez', '54556677', 6, 'CMP12355', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000003')),
('Dr. Gabriel Eduardo Vargas Silva', '55667788', 6, 'CMP12356', NULL),
-- Ginecología (id_especialidad = 7)
('Dra. Camila Rosa Cruz Herrera', '56778899', 7, 'CMP12357', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000004')),
('Dra. Valentina Elena Jimenez Torres', '57889900', 7, 'CMP12358', NULL),
-- Oftalmología (id_especialidad = 8)
('Dr. Nicolas Alberto Rodriguez Martinez', '58990011', 8, 'CMP12359', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000005')),
-- Otorrinolaringología (id_especialidad = 9)
('Dr. Sebastian Carlos Gonzalez Fernandez', '59001122', 9, 'CMP12360', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000006')),
-- Psiquiatría (id_especialidad = 10)
('Dra. Lucia Isabel Lopez Castillo', '60112233', 10, 'CMP12361', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000007')),
-- Endocrinología (id_especialidad = 11)
('Dr. Mateo Fernando Ruiz Mendoza', '61223344', 11, 'CMP12362', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000008')),
-- Gastroenterología (id_especialidad = 12)
('Dr. Santiago Miguel Mendoza Vargas', '62334455', 12, 'CMP12363', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000009')),
-- Neumología (id_especialidad = 13)
('Dra. Emma Carolina Jimenez Cruz', '63445566', 13, 'CMP12364', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000010'));
GO
PRINT 'Médicos insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 5: PACIENTES DIVERSOS (ADULTOS Y MENORES)
-- =====================================================
PRINT '';
PRINT '5. INSERTANDO PACIENTES...';
PRINT '--------------------------';
INSERT INTO Pacientes (nombre_completo, dni, fecha_nacimiento, genero, id_apoderado, id_contacto) VALUES
-- Pacientes Adultos
('Ana Patricia Martinez Gonzalez', '70123456', '1985-03-15', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987654321')),
('Carlos Eduardo Rodriguez Silva', '71234567', '1978-07-22', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '965432189')),
('Maria Elena Gonzalez Torres', '72345678', '1992-11-08', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '954321876')),
('Luis Alberto Fernandez Castro', '73456789', '1980-04-30', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '943218765')),
('Sofia Isabel Lopez Diaz', '74567890', '1995-09-14', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '932187654')),
('Diego Fernando Herrera Morales', '75678901', '1987-12-03', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '921876543')),
('Carmen Rosa Torres Vargas', '76789012', '1975-06-18', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '910765432')),
('Roberto Miguel Silva Jimenez', '77890123', '1983-02-25', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987123456')),
('Patricia Elena Morales Cruz', '78901234', '1990-08-12', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '976543210')),
('Fernando Gabriel Castillo Herrera', '79012345', '1982-05-07', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '965432108')),
('Isabella Maria Ruiz Torres', '80123456', '1988-10-20', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '954321097')),
('Alejandro Carlos Mendoza Silva', '81234567', '1979-01-16', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '943210986')),
('Valentina Rosa Jimenez Gonzalez', '82345678', '1993-07-09', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '932109875')),
('Gabriel Eduardo Vargas Fernandez', '83456789', '1986-03-28', 'M', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '921098764')),
('Camila Elena Cruz Martinez', '84567890', '1991-12-15', 'F', NULL, (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '910987653')),
-- Pacientes Menores de Edad
('Mateo Santiago Rodriguez Lopez', '85678901', '2015-04-10', 'M', 1, NULL), -- Apoderado: Ana Isabel Martinez
('Emma Lucia Gonzalez Castro', '86789012', '2018-08-22', 'F', 2, NULL), -- Apoderado: Carlos Eduardo Rodriguez
('Nicolas Alejandro Fernandez Diaz', '87890123', '2012-06-15', 'M', 3, NULL), -- Apoderado: Maria Elena Gonzalez
('Sebastian Diego Torres Silva', '88901234', '2016-11-03', 'M', 4, NULL), -- Apoderado: Luis Alberto Fernandez
('Lucia Valentina Herrera Morales', '89012345', '2019-02-28', 'F', 5, NULL), -- Apoderado: Sofia Carmen Lopez
('Santiago Gabriel Silva Torres', '90123456', '2014-09-12', 'M', 6, NULL), -- Apoderado: Diego Alejandro Herrera
('Carolina Isabella Morales Vargas', '91234567', '2017-05-07', 'F', 7, NULL), -- Apoderado: Carmen Rosa Torres
('Benjamin Mateo Castillo Jimenez', '92345678', '2013-10-20', 'M', 8, NULL), -- Apoderado: Roberto Miguel Silva
('Antonella Sofia Ruiz Cruz', '93456789', '2020-01-14', 'F', 1, NULL), -- Mismo apoderado que Mateo
('Leonardo Diego Mendoza Herrera', '94567890', '2011-07-26', 'M', 2, NULL); -- Mismo apoderado que Emma
GO
PRINT 'Pacientes insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 6: MEDICAMENTOS AMPLIADOS POR ESPECIALIDAD
-- =====================================================
PRINT '';
PRINT '6. INSERTANDO MEDICAMENTOS...';
PRINT '-----------------------------';
INSERT INTO Medicamentos (nombre, principio_activo, descripcion, presentacion, concentracion, contraindicaciones) VALUES
-- Dermatología
('Betametasona', 'Betametasona dipropionato', 'Corticoide tópico de potencia alta', 'Crema', '0.05%', 'Infecciones virales, bacterianas o fúngicas de la piel'),
('Ketoconazol', 'Ketoconazol', 'Antifúngico tópico', 'Crema', '2%', 'Hipersensibilidad al ketoconazol'),
('Tretinoína', 'Tretinoína', 'Retinoide tópico para acné', 'Gel', '0.025%', 'Embarazo, lactancia, piel lesionada'),
-- Cardiología
('Enalapril', 'Enalapril maleato', 'Inhibidor de la ECA', 'Tabletas', '10mg', 'Embarazo, angioedema previo'),
('Metoprolol', 'Metoprolol tartrato', 'Beta bloqueador cardioselectivo', 'Tabletas', '50mg', 'Bradicardia severa, bloqueo AV'),
('Atorvastatina', 'Atorvastatina cálcica', 'Estatina para dislipidemia', 'Tabletas', '20mg', 'Enfermedad hepática activa'),
-- Neurología
('Levetiracetam', 'Levetiracetam', 'Anticonvulsivante', 'Tabletas', '500mg', 'Hipersensibilidad al levetiracetam'),
('Gabapentina', 'Gabapentina', 'Anticonvulsivante y analgésico neuropático', 'Cápsulas', '300mg', 'Hipersensibilidad a gabapentina'),
-- Traumatología
('Diclofenaco', 'Diclofenaco sódico', 'AINE para dolor e inflamación', 'Tabletas', '50mg', 'Úlcera péptica activa, insuficiencia renal severa'),
('Ibuprofeno', 'Ibuprofeno', 'AINE analgésico y antiinflamatorio', 'Tabletas', '400mg', 'Úlcera péptica, insuficiencia cardíaca severa'),
-- Ginecología
('Etinilestradiol + Levonorgestrel', 'Etinilestradiol + Levonorgestrel', 'Anticonceptivo oral combinado', 'Tabletas', '0.03mg + 0.15mg', 'Tromboembolismo, cáncer de mama'),
('Clotrimazol', 'Clotrimazol', 'Antifúngico vaginal', 'Óvulos', '500mg', 'Hipersensibilidad al clotrimazol'),
-- Oftalmología
('Timolol', 'Timolol maleato', 'Beta bloqueador para glaucoma', 'Gotas oftálmicas', '0.5%', 'Asma bronquial, bradicardia severa'),
('Prednisolona', 'Prednisolona acetato', 'Corticoide oftálmico', 'Gotas oftálmicas', '1%', 'Infecciones virales del ojo'),
-- Psiquiatría
('Sertralina', 'Sertralina clorhidrato', 'Antidepresivo ISRS', 'Tabletas', '50mg', 'Uso concomitante con IMAO'),
('Lorazepam', 'Lorazepam', 'Benzodiacepina ansiolítica', 'Tabletas', '1mg', 'Miastenia gravis, glaucoma de ángulo cerrado'),
-- Endocrinología
('Metformina', 'Metformina clorhidrato', 'Antidiabético oral', 'Tabletas', '850mg', 'Insuficiencia renal, acidosis metabólica'),
('Levotiroxina', 'Levotiroxina sódica', 'Hormona tiroidea sintética', 'Tabletas', '50mcg', 'Tirotoxicosis no tratada'),
-- Gastroenterología
('Omeprazol', 'Omeprazol', 'Inhibidor de bomba de protones', 'Cápsulas', '20mg', 'Hipersensibilidad al omeprazol'),
('Loperamida', 'Loperamida clorhidrato', 'Antidiarreico', 'Tabletas', '2mg', 'Colitis ulcerosa aguda, disentería'),
-- Neumología
('Salbutamol', 'Salbutamol sulfato', 'Broncodilatador beta2 agonista', 'Inhalador', '100mcg/dosis', 'Hipersensibilidad al salbutamol'),
('Budesonida', 'Budesonida', 'Corticoide inhalado', 'Inhalador', '200mcg/dosis', 'Infecciones respiratorias no tratadas'),
-- Pediatría
('Paracetamol', 'Paracetamol', 'Analgésico y antipirético', 'Jarabe', '160mg/5ml', 'Insuficiencia hepática severa'),
('Amoxicilina', 'Amoxicilina', 'Antibiótico betalactámico', 'Suspensión', '250mg/5ml', 'Alergia a penicilinas');
GO
PRINT 'Medicamentos insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 7: INDICACIONES DE MEDICAMENTOS
-- =====================================================
PRINT '';
PRINT '7. INSERTANDO INDICACIONES DE MEDICAMENTOS...';
PRINT '---------------------------------------------';
INSERT INTO IndicacionesMedicamentos (id_medicamento, indicacion, dosis_recomendada, frecuencia, duracion_maxima, via_administracion) VALUES
-- Medicamentos Dermatológicos
(1, 'Dermatitis severa, psoriasis', 'Aplicar capa fina', '2 veces al día', '2 semanas', 'Tópica'),
(2, 'Herpes labial recurrente', 'Aplicar sobre lesión', '5 veces al día', '10 días', 'Tópica'),
(2, 'Tiña corporis', 'Aplicar sobre área afectada', '2 veces al día', '4 semanas', 'Tópica'),
(2, 'Candidiasis cutánea', 'Aplicar generosamente', '2 veces al día', '2 semanas', 'Tópica'),
(3, 'Acné comedonal', 'Aplicar por las noches', '1 vez al día', '12 semanas', 'Tópica'),
(3, 'Fotoenvejecimiento', 'Aplicar gradualmente', '3 veces por semana', '24 semanas', 'Tópica'),
-- Medicamentos Cardiológicos
(4, 'Hipertensión arterial', '10-20mg', '1 vez al día', 'Crónico', 'Oral'),
(4, 'Insuficiencia cardíaca', '2.5-5mg inicial', '2 veces al día', 'Crónico', 'Oral'),
(5, 'Hipertensión arterial', '50-100mg', '1-2 veces al día', 'Crónico', 'Oral'),
(5, 'Angina de pecho', '50mg', '2 veces al día', 'Crónico', 'Oral'),
(6, 'Dislipidemia', '10-20mg', '1 vez al día', 'Crónico', 'Oral'),
(6, 'Prevención cardiovascular', '20mg', '1 vez al día', 'Crónico', 'Oral'),
-- Medicamentos Neurológicos
(7, 'Epilepsia focal', '500mg inicial', '2 veces al día', 'Crónico', 'Oral'),
(7, 'Epilepsia generalizada', '1000mg', '2 veces al día', 'Crónico', 'Oral'),
(8, 'Dolor neuropático', '300mg inicial', '3 veces al día', 'Crónico', 'Oral'),
(8, 'Fibromialgia', '300-600mg', '3 veces al día', 'Crónico', 'Oral'),
-- Medicamentos Traumatológicos
(9, 'Dolor agudo musculoesquelético', '50mg', '3 veces al día', '7 días', 'Oral'),
(9, 'Artritis reumatoide', '50mg', '2-3 veces al día', '4 semanas', 'Oral'),
(10, 'Dolor leve a moderado', '400mg', '3 veces al día', '10 días', 'Oral'),
(10, 'Inflamación articular', '600mg', '3 veces al día', '2 semanas', 'Oral'),
-- Medicamentos Ginecológicos
(11, 'Anticoncepción hormonal', '1 tableta', '1 vez al día', 'Crónico', 'Oral'),
(12, 'Candidiasis vaginal', '1 óvulo', 'Dosis única', '1 día', 'Vaginal'),
(12, 'Vaginitis por cándida', '1 óvulo', '1 vez al día', '3 días', 'Vaginal'),
-- Medicamentos Oftalmológicos
(13, 'Glaucoma de ángulo abierto', '1 gota', '2 veces al día', 'Crónico', 'Oftálmica'),
(14, 'Uveítis anterior', '1-2 gotas', '4 veces al día', '2 semanas', 'Oftálmica'),
(14, 'Conjuntivitis alérgica', '1 gota', '3 veces al día', '1 semana', 'Oftálmica'),
-- Medicamentos Psiquiátricos
(15, 'Depresión mayor', '50mg inicial', '1 vez al día', 'Crónico', 'Oral'),
(15, 'Trastorno de ansiedad generalizada', '25mg inicial', '1 vez al día', 'Crónico', 'Oral'),
(16, 'Trastorno de ansiedad', '0.5-1mg', '2-3 veces al día', '4 semanas', 'Oral'),
(16, 'Insomnio transitorio', '1-2mg', '1 vez antes de dormir', '2 semanas', 'Oral'),
-- Medicamentos Endocrinos
(17, 'Diabetes mellitus tipo 2', '500-850mg', '2-3 veces al día', 'Crónico', 'Oral'),
(17, 'Síndrome de ovario poliquístico', '500mg', '2 veces al día', 'Crónico', 'Oral'),
(18, 'Hipotiroidismo', '25-50mcg inicial', '1 vez al día', 'Crónico', 'Oral'),
(18, 'Mixedema', '100-200mcg', '1 vez al día', 'Crónico', 'Oral'),
-- Medicamentos Gastroenterológicos
(19, 'Úlcera duodenal', '20mg', '1 vez al día', '4-8 semanas', 'Oral'),
(19, 'Reflujo gastroesofágico', '20-40mg', '1 vez al día', 'Crónico', 'Oral'),
(20, 'Diarrea aguda', '4mg inicial, luego 2mg', 'Después de cada deposición', '48 horas', 'Oral'),
(20, 'Síndrome del intestino irritable', '2mg', '2-4 veces al día', '2 semanas', 'Oral'),
-- Medicamentos Neumológicos
(21, 'Asma bronquial', '100-200mcg', '4-6 veces al día', 'Según necesidad', 'Inhalada'),
(21, 'Broncoespasmo agudo', '200mcg', 'Cada 4-6 horas', 'Según necesidad', 'Inhalada'),
(22, 'Asma persistente', '200-400mcg', '2 veces al día', 'Crónico', 'Inhalada'),
(22, 'EPOC estable', '400mcg', '2 veces al día', 'Crónico', 'Inhalada'),
-- Medicamentos Pediátricos
(23, 'Fiebre en niños', '10-15mg/kg', 'Cada 6-8 horas', '3 días', 'Oral'),
(23, 'Dolor leve en pediatría', '10mg/kg', 'Cada 6 horas', '5 días', 'Oral'),
(24, 'Infecciones respiratorias en niños', '20-40mg/kg/día', 'Cada 8 horas', '7-10 días', 'Oral'),
(24, 'Otitis media aguda', '80-90mg/kg/día', 'Cada 12 horas', '10 días', 'Oral');
GO
PRINT 'Indicaciones de medicamentos insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 8: HISTORIAS CLÍNICAS COMPLETAS
-- =====================================================
PRINT '';
PRINT '8. INSERTANDO HISTORIAS CLÍNICAS...';
PRINT '-----------------------------------';
INSERT INTO HistoriasClinicas (id_paciente, alergias, antecedentes_personales, antecedentes_familiares) VALUES
-- Historias de pacientes adultos
(1, 'Penicilina - rash cutáneo', 'Hipertensión arterial desde hace 5 años, diabetes mellitus tipo 2 desde hace 3 años', 'Padre: diabetes, hipertensión. Madre: cáncer de mama'),
(2, 'Ninguna conocida', 'Fumador de 20 cigarrillos diarios por 15 años, ex alcoholismo hace 2 años', 'Padre: infarto agudo de miocardio a los 55 años. Hermano: hipertensión'),
(3, 'Ácido acetilsalicílico - broncoespasmo', 'Asma bronquial desde la infancia, rinitis alérgica estacional', 'Madre: asma bronquial. Abuelo materno: EPOC'),
(4, 'Mariscos - urticaria generalizada', 'Gastritis crónica, colecistolitiasis', 'Madre: diabetes mellitus tipo 2. Padre: hipertensión arterial'),
(5, 'Ninguna conocida', 'Migraña crónica, síndrome del ovario poliquístico', 'Hermana: migraña. Abuela materna: diabetes'),
(6, 'Contraste yodado - reacción anafiláctica', 'Insuficiencia renal crónica estadio 3, gota', 'Padre: insuficiencia renal crónica. Tío paterno: gota'),
(7, 'Sulfonamidas - síndrome de Stevens-Johnson', 'Lupus eritematoso sistémico, osteoporosis', 'Madre: artritis reumatoide. Hermana: lupus'),
(8, 'Ninguna conocida', 'Úlcera duodenal, reflujo gastroesofágico', 'Padre: úlcera gástrica. Abuelo paterno: cáncer gástrico'),
(9, 'Metamizol - agranulocitosis', 'Fibromialgia, síndrome del intestino irritable', 'Madre: fibromialgia. Hermana: colitis ulcerosa'),
(10, 'Ninguna conocida', 'Epilepsia desde los 20 años, bien controlada', 'Tío materno: epilepsia. Primo: convulsiones febriles'),
(11, 'Latex - dermatitis de contacto', 'Endometriosis, quistes ováricos recurrentes', 'Madre: endometriosis. Hermana: síndrome del ovario poliquístico'),
(12, 'Ninguna conocida', 'Hernia discal L4-L5, artritis de rodillas', 'Padre: artritis reumatoide. Abuelo: osteoartrosis severa'),
(13, 'Dipirona - reacción cutánea', 'Hipotiroidismo, osteopenia', 'Madre: hipotiroidismo. Abuela: osteoporosis'),
(14, 'Ninguna conocida', 'Ansiedad generalizada, insomnio crónico', 'Padre: depresión mayor. Hermano: trastorno bipolar'),
(15, 'Gluten - enfermedad celíaca', 'Enfermedad celíaca, anemia ferropénica', 'Prima: enfermedad celíaca. Tía: anemia perniciosa'),
-- Historias de pacientes menores (con datos adaptados a pediatría)
(16, 'Ninguna conocida', 'Nacimiento a término, peso 3.2kg, lactancia materna exclusiva 6 meses', 'Padre: asma. Madre: rinitis alérgica'),
(17, 'Huevo - urticaria', 'Dermatitis atópica desde los 6 meses, múltiples episodios de bronquiolitis', 'Abuelo paterno: asma. Madre: dermatitis atópica'),
(18, 'Ninguna conocida', 'Retraso del lenguaje leve, otitis media recurrente', 'Padre: otitis crónica en infancia. Hermana mayor: retraso del lenguaje'),
(19, 'Frutos secos - reacción anafiláctica', 'Múltiples alergias alimentarias, eczema severo', 'Madre: múltiples alergias. Hermano: asma alérgica'),
(20, 'Ninguna conocida', 'Prematuridad 34 semanas, displasia broncopulmonar leve', 'Abuela materna: diabetes gestacional. Tío: fibrosis quística'),
(21, 'Ninguna conocida', 'Convulsiones febriles a los 2 años, desarrollo psicomotor normal', 'Padre: epilepsia. Abuelo paterno: convulsiones'),
(22, 'Penicilina - rash', 'Amigdalitis recurrente, adenoides hipertróficas', 'Madre: amigdalitis crónica. Hermana: adenoidectomía'),
(23, 'Ninguna conocida', 'Reflujo gastroesofágico neonatal, resuelto', 'Padre: reflujo. Tío materno: hernia hiatal'),
(24, 'Ninguna conocida', 'Soplo cardíaco funcional, peso bajo para edad', 'Abuelo: cardiopatía congénita. Prima: soplo funcional'),
(25, 'Ninguna conocida', 'Desarrollo normal, vacunas al día', 'Sin antecedentes familiares relevantes');
GO
PRINT 'Historias clínicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 9: CONSULTAS MÉDICAS VARIADAS
-- =====================================================
PRINT '';
PRINT '9. INSERTANDO CONSULTAS MÉDICAS...';
PRINT '-----------------------------------';
INSERT INTO Consultas (id_historia, id_medico, fecha_consulta, tipo_enfermedad, historia_enfermedad, examen_fisico, plan_tratamiento, observaciones) VALUES
-- Consultas Cardiológicas
(1, 7, '2024-01-15 09:30:00', 'Hipertensión Arterial', 
'Paciente refiere cefalea occipital matutina de 3 días de evolución, acompañada de mareos y visión borrosa ocasional. Refiere haber suspendido medicación antihipertensiva hace 1 semana por olvido.',
'PA: 180/110 mmHg, FC: 95 lpm, FR: 20 rpm. Examen cardiovascular: ruidos cardíacos rítmicos, no soplos. Fondo de ojo: cambios hipertensivos grado II',
'Reiniciar enalapril 10mg/día, control dietético, ejercicio moderado, control en 1 semana',
'Paciente educado sobre importancia de adherencia al tratamiento'),
-- Consultas Neurológicas  
(10, 9, '2024-01-20 14:00:00', 'Epilepsia',
'Paciente presenta crisis convulsiva tónico-clónica generalizada hace 2 días, primera crisis en 6 meses. Refiere estrés laboral y pocas horas de sueño última semana.',
'Consciente, orientado, sin déficit neurológico focal. Mordedura lateral de lengua. EEG previo con descargas epileptiformes temporales',
'Ajuste de dosis de levetiracetam a 1000mg c/12h, higiene del sueño, manejo del estrés',
'Control en 1 mes, considerar nueva EEG si persisten crisis'),
-- Consultas Dermatológicas
(3, 1, '2024-02-01 10:15:00', 'Dermatitis Atópica',
'Exacerbación de dermatitis atópica en flexuras de codos y rodillas, prurito intenso que interfiere con el sueño, lesiones de 1 semana de evolución',
'Eritema, edema y vesículas en flexuras. Excoriaciones secundarias a rascado. Piel seca generalizada',
'Betametasona crema 0.05% en lesiones activas, emolientes, antihistamínicos orales',
'Evitar desencadenantes conocidos, ropa de algodón'),
-- Consultas Ginecológicas
(11, 13, '2024-02-05 11:30:00', 'Endometriosis',
'Dismenorrea severa que ha empeorado en últimos 3 ciclos, dolor pélvico crónico, dispareunia. Sangrado menstrual abundante',
'Dolor a la movilización uterina, nodularidad en fondos de saco. Masa anexial derecha palpable',
'Ecografía transvaginal, marcadores tumorales, AINES para dolor, considerar tratamiento hormonal',
'Referencia a especialista en reproducción humana'),
-- Consultas Pediátricas
(16, 5, '2024-02-10 15:45:00', 'Bronquiolitis',
'Niño de 8 meses con tos, dificultad respiratoria y fiebre de 38.5°C por 3 días. Rechazo parcial de alimentos, irritabilidad',
'Temp: 38.2°C, FR: 50 rpm, tiraje subcostal leve. Crepitantes bilaterales, sibilancias espiratorias',
'Nebulizaciones con salbutamol, paracetamol para fiebre, hidratación oral fraccionada',
'Control diario, signos de alarma explicados a madre'),
-- Consultas de Medicina Interna
(4, 3, '2024-02-12 09:00:00', 'Gastritis Crónica',
'Epigastralgia recurrente de 2 meses, relacionada con comidas, pirosis ocasional, pérdida de peso de 3kg',
'Abdomen blando, dolor epigástrico a la palpación profunda, no masas palpables, ruidos hidroaéreos normales',
'Omeprazol 20mg/día, dieta blanda, endoscopia digestiva alta, test para H. pylori',
'Evitar irritantes gástricas, AINES'),
-- Consultas Traumatológicas
(12, 11, '2024-02-15 16:20:00', 'Lumbalgia Mecánica',
'Dolor lumbar de inicio súbito tras levantar objeto pesado hace 5 días, irradiación a glúteo derecho, mejora con reposo',
'Contractura paravertebral L4-L5, Lasègue negativo, fuerza conservada en miembros inferiores',
'Diclofenaco 50mg c/8h, relajante muscular, fisioterapia, ejercicios de Williams',
'Reposo relativo, aplicación de calor local'),
-- Consultas Oftalmológicas
(2, 15, '2024-02-18 11:00:00', 'Glaucoma',
'Control rutinario de glaucoma, refiere cumplimiento de tratamiento, sin síntomas visuales',
'AV: OD 20/30, OI 20/25. PIO: OD 18mmHg, OI 16mmHg. Excavación papilar 0.6 bilateral estable',
'Continuar timolol gotas c/12h, control de PIO en 3 meses, campimetría anual',
'Evolución favorable con tratamiento actual'),
-- Consultas Psiquiátricas
(14, 17, '2024-02-20 14:30:00', 'Trastorno de Ansiedad',
'Ansiedad generalizada que ha empeorado último mes, insomnio de conciliación, preocupaciones excesivas sobre trabajo y familia',
'Paciente ansiosa, inquieta, colaboradora. Sin ideas suicidas actuales. Insight conservado',
'Sertralina 50mg/día, técnicas de relajación, psicoterapia cognitivo-conductual',
'Control en 2 semanas para evaluar respuesta inicial'),
-- Consultas Endocrinológicas  
(1, 18, '2024-02-22 10:45:00', 'Diabetes Mellitus Tipo 2',
'Control de diabetes, refiere poliuria y polidipsia última semana, glicemias capilares entre 180-220mg/dl',
'IMC: 28.5, PA: 140/85mmHg. Examen de pies sin lesiones. Resto normal',
'Ajuste de metformina a 850mg c/12h, hemoglobina glicosilada, perfil lipídico, educación diabetológica',
'Control en 1 mes, derivar a nutricionista');
GO
PRINT 'Consultas médicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================  
-- PASO 10: RECETAS MÉDICAS COMPLETAS
-- =====================================================
PRINT '';
PRINT '10. INSERTANDO RECETAS MÉDICAS...';
PRINT '---------------------------------';
INSERT INTO Recetas (id_consulta, diagnostico, fecha_vencimiento, sello_medico, firma_medico) VALUES
(1, 'Hipertensión Arterial Sistémica. Crisis Hipertensiva Grado II', '2024-02-15', 'CMP12351', 'Dr. Diego Fernando Herrera Castro'),
(2, 'Epilepsia Focal Sintomática. Crisis Tónico-Clónica Generalizada', '2024-02-20', 'CMP12353', 'Dr. Fernando Gabriel Castillo Morales'),
(3, 'Dermatitis Atópica Severa. Exacerbación Aguda', '2024-03-01', 'CMP12345', 'Dr. Julio Hugo Vega Zuñiga'),
(4, 'Endometriosis Pélvica. Dismenorrea Severa', '2024-03-05', 'CMP12357', 'Dra. Camila Rosa Cruz Herrera'),
(5, 'Bronquiolitis Aguda. Síndrome Bronquial Obstructivo', '2024-02-17', 'CMP12349', 'Dr. Roberto Carlos Fernandez Lopez'),
(6, 'Gastritis Crónica Atrófica. Dispepsia Funcional', '2024-03-12', 'CMP12363', 'Dr. Santiago Miguel Mendoza Vargas'),
(7, 'Lumbalgia Mecánica Aguda. Contractura Muscular Paravertebral', '2024-02-22', 'CMP12355', 'Dr. Alejandro Miguel Mendoza Jimenez'),
(8, 'Glaucoma Primario de Ángulo Abierto Bilateral', '2024-05-18', 'CMP12359', 'Dr. Nicolas Alberto Rodriguez Martinez'),
(9, 'Trastorno de Ansiedad Generalizada. Episodio Depresivo Leve', '2024-03-20', 'CMP12361', 'Dra. Lucia Isabel Lopez Castillo'),
(10, 'Diabetes Mellitus Tipo 2 Descompensada. Hipertensión Arterial', '2024-03-22', 'CMP12362', 'Dr. Mateo Fernando Ruiz Mendoza');
GO
PRINT 'Recetas médicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);
-- =====================================================
-- PASO 11: DETALLES DE RECETAS CON MEDICAMENTOS
-- =====================================================
PRINT '';
PRINT '11. INSERTANDO DETALLES DE RECETAS...';
PRINT '------------------------------------';
INSERT INTO DetalleRecetas (id_receta, id_indicacion, duracion_tratamiento, cantidad, instrucciones_adicionales, fecha_inicio_tratamiento, fecha_fin_tratamiento) VALUES
-- Receta 1: Hipertensión
(1, 7, '30 días', 30, 'Tomar en ayunas, controlar presión arterial diariamente', '2024-01-15', '2024-02-14'),
-- Receta 2: Epilepsia  
(2, 13, '60 días', 120, 'No suspender bruscamente, tomar con alimentos', '2024-01-20', '2024-03-20'),
-- Receta 3: Dermatitis
(3, 1, '14 días', 2, 'Aplicar capa fina, no usar en cara, suspender gradualmente', '2024-02-01', '2024-02-15'),
-- Receta 4: Endometriosis
(4, 17, '15 días', 45, 'Tomar con alimentos, suspender si sangrado gastrointestinal', '2024-02-05', '2024-02-20'),
-- Receta 5: Bronquiolitis
(5, 31, '7 días', 1, 'Nebulizar cada 6 horas, agitar antes de usar', '2024-02-10', '2024-02-17'),
(5, 33, '3 días', 1, 'Solo si fiebre mayor a 38°C, máximo cada 6 horas', '2024-02-10', '2024-02-13'),
-- Receta 6: Gastritis
(6, 29, '30 días', 30, 'Tomar 30 minutos antes del desayuno', '2024-02-12', '2024-03-14'),
-- Receta 7: Lumbalgia
(7, 17, '7 días', 21, 'Tomar después de comidas, suspender si dolor epigástrico', '2024-02-15', '2024-02-22'),
-- Receta 8: Glaucoma
(8, 23, '90 días', 3, 'Instalar 1 gota cada 12 horas, presionar saco lagrimal', '2024-02-18', '2024-05-18'),
-- Receta 9: Ansiedad
(9, 25, '30 días', 30, 'Tomar con alimentos, no suspender bruscamente', '2024-02-20', '2024-03-22'),
-- Receta 10: Diabetes
(10, 27, '30 días', 60, 'Tomar con primera comida del día y cena', '2024-02-22', '2024-03-24');
GO
PRINT 'Detalles de recetas insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);
PRINT '';
PRINT '======================================================';
PRINT 'INSERCIÓN DE DATOS COMPLETADA EXITOSAMENTE';
PRINT '======================================================';
PRINT 'RESUMEN:';
PRINT '- Especialidades médicas: 18';
PRINT '- Información de contacto: 30+';
PRINT '- Apoderados: 8';
PRINT '- Médicos: 15+';
PRINT '- Pacientes: 25 (15 adultos + 10 menores)';
PRINT '- Medicamentos: 24';
PRINT '- Indicaciones de medicamentos: 34+';
PRINT '- Historias clínicas: 25';
PRINT '- Consultas médicas: 10';
PRINT '- Recetas médicas: 10';
PRINT '- Detalles de recetas: 12';
PRINT '======================================================';
