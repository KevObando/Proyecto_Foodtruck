---Se crean las tablas para el proyecto de Lenguajes de programación.
--Creaci?n de la tabla CLIENTE

CREATE TABLE CLIENTE(
ID_Cliente Number(2,0),
Telefono_Cliente varchar(10),
Nombre_Cliente varchar(80),
Direccion_Cliente varchar(100));

ALTER TABLE CLIENTE
add primary key (ID_Cliente);


-- Crear la tabla EMPLEADO
CREATE TABLE EMPLEADO (
    ID_Empleado INT PRIMARY KEY,
    Nombre_Empleado VARCHAR2(80),
    Apellido_Empleado  VARCHAR2(80),
    Tipo_Empleado VARCHAR2(20),
    Contraseña VARCHAR2(20)
);

ALTER TABLE EMPLEADO
ADD (
    Horario VARCHAR2(80),
   Asistencia CHAR(1) CHECK (Asistencia IN ('Y', 'N'))
);

--------- Tabla relacion Empleado_Funciones
CREATE TABLE EMPLEADO_FUNCIONES(
    ID_Empleado INT,
    ID_Empleado_Funciones INT PRIMARY KEY,
    Funciones VARCHAR(50),
    FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADO(ID_Empleado)
);

------------------------------------------------------------------------------
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
    ID_Pedido_Producto int,
    ID_Pedido INT,
    ID_Producto INT,
    Cantidad int,
    PRIMARY KEY (ID_Pedido_Producto),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

--------CREACION DE PAQUETES
------------------------PROCEDIMIENTOS ALMACENADOS---------------------------------
-- Creación del paquete EMPLEADO
CREATE OR REPLACE PACKAGE PKG_EMPLEADO AS
   PROCEDURE sp_llenar_empleados (
        p_ID_Empleado IN EMPLEADO.ID_Empleado%TYPE,
        p_Nombre_Empleado IN EMPLEADO.Nombre_Empleado%TYPE,
        p_Apellido_Empleado IN EMPLEADO.Apellido_Empleado%TYPE,
        p_Tipo_Empleado IN EMPLEADO.Tipo_Empleado%TYPE,
        p_Contraseña IN EMPLEADO.Contraseña%TYPE,
        p_Horario IN EMPLEADO.Horario%TYPE,
        p_Asistencia IN EMPLEADO.Asistencia%TYPE
    );
  PROCEDURE sp_consultar_empleados(k_cursor OUT SYS_REFCURSOR);
  PROCEDURE sp_InsertarEmpleadoFunciones(p_id_empleado INT, p_id_empleado_funciones INT, p_funciones VARCHAR2);
  PROCEDURE sp_ActualizarEmpleadoFunciones(p_id_empleado_funciones INT);
  PROCEDURE sp_Eliminar_Empleado;
END PKG_EMPLEADO;

/

CREATE OR REPLACE PACKAGE BODY PKG_EMPLEADO AS
  -- Procedimiento almacenado para insertar registros a la tabla empleados
  PROCEDURE sp_llenar_empleados (
        p_ID_Empleado IN EMPLEADO.ID_Empleado%TYPE,
        p_Nombre_Empleado IN EMPLEADO.Nombre_Empleado%TYPE,
        p_Apellido_Empleado IN EMPLEADO.Apellido_Empleado%TYPE,
        p_Tipo_Empleado IN EMPLEADO.Tipo_Empleado%TYPE,
        p_Contraseña IN EMPLEADO.Contraseña%TYPE,
        p_Horario IN EMPLEADO.Horario%TYPE,
        p_Asistencia IN EMPLEADO.Asistencia%TYPE
    ) IS
    BEGIN
        INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña, Horario, Asistencia)
        VALUES (p_ID_Empleado, p_Nombre_Empleado, p_Apellido_Empleado, p_Tipo_Empleado, p_Contraseña, p_Horario, p_Asistencia);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Empleado agregado exitosamente.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END sp_llenar_empleados;

  -- Procedimiento de consulta a la Tabla empleados
  PROCEDURE sp_consultar_empleados(k_cursor OUT SYS_REFCURSOR) AS
BEGIN
  OPEN k_cursor FOR SELECT * FROM EMPLEADO;
  END sp_consultar_empleados;

  -- Procedimiento para llenar la tabla empleado funciones
 PROCEDURE sp_InsertarEmpleadoFunciones(p_id_empleado INT, p_id_empleado_funciones INT, p_funciones VARCHAR2) AS 
BEGIN
  INSERT INTO EMPLEADO_FUNCIONES (ID_Empleado, ID_Empleado_Funciones, Funciones)
  VALUES (p_id_empleado, p_id_empleado_funciones, p_funciones);

  DBMS_OUTPUT.PUT_LINE('El registro se ha insertado correctamente.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar el registro: ' || SQLERRM);
END sp_InsertarEmpleadoFunciones;


  -- Procedimiento que actualiza registros en la tabla Empleado_funciones
PROCEDURE sp_ActualizarEmpleadoFunciones(p_id_empleado_funciones INT) AS 
BEGIN
  DELETE FROM EMPLEADO_FUNCIONES
  WHERE ID_Empleado = p_id_empleado_funciones;

  DBMS_OUTPUT.PUT_LINE('Los registros se han borrado correctamente.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al borrar los registros: ' || SQLERRM);
