# Tarea 4 - Red Social Estudiantil Pascualina

**Autor:** Juan José Oquendo Sánchez  
**Institución:** Institución Universitaria Pascual Bravo  
**Modalidad:** Trabajo individual; sin video ni conclusiones grupales simuladas.

## Objetivo

Adaptar el modelo conceptual (Tarea 1), lógico normalizado (Tarea 2) y físico PostgreSQL (Tarea 3) a tres SGBD: PostgreSQL, MySQL y SQLite. Se conserva el núcleo relacional de 12 tablas y 18 claves foráneas. Se agrega `evento.metadatos_contexto` para documentos JSON: 58 campos en total.

## Contenido

- `Diccionarios/Diccionario_generico/Diccionario_generico_actualizado.xlsx` - catálogo lógico actualizado.
- `Diccionarios/Diccionario_<Motor>/Diccionario_fisico_<Motor>.xlsx` - tipos, tamaños, claves y restricciones por motor.
- `DDL/Scripts_DDL_<Motor>/01_modelo_fisico_<motor>.sql` - estructura completa.
- `DDL/Scripts_DDL_<Motor>/02_datos_y_consulta_json_<motor>.sql` - datos ficticios y extracción JSON.
- `DDL/Scripts_DDL_<Motor>/03_verificacion_<motor>.sql` - consultas de comprobación.
- `Informe/Informe_Tarea4_RedSocialPascualina.pdf` - informe técnico.
- `Informe/Informe_Tarea4_RedSocialPascualina.docx` - informe editable.
- `Diagramas/modelo_relacional_t4.png` - referencia visual del esquema.
- `Evidencias/red_social_pascualina_sqlite_demo.db` y `verificacion_local_sqlite.txt` - implementación y pruebas locales SQLite.

## Orden de ejecución

Cada motor tiene instrucciones en su carpeta. Trabajar en bases de datos NUEVAS. Ejecutar 01, luego 02 y por último 03. Nunca ejecutar scripts de motores distintos sobre la misma base.

- **PostgreSQL:** crear base vacía, conectar y ejecutar 01 (crea esquema `red_social_pascualina`), 02 y 03.
- **MySQL:** ejecutar mediante MySQL Workbench/cliente mysql en modo script; `DELIMITER` en triggers es una instrucción del cliente, no del servidor.
- **SQLite:** abrir nueva base; activar `PRAGMA foreign_keys=ON` en cada conexión (no solo al crearla).

## Estado verificado

Se ejecutó y probó SQLite **3.46.1**, con 12 tablas, 58 columnas, 18 relaciones FK y siete pruebas de rechazo exitosas. **PostgreSQL y MySQL no fueron ejecutados en un servidor durante esta entrega**: son diseños y scripts listos para ejecutar y validar en esos SGBD. No debe afirmarse que han sido desplegados ni que ya hubo retroalimentación del docente.

## JSON / IoT

El nuevo campo `evento.metadatos_contexto` almacena una instantánea de contexto (fuente, coordenadas aproximadas, condiciones ambientales, momento de medición). PostgreSQL usa JSONB; MySQL JSON; SQLite TEXT + `json_valid/json_type`. Es un uso ilustrativo de IoT, **no una ingestión real ni un almacén masivo de series de sensores**.

## Pendientes de rúbrica

No se adjunta video por decisión expresa del estudiante. Tampoco se acredita participación en el foro, retroalimentación de compañeros o ejecuciones reales de PostgreSQL y MySQL. Si el docente los exige, estos ítems quedan pendientes.
