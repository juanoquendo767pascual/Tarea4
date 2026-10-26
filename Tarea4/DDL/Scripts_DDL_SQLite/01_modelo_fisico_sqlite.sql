-- Tarea 4 | Red Social Pascualina | Juan Jose Oquendo Sanchez
-- SQLite. Modelo equivalente al de Tarea 3, ampliado con evento.metadatos_contexto.
-- Abrir una BASE VACIA en SQLite 3.38+ y ejecutar el script completo; JSON1 requerido.
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;


-- AREA_ESTUDIO
CREATE TABLE area_estudio (
    id_area INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_area TEXT NOT NULL,
    facultad TEXT NOT NULL,
    CONSTRAINT uq_area_estudio_nombre_area UNIQUE (nombre_area),
    CONSTRAINT ck_area_estudio_nombre_area_long CHECK (length(nombre_area) <= 120),
    CONSTRAINT ck_area_estudio_nombre_area_no_vacio CHECK (trim(nombre_area) <> ''),
    CONSTRAINT ck_area_estudio_facultad_long CHECK (length(facultad) <= 140),
    CONSTRAINT ck_area_estudio_facultad_no_vacio CHECK (trim(facultad) <> '')
);


-- USUARIO
CREATE TABLE usuario (
    id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
    id_area INTEGER NOT NULL,
    nombre_completo TEXT NOT NULL,
    correo_institucional TEXT NOT NULL,
    fecha_nacimiento TEXT,
    fecha_registro TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    foto_perfil TEXT,
    biografia TEXT,
    CONSTRAINT uq_usuario_correo_institucional UNIQUE (correo_institucional),
    CONSTRAINT fk_usuario_id_area FOREIGN KEY (id_area) REFERENCES area_estudio (id_area) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_usuario_nombre_completo_long CHECK (length(nombre_completo) <= 160),
    CONSTRAINT ck_usuario_nombre_completo_no_vacio CHECK (trim(nombre_completo) <> ''),
    CONSTRAINT ck_usuario_correo_institucional_long CHECK (length(correo_institucional) <= 180),
    CONSTRAINT ck_usuario_correo_institucional_no_vacio CHECK (trim(correo_institucional) <> ''),
    CONSTRAINT ck_usuario_fecha_nacimiento_iso CHECK (fecha_nacimiento IS NULL OR (strftime('%Y-%m-%d', fecha_nacimiento) IS NOT NULL AND strftime('%Y-%m-%d', fecha_nacimiento) = fecha_nacimiento)),
    CONSTRAINT ck_usuario_fecha_registro_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_registro) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_registro) = fecha_registro)
);


-- INTERES_HABILIDAD
CREATE TABLE interes_habilidad (
    id_interes INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    categoria TEXT NOT NULL,
    CONSTRAINT uq_interes_habilidad_nombre_categoria UNIQUE (nombre, categoria),
    CONSTRAINT ck_interes_habilidad_nombre_long CHECK (length(nombre) <= 120),
    CONSTRAINT ck_interes_habilidad_nombre_no_vacio CHECK (trim(nombre) <> ''),
    CONSTRAINT ck_interes_habilidad_categoria_long CHECK (length(categoria) <= 80),
    CONSTRAINT ck_interes_habilidad_categoria_no_vacio CHECK (trim(categoria) <> '')
);


-- USUARIO_INTERES
CREATE TABLE usuario_interes (
    id_usuario INTEGER NOT NULL,
    id_interes INTEGER NOT NULL,
    nivel TEXT NOT NULL,
    CONSTRAINT pk_usuario_interes PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_usuario_interes_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usuario_interes_id_interes FOREIGN KEY (id_interes) REFERENCES interes_habilidad (id_interes) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_usuario_interes_nivel_long CHECK (length(nivel) <= 40),
    CONSTRAINT ck_usuario_interes_nivel_dom CHECK (nivel IN ('basico', 'intermedio', 'avanzado'))
);


