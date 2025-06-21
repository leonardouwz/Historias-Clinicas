// ============================================================================
// CONSULTAS ADICIONALES PARA VALIDAR LAS VISTAS CORREGIDAS
// ============================================================================

// Validar que las edades se calculan correctamente
db.vista_pacientes_completa.aggregate([
  {
    $match: {
      edad: { $ne: null }
    }
  },
  {
    $project: {
      nombre_completo: 1,
      fecha_nacimiento: 1,
      edad: 1,
      es_valida: {
        $and: [
          { $gte: ["$edad", 0] },
          { $lte: ["$edad", 120] }
        ]
      }
    }
  },
  {
    $sort: { edad: 1 }
  }
])

// Verificar consultas con edades válidas
db.vista_consultas_completa.aggregate([
  {
    $match: {
      "paciente.edad": { $ne: null }
    }
  },
  {
    $project: {
      "paciente.nombre_completo": 1,
      "paciente.edad": 1,
      fecha_consulta: 1,
      motivo_consulta: 1
    }
  },
  {
    $limit: 10
  }
])

// Verificar recetas con edades calculadas correctamente
db.vista_recetas_completa.aggregate([
  {
    $match: {
      "paciente.edad": { $ne: null }
    }
  },
  {
    $project: {
      "paciente.nombre_completo": 1,
      "paciente.edad": 1,
      fecha_emision: 1,
      diagnostico: 1
    }
  },
  {
    $limit: 10
  }
])

// ============================================================================
// CONSULTAS MEJORADAS PARA REPORTES CON MANEJO DE FECHAS
// ============================================================================

// Reporte de consultas por mes (manejando fechas string)
db.vista_consultas_completa.aggregate([
  {
    $addFields: {
      fecha_consulta_date: {
        $cond: {
          if: { $eq: [{ $type: "$fecha_consulta" }, "string"] },
          then: { $dateFromString: { dateString: "$fecha_consulta" } },
          else: "$fecha_consulta"
        }
      }
    }
  },
  {
    $group: {
      _id: {
        año: { $year: "$fecha_consulta_date" },
        mes: { $month: "$fecha_consulta_date" }
      },
      total_consultas: { $sum: 1 },
      especialidades: { $addToSet: "$medico.especialidad" },
      tipos_enfermedad: { $addToSet: "$tipo_enfermedad" }
    }
  },
  {
    $sort: { "_id.año": -1, "_id.mes": -1 }
  }
])

// Reporte de pacientes por grupo etario con validación
db.vista_reporte_pacientes.aggregate([
  {
    $match: {
      edad: { $gte: 0, $lte: 120 } // Solo edades válidas
    }
  },
  {
    $group: {
      _id: {
        rango_edad: "$rango_edad",
        genero: "$genero"
      },
      total_pacientes: { $sum: 1 },
      edad_promedio: { $avg: "$edad" },
      edad_minima: { $min: "$edad" },
      edad_maxima: { $max: "$edad" },
      con_historia_clinica: {
        $sum: {
          $cond: [{ $eq: ["$tiene_historia_clinica", true] }, 1, 0]
        }
      },
      con_consultas: {
        $sum: {
          $cond: [{ $eq: ["$tiene_consultas", true] }, 1, 0]
        }
      }
    }
  },
  {
    $sort: { 
      "_id.rango_edad": 1, 
      "_id.genero": 1 
    }
  }
])

// Médicos más activos en los últimos 30 días
db.vista_estadisticas_medicos.aggregate([
  {
    $lookup: {
      from: "consultas",
      let: { medico_id: "$_id" },
      pipeline: [
        {
          $addFields: {
            fecha_consulta_date: {
              $cond: {
                if: { $eq: [{ $type: "$fecha_consulta" }, "string"] },
                then: { $dateFromString: { dateString: "$fecha_consulta" } },
                else: "$fecha_consulta"
              }
            }
          }
        },
        {
          $match: {
            $expr: { 
              $and: [
                { $eq: ["$id_medico", "$medico_id"] },
                { $gte: ["$fecha_consulta_date", new Date(Date.now() - 30*24*60*60*1000)] }
              ]
            }
          }
        }
      ],
      as: "consultas_recientes"
    }
  },
  {
    $project: {
      nombre_completo: 1,
      especialidad: 1,
      consultas_ultimo_mes: { $size: "$consultas_recientes" },
      "estadisticas.total_consultas": 1
    }
  },
  {
    $match: {
      consultas_ultimo_mes: { $gt: 0 }
    }
  },
  {
    $sort: { consultas_ultimo_mes: -1 }
  }
])

