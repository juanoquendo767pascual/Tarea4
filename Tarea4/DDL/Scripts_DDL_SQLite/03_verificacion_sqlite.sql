-- Abrir la base de datos SQLite creada con el script 01
PRAGMA foreign_keys=ON;
SELECT count(*) AS total_tablas FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';
SELECT nombre_evento, json_extract(metadatos_contexto,'$.ambiente.temperatura_c') AS temperatura_c FROM evento;
PRAGMA foreign_key_check;
-- Para comprobar 18 FK, sumar las filas devueltas por PRAGMA foreign_key_list('nombre_tabla') para las doce tablas.
