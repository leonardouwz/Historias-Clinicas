-- =====================================================
-- DATOS DE EJEMPLO COMPLETOS - SISTEMA HISTORIAS CL�NICAS
-- =====================================================

USE SistemaHistoriasClinicas;
GO

PRINT '======================================================';
PRINT 'INSERTANDO DATOS DE EJEMPLO COMPLETOS';
PRINT '======================================================';


-- Limpiar especialidades existentes si es necesario
DELETE FROM EspecialidadesMedicas WHERE id_especialidad > 3;
GO

INSERT INTO EspecialidadesMedicas (nombre_especialidad, descripcion) VALUES
('Dermatolog�a', 'Especialidad m�dica que se encarga del estudio de la piel'),
('Medicina General', 'Atenci�n m�dica general y preventiva'),
('Pediatr�a', 'Especialidad m�dica que se encarga de ni�os y adolescentes'),
('Cardiolog�a', 'Especialidad m�dica que se encarga del estudio, diagn�stico y tratamiento de las enfermedades del coraz�n'),
('Neurolog�a', 'Especialidad m�dica que trata los trastornos del sistema nervioso'),
('Traumatolog�a', 'Especialidad m�dica que se dedica al estudio de las lesiones del aparato locomotor'),
('Ginecolog�a', 'Especialidad m�dica que trata las enfermedades del sistema reproductor femenino'),
('Oftalmolog�a', 'Especialidad m�dica que estudia las enfermedades de los ojos'),
('Otorrinolaringolog�a', 'Especialidad m�dica que trata las enfermedades del o�do, nariz y garganta'),
('Psiquiatr�a', 'Especialidad m�dica dedicada al estudio de los trastornos mentales'),
('Endocrinolog�a', 'Especialidad m�dica que estudia las hormonas y las gl�ndulas endocrinas'),
('Gastroenterolog�a', 'Especialidad m�dica que estudia el aparato digestivo'),
('Neumolog�a', 'Especialidad m�dica que se encarga de las enfermedades del aparato respiratorio'),
('Oncolog�a', 'Especialidad m�dica que estudia y trata los tumores benignos y malignos'),
('Urolog�a', 'Especialidad m�dica que se encarga del estudio del aparato genitourinario'),
('Reumatolog�a', 'Especialidad m�dica dedicada a los trastornos m�dicos del aparato locomotor'),
('Medicina Interna', 'Especialidad m�dica que se dedica a la atenci�n integral del adulto enfermo'),
('Cirug�a General', 'Especialidad m�dica que abarca las operaciones del abdomen y sistema digestivo');
GO

PRINT 'Especialidades m�dicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 2: INFORMACI�N DE CONTACTO MASIVA
-- =====================================================

PRINT '';
PRINT '2. INSERTANDO INFORMACI�N DE CONTACTO...';
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
('965432108', '01-7890123', 'fernando.castillo@yahoo.com', 'Jr. Huancayo 778, Bre�a', 'Lima', '15083'),
('954321097', NULL, 'isabella.ruiz@email.com', 'Av. Colonial 889, Callao', 'Callao', '15054'),
('943210986', '01-8901234', 'alejandro.mendoza@gmail.com', 'Calle San Martin 990, Miraflores', 'Lima', '15074'),
('932109875', NULL, 'valentina.jimenez@outlook.com', 'Av. Salaverry 1101, San Isidro', 'Lima', '15036'),
('921098764', '01-9012345', 'gabriel.vargas@email.com', 'Jr. Ancash 1212, Rimac', 'Lima', '15081'),
('910987653', NULL, 'camila.cruz@gmail.com', 'Av. Abancay 1323, Cercado de Lima', 'Lima', '15001'),

-- Contactos de M�dicos
('987000001', '01-2000001', 'dr.cardiologo@clinica.com', 'Cl�nica San Pablo, Surco', 'Lima', '15023'),
('987000002', '01-2000002', 'dr.neurologo@hospital.com', 'Hospital Nacional, Jesus Maria', 'Lima', '15072'),
('987000003', '01-2000003', 'dr.traumatologo@clinica.com', 'Centro M�dico, San Borja', 'Lima', '15037'),
('987000004', '01-2000004', 'dra.ginecologa@hospital.com', 'Hospital de la Mujer, Lima', 'Lima', '15001'),
('987000005', '01-2000005', 'dr.oftalmologo@clinica.com', 'Cl�nica de Ojos, Miraflores', 'Lima', '15074'),
('987000006', '01-2000006', 'dr.otorrino@hospital.com', 'Hospital Central, Lima', 'Lima', '15001'),
('987000007', '01-2000007', 'dr.psiquiatra@clinica.com', 'Centro de Salud Mental, San Isidro', 'Lima', '15036'),
('987000008', '01-2000008', 'dr.endocrinologo@hospital.com', 'Hospital Rebagliati, Jesus Maria', 'Lima', '15072'),
('987000009', '01-2000009', 'dr.gastroenterologo@clinica.com', 'Cl�nica Especializada, San Borja', 'Lima', '15037'),
('987000010', '01-2000010', 'dr.neumologo@hospital.com', 'Hospital del T�rax, Cercado', 'Lima', '15001'),

