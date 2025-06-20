// Conectar a la base de datos
use clinica_dermatologica

// ============================================================================
// 1. CREAR ÍNDICES PARA OPTIMIZACIÓN
// ============================================================================

print("🔧 Creando índices para optimización de consultas...")

// Índices únicos para documentos principales
db.pacientes.createIndex({dni: 1}, {unique: true, name: "idx_pacientes_dni"})
db.medicos.createIndex({dni: 1}, {unique: true, name: "idx_medicos_dni"})
db.medicos.createIndex({numero_colegiatura: 1}, {unique: true, name: "idx_medicos_colegiatura"})
db.apoderados.createIndex({dni: 1}, {unique: true, name: "idx_apoderados_dni"})

// Índices para búsquedas frecuentes
db.contactos.createIndex({correo_electronico: 1}, {name: "idx_contactos_email"})
db.contactos.createIndex({telefono_principal: 1}, {name: "idx_contactos_telefono"})
db.medicamentos.createIndex({nombre: 1}, {name: "idx_medicamentos_nombre"})
db.medicamentos.createIndex({principio_activo: 1}, {name: "idx_medicamentos_principio"})

// Índices para relaciones
db.consultas.createIndex({id_historia: 1}, {name: "idx_consultas_historia"})
db.consultas.createIndex({id_medico: 1}, {name: "idx_consultas_medico"})
db.consultas.createIndex({fecha_consulta: 1}, {name: "idx_consultas_fecha"})
db.recetas.createIndex({id_consulta: 1}, {name: "idx_recetas_consulta"})
db.recetas.createIndex({fecha_vencimiento: 1}, {name: "idx_recetas_vencimiento"})
db.recetas.createIndex({estado_receta: 1}, {name: "idx_recetas_estado"})

// Índices compuestos
db.consultas.createIndex({id_medico: 1, fecha_consulta: -1}, {name: "idx_consultas_medico_fecha"})
db.pacientes.createIndex({genero: 1, fecha_nacimiento: 1}, {name: "idx_pacientes_genero_edad"})

print("✅ Índices creados exitosamente")

// ============================================================================
// 2. VALIDACIONES DE INTEGRIDAD
// ============================================================================

print("🔍 Ejecutando validaciones de integridad...")

// Verificar conteos de documentos
const conteos = {
    especialidades_medicas: db.especialidades_medicas.countDocuments(),
    contactos: db.contactos.countDocuments(),
    medicamentos: db.medicamentos.countDocuments(),
    apoderados: db.apoderados.countDocuments(),
    medicos: db.medicos.countDocuments(),
    indicaciones_medicamentos: db.indicaciones_medicamentos.countDocuments(),
    pacientes: db.pacientes.countDocuments(),
    historias_clinicas: db.historias_clinicas.countDocuments(),
    consultas: db.consultas.countDocuments(),
    recetas: db.recetas.countDocuments()
}

print("📊 Conteos de documentos por colección:")
print(JSON.stringify(conteos, null, 2))

// Validar referencias
print("🔗 Validando referencias entre colecciones...")

// Verificar que todos los médicos tienen especialidad válida
const medicos_sin_especialidad = db.medicos.aggregate([
    {
        $lookup: {
            from: "especialidades_medicas",
            localField: "id_especialidad",
            foreignField: "_id",
            as: "especialidad"
        }
    },
    {
        $match: {
            especialidad: { $size: 0 }
        }
    }
]).toArray()

if (medicos_sin_especialidad.length > 0) {
    print("⚠️  ADVERTENCIA: Médicos sin especialidad válida encontrados:")
    print(JSON.stringify(medicos_sin_especialidad, null, 2))
} else {
    print("✅ Todas las referencias médico-especialidad son válidas")
}

// Verificar que todos los pacientes tienen contacto válido
const pacientes_sin_contacto = db.pacientes.aggregate([
    {
        $lookup: {
            from: "contactos",
            localField: "id_contacto",
            foreignField: "_id",
            as: "contacto"
        }
    },
    {
        $match: {
            contacto: { $size: 0 }
        }
    }
]).toArray()

