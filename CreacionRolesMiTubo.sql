---------------  DESDE SYSTEM ---------------

-- 1) Creamos el tablespace sobre el que va a operar el usuario MITUBO

CREATE TABLESPACE MITUBO_TS DATAFILE 'MITUBO_TS.DBF' SIZE 10M AUTOEXTEND ON;

-- 2) Creamos el usuario mitubo

CREATE USER MITUBO IDENTIFIED BY mitubo
  -- TEMPORARY TABLESPACE temp_ts      -- TABLESPACE PARA LOS SEGMENTOS TEMPORALES
  DEFAULT TABLESPACE MITUBO_TS         -- TABLESPACE POR DEFECTO PARA SUS OBJETOS
  QUOTA 100M ON MITUBO_TS;             -- MÁXIMO ESPACIO EN ESE TABLESPACE
  -- QUOTA 500K ON data_ts;
  -- PROFILE Perfil_1;                 -- ASIGNA EL Perfil_1 AL usuarios

-- 3) Creamos el perfil de conexión a la BD MiTubo

CREATE PROFILE PERFIL_CONEXION LIMIT
  -- SESSIONS_PER_USER 3               -- MÁXIMO NÚM. DE SESIONES PARA ESE USUARIO
  -- CONNECT_TIME UNLIMITED            -- DURACIÓN MÁXIMA DE LA CONEXIÓN (MINUTOS)
  IDLE_TIME 5                          -- MINUTOS DE TIEMPO MUERTO EN UNA SESIÓN
  FAILED_LOGIN_ATTEMPTS 3;             -- Nº MÁX. DE INTENTOS PARA BLOQUEAR CUENTA
  -- PASSWORD_LIFE_TIME 90             -- Nº DE DÍAS DE EXPIRACIÓN DE LA CONTRASEÑA
  -- PASSWORD_GRACE_TIME 3;            -- PERIODO DE GRACIA DESPUÉS DE LOS 90 DÍAS

-- 4) Le asigno el perfil a mitubo

ALTER USER MITUBO PROFILE PERFIL_CONEXION;

-- 5) Creamos un rol para el usuario mitubo, de modo que pueda operar con tablas,
-- conectarse a la base de datos, y dar permisos.

CREATE ROLE R_MITUBO;

GRANT CONNECT TO R_MITUBO WITH ADMIN OPTION;                                 -- AQUÍ LE DEJAMOS QUE SE CONECTE A LA BBDD


GRANT CREATE TABLE, CREATE VIEW TO R_MITUBO;   -- AQUÍ LE DAMOS PERMISOS PARA CREAR TABLAS Y VISTAS

-- 6) Le damos el rol de R_MITUBO al usuario MITUBO

GRANT R_MITUBO TO MITUBO;

-- 7) Lo primero que hacemos es crear el rol Administrador

CREATE ROLE R_ADMIN;

GRANT CONNECT TO R_ADMIN WITH ADMIN OPTION;                                  -- AQUÍ LE DEJAMOS QUE SE CONECTE A LA BBDD

GRANT CREATE ROLE, DROP ANY ROLE, ALTER ANY ROLE TO R_ADMIN;           -- AQUÍ LE DEJAMOS OPERAR CUALQUIER ROL

GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE, DELETE ANY TABLE,   -- AQUÍ LE DAMOS TODOS LOS PERMISOS SOBRE TABLAS
INSERT ANY TABLE,UPDATE ANY TABLE, SELECT ANY TABLE, EXECUTE ANY PROCEDURE
TO R_ADMIN;

GRANT CREATE USER, DROP USER TO R_ADMIN;                  -- AQUÍ LE DEJAMOS CREAR Y ELMIMIAR USUARIOS

GRANT CREATE ANY VIEW, DROP ANY VIEW TO R_ADMIN;                         -- AQUÍ LE DEJAMOS CREAR CUALQUIER VISTA

-- 8) Creamos el usuario ADMINISTRADOR

CREATE USER ADMINISTRADOR IDENTIFIED BY administrador
    -- TEMPORARY TABLESPACE temp_ts      -- TABLESPACE PARA LOS SEGMENTOS TEMPORALES
  DEFAULT TABLESPACE MITUBO_TS           -- TABLESPACE POR DEFECTO PARA SUS OBJETOS
  QUOTA 100M ON MITUBO_TS               -- MÁXIMO ESPACIO EN ESE TABLESPACE
  -- QUOTA 500K ON data_ts;
  PROFILE PERFIL_CONEXION;               -- ASIGNA EL Perfil_1 AL usuarios

