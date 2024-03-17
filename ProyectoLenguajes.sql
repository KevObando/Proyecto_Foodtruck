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




---Procedimiento almacenado para insertar registros a la tabla empleados      
CREATE OR REPLACE PROCEDURE p_llenar_empleados AS
BEGIN
  INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña, Horario, Asistencia)
    VALUES (1, 'Antonio', 'Marin', 'Cocinero', 'Contrasena1', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña, Horario, Asistencia)
    VALUES (2, 'María', 'Rodríguez', 'Cajera', 'Contrasena2', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña, Horario, Asistencia)
    VALUES (3, 'Carlos', 'Morales', 'Ayudante', 'Contrasena3', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña, Horario, Asistencia)
    VALUES (4, 'Ana', 'González', 'Cocinera', 'Contrasena4', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contraseña, Horario, Asistencia)
    VALUES (5, 'Fabian', 'Leal', 'Repartidor', 'Contrasena5', 'L-V 12md-9pm', 'Y');

    COMMIT;

  DBMS_OUTPUT.PUT_LINE('Los datos se han llenado correctamente.');
END;
/
SET SERVEROUTPUT ON;
Execute p_llenar_empleados;
-----------------------------------------------------------------------

---Procedimiento de consulta a la Tabla empleados

CREATE OR REPLACE PROCEDURE p_consultar_empleados(k_cursor OUT SYS_REFCURSOR) AS
BEGIN
  OPEN k_cursor FOR SELECT * FROM EMPLEADO;
END;
/
VAR my_cursor REFCURSOR;
EXEC p_consultar_empleados(:my_cursor);
PRINT my_cursor;


----------------------------Procedimiento para llenar la tabla empleado funciones
CREATE OR REPLACE PROCEDURE p_Insertar_Empleado_Funciones (
  p_id_empleado INT,
  p_id_empleado_funciones INT,
  p_funciones VARCHAR2
) IS
BEGIN
  INSERT INTO EMPLEADO_FUNCIONES (ID_Empleado, ID_Empleado_Funciones, Funciones)
  VALUES (p_id_empleado, p_id_empleado_funciones, p_funciones);

  DBMS_OUTPUT.PUT_LINE('El registro se ha insertado correctamente.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al insertar el registro: ' || SQLERRM);
END;

/

Execute p_Insertar_Empleado_Funciones(1, 1, 'Preparar comida');


-------------------Procedimiento que crea un update a la tabla Empleado_funciones---------
CREATE OR REPLACE PROCEDURE p_actualizar_empleado_funciones (
  p_id_empleado INT,
  p_id_empleado_funciones INT,
  p_funciones VARCHAR2
) IS
BEGIN
  UPDATE EMPLEADO_FUNCIONES
  SET Funciones = p_funciones,
      ID_Empleado_Funciones = p_id_empleado_funciones
  WHERE ID_Empleado = p_id_empleado;

  DBMS_OUTPUT.PUT_LINE('El registro se ha actualizado correctamente.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al actualizar el registro: ' || SQLERRM);
END;


// Se ingresa el ID del empleado, ID_de la funcion y la nueva funcion del personal para actualizacion
Execute p_actualizar_empleado_funciones(1, 106, 'Preparar alimentos');



------------------Procedimiento almacenado que hace un delete a la tabla Empleado_funciones---------------
CREATE OR REPLACE PROCEDURE eliminar_empleado_funciones (p_id_empleado_funciones INT)
IS
BEGIN
  DELETE FROM EMPLEADO_FUNCIONES
  WHERE ID_Empleado = p_id_empleado_funciones;

  DBMS_OUTPUT.PUT_LINE('Los registros se han borrado correctamente.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al borrar los registros: ' || SQLERRM);
END;

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

--- Se ejecuta la visualizacion de tablas---
execute imprimir_empleado_funciones;



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
---------------------------------------------------------------------------------------
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
    ID_Pedido INT,
    ID_Producto INT,
    PRIMARY KEY (ID_Pedido, ID_Producto),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);