if (pacientes_sin_contacto.length > 0) {
    print("⚠️  ADVERTENCIA: Pacientes sin contacto válido encontrados:")
    print(JSON.stringify(pacientes_sin_contacto, null, 2))
} else {
    print("✅ Todas las referencias paciente-contacto son válidas")
}

print("✅ Validaciones completadas")

// ============================================================================
// 3. CONFIGURAR REGLAS DE VALIDACIÓN DE ESQUEMAS
// ============================================================================

print("📋 Configurando reglas de validación de esquemas...")

// Validación para pacientes
db.runCommand({
    collMod: "pacientes",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["nombre_completo", "dni", "fecha_nacimiento", "genero", "id_contacto", "estado"],
            properties: {
                nombre_completo: {
                    bsonType: "string",
                    description: "Nombre completo es requerido y debe ser string"
                },
                dni: {
                    bsonType: "string",
                    pattern: "^[0-9]{8}$",
                    description: "DNI debe tener exactamente 8 dígitos"
                },
                genero: {
                    enum: ["M", "F"],
                    description: "Género debe ser M o F"
                },
                estado: {
                    bsonType: "bool",
                    description: "Estado debe ser boolean"
                }
            }
        }
    }
})

// Validación para médicos
db.runCommand({
    collMod: "medicos",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["nombre_completo", "dni", "id_especialidad", "numero_colegiatura", "estado"],
            properties: {
                dni: {
                    bsonType: "string",
                    pattern: "^[0-9]{8}$",
                    description: "DNI debe tener exactamente 8 dígitos"
                },
                numero_colegiatura: {
                    bsonType: "string",
                    pattern: "^CMP-[0-9]{5}$",
                    description: "Número de colegiatura debe seguir el formato CMP-#####"
                },
                estado: {
                    bsonType: "bool",
                    description: "Estado debe ser boolean"
                }
            }
        }
    }
})

// Validación para consultas
db.runCommand({
    collMod: "consultas",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["id_historia", "id_medico", "fecha_consulta", "motivo_consulta", "estado_consulta"],
            properties: {
                estado_consulta: {
                    enum: ["PROGRAMADA", "ACTIVA", "COMPLETADA", "CANCELADA"],
                    description: "Estado de consulta debe ser uno de los valores permitidos"
                }
            }
        }
    }
})

// Validación para recetas
db.runCommand({
    collMod: "recetas",
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["id_consulta", "diagnostico", "fecha_emision", "fecha_vencimiento", "estado_receta", "detalles"],
            properties: {
                estado_receta: {
                    enum: ["VIGENTE", "VENCIDA", "COMPLETADA", "CANCELADA"],
                    description: "Estado de receta debe ser uno de los valores permitidos"
                },
                detalles: {
                    bsonType: "array",
                    minItems: 1,
                    description: "Receta debe tener al menos un detalle de medicamento"
                }
            }
        }
    }
})

print("✅ Reglas de validación configuradas")

// ============================================================================
// 4. CREAR USUARIOS Y ROLES (OPCIONAL)
// ============================================================================

print("👥 Configurando roles de usuario...")

// Crear rol para médicos (solo lectura de pacientes y escritura de consultas)
db.createRole({
    role: "medico",
    privileges: [
        {
            resource: { db: "clinica_dermatologica", collection: "pacientes" },
            actions: ["find"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "historias_clinicas" },
            actions: ["find", "update"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "consultas" },
            actions: ["find", "insert", "update"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "recetas" },
            actions: ["find", "insert", "update"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "" },
            actions: ["find"]
        }
    ],
    roles: []
})

// Crear rol para administradores (acceso completo)
db.createRole({
    role: "admin_clinica",
    privileges: [
        {
            resource: { db: "clinica_dermatologica", collection: "" },
            actions: ["find", "insert", "update", "remove"]
        }
    ],
    roles: []
})

// Crear rol para recepcionistas (gestión de pacientes y citas)
db.createRole({
    role: "recepcionista",
    privileges: [
        {
            resource: { db: "clinica_dermatologica", collection: "pacientes" },
            actions: ["find", "insert", "update"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "contactos" },
            actions: ["find", "insert", "update"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "apoderados" },
            actions: ["find", "insert", "update"]
        },
        {
            resource: { db: "clinica_dermatologica", collection: "consultas" },
            actions: ["find", "insert", "update"]
        }
    ],
    roles: []
})