-- 9) Le damos el rol R_ADMIN a ADMINISTRADOR

GRANT R_ADMIN TO ADMINISTRADOR;

--

--------------- DESDE ADMINISTRADOR ---------------

-- 10)
CREATE ROLE R_AGENTE;
GRANT CONNECT TO R_AGENTE;

CREATE USER AGENTE1 IDENTIFIED BY agente1
DEFAULT TABLESPACE MITUBO_TS
QUOTA 500K ON MITUBO_TS
PROFILE PERFIL_CONEXION;

GRANT R_AGENTE TO AGENTE1;

CREATE ROLE R_USER;
GRANT CONNECT TO R_USER;

CREATE USER USUARIO1 IDENTIFIED BY usuario1
DEFAULT TABLESPACE MITUBO_TS
QUOTA 500K ON MITUBO_TS
PROFILE PERFIL_CONEXION;

GRANT R_USER TO USUARIO1;

CREATE ROLE R_CONSULTOR;
GRANT CONNECT TO R_CONSULTOR;

CREATE USER CONSULTOR1 IDENTIFIED BY consultor1
DEFAULT TABLESPACE MITUBO_TS
QUOTA 500K ON MITUBO_TS
PROFILE PERFIL_CONEXION;


-----------------DESDE MITUBO------------------------------------------------------------------

--COMIENZA SCRIPT BBDD


-- Generado por Oracle SQL Developer Data Modeler 17.4.0.355.2121
--   en:        2018-04-13 18:05:14 CEST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLE anuncios (
    id           NUMBER NOT NULL,
    idioma       VARCHAR2(2) NOT NULL,
    pais         VARCHAR2(50) NOT NULL,
    empresa_id   NUMBER NOT NULL,
    id3          NUMBER NOT NULL
);

ALTER TABLE anuncios ADD CONSTRAINT anuncios_pk PRIMARY KEY ( id,
id3 );

ALTER TABLE anuncios ADD CONSTRAINT anuncios_pkv1 UNIQUE ( empresa_id );

CREATE TABLE canal (
    id_canal           NUMBER NOT NULL,
    nombre             VARCHAR2(20) NOT NULL,
    descripcion        VARCHAR2(4000),
    ambito             VARCHAR2(7) DEFAULT 'Público' NOT NULL,
    imagen             BLOB,
    nº_suscriptores    NUMBER NOT NULL,
    video_id_video     NUMBER,
    video_usuario_id   NUMBER,
    usuario_id_user    NUMBER NOT NULL
);

ALTER TABLE canal
    ADD CONSTRAINT ámbito CHECK ( ambito IN (
        'Privado',
        'Público'
    ) );

CREATE UNIQUE INDEX canal__idx ON
    canal ( usuario_id_user ASC );

CREATE UNIQUE INDEX canal__idxv1 ON
    canal ( video_id_video ASC,
    video_usuario_id ASC );

CREATE UNIQUE INDEX canal__idx ON
    canal ( video_id_video ASC );

ALTER TABLE canal ADD CONSTRAINT canal_pk PRIMARY KEY ( id_canal );

CREATE TABLE categoria (
    id       NUMBER NOT NULL,
    nombre   VARCHAR2(20) NOT NULL
);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY ( id );

CREATE TABLE comentario (
    id_coment                     NUMBER NOT NULL,
    fecha                         DATE NOT NULL,
    hora                          DATE NOT NULL,
    usuario_id_user               NUMBER NOT NULL,
    comentario_usuario_id_user    NUMBER NOT NULL,
    video_id_video                NUMBER NOT NULL,
    video_usuario_id              NUMBER NOT NULL,
    comentario_video_id_video     NUMBER NOT NULL,
    comentario_video_usuario_id   NUMBER NOT NULL,
    comentario_id_coment          NUMBER NOT NULL,
    video_usuario_id_user         NUMBER NOT NULL
);

ALTER TABLE comentario
    ADD CONSTRAINT comentario_pk PRIMARY KEY ( usuario_id_user,
    video_id_video,
    id_coment );

CREATE TABLE denuncia (
    tipo               VARCHAR2(20) NOT NULL,
    usuario_id_user    NUMBER NOT NULL,
    video_id_video     NUMBER NOT NULL,
    video_usuario_id   NUMBER NOT NULL,
    video_id_user      NUMBER NOT NULL
);