-- Contactos de Apoderados
('987555001', '01-3555001', 'madre.ana@email.com', 'Av. Javier Prado 1234, San Isidro', 'Lima', '15036'),
('987555002', '01-3555002', 'padre.carlos@gmail.com', 'Jr. Lampa 567, Cercado de Lima', 'Lima', '15001'),
('987555003', NULL, 'abuela.maria@outlook.com', 'Av. Arequipa 2345, Lince', 'Lima', '15046'),
('987555004', '01-3555004', 'tio.luis@yahoo.com', 'Calle Los Olivos 890, Los Olivos', 'Lima', '15304'),
('987555005', NULL, 'madre.sofia@email.com', 'Av. Brasil 1122, Magdalena', 'Lima', '15076');
GO

PRINT 'Informaci�n de contacto insertada: ' + CAST(@@ROWCOUNT AS VARCHAR);

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
('Luis Alberto Fernandez Castro', '43456789', 'T�o', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555004')),
('Sofia Carmen Lopez Diaz', '44567890', 'Madre', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987555005')),
('Diego Alejandro Herrera Morales', '45678901', 'Padre', NULL),
('Carmen Rosa Torres Vargas', '46789012', 'Abuela', NULL),
('Roberto Miguel Silva Jimenez', '47890123', 'Abuelo', NULL);
GO

PRINT 'Apoderados insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 4: M�DICOS COMPLETOS POR ESPECIALIDAD
-- =====================================================

PRINT '';
PRINT '4. INSERTANDO M�DICOS...';
PRINT '------------------------';

INSERT INTO Medicos (nombre_completo, dni, id_especialidad, numero_colegiatura, id_contacto) VALUES
-- Dermatolog�a (id_especialidad = 1)
('Dr. Julio Hugo Vega Zu�iga', '22556677', 1, 'CMP12345', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '945678901')),
('Dra. Carmen Elena Rodriguez Paz', '22667788', 1, 'CMP12346', NULL),

-- Medicina General (id_especialidad = 2)  
('Dr. Luis Alberto Mendoza Silva', '46778899', 2, 'CMP12347', NULL),
('Dra. Ana Maria Gonzalez Torres', '47889900', 2, 'CMP12348', NULL),

-- Pediatr�a (id_especialidad = 3)
('Dr. Roberto Carlos Fernandez Lopez', '48990011', 3, 'CMP12349', NULL),
('Dra. Sofia Isabel Martinez Ruiz', '49001122', 3, 'CMP12350', NULL),

-- Cardiolog�a (id_especialidad = 4)
('Dr. Diego Fernando Herrera Castro', '50112233', 4, 'CMP12351', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000001')),
('Dra. Patricia Carmen Torres Diaz', '51223344', 4, 'CMP12352', NULL),

-- Neurolog�a (id_especialidad = 5)
('Dr. Fernando Gabriel Castillo Morales', '52334455', 5, 'CMP12353', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000002')),
('Dra. Isabella Maria Ruiz Vargas', '53445566', 5, 'CMP12354', NULL),

-- Traumatolog�a (id_especialidad = 6)
('Dr. Alejandro Miguel Mendoza Jimenez', '54556677', 6, 'CMP12355', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000003')),
('Dr. Gabriel Eduardo Vargas Silva', '55667788', 6, 'CMP12356', NULL),

-- Ginecolog�a (id_especialidad = 7)
('Dra. Camila Rosa Cruz Herrera', '56778899', 7, 'CMP12357', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000004')),
('Dra. Valentina Elena Jimenez Torres', '57889900', 7, 'CMP12358', NULL),

-- Oftalmolog�a (id_especialidad = 8)
('Dr. Nicolas Alberto Rodriguez Martinez', '58990011', 8, 'CMP12359', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000005')),

-- Otorrinolaringolog�a (id_especialidad = 9)
('Dr. Sebastian Carlos Gonzalez Fernandez', '59001122', 9, 'CMP12360', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000006')),

-- Psiquiatr�a (id_especialidad = 10)
('Dra. Lucia Isabel Lopez Castillo', '60112233', 10, 'CMP12361', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000007')),

-- Endocrinolog�a (id_especialidad = 11)
('Dr. Mateo Fernando Ruiz Mendoza', '61223344', 11, 'CMP12362', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000008')),

-- Gastroenterolog�a (id_especialidad = 12)
('Dr. Santiago Miguel Mendoza Vargas', '62334455', 12, 'CMP12363', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000009')),

-- Neumolog�a (id_especialidad = 13)
('Dra. Emma Carolina Jimenez Cruz', '63445566', 13, 'CMP12364', (SELECT TOP 1 id_contacto FROM InformacionContacto WHERE telefono_principal = '987000010'));
GO

PRINT 'M�dicos insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);

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
('Mateo Santiago Rodriguez Lopez', '85678901', '2015-04-10', 'M', 3, NULL), -- Apoderado: Ana Isabel Martinez
('Emma Lucia Gonzalez Castro', '86789012', '2018-08-22', 'F', 4, NULL), -- Apoderado: Carlos Eduardo Rodriguez
('Nicolas Alejandro Fernandez Diaz', '87890123', '2012-06-15', 'M', 5, NULL), -- Apoderado: Maria Elena Gonzalez
('Sebastian Diego Torres Silva', '88901234', '2016-11-03', 'M', 6, NULL), -- Apoderado: Luis Alberto Fernandez
('Lucia Valentina Herrera Morales', '89012345', '2019-02-28', 'F', 7, NULL), -- Apoderado: Sofia Carmen Lopez
('Santiago Gabriel Silva Torres', '90123456', '2014-09-12', 'M', 8, NULL), -- Apoderado: Diego Alejandro Herrera
('Carolina Isabella Morales Vargas', '91234567', '2017-05-07', 'F', 9, NULL), -- Apoderado: Carmen Rosa Torres
('Benjamin Mateo Castillo Jimenez', '92345678', '2013-10-20', 'M', 10, NULL), -- Apoderado: Roberto Miguel Silva
('Antonella Sofia Ruiz Cruz', '93456789', '2020-01-14', 'F', 3, NULL), -- Mismo apoderado que Mateo
('Leonardo Diego Mendoza Herrera', '94567890', '2011-07-26', 'M', 4, NULL); -- Mismo apoderado que Emma
GO

PRINT 'Pacientes insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 6: MEDICAMENTOS AMPLIADOS POR ESPECIALIDAD
-- =====================================================

PRINT '';
PRINT '6. INSERTANDO MEDICAMENTOS...';
PRINT '-----------------------------';

INSERT INTO Medicamentos (nombre, principio_activo, descripcion, presentacion, concentracion, contraindicaciones) VALUES
-- Dermatolog�a
('Betametasona', 'Betametasona dipropionato', 'Corticoide t�pico de potencia alta', 'Crema', '0.05%', 'Infecciones virales, bacterianas o f�ngicas de la piel'),
('Ketoconazol', 'Ketoconazol', 'Antif�ngico t�pico', 'Crema', '2%', 'Hipersensibilidad al ketoconazol'),
('Tretino�na', 'Tretino�na', 'Retinoide t�pico para acn�', 'Gel', '0.025%', 'Embarazo, lactancia, piel lesionada'),

-- Cardiolog�a
('Enalapril', 'Enalapril maleato', 'Inhibidor de la ECA', 'Tabletas', '10mg', 'Embarazo, angioedema previo'),
('Metoprolol', 'Metoprolol tartrato', 'Beta bloqueador cardioselectivo', 'Tabletas', '50mg', 'Bradicardia severa, bloqueo AV'),
('Atorvastatina', 'Atorvastatina c�lcica', 'Estatina para dislipidemia', 'Tabletas', '20mg', 'Enfermedad hep�tica activa'),

-- Neurolog�a
('Levetiracetam', 'Levetiracetam', 'Anticonvulsivante', 'Tabletas', '500mg', 'Hipersensibilidad al levetiracetam'),
('Gabapentina', 'Gabapentina', 'Anticonvulsivante y analg�sico neurop�tico', 'C�psulas', '300mg', 'Hipersensibilidad a gabapentina'),

-- Traumatolog�a
('Diclofenaco', 'Diclofenaco s�dico', 'AINE para dolor e inflamaci�n', 'Tabletas', '50mg', '�lcera p�ptica activa, insuficiencia renal severa'),
('Ibuprofeno', 'Ibuprofeno', 'AINE analg�sico y antiinflamatorio', 'Tabletas', '400mg', '�lcera p�ptica, insuficiencia card�aca severa'),

-- Ginecolog�a
('Etinilestradiol + Levonorgestrel', 'Etinilestradiol + Levonorgestrel', 'Anticonceptivo oral combinado', 'Tabletas', '0.03mg + 0.15mg', 'Tromboembolismo, c�ncer de mama'),
('Clotrimazol', 'Clotrimazol', 'Antif�ngico vaginal', '�vulos', '500mg', 'Hipersensibilidad al clotrimazol'),

-- Oftalmolog�a
('Timolol', 'Timolol maleato', 'Beta bloqueador para glaucoma', 'Gotas oft�lmicas', '0.5%', 'Asma bronquial, bradicardia severa'),
('Prednisolona', 'Prednisolona acetato', 'Corticoide oft�lmico', 'Gotas oft�lmicas', '1%', 'Infecciones virales del ojo'),

-- Psiquiatr�a
('Sertralina', 'Sertralina clorhidrato', 'Antidepresivo ISRS', 'Tabletas', '50mg', 'Uso concomitante con IMAO'),
('Lorazepam', 'Lorazepam', 'Benzodiacepina ansiol�tica', 'Tabletas', '1mg', 'Miastenia gravis, glaucoma de �ngulo cerrado'),

-- Endocrinolog�a
('Metformina', 'Metformina clorhidrato', 'Antidiab�tico oral', 'Tabletas', '850mg', 'Insuficiencia renal, acidosis metab�lica'),
('Levotiroxina', 'Levotiroxina s�dica', 'Hormona tiroidea sint�tica', 'Tabletas', '50mcg', 'Tirotoxicosis no tratada'),

-- Gastroenterolog�a
('Omeprazol', 'Omeprazol', 'Inhibidor de bomba de protones', 'C�psulas', '20mg', 'Hipersensibilidad al omeprazol'),
('Loperamida', 'Loperamida clorhidrato', 'Antidiarreico', 'Tabletas', '2mg', 'Colitis ulcerosa aguda, disenter�a'),

-- Neumolog�a
('Salbutamol', 'Salbutamol sulfato', 'Broncodilatador beta2 agonista', 'Inhalador', '100mcg/dosis', 'Hipersensibilidad al salbutamol'),
('Budesonida', 'Budesonida', 'Corticoide inhalado', 'Inhalador', '200mcg/dosis', 'Infecciones respiratorias no tratadas'),

-- Pediatr�a
('Paracetamol', 'Paracetamol', 'Analg�sico y antipir�tico', 'Jarabe', '160mg/5ml', 'Insuficiencia hep�tica severa'),
('Amoxicilina', 'Amoxicilina', 'Antibi�tico betalact�mico', 'Suspensi�n', '250mg/5ml', 'Alergia a penicilinas');
GO

PRINT 'Medicamentos insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 7: INDICACIONES DE MEDICAMENTOS
-- =====================================================

PRINT '';
PRINT '7. INSERTANDO INDICACIONES DE MEDICAMENTOS...';
PRINT '---------------------------------------------';

INSERT INTO IndicacionesMedicamentos (id_medicamento, indicacion, dosis_recomendada, frecuencia, duracion_maxima, via_administracion) VALUES
-- Medicamentos Dermatol�gicos
(1, 'Dermatitis severa, psoriasis', 'Aplicar capa fina', '2 veces al d�a', '2 semanas', 'T�pica'),
(2, 'Herpes labial recurrente', 'Aplicar sobre lesi�n', '5 veces al d�a', '10 d�as', 'T�pica'),
(3, 'Acn� noduloqu�stico severo', '0.5-1 mg/kg/d�a', '1 vez al d�a', '16-20 semanas', 'Oral'),
(4, 'Dermatitis at�pica severa', 'Aplicar capa fina', '2 veces al d�a', '4 semanas', 'T�pica'),
(4, 'Psoriasis en placas', 'Aplicar sobre lesiones', '1 vez al d�a', '6 semanas', 'T�pica'),
(5, 'Ti�a corporis', 'Aplicar sobre �rea afectada', '2 veces al d�a', '4 semanas', 'T�pica'),
(5, 'Candidiasis cut�nea', 'Aplicar generosamente', '2 veces al d�a', '2 semanas', 'T�pica'),
(6, 'Acn� comedonal', 'Aplicar por las noches', '1 vez al d�a', '12 semanas', 'T�pica'),
(6, 'Fotoenvejecimiento', 'Aplicar gradualmente', '3 veces por semana', '24 semanas', 'T�pica'),

-- Medicamentos Cardiol�gicos
(7, 'Hipertensi�n arterial', '10-20mg', '1 vez al d�a', 'Cr�nico', 'Oral'),
(7, 'Insuficiencia card�aca', '2.5-5mg inicial', '2 veces al d�a', 'Cr�nico', 'Oral'),
(8, 'Hipertensi�n arterial', '50-100mg', '1-2 veces al d�a', 'Cr�nico', 'Oral'),
(8, 'Angina de pecho', '50mg', '2 veces al d�a', 'Cr�nico', 'Oral'),
(9, 'Dislipidemia', '10-20mg', '1 vez al d�a', 'Cr�nico', 'Oral'),
(9, 'Prevenci�n cardiovascular', '20mg', '1 vez al d�a', 'Cr�nico', 'Oral'),

-- Medicamentos Neurol�gicos
(10, 'Epilepsia focal', '500mg inicial', '2 veces al d�a', 'Cr�nico', 'Oral'),
(10, 'Epilepsia generalizada', '1000mg', '2 veces al d�a', 'Cr�nico', 'Oral'),
(11, 'Dolor neurop�tico', '300mg inicial', '3 veces al d�a', 'Cr�nico', 'Oral'),
(11, 'Fibromialgia', '300-600mg', '3 veces al d�a', 'Cr�nico', 'Oral'),

-- Medicamentos Traumatol�gicos
(12, 'Dolor agudo musculoesquel�tico', '50mg', '3 veces al d�a', '7 d�as', 'Oral'),
(12, 'Artritis reumatoide', '50mg', '2-3 veces al d�a', '4 semanas', 'Oral'),
(13, 'Dolor leve a moderado', '400mg', '3 veces al d�a', '10 d�as', 'Oral'),
(13, 'Inflamaci�n articular', '600mg', '3 veces al d�a', '2 semanas', 'Oral'),

-- Medicamentos Ginecol�gicos
(14, 'Anticoncepci�n hormonal', '1 tableta', '1 vez al d�a', 'Cr�nico', 'Oral'),
(15, 'Candidiasis vaginal', '1 �vulo', 'Dosis �nica', '1 d�a', 'Vaginal'),
(15, 'Vaginitis por c�ndida', '1 �vulo', '1 vez al d�a', '3 d�as', 'Vaginal'),

-- Medicamentos Oftalmol�gicos
(16, 'Glaucoma de �ngulo abierto', '1 gota', '2 veces al d�a', 'Cr�nico', 'Oft�lmica'),
(17, 'Uve�tis anterior', '1-2 gotas', '4 veces al d�a', '2 semanas', 'Oft�lmica'),
(17, 'Conjuntivitis al�rgica', '1 gota', '3 veces al d�a', '1 semana', 'Oft�lmica'),

-- Medicamentos Psiqui�tricos
(18, 'Depresi�n mayor', '50mg inicial', '1 vez al d�a', 'Cr�nico', 'Oral'),
(18, 'Trastorno de ansiedad generalizada', '25mg inicial', '1 vez al d�a', 'Cr�nico', 'Oral'),
(19, 'Trastorno de ansiedad', '0.5-1mg', '2-3 veces al d�a', '4 semanas', 'Oral'),
(19, 'Insomnio transitorio', '1-2mg', '1 vez antes de dormir', '2 semanas', 'Oral'),

-- Medicamentos Endocrinos
(20, 'Diabetes mellitus tipo 2', '500-850mg', '2-3 veces al d�a', 'Cr�nico', 'Oral'),
(20, 'S�ndrome de ovario poliqu�stico', '500mg', '2 veces al d�a', 'Cr�nico', 'Oral'),
(21, 'Hipotiroidismo', '25-50mcg inicial', '1 vez al d�a', 'Cr�nico', 'Oral'),
(21, 'Mixedema', '100-200mcg', '1 vez al d�a', 'Cr�nico', 'Oral'),

-- Medicamentos Gastroenterol�gicos
(22, '�lcera duodenal', '20mg', '1 vez al d�a', '4-8 semanas', 'Oral'),
(22, 'Reflujo gastroesof�gico', '20-40mg', '1 vez al d�a', 'Cr�nico', 'Oral'),
(23, 'Diarrea aguda', '4mg inicial, luego 2mg', 'Despu�s de cada deposici�n', '48 horas', 'Oral'),
(23, 'S�ndrome del intestino irritable', '2mg', '2-4 veces al d�a', '2 semanas', 'Oral'),

-- Medicamentos Neumol�gicos
(24, 'Asma bronquial', '100-200mcg', '4-6 veces al d�a', 'Seg�n necesidad', 'Inhalada'),
(24, 'Broncoespasmo agudo', '200mcg', 'Cada 4-6 horas', 'Seg�n necesidad', 'Inhalada'),
(25, 'Asma persistente', '200-400mcg', '2 veces al d�a', 'Cr�nico', 'Inhalada'),
(25, 'EPOC estable', '400mcg', '2 veces al d�a', 'Cr�nico', 'Inhalada'),

-- Medicamentos Pedi�tricos
(26, 'Fiebre en ni�os', '10-15mg/kg', 'Cada 6-8 horas', '3 d�as', 'Oral'),
(26, 'Dolor leve en pediatr�a', '10mg/kg', 'Cada 6 horas', '5 d�as', 'Oral'),
(27, 'Infecciones respiratorias en ni�os', '20-40mg/kg/d�a', 'Cada 8 horas', '7-10 d�as', 'Oral'),
(27, 'Otitis media aguda', '80-90mg/kg/d�a', 'Cada 12 horas', '10 d�as', 'Oral');
GO

PRINT 'Indicaciones de medicamentos insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 8: INSERTAR ESPECIALIDADES M�DICAS B�SICAS
-- =====================================================

PRINT '';
PRINT '8. INSERTANDO ESPECIALIDADES M�DICAS B�SICAS...';
PRINT '-----------------------------------------------';

INSERT INTO EspecialidadesMedicas (nombre_especialidad, descripcion) VALUES
('Dermatolog�a', 'Especialidad m�dica que estudia la estructura y funci�n de la piel'),
('Medicina General', 'Atenci�n m�dica integral y continua del individuo y la familia'),
('Pediatr�a', 'Especialidad m�dica que estudia al ni�o y sus enfermedades');
GO

PRINT 'Especialidades m�dicas b�sicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 9: HISTORIAS CL�NICAS COMPLETAS
-- =====================================================

PRINT '';
PRINT '9. INSERTANDO HISTORIAS CL�NICAS...';
PRINT '-----------------------------------';

INSERT INTO HistoriasClinicas (id_paciente, alergias, antecedentes_personales, antecedentes_familiares) VALUES
-- Historias de pacientes adultos
(1, 'Penicilina - rash cut�neo', 'Hipertensi�n arterial desde hace 5 a�os, diabetes mellitus tipo 2 desde hace 3 a�os', 'Padre: diabetes, hipertensi�n. Madre: c�ncer de mama'),
(2, 'Ninguna conocida', 'Fumador de 20 cigarrillos diarios por 15 a�os, ex alcoholismo hace 2 a�os', 'Padre: infarto agudo de miocardio a los 55 a�os. Hermano: hipertensi�n'),
(3, '�cido acetilsalic�lico - broncoespasmo', 'Asma bronquial desde la infancia, rinitis al�rgica estacional', 'Madre: asma bronquial. Abuelo materno: EPOC'),
(4, 'Mariscos - urticaria generalizada', 'Gastritis cr�nica, colecistolitiasis', 'Madre: diabetes mellitus tipo 2. Padre: hipertensi�n arterial'),
(5, 'Ninguna conocida', 'Migra�a cr�nica, s�ndrome del ovario poliqu�stico', 'Hermana: migra�a. Abuela materna: diabetes'),
(6, 'Contraste yodado - reacci�n anafil�ctica', 'Insuficiencia renal cr�nica estadio 3, gota', 'Padre: insuficiencia renal cr�nica. T�o paterno: gota'),
(7, 'Sulfonamidas - s�ndrome de Stevens-Johnson', 'Lupus eritematoso sist�mico, osteoporosis', 'Madre: artritis reumatoide. Hermana: lupus'),
(8, 'Ninguna conocida', '�lcera duodenal, reflujo gastroesof�gico', 'Padre: �lcera g�strica. Abuelo paterno: c�ncer g�strico'),
(9, 'Metamizol - agranulocitosis', 'Fibromialgia, s�ndrome del intestino irritable', 'Madre: fibromialgia. Hermana: colitis ulcerosa'),
(10, 'Ninguna conocida', 'Epilepsia desde los 20 a�os, bien controlada', 'T�o materno: epilepsia. Primo: convulsiones febriles'),
(11, 'Latex - dermatitis de contacto', 'Endometriosis, quistes ov�ricos recurrentes', 'Madre: endometriosis. Hermana: s�ndrome del ovario poliqu�stico'),
(12, 'Ninguna conocida', 'Hernia discal L4-L5, artritis de rodillas', 'Padre: artritis reumatoide. Abuelo: osteoartrosis severa'),
(13, 'Dipirona - reacci�n cut�nea', 'Hipotiroidismo, osteopenia', 'Madre: hipotiroidismo. Abuela: osteoporosis'),
(14, 'Ninguna conocida', 'Ansiedad generalizada, insomnio cr�nico', 'Padre: depresi�n mayor. Hermano: trastorno bipolar'),
(15, 'Gluten - enfermedad cel�aca', 'Enfermedad cel�aca, anemia ferrop�nica', 'Prima: enfermedad cel�aca. T�a: anemia perniciosa'),

-- Historias de pacientes menores (con datos adaptados a pediatr�a)
(16, 'Ninguna conocida', 'Nacimiento a t�rmino, peso 3.2kg, lactancia materna exclusiva 6 meses', 'Padre: asma. Madre: rinitis al�rgica'),
(17, 'Huevo - urticaria', 'Dermatitis at�pica desde los 6 meses, m�ltiples episodios de bronquiolitis', 'Abuelo paterno: asma. Madre: dermatitis at�pica'),
(18, 'Ninguna conocida', 'Retraso del lenguaje leve, otitis media recurrente', 'Padre: otitis cr�nica en infancia. Hermana mayor: retraso del lenguaje'),
(19, 'Frutos secos - reacci�n anafil�ctica', 'M�ltiples alergias alimentarias, eczema severo', 'Madre: m�ltiples alergias. Hermano: asma al�rgica'),
(20, 'Ninguna conocida', 'Prematuridad 34 semanas, displasia broncopulmonar leve', 'Abuela materna: diabetes gestacional. T�o: fibrosis qu�stica'),
(21, 'Ninguna conocida', 'Convulsiones febriles a los 2 a�os, desarrollo psicomotor normal', 'Padre: epilepsia. Abuelo paterno: convulsiones'),
(22, 'Penicilina - rash', 'Amigdalitis recurrente, adenoides hipertr�ficas', 'Madre: amigdalitis cr�nica. Hermana: adenoidectom�a'),
(23, 'Ninguna conocida', 'Reflujo gastroesof�gico neonatal, resuelto', 'Padre: reflujo. T�o materno: hernia hiatal'),
(24, 'Ninguna conocida', 'Soplo card�aco funcional, peso bajo para edad', 'Abuelo: cardiopat�a cong�nita. Prima: soplo funcional'),
(25, 'Ninguna conocida', 'Desarrollo normal, vacunas al d�a', 'Sin antecedentes familiares relevantes');
GO

PRINT 'Historias cl�nicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 10: CONSULTAS M�DICAS VARIADAS
-- =====================================================

PRINT '';
PRINT '10. INSERTANDO CONSULTAS M�DICAS...';
PRINT '-----------------------------------';

INSERT INTO Consultas (id_historia, id_medico, fecha_consulta, tipo_enfermedad, historia_enfermedad, examen_fisico, plan_tratamiento, observaciones) VALUES
-- Consultas Cardiol�gicas
(1, 9, '2024-01-15 09:30:00', 'Hipertensi�n Arterial', 
'Paciente refiere cefalea occipital matutina de 3 d�as de evoluci�n, acompa�ada de mareos y visi�n borrosa ocasional. Refiere haber suspendido medicaci�n antihipertensiva hace 1 semana por olvido.',
'PA: 180/110 mmHg, FC: 95 lpm, FR: 20 rpm. Examen cardiovascular: ruidos card�acos r�tmicos, no soplos. Fondo de ojo: cambios hipertensivos grado II',
'Reiniciar enalapril 10mg/d�a, control diet�tico, ejercicio moderado, control en 1 semana',
'Paciente educado sobre importancia de adherencia al tratamiento'),

-- Consultas Neurol�gicas  
(10, 11, '2024-01-20 14:00:00', 'Epilepsia',
'Paciente presenta crisis convulsiva t�nico-cl�nica generalizada hace 2 d�as, primera crisis en 6 meses. Refiere estr�s laboral y pocas horas de sue�o �ltima semana.',
'Consciente, orientado, sin d�ficit neurol�gico focal. Mordedura lateral de lengua. EEG previo con descargas epileptiformes temporales',
'Ajuste de dosis de levetiracetam a 1000mg c/12h, higiene del sue�o, manejo del estr�s',
'Control en 1 mes, considerar nueva EEG si persisten crisis'),

-- Consultas Dermatol�gicas
(3, 1, '2024-02-01 10:15:00', 'Dermatitis At�pica',
'Exacerbaci�n de dermatitis at�pica en flexuras de codos y rodillas, prurito intenso que interfiere con el sue�o, lesiones de 1 semana de evoluci�n',
'Eritema, edema y ves�culas en flexuras. Excoriaciones secundarias a rascado. Piel seca generalizada',
'Betametasona crema 0.05% en lesiones activas, emolientes, antihistam�nicos orales',
'Evitar desencadenantes conocidos, ropa de algod�n'),

-- Consultas Ginecol�gicas
(11, 15, '2024-02-05 11:30:00', 'Endometriosis',
'Dismenorrea severa que ha empeorado en �ltimos 3 ciclos, dolor p�lvico cr�nico, dispareunia. Sangrado menstrual abundante',
'Dolor a la movilizaci�n uterina, nodularidad en fondos de saco. Masa anexial derecha palpable',
'Ecograf�a transvaginal, marcadores tumorales, AINES para dolor, considerar tratamiento hormonal',
'Referencia a especialista en reproducci�n humana'),

-- Consultas Pedi�tricas
(16, 6, '2024-02-10 15:45:00', 'Bronquiolitis',
'Ni�o de 8 meses con tos, dificultad respiratoria y fiebre de 38.5�C por 3 d�as. Rechazo parcial de alimentos, irritabilidad',
'Temp: 38.2�C, FR: 50 rpm, tiraje subcostal leve. Crepitantes bilaterales, sibilancias espiratorias',
'Nebulizaciones con salbutamol, paracetamol para fiebre, hidrataci�n oral fraccionada',
'Control diario, signos de alarma explicados a madre'),

-- Consultas de Medicina Interna
(4, 4, '2024-02-12 09:00:00', 'Gastritis Cr�nica',
'Epigastralgia recurrente de 2 meses, relacionada con comidas, pirosis ocasional, p�rdida de peso de 3kg',
'Abdomen blando, dolor epig�strico a la palpaci�n profunda, no masas palpables, ruidos hidroa�reos normales',
'Omeprazol 20mg/d�a, dieta blanda, endoscopia digestiva alta, test para H. pylori',
'Evitar irritantes g�stricas, AINES'),

-- Consultas Traumatol�gicas
(12, 12, '2024-02-15 16:20:00', 'Lumbalgia Mec�nica',
'Dolor lumbar de inicio s�bito tras levantar objeto pesado hace 5 d�as, irradiaci�n a gl�teo derecho, mejora con reposo',
'Contractura paravertebral L4-L5, Las�gue negativo, fuerza conservada en miembros inferiores',
'Diclofenaco 50mg c/8h, relajante muscular, fisioterapia, ejercicios de Williams',
'Reposo relativo, aplicaci�n de calor local'),

-- Consultas Oftalmol�gicas
(2, 14, '2024-02-18 11:00:00', 'Glaucoma',
'Control rutinario de glaucoma, refiere cumplimiento de tratamiento, sin s�ntomas visuales',
'AV: OD 20/30, OI 20/25. PIO: OD 18mmHg, OI 16mmHg. Excavaci�n papilar 0.6 bilateral estable',
'Continuar timolol gotas c/12h, control de PIO en 3 meses, campimetr�a anual',
'Evoluci�n favorable con tratamiento actual'),

-- Consultas Psiqui�tricas
(14, 18, '2024-02-20 14:30:00', 'Trastorno de Ansiedad',
'Ansiedad generalizada que ha empeorado �ltimo mes, insomnio de conciliaci�n, preocupaciones excesivas sobre trabajo y familia',
'Paciente ansiosa, inquieta, colaboradora. Sin ideas suicidas actuales. Insight conservado',
'Sertralina 50mg/d�a, t�cnicas de relajaci�n, psicoterapia cognitivo-conductual',
'Control en 2 semanas para evaluar respuesta inicial'),

-- Consultas Endocrinol�gicas  
(1, 19, '2024-02-22 10:45:00', 'Diabetes Mellitus Tipo 2',
'Control de diabetes, refiere poliuria y polidipsia �ltima semana, glicemias capilares entre 180-220mg/dl',
'IMC: 28.5, PA: 140/85mmHg. Examen de pies sin lesiones. Resto normal',
'Ajuste de metformina a 850mg c/12h, hemoglobina glicosilada, perfil lip�dico, educaci�n diabetol�gica',
'Control en 1 mes, derivar a nutricionista');
GO

PRINT 'Consultas m�dicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================  
-- PASO 11: RECETAS M�DICAS COMPLETAS
-- =====================================================

PRINT '';
PRINT '11. INSERTANDO RECETAS M�DICAS...';
PRINT '---------------------------------';

INSERT INTO Recetas (id_consulta, diagnostico, fecha_vencimiento, sello_medico, firma_medico) VALUES
(1, 'Hipertensi�n Arterial Sist�mica. Crisis Hipertensiva Grado II', '2024-02-15', 'CMP12351', 'Dr. Diego Fernando Herrera Castro'),
(2, 'Epilepsia Focal Sintom�tica. Crisis T�nico-Cl�nica Generalizada', '2024-02-20', 'CMP12353', 'Dr. Fernando Gabriel Castillo Morales'),
(3, 'Dermatitis At�pica Severa. Exacerbaci�n Aguda', '2024-03-01', 'CMP12345', 'Dr. Julio Hugo Vega Zu�iga'),
(4, 'Endometriosis P�lvica. Dismenorrea Severa', '2024-03-05', 'CMP12357', 'Dra. Camila Rosa Cruz Herrera'),
(5, 'Bronquiolitis Aguda. S�ndrome Bronquial Obstructivo', '2024-02-17', 'CMP12349', 'Dr. Roberto Carlos Fernandez Lopez'),
(6, 'Gastritis Cr�nica Atr�fica. Dispepsia Funcional', '2024-03-12', 'CMP12363', 'Dr. Santiago Miguel Mendoza Vargas'),
(7, 'Lumbalgia Mec�nica Aguda. Contractura Muscular Paravertebral', '2024-02-22', 'CMP12355', 'Dr. Alejandro Miguel Mendoza Jimenez'),
(8, 'Glaucoma Primario de �ngulo Abierto Bilateral', '2024-05-18', 'CMP12359', 'Dr. Nicolas Alberto Rodriguez Martinez'),
(9, 'Trastorno de Ansiedad Generalizada. Episodio Depresivo Leve', '2024-03-20', 'CMP12361', 'Dra. Lucia Isabel Lopez Castillo'),
(10, 'Diabetes Mellitus Tipo 2 Descompensada. Hipertensi�n Arterial', '2024-03-22', 'CMP12362', 'Dr. Mateo Fernando Ruiz Mendoza');
GO

PRINT 'Recetas m�dicas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- =====================================================
-- PASO 12: DETALLES DE RECETAS CON MEDICAMENTOS
-- =====================================================

PRINT '';
PRINT '12. INSERTANDO DETALLES DE RECETAS...';
PRINT '------------------------------------';

INSERT INTO DetalleRecetas (id_receta, id_indicacion, duracion_tratamiento, cantidad, instrucciones_adicionales, fecha_inicio_tratamiento, fecha_fin_tratamiento) VALUES
-- Receta 1: Hipertensi�n
(1, 7, '30 d�as', 30, 'Tomar en ayunas, controlar presi�n arterial diariamente', '2024-01-15', '2024-02-14'),

-- Receta 2: Epilepsia  
(2, 10, '60 d�as', 120, 'No suspender bruscamente, tomar con alimentos', '2024-01-20', '2024-03-20'),

-- Receta 3: Dermatitis
(3, 4, '14 d�as', 2, 'Aplicar capa fina, no usar en cara, suspender gradualmente', '2024-02-01', '2024-02-15'),

-- Receta 4: Endometriosis
(4, 12, '15 d�as', 45, 'Tomar con alimentos, suspender si sangrado gastrointestinal', '2024-02-05', '2024-02-20'),

-- Receta 5: Bronquiolitis
(5, 24, '7 d�as', 1, 'Nebulizar cada 6 horas, agitar antes de usar', '2024-02-10', '2024-02-17'),
(5, 26, '3 d�as', 1, 'Solo si fiebre mayor a 38�C, m�ximo cada 6 horas', '2024-02-10', '2024-02-13'),

-- Receta 6: Gastritis
(6, 22, '30 d�as', 30, 'Tomar 30 minutos antes del desayuno', '2024-02-12', '2024-03-14'),

-- Receta 7: Lumbalgia
(7, 12, '7 d�as', 21, 'Tomar despu�s de comidas, suspender si dolor epig�strico', '2024-02-15', '2024-02-22'),

-- Receta 8: Glaucoma
(8, 16, '90 d�as', 3, 'Instalar 1 gota cada 12 horas, presionar saco lagrimal', '2024-02-18', '2024-05-18'),

-- Receta 9: Ansiedad
(9, 18, '30 d�as', 30, 'Tomar con alimentos, no suspender bruscamente', '2024-02-20', '2024-03-22'),

-- Receta 10: Diabetes
(10, 20, '30 d�as', 60, 'Tomar con primera comida del d�a y cena', '2024-02-22', '2024-03-24');
GO

PRINT 'Detalles de recetas insertados: ' + CAST(@@ROWCOUNT AS VARCHAR);