-- CONEXION
CREATE TABLE conexion (
    id_usuario_origen INTEGER NOT NULL,
    id_usuario_destino INTEGER NOT NULL,
    estado TEXT NOT NULL,
    fecha_conexion TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    CONSTRAINT pk_conexion PRIMARY KEY (id_usuario_origen, id_usuario_destino),
    CONSTRAINT fk_conexion_id_usuario_origen FOREIGN KEY (id_usuario_origen) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_conexion_id_usuario_destino FOREIGN KEY (id_usuario_destino) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_conexion_estado_long CHECK (length(estado) <= 40),
    CONSTRAINT ck_conexion_estado_dom CHECK (estado IN ('pendiente', 'aceptada', 'rechazada', 'bloqueada')),
    CONSTRAINT ck_conexion_fecha_conexion_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_conexion) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_conexion) = fecha_conexion),
    CONSTRAINT ck_conexion_distinta CHECK (id_usuario_origen <> id_usuario_destino)
);


-- GRUPO
CREATE TABLE grupo (
    id_grupo INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario_creador INTEGER NOT NULL,
    nombre_grupo TEXT NOT NULL,
    descripcion TEXT,
    tipo_grupo TEXT NOT NULL,
    fecha_creacion TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    CONSTRAINT fk_grupo_id_usuario_creador FOREIGN KEY (id_usuario_creador) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_grupo_nombre_grupo_long CHECK (length(nombre_grupo) <= 160),
    CONSTRAINT ck_grupo_nombre_grupo_no_vacio CHECK (trim(nombre_grupo) <> ''),
    CONSTRAINT ck_grupo_tipo_grupo_long CHECK (length(tipo_grupo) <= 60),
    CONSTRAINT ck_grupo_tipo_grupo_dom CHECK (tipo_grupo IN ('estudio', 'club', 'hackaton', 'deportes', 'otro')),
    CONSTRAINT ck_grupo_fecha_creacion_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_creacion) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_creacion) = fecha_creacion)
);


-- MEMBRESIA_GRUPO
CREATE TABLE membresia_grupo (
    id_usuario INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    rol TEXT NOT NULL,
    fecha_ingreso TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    CONSTRAINT pk_membresia_grupo PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_membresia_grupo_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_membresia_grupo_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_membresia_grupo_rol_long CHECK (length(rol) <= 40),
    CONSTRAINT ck_membresia_grupo_rol_dom CHECK (rol IN ('administrador', 'moderador', 'miembro')),
    CONSTRAINT ck_membresia_grupo_fecha_ingreso_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_ingreso) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_ingreso) = fecha_ingreso)
);


-- PUBLICACION
CREATE TABLE publicacion (
    id_publicacion INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    id_grupo INTEGER,
    tipo TEXT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    CONSTRAINT fk_publicacion_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_publicacion_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_publicacion_tipo_long CHECK (length(tipo) <= 50),
    CONSTRAINT ck_publicacion_tipo_dom CHECK (tipo IN ('pregunta', 'recurso', 'noticia', 'meme', 'otro')),
    CONSTRAINT ck_publicacion_contenido_no_vacio CHECK (trim(contenido) <> ''),
    CONSTRAINT ck_publicacion_fecha_publicacion_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_publicacion) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_publicacion) = fecha_publicacion)
);


-- COMENTARIO
CREATE TABLE comentario (
    id_comentario INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_comentario TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    CONSTRAINT fk_comentario_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_comentario_id_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_comentario_contenido_no_vacio CHECK (trim(contenido) <> ''),
    CONSTRAINT ck_comentario_fecha_comentario_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_comentario) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_comentario) = fecha_comentario)
);