ALTER TABLE denuncia ADD CONSTRAINT denuncia_pk PRIMARY KEY ( usuario_id_user,
video_id_video );

CREATE TABLE dirigido_a (
    anuncios_id    NUMBER NOT NULL,
    anuncios_id3   NUMBER NOT NULL,
    perfil_id      NUMBER NOT NULL
);

ALTER TABLE dirigido_a
    ADD CONSTRAINT dirigido_a_pk PRIMARY KEY ( anuncios_id,
    anuncios_id3,
    perfil_id );

CREATE TABLE empresa (
    id           NUMBER NOT NULL,
    id_empresa   NUMBER NOT NULL
);

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( id );

CREATE TABLE ldr (
    id_ldr    NUMBER NOT NULL,
    nombre    VARCHAR2(20) NOT NULL,
    ambito    VARCHAR2(7) DEFAULT 'Público' NOT NULL,
    creador   VARCHAR2(20) NOT NULL
);

ALTER TABLE ldr
    ADD CONSTRAINT ámbito CHECK ( ambito IN (
        'Privado',
        'Público'
    ) );

ALTER TABLE ldr ADD CONSTRAINT ldr_pk PRIMARY KEY ( id_ldr );

CREATE TABLE notificaciones (
    id_notif                     NUMBER NOT NULL,
    tipo                         VARCHAR2(20),
    descripcion                  VARCHAR2(4000),
    usuario_id_user              NUMBER NOT NULL,
    video_id_video               NUMBER,
    denuncia_usuario_id_user     NUMBER,
    denuncia_video_id_video      NUMBER,
    comentario_usuario_id_user   NUMBER,
    comentario_video_id_video    NUMBER,
    comentario_id_coment         NUMBER
);

ALTER TABLE notificaciones
    ADD CONSTRAINT notificaciones_ck_1 CHECK (
        (
            ( usuario_id_user IS NOT NULL )
            AND ( video_id_video IS NULL )
            AND ( denuncia_usuario_id IS NULL )
        )
        OR (
            ( usuario_id_user IS NULL )
            AND ( video_id_video IS NOT NULL )
            AND ( denuncia_usuario_id IS NULL )
        )
        OR (
            ( usuario_id_user IS NULL )
            AND ( video_id_video IS NULL )
            AND ( denuncia_usuario_id IS NOT NULL )
        )
    );

ALTER TABLE notificaciones ADD CONSTRAINT notificaciones_pk PRIMARY KEY ( id_notif );

CREATE TABLE opciones (
    id_options      NUMBER NOT NULL,
    nombre          VARCHAR2(20) NOT NULL,
    descripcion     VARCHAR2(4000) NOT NULL,
    valor_defecto   VARCHAR2(20) NOT NULL,
    tipo            VARCHAR2(20) NOT NULL,
    id_usuario      NUMBER NOT NULL
);

ALTER TABLE opciones
    ADD CHECK ( tipo IN (
        'Boolean',
        'Integer',
        'String'
    ) );

ALTER TABLE opciones ADD CONSTRAINT opciones_pk PRIMARY KEY ( id_options );

CREATE TABLE opcionesv2 (
    usuario_id    NUMBER NOT NULL,
    opciones_id   NUMBER NOT NULL
);

ALTER TABLE opcionesv2 ADD CONSTRAINT opcionesv1_pk PRIMARY KEY ( usuario_id,
opciones_id );

CREATE TABLE orden_video (
    video              NUMBER NOT NULL,
    lista_rep          VARCHAR2(20) NOT NULL,
    posición           NUMBER NOT NULL,
    video_id           NUMBER NOT NULL,
    video_usuario_id   NUMBER NOT NULL,
    ldr_id_ldr         NUMBER NOT NULL
);

ALTER TABLE orden_video ADD CONSTRAINT orden_video_pk PRIMARY KEY ( ldr_id_ldr,
posición );

CREATE TABLE pagos (
    usuario            VARCHAR2(20) NOT NULL,
    video              VARCHAR2(20) NOT NULL,
    visualizaciones    NUMBER,
    cantidad_abonada   NUMBER,
    usuario_id_user    NUMBER NOT NULL,
    video_id_video     NUMBER NOT NULL,
    video_usuario_id   NUMBER NOT NULL,
    video_id_user      NUMBER NOT NULL
);

ALTER TABLE pagos ADD CONSTRAINT pagos_pk PRIMARY KEY ( usuario_id_user,
video_id_video );

