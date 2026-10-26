-- Tarea 4 | Red Social Pascualina | Juan Jose Oquendo Sanchez
-- MySQL. Modelo equivalente al de Tarea 3, ampliado con evento.metadatos_contexto.
-- Requiere permisos para CREATE DATABASE; MySQL 8.0.16+ / preferible MySQL 8.4.
CREATE DATABASE red_social_pascualina CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
USE red_social_pascualina;
SET time_zone = '+00:00';


-- AREA_ESTUDIO
CREATE TABLE area_estudio (
    id_area INT AUTO_INCREMENT NOT NULL,
    nombre_area VARCHAR(120) NOT NULL,
    facultad VARCHAR(140) NOT NULL,
    CONSTRAINT pk_area_estudio PRIMARY KEY (id_area),
    CONSTRAINT uq_area_estudio_nombre_area UNIQUE (nombre_area),
    CONSTRAINT ck_area_estudio_nombre_area_no_vacio CHECK (trim(nombre_area) <> ''),
    CONSTRAINT ck_area_estudio_facultad_no_vacio CHECK (trim(facultad) <> '')
) ENGINE=InnoDB;


-- USUARIO
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT NOT NULL,
    id_area INT NOT NULL,
    nombre_completo VARCHAR(160) NOT NULL,
    correo_institucional VARCHAR(180) NOT NULL,
    fecha_nacimiento DATE,
    fecha_registro DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    foto_perfil TEXT,
    biografia TEXT,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_correo_institucional UNIQUE (correo_institucional),
    CONSTRAINT fk_usuario_id_area FOREIGN KEY (id_area) REFERENCES area_estudio (id_area) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_usuario_nombre_completo_no_vacio CHECK (trim(nombre_completo) <> ''),
    CONSTRAINT ck_usuario_correo_institucional_no_vacio CHECK (trim(correo_institucional) <> '')
) ENGINE=InnoDB;


-- INTERES_HABILIDAD
CREATE TABLE interes_habilidad (
    id_interes INT AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    CONSTRAINT pk_interes_habilidad PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_habilidad_nombre_categoria UNIQUE (nombre, categoria),
    CONSTRAINT ck_interes_habilidad_nombre_no_vacio CHECK (trim(nombre) <> ''),
    CONSTRAINT ck_interes_habilidad_categoria_no_vacio CHECK (trim(categoria) <> '')
) ENGINE=InnoDB;


-- USUARIO_INTERES
CREATE TABLE usuario_interes (
    id_usuario INT NOT NULL,
    id_interes INT NOT NULL,
    nivel VARCHAR(40) NOT NULL,
    CONSTRAINT pk_usuario_interes PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_usuario_interes_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usuario_interes_id_interes FOREIGN KEY (id_interes) REFERENCES interes_habilidad (id_interes) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_usuario_interes_nivel_dom CHECK (nivel IN ('basico', 'intermedio', 'avanzado'))
) ENGINE=InnoDB;


-- CONEXION
CREATE TABLE conexion (
    id_usuario_origen INT NOT NULL,
    id_usuario_destino INT NOT NULL,
    estado VARCHAR(40) NOT NULL,
    fecha_conexion DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_conexion PRIMARY KEY (id_usuario_origen, id_usuario_destino),
    CONSTRAINT fk_conexion_id_usuario_origen FOREIGN KEY (id_usuario_origen) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_conexion_id_usuario_destino FOREIGN KEY (id_usuario_destino) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_conexion_estado_dom CHECK (estado IN ('pendiente', 'aceptada', 'rechazada', 'bloqueada'))
) ENGINE=InnoDB;


-- GRUPO
CREATE TABLE grupo (
    id_grupo INT AUTO_INCREMENT NOT NULL,
    id_usuario_creador INT NOT NULL,
    nombre_grupo VARCHAR(160) NOT NULL,
    descripcion TEXT,
    tipo_grupo VARCHAR(60) NOT NULL,
    fecha_creacion DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT fk_grupo_id_usuario_creador FOREIGN KEY (id_usuario_creador) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_grupo_nombre_grupo_no_vacio CHECK (trim(nombre_grupo) <> ''),
    CONSTRAINT ck_grupo_tipo_grupo_dom CHECK (tipo_grupo IN ('estudio', 'club', 'hackaton', 'deportes', 'otro'))
) ENGINE=InnoDB;


