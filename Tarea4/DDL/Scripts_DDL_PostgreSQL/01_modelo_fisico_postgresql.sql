-- Tarea 4 | Red Social Pascualina | Juan Jose Oquendo Sanchez
-- PostgreSQL. Modelo equivalente al de Tarea 3, ampliado con evento.metadatos_contexto.
-- Ejecutar conectado a una base de datos vacia o nueva; requiere permiso CREATE SCHEMA.
BEGIN;
CREATE SCHEMA red_social_pascualina;
SET LOCAL search_path TO red_social_pascualina, public;


-- AREA_ESTUDIO
CREATE TABLE area_estudio (
    id_area INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre_area VARCHAR(120) NOT NULL,
    facultad VARCHAR(140) NOT NULL,
    CONSTRAINT pk_area_estudio PRIMARY KEY (id_area),
    CONSTRAINT uq_area_estudio_nombre_area UNIQUE (nombre_area),
    CONSTRAINT ck_area_estudio_nombre_area_no_vacio CHECK (btrim(nombre_area) <> ''),
    CONSTRAINT ck_area_estudio_facultad_no_vacio CHECK (btrim(facultad) <> '')
);


-- USUARIO
CREATE TABLE usuario (
    id_usuario INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_area INTEGER NOT NULL,
    nombre_completo VARCHAR(160) NOT NULL,
    correo_institucional VARCHAR(180) NOT NULL,
    fecha_nacimiento DATE,
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    foto_perfil TEXT,
    biografia TEXT,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_correo_institucional UNIQUE (correo_institucional),
    CONSTRAINT fk_usuario_id_area FOREIGN KEY (id_area) REFERENCES area_estudio (id_area) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_usuario_nombre_completo_no_vacio CHECK (btrim(nombre_completo) <> ''),
    CONSTRAINT ck_usuario_correo_institucional_no_vacio CHECK (btrim(correo_institucional) <> '')
);


-- INTERES_HABILIDAD
CREATE TABLE interes_habilidad (
    id_interes INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    CONSTRAINT pk_interes_habilidad PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_habilidad_nombre_categoria UNIQUE (nombre, categoria),
    CONSTRAINT ck_interes_habilidad_nombre_no_vacio CHECK (btrim(nombre) <> ''),
    CONSTRAINT ck_interes_habilidad_categoria_no_vacio CHECK (btrim(categoria) <> '')
);


-- USUARIO_INTERES
CREATE TABLE usuario_interes (
    id_usuario INTEGER NOT NULL,
    id_interes INTEGER NOT NULL,
    nivel VARCHAR(40) NOT NULL,
    CONSTRAINT pk_usuario_interes PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_usuario_interes_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usuario_interes_id_interes FOREIGN KEY (id_interes) REFERENCES interes_habilidad (id_interes) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_usuario_interes_nivel_dom CHECK (nivel IN ('basico', 'intermedio', 'avanzado'))
);


-- CONEXION
CREATE TABLE conexion (
    id_usuario_origen INTEGER NOT NULL,
    id_usuario_destino INTEGER NOT NULL,
    estado VARCHAR(40) NOT NULL,
    fecha_conexion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_conexion PRIMARY KEY (id_usuario_origen, id_usuario_destino),
    CONSTRAINT fk_conexion_id_usuario_origen FOREIGN KEY (id_usuario_origen) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_conexion_id_usuario_destino FOREIGN KEY (id_usuario_destino) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_conexion_estado_dom CHECK (estado IN ('pendiente', 'aceptada', 'rechazada', 'bloqueada')),
    CONSTRAINT ck_conexion_distinta CHECK (id_usuario_origen <> id_usuario_destino)
);


-- GRUPO
CREATE TABLE grupo (
    id_grupo INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_usuario_creador INTEGER NOT NULL,
    nombre_grupo VARCHAR(160) NOT NULL,
    descripcion TEXT,
    tipo_grupo VARCHAR(60) NOT NULL,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT fk_grupo_id_usuario_creador FOREIGN KEY (id_usuario_creador) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_grupo_nombre_grupo_no_vacio CHECK (btrim(nombre_grupo) <> ''),
    CONSTRAINT ck_grupo_tipo_grupo_dom CHECK (tipo_grupo IN ('estudio', 'club', 'hackaton', 'deportes', 'otro'))
);


-- MEMBRESIA_GRUPO
CREATE TABLE membresia_grupo (
    id_usuario INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    rol VARCHAR(40) NOT NULL,
    fecha_ingreso TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_membresia_grupo PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_membresia_grupo_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_membresia_grupo_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_membresia_grupo_rol_dom CHECK (rol IN ('administrador', 'moderador', 'miembro'))
);


-- PUBLICACION
CREATE TABLE publicacion (
    id_publicacion INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_usuario INTEGER NOT NULL,
    id_grupo INTEGER,
    tipo VARCHAR(50) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT fk_publicacion_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_publicacion_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_publicacion_tipo_dom CHECK (tipo IN ('pregunta', 'recurso', 'noticia', 'meme', 'otro')),
    CONSTRAINT ck_publicacion_contenido_no_vacio CHECK (btrim(contenido) <> '')
);


-- COMENTARIO
CREATE TABLE comentario (
    id_comentario INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_comentario TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_comentario_id_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_comentario_contenido_no_vacio CHECK (btrim(contenido) <> '')
);


-- REACCION
CREATE TABLE reaccion (
    id_usuario INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    tipo_reaccion VARCHAR(40) NOT NULL,
    fecha_reaccion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_reaccion PRIMARY KEY (id_usuario, id_publicacion),
    CONSTRAINT fk_reaccion_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reaccion_id_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_reaccion_tipo_reaccion_dom CHECK (tipo_reaccion IN ('me_gusta', 'me_encanta', 'apoyo', 'divertido', 'sorprendido'))
);


-- EVENTO
CREATE TABLE evento (
    id_evento INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_usuario_organizador INTEGER NOT NULL,
    id_grupo INTEGER,
    nombre_evento VARCHAR(180) NOT NULL,
    descripcion TEXT,
    fecha_hora_inicio TIMESTAMPTZ NOT NULL,
    fecha_hora_fin TIMESTAMPTZ NOT NULL,
    ubicacion TEXT NOT NULL,
    metadatos_contexto JSONB,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT fk_evento_id_usuario_organizador FOREIGN KEY (id_usuario_organizador) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_evento_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_evento_nombre_evento_no_vacio CHECK (btrim(nombre_evento) <> ''),
    CONSTRAINT ck_evento_ubicacion_no_vacio CHECK (btrim(ubicacion) <> ''),
    CONSTRAINT ck_evento_fechas CHECK (fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_evento_metadatos_objeto CHECK (metadatos_contexto IS NULL OR jsonb_typeof(metadatos_contexto) = 'object')
);


-- ASISTENCIA_EVENTO
CREATE TABLE asistencia_evento (
    id_usuario INTEGER NOT NULL,
    id_evento INTEGER NOT NULL,
    estado_asistencia VARCHAR(30) NOT NULL,
    CONSTRAINT pk_asistencia_evento PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_asistencia_evento_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asistencia_evento_id_evento FOREIGN KEY (id_evento) REFERENCES evento (id_evento) ON UPDATE CASCADE ON DELETE CASCADE,
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

-- Indice JSON para busquedas por contenido de objeto; extension propia del motor.
CREATE INDEX idx_evento_metadatos_gin ON evento USING GIN (metadatos_contexto);

COMMIT;