// Pacientes con más consultas
db.vista_historia_clinica_completa.aggregate([
  {
    $match: {
      "resumen_consultas.total_consultas": { $gt: 0 }
    }
  },
  {
    $project: {
      "paciente.nombre_completo": 1,
      "paciente.edad": 1,
      "paciente.genero": 1,
      "resumen_consultas.total_consultas": 1,
      "resumen_consultas.consultas_activas": 1,
      "resumen_consultas.ultima_consulta": 1,
      "resumen_consultas.tipos_enfermedades": 1
    }
  },
  {
    $sort: { "resumen_consultas.total_consultas": -1 }
  },
  {
    $limit: 20
  }
])

// Análisis de medicamentos por especialidad
db.vista_recetas_completa.aggregate([
  {
    $unwind: "$medicamentos"
  },
  {
    $lookup: {
      from: "consultas",
      localField: "id_consulta",
      foreignField: "_id",
      as: "consulta_info"
    }
  },
  {
    $unwind: "$consulta_info"
  },
  {
    $lookup: {
      from: "medicos",
      localField: "consulta_info.id_medico",
      foreignField: "_id",
      as: "medico_info"
    }
  },
  {
    $unwind: "$medico_info"
  },
  {
    $lookup: {
      from: "especialidades_medicas",
      localField: "medico_info.id_especialidad",
      foreignField: "_id",
      as: "especialidad_info"
    }
  },
  {
    $unwind: "$especialidad_info"
  },
  {
    $group: {
      _id: {
        especialidad: "$especialidad_info.nombre_especialidad",
        medicamento: "$medicamentos.nombre"
      },
      total_prescripciones: { $sum: 1 },
      principios_activos: { $addToSet: "$medicamentos.principio_activo" },
      indicaciones: { $addToSet: "$medicamentos.indicacion" }
    }
  },
  {
    $sort: { 
      "_id.especialidad": 1, 
      total_prescripciones: -1 
    }
  }
])

// ============================================================================
// FUNCIONES AUXILIARES PARA MANEJO DE FECHAS
// ============================================================================

// Función para convertir fechas string a Date (usar en agregaciones)
function convertirFechaADate(campo) {
  return {
    $cond: {
      if: { 
        $and: [
          { $ne: [campo, null] },
          { $ne: [campo, ""] }
        ]
      },
      then: {
        $cond: {
          if: { $eq: [{ $type: campo }, "string"] },
          then: { 
            $dateFromString: { 
              dateString: campo,
              onError: new Date("1900-01-01") // Fecha por defecto en caso de error
            }
          },
          else: campo
        }
      },
      else: new Date("1900-01-01")
    }
  }
}

// Función para calcular edad de forma segura
function calcularEdad(fechaNacimiento, fechaReferencia = new Date()) {
  return {
    $cond: {
      if: { 
        $and: [
          { $ne: [fechaNacimiento, null] },
          { $ne: [fechaNacimiento, ""] }
        ]
      },
      then: {
        $floor: {
          $divide: [
            { 
              $subtract: [
                fechaReferencia,
                convertirFechaADate(fechaNacimiento)
              ]
            },
            365.25 * 24 * 60 * 60 * 1000
          ]
        }
      },
      else: null
    }
  }
}

// ============================================================================
// COMANDOS PARA ELIMINAR VISTAS (SI ES NECESARIO)
// ============================================================================

/*
db.vista_medicos_completa.drop()
db.vista_pacientes_completa.drop()
db.vista_consultas_completa.drop()
db.vista_recetas_completa.drop()
db.vista_medicamentos_indicaciones.drop()
db.vista_historia_clinica_completa.drop()
db.vista_estadisticas_medicos.drop()
db.vista_reporte_pacientes.drop()
*/

// ============================================================================
// COMANDOS PARA RECREAR TODAS LAS VISTAS
// ============================================================================

