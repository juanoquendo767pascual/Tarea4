SET search_path TO red_social_pascualina, public;
-- Demostracion controlada: ejecutar sobre las 12 tablas recien creadas.
INSERT INTO area_estudio (nombre_area, facultad) VALUES ('Ingenieria de Software', 'Ingenieria');
INSERT INTO usuario (id_area, nombre_completo, correo_institucional) SELECT id_area,'Juan Ejemplo','juan.ejemplo@pascualbravo.edu.co' FROM area_estudio WHERE nombre_area='Ingenieria de Software';
INSERT INTO grupo (id_usuario_creador,nombre_grupo,tipo_grupo) SELECT id_usuario,'Club de estudio IoT','estudio' FROM usuario WHERE correo_institucional='juan.ejemplo@pascualbravo.edu.co';
INSERT INTO evento (id_usuario_organizador,id_grupo,nombre_evento,fecha_hora_inicio,fecha_hora_fin,ubicacion,metadatos_contexto) SELECT u.id_usuario,g.id_grupo,'Taller de sensores','2026-11-02T14:00:00Z','2026-11-02T16:00:00Z','Laboratorio universitario', '{"origen":"sensor_iot","geolocalizacion":{"lat":6.2442,"lon":-75.5812},"ambiente":{"temperatura_c":24.1,"humedad_pct":65},"instante_medicion":"2026-10-25T18:00:00Z"}' FROM usuario u JOIN grupo g ON g.id_usuario_creador=u.id_usuario WHERE u.correo_institucional='juan.ejemplo@pascualbravo.edu.co';

-- Consulta de atributo semiestructurado
SELECT id_evento,nombre_evento,metadatos_contexto -> 'ambiente' ->> 'temperatura_c' AS temperatura_c FROM evento;