CREATE TABLE perfil (
    id_perf   NUMBER NOT NULL,
    pais      VARCHAR2(20),
    idioma    VARCHAR2(2)
);

ALTER TABLE perfil ADD CONSTRAINT perfil_pk PRIMARY KEY ( id_perf );

CREATE TABLE relation_27 (
    video_id           NUMBER NOT NULL,
    video_usuario_id   NUMBER NOT NULL,
    categoria_id       NUMBER NOT NULL,
    video_id_user      NUMBER
);

ALTER TABLE relation_27
    ADD CONSTRAINT relation_27_pk PRIMARY KEY ( video_id,
    video_usuario_id,
    categoria_id,
    video_id_user );

CREATE TABLE relation_30 (
    canal_id     NUMBER NOT NULL,
    usuario_id   NUMBER NOT NULL,
    ambito       VARCHAR2(7)
);

ALTER TABLE relation_30 ADD CONSTRAINT relation_30_pk PRIMARY KEY ( canal_id,
usuario_id );

CREATE TABLE relation_31 (
    usuario_id         NUMBER NOT NULL,
    video_id           NUMBER NOT NULL,
    video_usuario_id   NUMBER NOT NULL,
    fecha              DATE NOT NULL,
    inicio             DATE NOT NULL,
    fin                DATE,
    video_id_user      NUMBER
);

ALTER TABLE relation_31
    ADD CONSTRAINT relation_31_pk PRIMARY KEY ( usuario_id,
    video_id,
    video_usuario_id,
    video_id_user );

CREATE TABLE tarifas (
    anuncios_empresa_id   NUMBER NOT NULL,
    empresa_id            NUMBER NOT NULL,
    id_tarifa             NUMBER NOT NULL
);

ALTER TABLE tarifas
    ADD CONSTRAINT tarifas_pk PRIMARY KEY ( anuncios_empresa_id,
    empresa_id,
    id_tarifa );

CREATE TABLE usuario (
    id_user              NUMBER NOT NULL,
    alias                VARCHAR2(20) NOT NULL,
    nombre               VARCHAR2(20) NOT NULL,
    apellidos            VARCHAR2(20) NOT NULL,
    correo_electronico   VARCHAR2(200) NOT NULL,
    foto                 BLOB,
    descripcion          VARCHAR2(4000),
    idioma               VARCHAR2(2) NOT NULL,
    pais                 VARCHAR2(20) NOT NULL,
    canal_id_canal       NUMBER NOT NULL,
    perfil_id_perf       NUMBER NOT NULL
);

CREATE UNIQUE INDEX usuario__idx ON
    usuario ( canal_id_canal ASC );

ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY ( id_user );

CREATE TABLE video (
    id_video                 NUMBER NOT NULL,
    duracion                 DATE NOT NULL,
    titulo                   VARCHAR2(20) NOT NULL,
    descripcion              VARCHAR2(4000),
    formato                  BLOB NOT NULL,
    enlace                   VARCHAR2(400) NOT NULL,
    visualizaciones          NUMBER NOT NULL,
    num_comentarios          NUMBER NOT NULL,
    n_likes                  NUMBER NOT NULL,
    n_dislikes               NUMBER NOT NULL,
    fecha                    DATE NOT NULL,
    imagen                   BLOB,
    usuario_id               NUMBER NOT NULL,
    canal_id_canal1          NUMBER,
    precio                   NUMBER,
    canal_id_canal           NUMBER NOT NULL,
    orden_video_ldr_id_ldr   NUMBER,
    orden_video_posición     NUMBER,
    usuario_id_user          NUMBER NOT NULL,
    id_propietario           NUMBER NOT NULL,
    orden_video_posición1    NUMBER,
    usuario_id_user1         NUMBER NOT NULL
);

CREATE UNIQUE INDEX video__idx ON
    video ( canal_id_canal1 ASC );

ALTER TABLE video ADD CONSTRAINT video_pk PRIMARY KEY ( id_video );

ALTER TABLE anuncios
    ADD CONSTRAINT anuncios_empresa_fk FOREIGN KEY ( empresa_id )
        REFERENCES empresa ( id );

ALTER TABLE anuncios
    ADD CONSTRAINT anuncios_video_fk FOREIGN KEY ( id,
    id3 )
        REFERENCES video ( id_video );

ALTER TABLE canal
    ADD CONSTRAINT canal_usuario_fk FOREIGN KEY ( usuario_id_user )
        REFERENCES usuario ( id_user );