-- MEMBRESIA_GRUPO
CREATE TABLE membresia_grupo (
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    rol VARCHAR(40) NOT NULL,
    fecha_ingreso DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_membresia_grupo PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_membresia_grupo_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_membresia_grupo_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_membresia_grupo_rol_dom CHECK (rol IN ('administrador', 'moderador', 'miembro'))
) ENGINE=InnoDB;


-- PUBLICACION
CREATE TABLE publicacion (
    id_publicacion INT AUTO_INCREMENT NOT NULL,
    id_usuario INT NOT NULL,
    id_grupo INT,
    tipo VARCHAR(50) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT fk_publicacion_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_publicacion_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_publicacion_tipo_dom CHECK (tipo IN ('pregunta', 'recurso', 'noticia', 'meme', 'otro')),
    CONSTRAINT ck_publicacion_contenido_no_vacio CHECK (trim(contenido) <> '')
) ENGINE=InnoDB;


-- COMENTARIO
CREATE TABLE comentario (
    id_comentario INT AUTO_INCREMENT NOT NULL,
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_comentario DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_comentario_id_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_comentario_contenido_no_vacio CHECK (trim(contenido) <> '')
) ENGINE=InnoDB;


-- REACCION
CREATE TABLE reaccion (
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    tipo_reaccion VARCHAR(40) NOT NULL,
    fecha_reaccion DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_reaccion PRIMARY KEY (id_usuario, id_publicacion),
    CONSTRAINT fk_reaccion_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reaccion_id_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_reaccion_tipo_reaccion_dom CHECK (tipo_reaccion IN ('me_gusta', 'me_encanta', 'apoyo', 'divertido', 'sorprendido'))
) ENGINE=InnoDB;


-- EVENTO
CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT NOT NULL,
    id_usuario_organizador INT NOT NULL,
    id_grupo INT,
    nombre_evento VARCHAR(180) NOT NULL,
    descripcion TEXT,
    fecha_hora_inicio DATETIME(6) NOT NULL,
    fecha_hora_fin DATETIME(6) NOT NULL,
    ubicacion TEXT NOT NULL,
    metadatos_contexto JSON,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT fk_evento_id_usuario_organizador FOREIGN KEY (id_usuario_organizador) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_evento_id_grupo FOREIGN KEY (id_grupo) REFERENCES grupo (id_grupo) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_evento_nombre_evento_no_vacio CHECK (trim(nombre_evento) <> ''),
    CONSTRAINT ck_evento_ubicacion_no_vacio CHECK (trim(ubicacion) <> ''),
    CONSTRAINT ck_evento_fechas CHECK (fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_evento_metadatos_objeto CHECK (metadatos_contexto IS NULL OR JSON_TYPE(metadatos_contexto) = 'OBJECT')
) ENGINE=InnoDB;


-- ASISTENCIA_EVENTO
CREATE TABLE asistencia_evento (
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    estado_asistencia VARCHAR(30) NOT NULL,
    CONSTRAINT pk_asistencia_evento PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_asistencia_evento_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asistencia_evento_id_evento FOREIGN KEY (id_evento) REFERENCES evento (id_evento) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_asistencia_evento_estado_asistencia_dom CHECK (estado_asistencia IN ('interesado', 'confirmado', 'no_asiste'))
) ENGINE=InnoDB;

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

-- MySQL no admite CHECK sobre columnas con acciones FK referenciales.
-- Por eso la restriccion de autoconexion se implementa con triggers.
DELIMITER $$
CREATE TRIGGER trg_conexion_no_self_ins BEFORE INSERT ON conexion
FOR EACH ROW BEGIN
 IF NEW.id_usuario_origen = NEW.id_usuario_destino THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un usuario no puede conectarse consigo mismo';
 END IF;
END$$
CREATE TRIGGER trg_conexion_no_self_upd BEFORE UPDATE ON conexion
FOR EACH ROW BEGIN
 IF NEW.id_usuario_origen = NEW.id_usuario_destino THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un usuario no puede conectarse consigo mismo';
 END IF;
END$$
DELIMITER ;

