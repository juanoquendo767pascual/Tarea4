-- Abrir conexion en bd_redsocial_pascualina, schema red_social_pascualina
SELECT count(*) AS total_tablas FROM information_schema.tables WHERE table_schema='red_social_pascualina' AND table_type='BASE TABLE';
SELECT count(*) AS total_campos FROM information_schema.columns WHERE table_schema='red_social_pascualina';
SELECT count(*) AS total_fk FROM information_schema.table_constraints WHERE table_schema='red_social_pascualina' AND constraint_type='FOREIGN KEY';
SELECT nombre_evento, metadatos_contexto #>> '{ambiente,temperatura_c}' AS temperatura_c FROM red_social_pascualina.evento;
