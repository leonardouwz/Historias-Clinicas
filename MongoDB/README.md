# Clínica Dermatológica - Base de Datos MongoDB

## 📋 Estructura de la Base de Datos

### Colecciones Principales (10)

| Colección | Descripción | Documentos | Dependencias |
|-----------|-------------|------------|--------------|
| `especialidades_medicas` | Especialidades dermatológicas | 5 | Ninguna |
| `contactos` | Información de contacto | 8 | Ninguna |
| `medicamentos` | Catálogo de medicamentos | 8 | Ninguna |
| `apoderados` | Apoderados de pacientes menores | 5 | contactos |
| `medicos` | Médicos de la clínica | 5 | especialidades_medicas, contactos |
| `indicaciones_medicamentos` | Indicaciones de uso | 10 | medicamentos |
| `pacientes` | Pacientes de la clínica | 7 | apoderados, contactos |
| `historias_clinicas` | Historias clínicas | 7 | pacientes |
| `consultas` | Consultas médicas | 7 | historias_clinicas, medicos |
| `recetas` | Recetas médicas con detalles | 6 | consultas, indicaciones_medicamentos |

## 📁 Archivos Incluidos

```
mongodb_collections/
├── README_Importacion_MongoDB.md          # Este archivo
├── especialidades_medicas.json            # Especialidades dermatológicas
├── contactos.json                         # Datos de contacto
├── medicamentos.json                      # Catálogo de medicamentos
├── apoderados.json                        # Apoderados de menores
├── medicos.json                           # Médicos especialistas
├── indicaciones_medicamentos.json         # Indicaciones farmacológicas
├── pacientes.json                         # Pacientes registrados
├── historias_clinicas.json               # Historias clínicas
├── consultas.json                         # Consultas médicas
├── recetas.json                          # Recetas con medicamentos
├── consultas_crud_mongodb.js             # Consultas CRUD completas
└── vistas_lookup_mongodb.js              # Vistas con lookup/relaciones
```

## 🚀 Instrucciones de Importación en MongoDB Compass

### Paso 1: Preparar la Base de Datos

1. Abrir MongoDB Compass
2. Conectar a tu instancia de MongoDB
3. Crear nueva base de datos llamada: `clinica_dermatologica`

### Paso 2: Importar Colecciones (ORDEN IMPORTANTE)

**IMPORTANTE:** Importar en este orden específico debido a las dependencias:

#### Colecciones Base (Sin dependencias)
1. **especialidades_medicas.json**
2. **contactos.json**
3. **medicamentos.json**

#### Colecciones con Dependencias Nivel 1
4. **apoderados.json** (depende de contactos)
5. **medicos.json** (depende de especialidades_medicas, contactos)
6. **indicaciones_medicamentos.json** (depende de medicamentos)

#### Colecciones con Dependencias Nivel 2
7. **pacientes.json** (depende de apoderados, contactos)

#### Colecciones con Dependencias Nivel 3
8. **historias_clinicas.json** (depende de pacientes)

#### Colecciones con Dependencias Nivel 4
9. **consultas.json** (depende de historias_clinicas, medicos)

#### Colecciones con Dependencias Nivel 5
10. **recetas.json** (depende de consultas, indicaciones_medicamentos)

### Paso 3: Proceso de Importación por Colección

Para cada archivo JSON:

1. En MongoDB Compass, seleccionar la base de datos `clinica_dermatologica`
2. Hacer clic en "CREATE COLLECTION"
3. Nombrar la colección (ejemplo: `especialidades_medicas`)
4. Una vez creada, hacer clic en "ADD DATA" → "Import JSON or CSV file"
5. Seleccionar el archivo JSON correspondiente
6. Verificar que el formato sea "JSON"
7. Hacer clic en "IMPORT"

### Paso 4: Ejecutar Consultas y Vistas

1. Abrir MongoDB Shell o usar la pestaña "Playground" en Compass
2. Ejecutar primero: `use clinica_dermatologica`
3. Ejecutar el contenido de `consultas_crud_mongodb.js` para las operaciones CRUD
4. Ejecutar el contenido de `vistas_lookup_mongodb.js` para crear las vistas

## 🔗 Características de los Datos

### IDs Iterativos
- Todos los documentos usan IDs iterativos (1, 2, 3, ...) como solicitado
- Facilita la referencia entre colecciones
- Compatible con importación directa