/*
// Ejecutar estos comandos para recrear todas las vistas con las correcciones
db.vista_medicos_completa.drop()
db.vista_pacientes_completa.drop()
db.vista_consultas_completa.drop()
db.vista_recetas_completa.drop()
db.vista_medicamentos_indicaciones.drop()
db.vista_historia_clinica_completa.drop()
db.vista_estadisticas_medicos.drop()
db.vista_reporte_pacientes.drop()

// Luego ejecutar todo el script nuevamente desde el inicio
*/

// ============================================================================
// FIN DE VISTAS CON LOOKUP - FECHAS CORREGIDAS
// ============================================================================ Conectar a la base de datos
use clinica_dermatologica

// ============================================================================
// 1. VISTA COMPLETA DE MÉDICOS CON ESPECIALIDAD Y CONTACTO
// ============================================================================

db.createView("vista_medicos_completa", "medicos", [
  {
    $lookup: {
      from: "especialidades_medicas",
      localField: "id_especialidad",
      foreignField: "_id",
      as: "especialidad"
    }
  },
  {
    $lookup: {
      from: "contactos",
      localField: "id_contacto",
      foreignField: "_id",
      as: "contacto"
    }
  },
  {
    $unwind: "$especialidad"
  },
  {
    $unwind: "$contacto"
  },
  {
    $match: {
      estado: true
    }
  },
  {
    $project: {
      _id: 1,
      nombre_completo: 1,
      dni: 1,
      numero_colegiatura: 1,
      especialidad: {
        nombre_especialidad: "$especialidad.nombre_especialidad",
        descripcion: "$especialidad.descripcion"
      },
      contacto: {
        telefono_principal: "$contacto.telefono_principal",
        telefono_secundario: "$contacto.telefono_secundario",
        correo_electronico: "$contacto.correo_electronico",
        direccion: "$contacto.direccion",
        ciudad: "$contacto.ciudad"
      },
      fecha_creacion: 1
    }
  }
])

// Consultar la vista de médicos completa
db.vista_medicos_completa.find()

// ============================================================================
// 2. VISTA COMPLETA DE PACIENTES CON APODERADO Y CONTACTO
// ============================================================================