ALTER TABLE canal
    ADD CONSTRAINT canal_video_fk FOREIGN KEY ( video_id_video )
        REFERENCES video ( id_video );

ALTER TABLE comentario
    ADD CONSTRAINT comentario_comentario_fk FOREIGN KEY ( comentario_usuario_id_user,
    comentario_video_id_video,
    comentario_id_coment )
        REFERENCES comentario ( usuario_id_user,
        video_id_video,
        id_coment );

ALTER TABLE comentario
    ADD CONSTRAINT comentario_usuario_fk FOREIGN KEY ( usuario_id_user )
        REFERENCES usuario ( id_user );

ALTER TABLE comentario
    ADD CONSTRAINT comentario_video_fk FOREIGN KEY ( video_id_video )
        REFERENCES video ( id_video );

ALTER TABLE denuncia
    ADD CONSTRAINT denuncia_usuario_fk FOREIGN KEY ( usuario_id_user )
        REFERENCES usuario ( id_user );

ALTER TABLE denuncia
    ADD CONSTRAINT denuncia_video_fk FOREIGN KEY ( video_id_video )
        REFERENCES video ( id_video );

ALTER TABLE dirigido_a
    ADD CONSTRAINT dirigido_a_anuncios_fk FOREIGN KEY ( anuncios_id,
    anuncios_id3 )
        REFERENCES anuncios ( id,
        id3 );

ALTER TABLE dirigido_a
    ADD CONSTRAINT dirigido_a_perfil_fk FOREIGN KEY ( perfil_id )
        REFERENCES perfil ( id_perf );

ALTER TABLE empresa
    ADD CONSTRAINT empresa_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id_user );

ALTER TABLE notificaciones
    ADD CONSTRAINT notificaciones_comentario_fk FOREIGN KEY ( comentario_usuario_id_user,
    comentario_video_id_video,
    comentario_id_coment )
        REFERENCES comentario ( usuario_id_user,
        video_id_video,
        id_coment );

ALTER TABLE notificaciones
    ADD CONSTRAINT notificaciones_denuncia_fk FOREIGN KEY ( denuncia_usuario_id_user,
    denuncia_video_id_video )
        REFERENCES denuncia ( usuario_id_user,
        video_id_video );

ALTER TABLE notificaciones
    ADD CONSTRAINT notificaciones_usuario_fk FOREIGN KEY ( usuario_id_user )
        REFERENCES usuario ( id_user );

ALTER TABLE notificaciones
    ADD CONSTRAINT notificaciones_video_fk FOREIGN KEY ( video_id_video )
        REFERENCES video ( id_video );

ALTER TABLE opcionesv2
    ADD CONSTRAINT opcionesv1_opciones_fk FOREIGN KEY ( opciones_id )
        REFERENCES opciones ( id_options );

ALTER TABLE opcionesv2
    ADD CONSTRAINT opcionesv1_usuario_fk FOREIGN KEY ( usuario_id )
        REFERENCES usuario ( id_user );

ALTER TABLE orden_video
    ADD CONSTRAINT orden_video_ldr_fk FOREIGN KEY ( ldr_id_ldr )
        REFERENCES ldr ( id_ldr );

ALTER TABLE orden_video
    ADD CONSTRAINT orden_video_video_fk FOREIGN KEY ( video_id,
    video_usuario_id )
        REFERENCES video ( id_video );

ALTER TABLE pagos
    ADD CONSTRAINT pagos_usuario_fk FOREIGN KEY ( usuario_id_user )
        REFERENCES usuario ( id_user );

ALTER TABLE pagos
    ADD CONSTRAINT pagos_video_fk FOREIGN KEY ( video_id_video )
        REFERENCES video ( id_video );

ALTER TABLE relation_27
    ADD CONSTRAINT relation_27_categoria_fk FOREIGN KEY ( categoria_id )
        REFERENCES categoria ( id );

ALTER TABLE relation_27
    ADD CONSTRAINT relation_27_video_fk FOREIGN KEY ( video_id,
    video_id_user,
    video_usuario_id )
        REFERENCES video ( id_video );

ALTER TABLE relation_30
    ADD CONSTRAINT relation_30_canal_fk FOREIGN KEY ( canal_id )
        REFERENCES canal ( id_canal );

ALTER TABLE relation_30
    ADD CONSTRAINT relation_30_usuario_fk FOREIGN KEY ( usuario_id )
        REFERENCES usuario ( id_user );

ALTER TABLE relation_31
    ADD CONSTRAINT relation_31_usuario_fk FOREIGN KEY ( usuario_id )
        REFERENCES usuario ( id_user );

