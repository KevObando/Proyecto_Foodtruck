---Se crean las tablas para el proyecto de Lenguajes de programaci�n.
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
    Contrase�a VARCHAR2(20)
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

--Creaci�n de las tablas for�neas para la tabla PEDIDO
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

--------CREACION DE PAQUETES
------------------------PROCEDIMIENTOS ALMACENADOS---------------------------------
-- Creaci�n del paquete EMPLEADO
CREATE OR REPLACE PACKAGE PKG_EMPLEADO AS
  PROCEDURE sp_llenar_empleados;
  PROCEDURE sp_consultar_empleados(k_cursor OUT SYS_REFCURSOR);
  PROCEDURE sp_InsertarEmpleadoFunciones;
  PROCEDURE sp_ActualizarEmpleadoFunciones;
  PROCEDURE sp_Eliminar_Empleado;
END PKG_EMPLEADO;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMPLEADO AS
  -- Procedimiento almacenado para insertar registros a la tabla empleados
  PROCEDURE sp_llenar_empleados AS
  BEGIN
    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase�a, Horario, Asistencia)
    VALUES (1, 'Antonio', 'Marin', 'Cocinero', 'Contrasena1', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase�a, Horario, Asistencia)
    VALUES (2, 'Mar�a', 'Rodr�guez', 'Cajera', 'Contrasena2', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase�a, Horario, Asistencia)
    VALUES (3, 'Carlos', 'Morales', 'Ayudante', 'Contrasena3', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase�a, Horario, Asistencia)
    VALUES (4, 'Ana', 'Gonz�lez', 'Cocinera', 'Contrasena4', 'L-V 12md-9pm', 'Y');

    INSERT INTO EMPLEADO (ID_Empleado, Nombre_Empleado, Apellido_Empleado, Tipo_Empleado, Contrase�a, Horario, Asistencia)
    VALUES (5, 'Fabian', 'Leal', 'Repartidor', 'Contrasena5', 'L-V 12md-9pm', 'Y');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Los datos se han llenado correctamente.');
  END sp_llenar_empleados;

  -- Procedimiento de consulta a la Tabla empleados
  PROCEDURE sp_consultar_empleados(k_cursor OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN k_cursor FOR SELECT * FROM EMPLEADO;
  END sp_consultar_empleados;

  -- Procedimiento para llenar la tabla empleado funciones
  PROCEDURE sp_InsertarEmpleadoFunciones AS 
  BEGIN
    INSERT INTO empleado_funciones (ID_Empleado, ID_Empleado_Funciones, Funciones)
    VALUES (1, 101, 'Preparar comida');

    INSERT INTO empleado_funciones (ID_Empleado, ID_Empleado_Funciones, Funciones)
    VALUES (2, 102, 'Cobrar en caja');

    INSERT INTO empleado_funciones (ID_Empleado, ID_Empleado_Funciones, Funciones)
    VALUES (3, 103, 'Limpiar mesas');

    INSERT INTO empleado_funciones (ID_Empleado, ID_Empleado_Funciones, Funciones)
    VALUES (4, 104, 'Preparar bebidas');

    INSERT INTO empleado_funciones (ID_Empleado, ID_Empleado_Funciones, Funciones)
    VALUES (5, 105, 'Repartir pedidos');

    COMMIT;
  END sp_InsertarEmpleadoFunciones;

  -- Procedimiento que actualiza registros en la tabla Empleado_funciones
  PROCEDURE sp_ActualizarEmpleadoFunciones AS 
  BEGIN
    UPDATE empleado_funciones
    SET Funciones = 'Administracion'
    WHERE ID_Empleado = 2;

    COMMIT;
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
END;
/

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

-------Triggers tabla compra acci�n INSERT
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

---------Trigger tabla compra acci�n Delete o Update
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