db.createView("vista_pacientes_completa", "pacientes", [
  {
    $lookup: {
      from: "apoderados",
      localField: "id_apoderado",
      foreignField: "_id",
      as: "apoderado"
    }
  },
  {
    $lookup: {
      from: "contactos",
      localField: "id_contacto",
      foreignField: "_id",
      as: "contacto"
    }
  },
  {
    $unwind: {
      path: "$apoderado",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $unwind: "$contacto"
  },
  {
    $lookup: {
      from: "contactos",
      localField: "apoderado.id_contacto",
      foreignField: "_id",
      as: "contacto_apoderado"
    }
  },
  {
    $unwind: {
      path: "$contacto_apoderado",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $match: {
      estado: true
    }
  },
  {
    $project: {
      _id: 1,
      nombre_completo: 1,
      dni: 1,
      fecha_nacimiento: 1,
      genero: 1,
      edad: {
        $cond: {
          if: { 
            $and: [
              { $ne: ["$fecha_nacimiento", null] },
              { $ne: ["$fecha_nacimiento", ""] }
            ]
          },
          then: {
            $floor: {
              $divide: [
                { 
                  $subtract: [
                    new Date(), 
                    {
                      $cond: {
                        if: { $type: "$fecha_nacimiento" },
                        then: {
                          $switch: {
                            branches: [
                              {
                                case: { $eq: [{ $type: "$fecha_nacimiento" }, "string"] },
                                then: { $dateFromString: { dateString: "$fecha_nacimiento" } }
                              }
                            ],
                            default: "$fecha_nacimiento"
                          }
                        },
                        else: new Date()
                      }
                    }
                  ]
                },
                365.25 * 24 * 60 * 60 * 1000
              ]
            }
          },
          else: null
        }
      },
      es_menor_edad: {
        $cond: {
          if: { $ne: ["$apoderado", null] },
          then: true,
          else: false
        }
      },
      apoderado: {
        $cond: {
          if: { $ne: ["$apoderado", null] },
          then: {
            nombre_completo: "$apoderado.nombre_completo",
            dni: "$apoderado.dni",
            parentesco: "$apoderado.parentesco",
            telefono: "$contacto_apoderado.telefono_principal",
            correo: "$contacto_apoderado.correo_electronico"
          },
          else: null
        }
      },
      contacto_paciente: {
        telefono_principal: "$contacto.telefono_principal",
        telefono_secundario: "$contacto.telefono_secundario",
        correo_electronico: "$contacto.correo_electronico",
        direccion: "$contacto.direccion",
        ciudad: "$contacto.ciudad"
      },
      fecha_creacion: 1
    }
  }
])

// Consultar la vista de pacientes completa
db.vista_pacientes_completa.find()

// ============================================================================
// 3. VISTA COMPLETA DE CONSULTAS CON PACIENTE, MÉDICO Y ESPECIALIDAD
// ============================================================================

db.createView("vista_consultas_completa", "consultas", [
  {
    $lookup: {
      from: "historias_clinicas",
      localField: "id_historia",
      foreignField: "_id",
      as: "historia"
    }
  },
  {
    $unwind: "$historia"
  },
  {
    $lookup: {
      from: "pacientes",
      localField: "historia.id_paciente",
      foreignField: "_id",
      as: "paciente"
    }
  },
  {
    $unwind: "$paciente"
  },
  {
    $lookup: {
      from: "medicos",
      localField: "id_medico",
      foreignField: "_id",
      as: "medico"
    }
  },
  {
    $unwind: "$medico"
  },
  {
    $lookup: {
      from: "especialidades_medicas",
      localField: "medico.id_especialidad",
      foreignField: "_id",
      as: "especialidad"
    }
  },
  {
    $unwind: "$especialidad"
  },
  {
    $lookup: {
      from: "contactos",
      localField: "paciente.id_contacto",
      foreignField: "_id",
      as: "contacto_paciente"
    }
  },
  {
    $unwind: "$contacto_paciente"
  },
  {
    $project: {
      _id: 1,
      fecha_consulta: 1,
      motivo_consulta: 1,
      tipo_enfermedad: 1,
      historia_enfermedad: 1,
      examen_fisico: 1,
      plan_tratamiento: 1,
      observaciones: 1,
      estado_consulta: 1,
      paciente: {
        _id: "$paciente._id",
        nombre_completo: "$paciente.nombre_completo",
        dni: "$paciente.dni",
        edad: {
          $cond: {
            if: { 
              $and: [
                { $ne: ["$paciente.fecha_nacimiento", null] },
                { $ne: ["$paciente.fecha_nacimiento", ""] },
                { $ne: ["$fecha_consulta", null] },
                { $ne: ["$fecha_consulta", ""] }
              ]
            },
            then: {
              $floor: {
                $divide: [
                  { 
                    $subtract: [
                      {
                        $cond: {
                          if: { $eq: [{ $type: "$fecha_consulta" }, "string"] },
                          then: { $dateFromString: { dateString: "$fecha_consulta" } },
                          else: "$fecha_consulta"
                        }
                      },
                      {
                        $cond: {
                          if: { $eq: [{ $type: "$paciente.fecha_nacimiento" }, "string"] },
                          then: { $dateFromString: { dateString: "$paciente.fecha_nacimiento" } },
                          else: "$paciente.fecha_nacimiento"
                        }
                      }
                    ]
                  },
                  365.25 * 24 * 60 * 60 * 1000
                ]
              }
            },
            else: null
          }
        },
        genero: "$paciente.genero",
        telefono: "$contacto_paciente.telefono_principal"
      },
      medico: {
        _id: "$medico._id",
        nombre_completo: "$medico.nombre_completo",
        numero_colegiatura: "$medico.numero_colegiatura",
        especialidad: "$especialidad.nombre_especialidad"
      },
      historia_clinica: {
        tipo_piel: "$historia.tipo_piel",
        fototipo: "$historia.fototipo",
        alergias: "$historia.alergias",
        antecedentes_personales: "$historia.antecedentes_personales",
        antecedentes_familiares: "$historia.antecedentes_familiares"
      },
      fecha_creacion: 1
    }
  },
  {
    $sort: {
      fecha_consulta: -1
    }
  }
])

// Consultar la vista de consultas completa
db.vista_consultas_completa.find()

// ============================================================================
// 4. VISTA COMPLETA DE RECETAS CON MEDICAMENTOS E INDICACIONES
// ============================================================================

db.createView("vista_recetas_completa", "recetas", [
  {
    $lookup: {
      from: "consultas",
      localField: "id_consulta",
      foreignField: "_id",
      as: "consulta"
    }
  },
  {
    $unwind: "$consulta"
  },
  {
    $lookup: {
      from: "historias_clinicas",
      localField: "consulta.id_historia",
      foreignField: "_id",
      as: "historia"
    }
  },
  {
    $unwind: "$historia"
  },
  {
    $lookup: {
      from: "pacientes",
      localField: "historia.id_paciente",
      foreignField: "_id",
      as: "paciente"
    }
  },
  {
    $unwind: "$paciente"
  },
  {
    $lookup: {
      from: "medicos",
      localField: "consulta.id_medico",
      foreignField: "_id",
      as: "medico"
    }
  },
  {
    $unwind: "$medico"
  },
  {
    $unwind: "$detalles"
  },
  {
    $lookup: {
      from: "indicaciones_medicamentos",
      localField: "detalles.id_indicacion",
      foreignField: "_id",
      as: "indicacion"
    }
  },
  {
    $unwind: "$indicacion"
  },
  {
    $lookup: {
      from: "medicamentos",
      localField: "indicacion.id_medicamento",
      foreignField: "_id",
      as: "medicamento"
    }
  },
  {
    $unwind: "$medicamento"
  },
  {
    $group: {
      _id: "$_id",
      diagnostico: { $first: "$diagnostico" },
      fecha_emision: { $first: "$fecha_emision" },
      fecha_vencimiento: { $first: "$fecha_vencimiento" },
      estado_receta: { $first: "$estado_receta" },
      paciente: {
        $first: {
          nombre_completo: "$paciente.nombre_completo",
          dni: "$paciente.dni",
          edad: {
            $cond: {
              if: { 
                $and: [
                  { $ne: ["$paciente.fecha_nacimiento", null] },
                  { $ne: ["$paciente.fecha_nacimiento", ""] },
                  { $ne: ["$fecha_emision", null] },
                  { $ne: ["$fecha_emision", ""] }
                ]
              },
              then: {
                $floor: {
                  $divide: [
                    { 
                      $subtract: [
                        {
                          $cond: {
                            if: { $eq: [{ $type: "$fecha_emision" }, "string"] },
                            then: { $dateFromString: { dateString: "$fecha_emision" } },
                            else: "$fecha_emision"
                          }
                        },
                        {
                          $cond: {
                            if: { $eq: [{ $type: "$paciente.fecha_nacimiento" }, "string"] },
                            then: { $dateFromString: { dateString: "$paciente.fecha_nacimiento" } },
                            else: "$paciente.fecha_nacimiento"
                          }
                        }
                      ]
                    },
                    365.25 * 24 * 60 * 60 * 1000
                  ]
                }
              },
              else: null
            }
          }
        }
      },
      medico: {
        $first: {
          nombre_completo: "$medico.nombre_completo",
          numero_colegiatura: "$medico.numero_colegiatura"
        }
      },
      medicamentos: {
        $push: {
          nombre: "$medicamento.nombre",
          principio_activo: "$medicamento.principio_activo",
          presentacion: "$medicamento.presentacion",
          concentracion: "$medicamento.concentracion",
          indicacion: "$indicacion.indicacion",
          dosis_recomendada: "$indicacion.dosis_recomendada",
          frecuencia: "$indicacion.frecuencia",
          via_administracion: "$indicacion.via_administracion",
          duracion_tratamiento: "$detalles.duracion_tratamiento",
          cantidad: "$detalles.cantidad",
          instrucciones_adicionales: "$detalles.instrucciones_adicionales",
          fecha_inicio_tratamiento: "$detalles.fecha_inicio_tratamiento",
          fecha_fin_tratamiento: "$detalles.fecha_fin_tratamiento"
        }
      }
    }
  },
  {
    $sort: {
      fecha_emision: -1
    }
  }
])

// Consultar la vista de recetas completa
db.vista_recetas_completa.find()

// ============================================================================
// 5. VISTA DE MEDICAMENTOS CON TODAS SUS INDICACIONES
// ============================================================================

db.createView("vista_medicamentos_indicaciones", "medicamentos", [
  {
    $lookup: {
      from: "indicaciones_medicamentos",
      localField: "_id",
      foreignField: "id_medicamento",
      as: "indicaciones"
    }
  },
  {
    $match: {
      estado: true
    }
  },
  {
    $project: {
      _id: 1,
      nombre: 1,
      principio_activo: 1,
      presentacion: 1,
      concentracion: 1,
      descripcion: 1,
      contraindicaciones: 1,
      total_indicaciones: { $size: "$indicaciones" },
      indicaciones: {
        $filter: {
          input: "$indicaciones",
          cond: { $eq: ["$$this.estado", true] }
        }
      },
      fecha_creacion: 1
    }
  },
  {
    $sort: {
      nombre: 1
    }
  }
])

// Consultar la vista de medicamentos con indicaciones
db.vista_medicamentos_indicaciones.find()

// ============================================================================
// 6. VISTA DE HISTORIA CLÍNICA COMPLETA CON CONSULTAS
// ============================================================================

db.createView("vista_historia_clinica_completa", "historias_clinicas", [
  {
    $lookup: {
      from: "pacientes",
      localField: "id_paciente",
      foreignField: "_id",
      as: "paciente"
    }
  },
  {
    $unwind: "$paciente"
  },
  {
    $lookup: {
      from: "contactos",
      localField: "paciente.id_contacto",
      foreignField: "_id",
      as: "contacto"
    }
  },
  {
    $unwind: "$contacto"
  },
  {
    $lookup: {
      from: "apoderados",
      localField: "paciente.id_apoderado",
      foreignField: "_id",
      as: "apoderado"
    }
  },
  {
    $unwind: {
      path: "$apoderado",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $lookup: {
      from: "consultas",
      localField: "_id",
      foreignField: "id_historia",
      as: "consultas"
    }
  },
  {
    $match: {
      estado: true
    }
  },
  {
    $project: {
      _id: 1,
      paciente: {
        _id: "$paciente._id",
        nombre_completo: "$paciente.nombre_completo",
        dni: "$paciente.dni",
        fecha_nacimiento: "$paciente.fecha_nacimiento",
        edad: {
          $cond: {
            if: { 
              $and: [
                { $ne: ["$paciente.fecha_nacimiento", null] },
                { $ne: ["$paciente.fecha_nacimiento", ""] }
              ]
            },
            then: {
              $floor: {
                $divide: [
                  { 
                    $subtract: [
                      new Date(), 
                      {
                        $cond: {
                          if: { $eq: [{ $type: "$paciente.fecha_nacimiento" }, "string"] },
                          then: { $dateFromString: { dateString: "$paciente.fecha_nacimiento" } },
                          else: "$paciente.fecha_nacimiento"
                        }
                      }
                    ]
                  },
                  365.25 * 24 * 60 * 60 * 1000
                ]
              }
            },
            else: null
          }
        },
        genero: "$paciente.genero",
        es_menor_edad: {
          $cond: {
            if: { $ne: ["$apoderado", null] },
            then: true,
            else: false
          }
        }
      },
      apoderado: {
        $cond: {
          if: { $ne: ["$apoderado", null] },
          then: {
            nombre_completo: "$apoderado.nombre_completo",
            dni: "$apoderado.dni",
            parentesco: "$apoderado.parentesco"
          },
          else: null
        }
      },
      contacto: {
        telefono_principal: "$contacto.telefono_principal",
        correo_electronico: "$contacto.correo_electronico",
        direccion: "$contacto.direccion",
        ciudad: "$contacto.ciudad"
      },
      informacion_clinica: {
        alergias: "$alergias",
        antecedentes_personales: "$antecedentes_personales",
        antecedentes_familiares: "$antecedentes_familiares",
        tipo_piel: "$tipo_piel",
        fototipo: "$fototipo"
      },
      resumen_consultas: {
        total_consultas: { $size: "$consultas" },
        consultas_activas: {
          $size: {
            $filter: {
              input: "$consultas",
              cond: { $eq: ["$$this.estado_consulta", "ACTIVA"] }
            }
          }
        },
        ultima_consulta: {
          $max: "$consultas.fecha_consulta"
        },
        tipos_enfermedades: {
          $setUnion: ["$consultas.tipo_enfermedad", []]
        }
      },
      fecha_creacion: 1,
      fecha_modificacion: 1
    }
  },
  {
    $sort: {
      "paciente.nombre_completo": 1
    }
  }
])

// Consultar la vista de historia clínica completa
db.vista_historia_clinica_completa.find()

// ============================================================================
// 7. VISTA ESTADÍSTICAS MÉDICOS (PRODUCTIVIDAD)
// ============================================================================

db.createView("vista_estadisticas_medicos", "medicos", [
  {
    $lookup: {
      from: "especialidades_medicas",
      localField: "id_especialidad",
      foreignField: "_id",
      as: "especialidad"
    }
  },
  {
    $unwind: "$especialidad"
  },
  {
    $lookup: {
      from: "consultas",
      localField: "_id",
      foreignField: "id_medico",
      as: "consultas"
    }
  },
  {
    $lookup: {
      from: "recetas",
      let: { medico_id: "$_id" },
      pipeline: [
        {
          $lookup: {
            from: "consultas",
            localField: "id_consulta",
            foreignField: "_id",
            as: "consulta"
          }
        },
        {
          $unwind: "$consulta"
        },
        {
          $match: {
            $expr: { $eq: ["$consulta.id_medico", "$$medico_id"] }
          }
        }
      ],
      as: "recetas"
    }
  },
  {
    $match: {
      estado: true
    }
  },
  {
    $project: {
      _id: 1,
      nombre_completo: 1,
      numero_colegiatura: 1,
      especialidad: "$especialidad.nombre_especialidad",
      estadisticas: {
        total_consultas: { $size: "$consultas" },
        consultas_activas: {
          $size: {
            $filter: {
              input: "$consultas",
              cond: { $eq: ["$$this.estado_consulta", "ACTIVA"] }
            }
          }
        },
        consultas_completadas: {
          $size: {
            $filter: {
              input: "$consultas",
              cond: { $eq: ["$$this.estado_consulta", "COMPLETADA"] }
            }
          }
        },
        total_recetas: { $size: "$recetas" },
        recetas_vigentes: {
          $size: {
            $filter: {
              input: "$recetas",
              cond: { $eq: ["$$this.estado_receta", "VIGENTE"] }
            }
          }
        },
        tipos_enfermedades_tratadas: {
          $size: {
            $setUnion: ["$consultas.tipo_enfermedad", []]
          }
        },
        primera_consulta: { $min: "$consultas.fecha_consulta" },
        ultima_consulta: { $max: "$consultas.fecha_consulta" }
      },
      fecha_creacion: 1
    }
  },
  {
    $sort: {
      "estadisticas.total_consultas": -1
    }
  }
])

// Consultar la vista de estadísticas de médicos
db.vista_estadisticas_medicos.find()

// ============================================================================
// 8. VISTA REPORTE PACIENTES POR EDAD Y GÉNERO
// ============================================================================

db.createView("vista_reporte_pacientes", "pacientes", [
  {
    $lookup: {
      from: "historias_clinicas",
      localField: "_id",
      foreignField: "id_paciente",
      as: "historia"
    }
  },
  {
    $unwind: {
      path: "$historia",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $lookup: {
      from: "consultas",
      localField: "historia._id",
      foreignField: "id_historia",
      as: "consultas"
    }
  },
  {
    $match: {
      estado: true
    }
  },
  {
    $addFields: {
      edad_calculada: {
        $cond: {
          if: { 
            $and: [
              { $ne: ["$fecha_nacimiento", null] },
              { $ne: ["$fecha_nacimiento", ""] }
            ]
          },
          then: {
            $floor: {
              $divide: [
                { 
                  $subtract: [
                    new Date(), 
                    {
                      $cond: {
                        if: { $eq: [{ $type: "$fecha_nacimiento" }, "string"] },
                        then: { $dateFromString: { dateString: "$fecha_nacimiento" } },
                        else: "$fecha_nacimiento"
                      }
                    }
                  ]
                },
                365.25 * 24 * 60 * 60 * 1000
              ]
            }
          },
          else: 0
        }
      }
    }
  },
  {
    $project: {
      _id: 1,
      nombre_completo: 1,
      dni: 1,
      genero: 1,
      edad: "$edad_calculada",
      rango_edad: {
        $switch: {
          branches: [
            {
              case: { $lte: ["$edad_calculada", 12] },
              then: "Niño (0-12)"
            },
            {
              case: { $lte: ["$edad_calculada", 17] },
              then: "Adolescente (13-17)"
            },
            {
              case: { $lte: ["$edad_calculada", 30] },
              then: "Joven Adulto (18-30)"
            },
            {
              case: { $lte: ["$edad_calculada", 50] },
              then: "Adulto (31-50)"
            }
          ],
          default: "Adulto Mayor (51+)"
        }
      },
      tipo_piel: "$historia.tipo_piel",
      fototipo: "$historia.fototipo",
      tiene_historia_clinica: {
        $cond: {
          if: { $ne: ["$historia", null] },
          then: true,
          else: false
        }
      },
      total_consultas: { $size: "$consultas" },
      tiene_consultas: {
        $cond: {
          if: { $gt: [{ $size: "$consultas" }, 0] },
          then: true,
          else: false
        }
      },
      fecha_ultima_consulta: { $max: "$consultas.fecha_consulta" },
      fecha_creacion: 1
    }
  },
  {
    $sort: {
      edad: 1,
      nombre_completo: 1
    }
  }
])

// Consultar la vista de reporte de pacientes
db.vista_reporte_pacientes.find()

// ============================================================================
// CONSULTAS DE EJEMPLO USANDO LAS VISTAS
// ============================================================================

// Médicos por especialidad
db.vista_medicos_completa.aggregate([
  {
    $group: {
      _id: "$especialidad.nombre_especialidad",
      total_medicos: { $sum: 1 },
      medicos: { $push: "$nombre_completo" }
    }
  },
  {
    $sort: { total_medicos: -1 }
  }
])

// Pacientes menores de edad
db.vista_pacientes_completa.find({
  es_menor_edad: true
})

// Consultas por tipo de enfermedad
db.vista_consultas_completa.aggregate([
  {
    $group: {
      _id: "$tipo_enfermedad",
      total_consultas: { $sum: 1 },
      medicos_involucrados: { $addToSet: "$medico.nombre_completo" }
    }
  },
  {
    $sort: { total_consultas: -1 }
  }
])

// Medicamentos más recetados
db.vista_recetas_completa.aggregate([
  {
    $unwind: "$medicamentos"
  },
  {
    $group: {
      _id: "$medicamentos.nombre",
      total_recetas: { $sum: 1 },
      indicaciones: { $addToSet: "$medicamentos.indicacion" }
    }
  },
  {
    $sort: { total_recetas: -1 }
  }
])

// Estadísticas por rango de edad
db.vista_reporte_pacientes.aggregate([
  {
    $group: {
      _id: {
        rango_edad: "$rango_edad",
        genero: "$genero"
      },
      total_pacientes: { $sum: 1 },
      con_historia_clinica: {
        $sum: {
          $cond: [{ $eq: ["$tiene_historia_clinica", true] }, 1, 0]
        }
      },
      con_consultas: {
        $sum: {
          $cond: [{ $eq: ["$tiene_consultas", true] }, 1, 0]
        }
      }
    }
  },
  {
    $sort: { "_id.rango_edad": 1, "_id.genero": 1 }
  }
])

// Recetas que vencen pronto (mejorado para manejar fechas string)
db.vista_recetas_completa.aggregate([
  {
    $match: {
      estado_receta: "VIGENTE"
    }
  },
  {
    $addFields: {
      fecha_vencimiento_date: {
        $cond: {
          if: { $eq: [{ $type: "$fecha_vencimiento" }, "string"] },
          then: { $dateFromString: { dateString: "$fecha_vencimiento" } },
          else: "$fecha_vencimiento"
        }
      }
    }
  },
  {
    $match: {
      fecha_vencimiento_date: {
        $lte: new Date(Date.now() + 7*24*60*60*1000) // próximos 7 días
      }
    }
  }
])


// ============================================================================
// COMANDOS PARA ELIMINAR VISTAS (SI ES NECESARIO)
// ============================================================================

/*
db.vista_medicos_completa.drop()
db.vista_pacientes_completa.drop()
db.vista_consultas_completa.drop()
db.vista_recetas_completa.drop()
db.vista_medicamentos_indicaciones.drop()
db.vista_historia_clinica_completa.drop()
db.vista_estadisticas_medicos.drop()
db.vista_reporte_pacientes.drop()
*/

// ============================================================================
// FIN DE VISTAS CON LOOKUP
// ============================================================================
