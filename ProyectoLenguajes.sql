---Se crean las tablas para el proyecto de Lenguajes de programación.
--Creaci?n de la tabla CLIENTE

CREATE TABLE CLIENTE(
ID_Cliente Number(2,0),
Telefono_Cliente varchar(10),
Nombre_Cliente varchar(80),
Direccion_Cliente varchar(100));

ALTER TABLE CLIENTE
add primary key (ID_Cliente);


DROP TABLE EMPLEADO;

-- Crear la tabla EMPLEADO
CREATE TABLE EMPLEADO (
    ID_Empleado INT PRIMARY KEY,
    Nombre_Empleado VARCHAR2(80),
    Apellido_Empleado  VARCHAR2(80),
    Tipo_Empleado VARCHAR2(20),
    Contrase?a VARCHAR2(20)
);

CREATE TABLE EMPLEADO_FUNCIONES
--ID_Empleado INT FOREING KEY,     hacer inner join de la tabla empleado con empleado_funciones
ID_Empleado_Funciones INT PRIMARY KEY,
Funciones VARCHAR(50);



ALTER TABLE EMPLEADO      ---terminar alter table
ADD HORARIO VARCHAR(50),
ADD ASISTENCIA
  
     
-------------------------------------------TRIGGERS-------------------------------------
--- Trigger de insert y delete de la tabla empleado

CREATE TABLE trg_empleado_Insercion_Eliminacion (
    fecha_creacion     TIMESTAMP,
    creado_por         VARCHAR2(100),
    modificado_por     VARCHAR2(100),
    fecha_actualizacion TIMESTAMP,
    accion             VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trg_empleado_Insercion_Eliminacion
BEFORE INSERT OR DELETE ON EMPLEADO
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO trg_empleado_Insercion_Eliminacion(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'INSERT');
    END IF;
    
    IF DELETING THEN
        INSERT INTO trg_empleado_Insercion_Eliminacion(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'DELETE');
    END IF;
END;
/

--- Trigger de update de la tabla empleado
CREATE TABLE trg_empleado_Update (
    fecha_creacion     TIMESTAMP,
    creado_por         VARCHAR2(100),
    modificado_por     VARCHAR2(100),
    fecha_actualizacion TIMESTAMP,
    accion             VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trg_empleado_Update
BEFORE UPDATE ON EMPLEADO
FOR EACH ROW
BEGIN
        INSERT INTO trg_empleado_Update(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'UPDATE');
END;
/

--------Triggers tabla cliente

CREATE TABLE trg_cliente_Insercion_Eliminacion_update (
    fecha_creacion     TIMESTAMP,
    creado_por         VARCHAR2(100),
    modificado_por     VARCHAR2(100),
    fecha_actualizacion TIMESTAMP,
    accion             VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trg_cliente_Insercion_Eliminacion_update
BEFORE INSERT OR DELETE OR UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO trg_cliente_Insercion_Eliminacion_update(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'INSERT');
     ELSIF DELETING THEN
        INSERT INTO trg_cliente_Insercion_Eliminacion_update(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'DELETE');
    ELSIF UPDATING THEN
        INSERT INTO trg_cliente_Insercion_Eliminacion_update(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'UPDATE');
    END IF;
END;
/

-------Triggers tabla 



















  
---Procedimiento almacenado para insertar registros a la tabla empleados      
CREATE OR REPLACE PROCEDURE p_llenar_empleados AS
BEGIN
  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase?a)
  VALUES (101, 'Jose', 'Perez', 'Cocinero', 'Contrasena1');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase?a)
  VALUES (102, 'Maria', 'Gonzales', 'Cajera', 'Contrasena2');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase?a)
  VALUES (103, 'Carlos', 'Martinez', 'Gerente', 'Contrasena3');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase?a)
  VALUES (104, 'Ana', 'Leal', 'Asistente', 'Contrasena4');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase?a)
  VALUES (105, 'Marcos', 'Zamora', 'Repartidor', 'Contrasena5');

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Los datos se han llenado correctamente.');
END;
/
SET SERVEROUTPUT ON;
Execute p_llenar_empleados;




---Procedimiento de consulta a la Tabla empleados

CREATE OR REPLACE PROCEDURE p_consultar_empleados(k_cursor OUT SYS_REFCURSOR) AS
BEGIN
  OPEN k_cursor FOR SELECT * FROM EMPLEADO;
END;
/
VAR my_cursor REFCURSOR;
EXEC p_consultar_empleados(:my_cursor);
PRINT my_cursor;


-- Crear la tabla PRODUCTO
CREATE TABLE PRODUCTO (
    ID_Producto INT PRIMARY KEY,
    Descripcion VARCHAR2(80),
    Disponibilidad VARCHAR2(10),
    Precio NUMBER(10, 2)
);

-- Crear la tabla PEDIDO
CREATE TABLE PEDIDO (
    ID_Pedido INT PRIMARY KEY,
    Estado_Pedido VARCHAR2(20),
    Monto_total NUMBER(10, 2),
    Fecha DATE,
    ID_Cliente Number(2,0),
    ID_Empleado INT
    );

--Creación de las tablas foráneas para la tabla PEDIDO
ALTER TABLE PEDIDO
ADD CONSTRAINT pk_id_cliente
FOREIGN KEY (ID_Cliente)
REFERENCES CLIENTE (ID_Cliente);

ALTER TABLE PEDIDO
ADD CONSTRAINT pk_id_empleado
FOREIGN KEY (ID_Empleado)
REFERENCES EMPLEADO(ID_Empleado);
/
--Crear la tabla COMPRA
CREATE TABLE COMPRA (
    ID_Compra INT PRIMARY KEY,
    ID_Pedido INT,
    Productos_Comprados varchar(30),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido)
);
/
-- Crear la tabla PEDIDO-PRODUCTO
CREATE TABLE PEDIDO_PRODUCTO (
    ID_Pedido INT,
    ID_Producto INT,
    PRIMARY KEY (ID_Pedido, ID_Producto),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);