print("✅ Roles de usuario creados")

// ============================================================================
// 5. ESTADÍSTICAS INICIALES
// ============================================================================

print("📈 Generando estadísticas iniciales...")

const estadisticas = {
    total_especialidades: db.especialidades_medicas.countDocuments({estado: true}),
    total_medicos: db.medicos.countDocuments({estado: true}),
    total_pacientes: db.pacientes.countDocuments({estado: true}),
    total_historias_clinicas: db.historias_clinicas.countDocuments({estado: true}),
    pacientes_menores: db.pacientes.countDocuments({id_apoderado: {$ne: null}}),
    pacientes_adultos: db.pacientes.countDocuments({id_apoderado: null}),
    consultas_activas: db.consultas.countDocuments({estado_consulta: "ACTIVA"}),
    consultas_completadas: db.consultas.countDocuments({estado_consulta: "COMPLETADA"}),
    recetas_vigentes: db.recetas.countDocuments({estado_receta: "VIGENTE"}),
    medicamentos_activos: db.medicamentos.countDocuments({estado: true})
}

print("📊 Estadísticas de la base de datos:")
print(JSON.stringify(estadisticas, null, 2))

// ============================================================================
// 6. CONFIGURACIONES ADICIONALES
// ============================================================================

print("⚙️  Aplicando configuraciones adicionales...")

// Configurar TTL para limpiar consultas antiguas canceladas (opcional)
db.consultas.createIndex(
    { "fecha_modificacion": 1 },
    { 
        expireAfterSeconds: 31536000, // 1 año
        partialFilterExpression: { estado_consulta: "CANCELADA" },
        name: "idx_consultas_ttl_canceladas"
    }
)

// Configurar text index para búsquedas
db.pacientes.createIndex(
    { 
        nombre_completo: "text",
        dni: "text"
    },
    { 
        name: "idx_pacientes_text_search",
        default_language: "spanish"
    }
)

db.medicamentos.createIndex(
    {
        nombre: "text",
        principio_activo: "text",
        descripcion: "text"
    },
    {
        name: "idx_medicamentos_text_search",
        default_language: "spanish"
    }
)

print("✅ Configuraciones adicionales aplicadas")

// ============================================================================
// 7. VERIFICACIÓN FINAL
// ============================================================================

print("🔍 Ejecutando verificación final...")

// Verificar que todas las vistas estén disponibles (se ejecutarán después)
const colecciones_esperadas = [
    "especialidades_medicas", "contactos", "medicamentos", "apoderados",
    "medicos", "indicaciones_medicamentos", "pacientes", "historias_clinicas",
    "consultas", "recetas"
]

const colecciones_existentes = db.listCollectionNames()
const colecciones_faltantes = colecciones_esperadas.filter(col => !colecciones_existentes.includes(col))

if (colecciones_faltantes.length > 0) {
    print("⚠️  ADVERTENCIA: Colecciones faltantes:")
    print(JSON.stringify(colecciones_faltantes, null, 2))
} else {
    print("✅ Todas las colecciones están presentes")
}

// Verificar índices creados
const indices_creados = db.pacientes.getIndexes().length + 
                       db.medicos.getIndexes().length + 
                       db.consultas.getIndexes().length + 
                       db.recetas.getIndexes().length

print(`✅ Total de índices creados: ${indices_creados}`)

print("🎉 ¡Configuración inicial completada exitosamente!")
print("")
print("📝 Próximos pasos:")
print("1. Ejecutar el archivo 'vistas_lookup_mongodb.js' para crear las vistas")
print("2. Crear usuarios específicos si es necesario")
print("3. Configurar backup automático")
print("4. Establecer monitoring de la base de datos")
print("")
print("🚀 ¡La base de datos está lista para usar!")

// ============================================================================
// FIN DE CONFIGURACIÓN INICIAL
// ============================================================================