### Datos Realistas
- **Especialidades:** Dermatología General, Pediátrica, Cosmética, Patológica, Oncológica
- **Medicamentos:** Tretinoína, Clindamicina, Hidrocortisona, Protector Solar, etc.
- **Pacientes:** Variedad de edades (niños, adolescentes, adultos)
- **Consultas:** Diferentes patologías dermatológicas
- **Recetas:** Tratamientos específicos con duración y dosificación

### Relaciones Implementadas
- Médicos ↔ Especialidades ↔ Contactos
- Pacientes ↔ Apoderados ↔ Contactos
- Historia Clínica ↔ Pacientes
- Consultas ↔ Historia Clínica ↔ Médicos
- Recetas ↔ Consultas ↔ Indicaciones ↔ Medicamentos

## 📊 Vistas Creadas

### 1. `vista_medicos_completa`
Médicos con especialidad y datos de contacto completos

### 2. `vista_pacientes_completa`
Pacientes con apoderados (si aplica) y contacto, incluyendo edad calculada

### 3. `vista_consultas_completa`
Consultas con información completa de paciente, médico y especialidad

### 4. `vista_recetas_completa`
Recetas con medicamentos detallados e información del paciente

### 5. `vista_medicamentos_indicaciones`
Medicamentos con todas sus indicaciones terapéuticas

### 6. `vista_historia_clinica_completa`
Historia clínica con resumen de consultas y datos del paciente

### 7. `vista_estadisticas_medicos`
Estadísticas de productividad por médico

### 8. `vista_reporte_pacientes`
Reporte de pacientes por edad, género y actividad clínica

## 💡 Operaciones CRUD Disponibles

El archivo `consultas_crud_mongodb.js` incluye:

- **CREATE:** Inserción de nuevos documentos en todas las colecciones
- **READ:** Consultas complejas con filtros y búsquedas
- **UPDATE:** Actualizaciones simples y múltiples con versionado
- **DELETE:** Eliminación suave (recomendada) y eliminación física

### Índices Recomendados
```javascript
// Ejecutar después de la importación para optimizar consultas
db.pacientes.createIndex({dni: 1}, {unique: true})
db.medicos.createIndex({dni: 1}, {unique: true})
db.medicos.createIndex({numero_colegiatura: 1}, {unique: true})
db.contactos.createIndex({correo_electronico: 1})
db.consultas.createIndex({fecha_consulta: 1})
db.consultas.createIndex({id_historia: 1})
db.consultas.createIndex({id_medico: 1})
db.recetas.createIndex({fecha_vencimiento: 1})
db.recetas.createIndex({estado_receta: 1})
```

## 🔍 Consultas de Ejemplo

### Buscar pacientes por edad
```javascript
db.vista_pacientes_completa.find({
  "edad": {$gte: 18, $lt: 30}
})
```

### Médicos por especialidad
```javascript
db.vista_medicos_completa.aggregate([
  {
    $group: {
      _id: "$especialidad.nombre_especialidad",
      total_medicos: {$sum: 1}
    }
  }
])
```

### Recetas vigentes que vencen pronto
```javascript
db.vista_recetas_completa.find({
  estado_receta: "VIGENTE",
  fecha_vencimiento: {
    $lte: new Date(Date.now() + 7*24*60*60*1000)
  }
})
```

## ⚠️ Notas Importantes

1. **Orden de Importación:** Respetar el orden indicado para evitar errores de referencia
2. **Validación:** Verificar que cada colección tenga el número correcto de documentos
3. **Índices:** Crear índices después de la importación para mejorar rendimiento
4. **Backups:** Realizar backup antes de operaciones de eliminación
5. **Vistas:** Las vistas se crean automáticamente al ejecutar el script correspondiente

## 🛠️ Solución de Problemas

### Error de Referencia
Si hay errores de referencia, verificar:
- Orden de importación correcto
- IDs coinciden entre colecciones relacionadas
- No hay documentos faltantes en colecciones padre

### Problemas de Importación
- Verificar formato JSON válido
- Comprobar que MongoDB Compass esté actualizado
- Asegurar permisos de escritura en la base de datos

### Rendimiento Lento
- Crear índices recomendados
- Verificar que las consultas usen campos indexados
- Considerar paginación para grandes resultados

## 📞 Soporte

Para problemas específicos:
1. Verificar logs de MongoDB
2. Revisar sintaxis de consultas
3. Comprobar estructura de datos
4. Validar relaciones entre colecciones

---

**¡Base de datos lista para usar en producción!** 🚀