-- REACCION
CREATE TABLE reaccion (
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    tipo_reaccion TEXT NOT NULL,
    fecha_reaccion TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
    CONSTRAINT pk_reaccion PRIMARY KEY (id_usuario, id_publicacion),
    CONSTRAINT fk_reaccion_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reaccion_id_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_reaccion_tipo_reaccion_long CHECK (length(tipo_reaccion) <= 40),
    CONSTRAINT ck_reaccion_tipo_reaccion_dom CHECK (tipo_reaccion IN ('me_gusta', 'me_encanta', 'apoyo', 'divertido', 'sorprendido')),
    CONSTRAINT ck_reaccion_fecha_reaccion_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_reaccion) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_reaccion) = fecha_reaccion)
);


-- EVENTO
CREATE TABLE evento (
    id_evento INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario_organizador INTEGER NOT NULL,
    id_grupo INTEGER,
    nombre_evento TEXT NOT NULL,
    descripcion TEXT,
    fecha_hora_inicio TEXT NOT NULL,
    fecha_hora_fin TEXT NOT NULL,
    ubicacion TEXT NOT NULL,
    metadatos_contexto TEXT,
    CONSTRAINT fk_evento_id_usuario_organizador FOREIGN KEY (id_usuario_organizador) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_evento_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_evento_nombre_evento_long CHECK (length(nombre_evento) <= 180),
    CONSTRAINT ck_evento_nombre_evento_no_vacio CHECK (trim(nombre_evento) <> ''),
    CONSTRAINT ck_evento_fecha_hora_inicio_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_hora_inicio) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_hora_inicio) = fecha_hora_inicio),
    CONSTRAINT ck_evento_fecha_hora_fin_utc CHECK (strftime('%Y-%m-%dT%H:%M:%SZ', fecha_hora_fin) IS NOT NULL AND strftime('%Y-%m-%dT%H:%M:%SZ', fecha_hora_fin) = fecha_hora_fin),
    CONSTRAINT ck_evento_ubicacion_no_vacio CHECK (trim(ubicacion) <> ''),
    CONSTRAINT ck_evento_fechas CHECK (fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_evento_metadatos_objeto CHECK (metadatos_contexto IS NULL OR (CASE WHEN json_valid(metadatos_contexto) THEN json_type(metadatos_contexto) = 'object' ELSE 0 END))
);


-- ASISTENCIA_EVENTO
CREATE TABLE asistencia_evento (
    id_usuario INTEGER NOT NULL,
    id_evento INTEGER NOT NULL,
    estado_asistencia TEXT NOT NULL,
    CONSTRAINT pk_asistencia_evento PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_asistencia_evento_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asistencia_evento_id_evento FOREIGN KEY (id_evento) REFERENCES evento (id_evento) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_asistencia_evento_estado_asistencia_long CHECK (length(estado_asistencia) <= 30),
    CONSTRAINT ck_asistencia_evento_estado_asistencia_dom CHECK (estado_asistencia IN ('interesado', 'confirmado', 'no_asiste'))
);

CREATE INDEX idx_usuario_id_area ON usuario (id_area);
CREATE INDEX idx_usuario_interes_id_interes ON usuario_interes (id_interes);
CREATE INDEX idx_conexion_id_usuario_destino ON conexion (id_usuario_destino);
CREATE INDEX idx_grupo_id_usuario_creador ON grupo (id_usuario_creador);
CREATE INDEX idx_membresia_grupo_id_grupo ON membresia_grupo (id_grupo);
CREATE INDEX idx_publicacion_id_usuario ON publicacion (id_usuario);
CREATE INDEX idx_publicacion_id_grupo ON publicacion (id_grupo);
CREATE INDEX idx_comentario_id_usuario ON comentario (id_usuario);
CREATE INDEX idx_comentario_id_publicacion ON comentario (id_publicacion);
CREATE INDEX idx_reaccion_id_publicacion ON reaccion (id_publicacion);
CREATE INDEX idx_evento_id_usuario_organizador ON evento (id_usuario_organizador);
CREATE INDEX idx_evento_id_grupo ON evento (id_grupo);
CREATE INDEX idx_asistencia_evento_id_evento ON asistencia_evento (id_evento);

COMMIT;