END sp_ActualizarEmpleadoFunciones;

  -- Procedimiento para eliminar empleado
  PROCEDURE sp_Eliminar_Empleado AS
  BEGIN
    DELETE FROM EMPLEADO WHERE ID_EMPLEADO = 105;
    COMMIT;
  END sp_Eliminar_Empleado;
END PKG_EMPLEADO;
/

-- Llamar al procedimiento llenar_empleados
BEGIN
  PKG_EMPLEADO.sp_llenar_empleados;
END ;

------Ejecuta el procedimiento solicitando el ID del empleado----------
Execute eliminar_empleado_funciones(1);
----------------------------------------------------------------------------------------------------------



----------------Procedimientos para ver la tabla empleado_funciones--------
CREATE OR REPLACE PROCEDURE visualizar_empleado_funciones (k_cursor OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN k_cursor FOR
    SELECT * FROM EMPLEADO_FUNCIONES;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al visualizar los datos: ' || SQLERRM);
END;
/
-----Procedimeinto para consultar la tabla Empleadofunciones---
CREATE OR REPLACE PROCEDURE imprimir_empleado_funciones IS
  v_cursor SYS_REFCURSOR;
  v_info EMPLEADO_FUNCIONES%ROWTYPE;
BEGIN
  visualizar_empleado_funciones(v_cursor);
  LOOP
    FETCH v_cursor INTO v_info;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('ID_Empleado: ' || v_info.ID_Empleado || ', ID_Empleado_Funciones: ' || v_info.ID_Empleado_Funciones || ', Funciones: ' || v_info.Funciones);
  END LOOP;
  CLOSE v_cursor;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al imprimir los datos: ' || SQLERRM);
END;

-- Consultar empleados
VAR my_cursor REFCURSOR;
EXEC PKG_EMPLEADO.sp_consultar_empleados(:my_cursor);
PRINT my_cursor;

-- Insertar registros en empleado_funciones
BEGIN
  PKG_EMPLEADO.sp_InsertarEmpleadoFunciones;
END;
/

-- Actualizar registros en empleado_funciones
BEGIN
  PKG_EMPLEADO.sp_ActualizarEmpleadoFunciones;
END;
/

-- Eliminar empleado
BEGIN
  PKG_EMPLEADO.sp_Eliminar_Empleado;
END;
/



-----------------------------------------------------------------------






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
---------------------------------------------------------------------------------------
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
/
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

-------Triggers tabla compra acción INSERT
CREATE TABLE trg_compra_insercion (
    fecha_creacion     TIMESTAMP,
    creado_por         VARCHAR2(100),
    modificado_por     VARCHAR2(100),
    fecha_actualizacion TIMESTAMP,
    accion             VARCHAR2(10)
);
/
CREATE OR REPLACE TRIGGER trg_compra_insercion
BEFORE INSERT ON COMPRA
FOR EACH ROW
BEGIN
        INSERT INTO trg_compra_insercion(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'INSERT');
END;
/

---------Trigger tabla compra acción Delete o Update
CREATE TABLE trg_compra_Eliminacion_update (
    fecha_creacion     TIMESTAMP,
    creado_por         VARCHAR2(100),
    modificado_por     VARCHAR2(100),
    fecha_actualizacion TIMESTAMP,
    accion             VARCHAR2(10)
);
/
CREATE OR REPLACE TRIGGER trg_compra_Eliminacion_update
BEFORE INSERT OR DELETE OR UPDATE ON COMPRA
FOR EACH ROW
BEGIN
     IF DELETING THEN
        INSERT INTO trg_compra_Eliminacion_update(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'DELETE');
    ELSIF UPDATING THEN
        INSERT INTO trg_compra_Eliminacion_update(fecha_creacion, creado_por, modificado_por, fecha_actualizacion, accion)
        VALUES (SYSTIMESTAMP, USER, USER, SYSTIMESTAMP, 'UPDATE');
    END IF;
END;
/

------------------VISTAS----------
------Vistas de la tabla empleado
CREATE OR REPLACE VIEW vista_empleado AS
SELECT 
    ID_Empleado,
    Nombre_Empleado,
    Apellido_Empleado,
    Tipo_Empleado,
    Horario
FROM EMPLEADO;
/

--vista materializada de la tabla empleado
CREATE MATERIALIZED VIEW mv_empleado
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT 
    ID_Empleado,
    Nombre_Empleado,
    Apellido_Empleado,
    Tipo_Empleado
FROM EMPLEADO;
/

--vista de la tabla cliente
CREATE OR REPLACE VIEW vista_cliente AS
SELECT 
    ID_Cliente,
    Telefono_Cliente,
    Nombre_Cliente,
    Direccion_Cliente
FROM CLIENTE;
/

--vista de la tabla compra
CREATE OR REPLACE VIEW vista_compra AS
SELECT 
    ID_Compra,
    ID_Pedido,
    Productos_Comprados
FROM COMPRA;
/

--vista de la tabla empleado funciones
CREATE OR REPLACE VIEW vista_empleado_funciones AS
SELECT 
    ID_Empleado,
    ID_Empleado_Funciones,
    Funciones
FROM EMPLEADO_FUNCIONES;

--vista de la tabla pedido
CREATE OR REPLACE VIEW vista_pedido AS
SELECT 
    ID_Pedido,
    Estado_Pedido,
    Monto_total,
    Fecha,
    ID_Cliente,
    ID_Empleado
FROM PEDIDO;
/








