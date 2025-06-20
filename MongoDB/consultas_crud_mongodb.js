// Conectar a la base de datos
use clinica_dermatologica

// ============================================================================
// 1. ESPECIALIDADES MÉDICAS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nueva especialidad
db.especialidades_medicas.insertOne({
  nombre_especialidad: "Dermatología Quirúrgica",
  descripcion: "Cirugía dermatológica y procedimientos invasivos",
  estado: true,
  fecha_creacion: new Date()
})

// READ - Consultas de lectura
// Obtener todas las especialidades activas
db.especialidades_medicas.find({estado: true})

// Buscar especialidad específica
db.especialidades_medicas.findOne({nombre_especialidad: "Dermatología General"})

// Buscar por ID
db.especialidades_medicas.findOne({_id: 1})

// UPDATE - Actualizar especialidad
db.especialidades_medicas.updateOne(
  {_id: 1},
  {
    $set: {
      descripcion: "Atención dermatológica integral y diagnóstico avanzado",
      fecha_modificacion: new Date()
    }
  }
)

// Actualizar múltiples documentos
db.especialidades_medicas.updateMany(
  {estado: true},
  {$set: {fecha_modificacion: new Date()}}
)

// DELETE - Eliminar (soft delete recomendado)
db.especialidades_medicas.updateOne(
  {_id: 6},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// Hard delete (usar con precaución)
// db.especialidades_medicas.deleteOne({_id: 6})

// ============================================================================
// 2. CONTACTOS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nuevo contacto
db.contactos.insertOne({
  telefono_principal: "988776655",
  telefono_secundario: "017776655",
  correo_electronico: "nuevo.contacto@email.com",
  direccion: "Av. Nuevo Contacto 123",
  ciudad: "Lima",
  codigo_postal: "15001",
  fecha_creacion: new Date()
})

// READ - Consultas de lectura
// Obtener todos los contactos
db.contactos.find()

// Buscar por email
db.contactos.findOne({correo_electronico: "drsmith@clinica.com"})

// Buscar contactos de una ciudad específica
db.contactos.find({ciudad: "Lima"})

// Buscar contactos con teléfono secundario
db.contactos.find({telefono_secundario: {$ne: null}})

// UPDATE - Actualizar contacto
db.contactos.updateOne(
  {_id: 1},
  {
    $set: {
      telefono_secundario: "017777777",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Eliminar contacto
db.contactos.deleteOne({_id: 9})

// ============================================================================
// 3. MEDICAMENTOS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nuevo medicamento
db.medicamentos.insertOne({
  nombre: "Adapaleno Gel",
  principio_activo: "Adapaleno",
  presentacion: "Gel",
  concentracion: "0.1%",
  descripcion: "Retinoide tópico para acné",
  contraindicaciones: "Embarazo, lactancia",
  estado: true,
  fecha_creacion: new Date()
})

// READ - Consultas de lectura
// Obtener todos los medicamentos activos
db.medicamentos.find({estado: true})

// Buscar medicamentos por principio activo
db.medicamentos.find({principio_activo: /Tretinoína/i})

// Buscar por presentación
db.medicamentos.find({presentacion: "Crema"})

// Medicamentos con concentración específica
db.medicamentos.find({concentracion: "1%"})

// UPDATE - Actualizar medicamento
db.medicamentos.updateOne(
  {_id: 1},
  {
    $set: {
      descripcion: "Medicamento retinol tópico para acné y fotoenvejecimiento - Fórmula mejorada",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Desactivar medicamento
db.medicamentos.updateOne(
  {_id: 9},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// ============================================================================
// 4. APODERADOS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nuevo apoderado
db.apoderados.insertOne({
  nombre_completo: "Laura Vega Santos",
  dni: "99887766",
  parentesco: "Madre",
  id_contacto: 2,
  estado: true,
  fecha_creacion: new Date()
})

// READ - Consultas de lectura
// Obtener todos los apoderados activos
db.apoderados.find({estado: true})

// Buscar apoderado por DNI
db.apoderados.findOne({dni: "55667788"})

// Buscar por parentesco
db.apoderados.find({parentesco: "Madre"})

// UPDATE - Actualizar apoderado
db.apoderados.updateOne(
  {_id: 1},
  {
    $set: {
      nombre_completo: "Carlos Pérez Vega Mendoza",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Desactivar apoderado
db.apoderados.updateOne(
  {_id: 6},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// ============================================================================
// 5. MÉDICOS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nuevo médico
db.medicos.insertOne({
  nombre_completo: "Dra. Sandra Morales Vega",
  dni: "67890123",
  id_especialidad: 2,
  numero_colegiatura: "CMP-67890",
  id_contacto: 1,
  estado: true,
  fecha_creacion: new Date()
})

// READ - Consultas de lectura
// Obtener todos los médicos activos
db.medicos.find({estado: true})

// Buscar médico por DNI
db.medicos.findOne({dni: "12345678"})

// Buscar por especialidad
db.medicos.find({id_especialidad: 1})

// Buscar por número de colegiatura
db.medicos.findOne({numero_colegiatura: "CMP-12345"})

// UPDATE - Actualizar médico
db.medicos.updateOne(
  {_id: 1},
  {
    $set: {
      nombre_completo: "Dr. Carlos Smith Rodriguez Mendoza",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Desactivar médico
db.medicos.updateOne(
  {_id: 6},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// ============================================================================
// 6. INDICACIONES MEDICAMENTOS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nueva indicación
db.indicaciones_medicamentos.insertOne({
  id_medicamento: 1,
  indicacion: "Comedones cerrados",
  dosis_recomendada: "Aplicar punto a punto",
  frecuencia: "Una vez al día por la noche",
  duracion_maxima: "8 semanas",
  via_administracion: "Tópica",
  estado: true,
  fecha_creacion: new Date()
})

// READ - Consultas de lectura
// Obtener todas las indicaciones activas
db.indicaciones_medicamentos.find({estado: true})

// Buscar indicaciones por medicamento
db.indicaciones_medicamentos.find({id_medicamento: 1})

// Buscar por tipo de indicación
db.indicaciones_medicamentos.find({indicacion: /acné/i})

// Buscar por vía de administración
db.indicaciones_medicamentos.find({via_administracion: "Tópica"})

// UPDATE - Actualizar indicación
db.indicaciones_medicamentos.updateOne(
  {_id: 1},
  {
    $set: {
      dosis_recomendada: "Aplicar capa muy fina en área afectada",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Desactivar indicación
db.indicaciones_medicamentos.updateOne(
  {_id: 11},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// ============================================================================
// 7. PACIENTES - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nuevo paciente
db.pacientes.insertOne({
  nombre_completo: "Valeria Castillo Herrera",
  dni: "88997766",
  fecha_nacimiento: new Date("2005-04-12"),
  genero: "F",
  id_apoderado: 2,
  id_contacto: 2,
  estado: true,
  fecha_creacion: new Date(),
  fecha_modificacion: new Date()
})

// READ - Consultas de lectura
// Obtener todos los pacientes activos
db.pacientes.find({estado: true})

// Buscar paciente por DNI
db.pacientes.findOne({dni: "11223344"})

// Buscar pacientes menores de edad (con apoderado)
db.pacientes.find({id_apoderado: {$ne: null}})

// Buscar por género
db.pacientes.find({genero: "F"})

// Pacientes por rango de edad
db.pacientes.find({
  fecha_nacimiento: {
    $gte: new Date("2000-01-01"),
    $lte: new Date("2010-12-31")
  }
})

// UPDATE - Actualizar paciente
db.pacientes.updateOne(
  {_id: 1},
  {
    $set: {
      nombre_completo: "Juan Pérez Mendoza García",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Desactivar paciente
db.pacientes.updateOne(
  {_id: 8},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// ============================================================================
// 8. HISTORIAS CLÍNICAS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nueva historia clínica
db.historias_clinicas.insertOne({
  id_paciente: 8,
  alergias: "Alergia a anestésicos locales",
  antecedentes_personales: "Rosácea ocular",
  antecedentes_familiares: "Madre con lupus eritematoso",
  tipo_piel: "sensible",
  fototipo: "I",
  estado: true,
  fecha_creacion: new Date(),
  fecha_modificacion: new Date()
})

// READ - Consultas de lectura
// Obtener todas las historias clínicas activas
db.historias_clinicas.find({estado: true})

// Buscar historia por paciente
db.historias_clinicas.findOne({id_paciente: 1})

// Buscar por tipo de piel
db.historias_clinicas.find({tipo_piel: "grasa"})

// Buscar por fototipo
db.historias_clinicas.find({fototipo: "IV"})

// Pacientes con alergias específicas
db.historias_clinicas.find({alergias: /níquel/i})

// UPDATE - Actualizar historia clínica
db.historias_clinicas.updateOne(
  {_id: 1},
  {
    $set: {
      antecedentes_personales: "Asma infantil controlado, rinitis alérgica estacional",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Desactivar historia clínica
db.historias_clinicas.updateOne(
  {_id: 8},
  {$set: {estado: false, fecha_eliminacion: new Date()}}
)

// ============================================================================
// 9. CONSULTAS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nueva consulta
db.consultas.insertOne({
  id_historia: 1,
  id_medico: 2,
  fecha_consulta: new Date(),
  motivo_consulta: "Control de acné post-tratamiento",
  tipo_enfermedad: "acné",
  historia_enfermedad: "Mejoría del 70% de lesiones tras 4 semanas de tratamiento",
  examen_fisico: "Reducción significativa de lesiones inflamatorias",
  plan_tratamiento: "Continuar tratamiento actual, reducir frecuencia",
  observaciones: "Excelente respuesta al tratamiento, próximo control en 6 semanas",
  estado_consulta: "COMPLETADA",
  fecha_creacion: new Date(),
  fecha_modificacion: new Date()
})

// READ - Consultas de lectura
// Obtener todas las consultas activas
db.consultas.find({estado_consulta: "ACTIVA"})

// Buscar consultas por paciente (a través de historia clínica)
db.consultas.find({id_historia: 1})

// Buscar consultas por médico
db.consultas.find({id_medico: 1})

// Consultas por fecha
db.consultas.find({
  fecha_consulta: {
    $gte: new Date("2025-06-01"),
    $lte: new Date("2025-06-30")
  }
})

// Buscar por tipo de enfermedad
db.consultas.find({tipo_enfermedad: "acné"})

// UPDATE - Actualizar consulta
db.consultas.updateOne(
  {_id: 1},
  {
    $set: {
      observaciones: "Revisión en 2 semanas para evaluar tolerancia al tratamiento. Paciente muy colaborador.",
      fecha_modificacion: new Date()
    }
  }
)

// Cambiar estado de consulta
db.consultas.updateOne(
  {_id: 1},
  {
    $set: {
      estado_consulta: "COMPLETADA",
      fecha_modificacion: new Date()
    }
  }
)

// DELETE - Eliminar consulta (generalmente no recomendado por historial médico)
// db.consultas.deleteOne({_id: 8})

// ============================================================================
// 10. RECETAS - CRUD OPERATIONS
// ============================================================================

// CREATE - Insertar nueva receta
db.recetas.insertOne({
  id_consulta: 8,
  diagnostico: "Acné nodular severo",
  fecha_emision: new Date(),
  fecha_vencimiento: new Date(Date.now() + 30*24*60*60*1000), // 30 días
  estado_receta: "VIGENTE",
  detalles: [
    {
      id_indicacion: 1,
      duracion_tratamiento: "8 semanas",
      cantidad: 2,
      instrucciones_adicionales: "Aplicar solo por la noche, usar protector solar diario",
      fecha_inicio_tratamiento: new Date(),
      fecha_fin_tratamiento: new Date(Date.now() + 56*24*60*60*1000) // 8 semanas
    },
    {
      id_indicacion: 3,
      duracion_tratamiento: "4 semanas",
      cantidad: 1,
      instrucciones_adicionales: "Aplicar en lesiones inflamatorias activas",
      fecha_inicio_tratamiento: new Date(),
      fecha_fin_tratamiento: new Date(Date.now() + 28*24*60*60*1000) // 4 semanas
    }
  ]
})

// READ - Consultas de lectura
// Obtener todas las recetas vigentes
db.recetas.find({estado_receta: "VIGENTE"})

// Buscar recetas por consulta
db.recetas.find({id_consulta: 1})

// Recetas por fecha de emisión
db.recetas.find({
  fecha_emision: {
    $gte: new Date("2025-06-01"),
    $lte: new Date("2025-06-30")
  }
})

// Buscar por diagnóstico
db.recetas.find({diagnostico: /acné/i})

// Recetas que vencen pronto
db.recetas.find({
  fecha_vencimiento: {
    $lte: new Date(Date.now() + 7*24*60*60*1000) // próximos 7 días
  },
  estado_receta: "VIGENTE"
})

// UPDATE - Actualizar receta
db.recetas.updateOne(
  {_id: 1},
  {
    $set: {
      "detalles.0.instrucciones_adicionales": "Evitar exposición solar directa, usar protector solar SPF 50+, aplicar humectante",
      fecha_modificacion: new Date()
    }
  }
)

// Cambiar estado de receta
db.recetas.updateOne(
  {_id: 2},
  {
    $set: {
      estado_receta: "VENCIDA",
      fecha_modificacion: new Date()
    }
  }
)

// Agregar nuevo detalle a receta existente
db.recetas.updateOne(
  {_id: 1},
  {
    $push: {
      detalles: {
        id_indicacion: 6,
        duracion_tratamiento: "Uso continuo",
        cantidad: 1,
        instrucciones_adicionales: "Aplicar 30 minutos antes de exposición solar",
        fecha_inicio_tratamiento: new Date(),
        fecha_fin_tratamiento: new Date(Date.now() + 84*24*60*60*1000) // 12 semanas
      }
    }
  }
)

// DELETE - Eliminar receta (generalmente no recomendado por historial médico)
// db.recetas.deleteOne({_id: 7})

// ============================================================================
// CONSULTAS ADICIONALES ÚTILES
// ============================================================================

// Contar documentos por colección
db.especialidades_medicas.countDocuments()
db.contactos.countDocuments()
db.medicamentos.countDocuments()
db.apoderados.countDocuments()
db.medicos.countDocuments()
db.indicaciones_medicamentos.countDocuments()
db.pacientes.countDocuments()
db.historias_clinicas.countDocuments()
db.consultas.countDocuments()
db.recetas.countDocuments()

// Obtener estadísticas de colecciones
db.stats()

// Índices recomendados para optimizar consultas
db.pacientes.createIndex({dni: 1}, {unique: true})
db.medicos.createIndex({dni: 1}, {unique: true})
db.medicos.createIndex({numero_colegiatura: 1}, {unique: true})
db.contactos.createIndex({correo_electronico: 1})
db.consultas.createIndex({fecha_consulta: 1})
db.consultas.createIndex({id_historia: 1})
db.consultas.createIndex({id_medico: 1})
db.recetas.createIndex({fecha_vencimiento: 1})
db.recetas.createIndex({estado_receta: 1})

// ============================================================================
// FIN DE CONSULTAS CRUD
// ============================================================================