ALTER TABLE relation_31
    ADD CONSTRAINT relation_31_video_fk FOREIGN KEY ( video_id,
    video_id_user,
    video_usuario_id )
        REFERENCES video ( id_video );

ALTER TABLE tarifas
    ADD CONSTRAINT tarifas_anuncios_fk FOREIGN KEY ( anuncios_empresa_id )
        REFERENCES anuncios ( empresa_id );

ALTER TABLE tarifas
    ADD CONSTRAINT tarifas_empresa_fk FOREIGN KEY ( empresa_id )
        REFERENCES empresa ( id );

ALTER TABLE usuario
    ADD CONSTRAINT usuario_canal_fk FOREIGN KEY ( canal_id_canal )
        REFERENCES canal ( id_canal );

ALTER TABLE usuario
    ADD CONSTRAINT usuario_perfil_fk FOREIGN KEY ( perfil_id_perf )
        REFERENCES perfil ( id_perf );

ALTER TABLE video
    ADD CONSTRAINT video_canal_fk FOREIGN KEY ( canal_id_canal1 )
        REFERENCES canal ( id_canal );

ALTER TABLE video
    ADD CONSTRAINT video_canal_fkv1 FOREIGN KEY ( canal_id_canal )
        REFERENCES canal ( id_canal );

ALTER TABLE video
    ADD CONSTRAINT video_orden_video_fk FOREIGN KEY ( orden_video_ldr_id_ldr,
    orden_video_posición1 )
        REFERENCES orden_video ( ldr_id_ldr,
        posición );

ALTER TABLE video
    ADD CONSTRAINT video_usuario_fk FOREIGN KEY ( usuario_id )
        REFERENCES usuario ( id_user );

ALTER TABLE video
    ADD CONSTRAINT video_usuario_fkv2 FOREIGN KEY ( usuario_id_user )
        REFERENCES usuario ( id_user );

ALTER TABLE video
    ADD CONSTRAINT video_usuario_fkv3 FOREIGN KEY ( usuario_id_user1 )
        REFERENCES usuario ( id_user );



-- Informe de Resumen de Oracle SQL Developer Data Modeler:
--
-- CREATE TABLE                            20
-- CREATE INDEX                             5
-- ALTER TABLE                             63
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
--
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
--
-- REDACTION POLICY                         0
--
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
--
-- ERRORS                                   0
-- WARNINGS                                 0



--ACABA SCRIPT BBDD

--vistas para el usuario
CREATE VIEW MIS_DATOS AS SELECT * FROM USUARIO WHERE ID_USER=0;
CREATE VIEW MIS_VIDEOS AS SELECT * FROM VIDEO  WHERE USUARIO_ID_USER=0;
CREATE VIEW MIS_OPCIONES AS SELECT * FROM OPCIONES WHERE ID_USUARIO=0;
CREATE VIEW MIS_COMENTARIOS AS SELECT *FROM COMENTARIO WHERE USUARIO_ID_USER=0;
/*
Estas vistas se han hecho a mano pero realmente debria de hacerse con un proceso PL/SQL el cual cada
vez que se cree un usuario automaticamente se generen estas vistas
*/
GRANT SELECT ON MIS_DATOS TO R_USER;
GRANT SELECT ON MIS_VIDEOS TO R_USER;
GRANT SELECT ON MIS_OPCIONES TO R_USER;
GRANT SELECT ON MIS_COMENTARIOS TO R_USER;

--Le damos los permisos correspondientes al usuario AGENTE1 para que pueda realizar sus funciones
--Le hemos dado los permisos al usuario y no al rol, porque por temas de seguridad oracle no permite dar estos permisos al rol
GRANT SELECT, DELETE ON DENUNCIA TO R_AGENTE;
GRANT DELETE ON VIDEO TO R_AGENTE;
GRANT INSERT, DELETE ON NOTIFICACIONES TO R_AGENTE;

--vistas para el consultor
CREATE VIEW VALOR_VISUALIZACION AS SELECT (VISUALIZACIONES/CANTIDAD_ABONADA) PAGADO FROM PAGOS;
CREATE VIEW VISITAS_VIDEO AS SELECT VIDEO, VISUALIZACIONES FROM PAGOS;

GRANT SELECT ON VALOR_VISUALIZACION TO R_CONSULTOR;
GRANT SELECT ON VISITAS_VIDEO TO R_CONSULTOR;
