--Se crean las tablas para el proyecto de Lenguajes de programaciÃ³n.
--Creación de la tabla CLIENTE
---Prueba de sincronización Github

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
    Contraseña VARCHAR2(20),
    fecha_creacion DATE,
    creado_por VARCHAR2(80),
    modificado_por VARCHAR2(80),
    fecha_actualizacion DATE    
);

---Agrega las nuevas filas
ALTER TABLE EMPLEADO
ADD Apellido_Empleado  VARCHAR2(80)
ADD  fecha_creacion DATE
ADD creado_por VARCHAR2(80)
ADD modificado_por VARCHAR2(80)
ADD fecha_actualizacion DATE    
;


     
--- Creacion tabla log_empleado para llevar registro de update o delete 
CREATE TABLE log_empleado (
  id_log INT PRIMARY KEY,
  accion VARCHAR2(10),
  usuario VARCHAR2(100),
  fecha DATE,
  id_registro INT
);
     
--- Triggers para la tabla EMPLEADO





--- Fecha de aztualizacion..
CREATE OR REPLACE TRIGGER trg_empleado_fecha_creacion
BEFORE INSERT ON EMPLEADO
FOR EACH ROW
BEGIN
  :new.fecha_creacion := SYSDATE;
END;

--- Creado por..
CREATE OR REPLACE TRIGGER trg_empleado_creado_por
BEFORE INSERT ON EMPLEADO
FOR EACH ROW
BEGIN
  :new.creado_por := USER;
END;

--- modificado por..
CREATE OR REPLACE TRIGGER trg_empleado_modificado_por
BEFORE UPDATE ON empleado
FOR EACH ROW
BEGIN
  :new.modificado_por := USER;
END;

--- Fecha de actualizacion
CREATE OR REPLACE TRIGGER trg_empleado_fecha_actualizacion
BEFORE UPDATE ON empleado
FOR EACH ROW
BEGIN
  :new.fecha_actualizacion := SYSDATE;
END;

--- Registro si se hace un update o delete
CREATE OR REPLACE TRIGGER trg_empleado_update_delete
AFTER UPDATE OR DELETE ON empleado
FOR EACH ROW
DECLARE
    v_usuario varchar2(10);
    v_accion varchar2(50);
BEGIN
    SELECT user INTO v_usuario FROM dual;  
    IF UPDATING THEN
        v_accion := 'UPDATE';
    ELSIF DELETING THEN
        v_accion := 'DELETE';
    END IF;
      -- Insertar en la tabla de log
    INSERT INTO log_empleado(accion, usuario, fecha, id_registro)
    VALUES ( v_accion,v_usuario, SYSDATE, :OLD.id_empleado);
END;
  
---Procedimiento almacenado para insertar registros a la tabla empleados      
CREATE OR REPLACE PROCEDURE p_llenar_empleados AS
BEGIN
  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña)
  VALUES (101, 'Jose', 'Perez', 'Cocinero', 'Contrasena1');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña)
  VALUES (102, 'Maria', 'Gonzales', 'Cajera', 'Contrasena2');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña)
  VALUES (103, 'Carlos', 'Martinez', 'Gerente', 'Contrasena3');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña)
  VALUES (104, 'Ana', 'Leal', 'Asistente', 'Contrasena4');

  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña)
  VALUES (105, 'Marcos', 'Zamora', 'Repartidor', 'Contrasena5');

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Los datos se han llenado correctamente.');
END;
/
SET SERVEROUTPUT ON;
Execute p_llenar_empleados;

select * from EMPLEADO;


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

--CreaciÃ³n de las tablas forÃ¡neas para la tabla PEDIDO
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


