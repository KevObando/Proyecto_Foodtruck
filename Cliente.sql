//MODULO DE CLIENTE
//Prueba git
//TABLA
CREATE TABLE CLIENTE(
ID_Cliente Number(2,0),
Telefono_Cliente varchar(10),
Nombre_Cliente varchar(80),
Direccion_Cliente varchar(100));

ALTER TABLE CLIENTE
add primary key (ID_Cliente);

-- Se modifica la longitud de ID_Cliente
ALTER TABLE CLIENTE
MODIFY (ID_Cliente NUMBER(3,0));


//ALTER PARA AGREGAR ESPACIOS DE LOG (RECOMENDACION)

ALTER TABLE CLIENTE
ADD (
    fecha_creacion     DATE,
    creado_por         VARCHAR2(100),
    modificado_por     VARCHAR2(100),
    fecha_actualizacion DATE,
    accion             VARCHAR2(10),
    Apellido_Cliente varchar(80)
);

//TRIGGERS FECHA, CREADO POR, MODIFICADO POR, FECHA ACTUALIZACION, ACCION

//CREADO POR
CREATE OR REPLACE TRIGGER TRG_CLIENTE_CREADO_POR
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
     :NEW.CREADO_POR:= USER;
END;

//MODIFICADO POR
CREATE OR REPLACE TRIGGER TRG_CLIENTE_MODIFICADO_POR
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
  :NEW.MODIFICADO_POR:= USER;
END;

//FECHA_CREACION
CREATE OR REPLACE TRIGGER TRG_CLIENTE_FECHA_CREACION
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
  :NEW.FECHA_CREACION:= SYSDATE;
END;

//FECHA UPDATE
CREATE OR REPLACE TRIGGER TRG_CLIENTE_FECHA_ACTUALIZACION
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
  :NEW.FECHA_ACTUALIZACION:= SYSDATE;
END;

//ACCION
CREATE OR REPLACE TRIGGER TRG_CLIENTE_ACCION
BEFORE INSERT OR UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
 IF INSERTING THEN
 :NEW.ACCION:='INSERT';
 ELSIF UPDATING THEN
 :NEW.ACCION:='UPDATE';
 END IF;
END;

// CREACION DE PAQUETES CON LOS PROCEDIMIENTOS Y FUNCIONES

//SP AGREGAR CLIENTES
--SECUENCIA PARA HACER EL ID
CREATE SEQUENCE seq_cliente
START WITH 101
INCREMENT BY 1;


-- PKG_CLIENTES
CREATE OR REPLACE PACKAGE PKG_CLIENTES AS
    -- ESPECIFICACION
    PROCEDURE sp_agregar_cliente(
        p_telefono_cliente CLIENTE.Telefono_Cliente%TYPE,
        p_nombre_cliente CLIENTE.Nombre_Cliente%TYPE,
        p_apellido_cliente CLIENTE.Apellido_Cliente%TYPE,
        p_direccion_cliente CLIENTE.Direccion_Cliente%TYPE
    );
    PROCEDURE sp_actualizar_cliente(
        p_id_cliente CLIENTE.ID_Cliente%TYPE,
        p_telefono_cliente CLIENTE.Telefono_Cliente%TYPE,
        p_nombre_cliente CLIENTE.Nombre_Cliente%TYPE,
        p_apellido_cliente CLIENTE.Apellido_Cliente%TYPE,
        p_direccion_cliente CLIENTE.Direccion_Cliente%TYPE
    );
    PROCEDURE sp_eliminar_cliente(
        p_id_cliente CLIENTE.ID_Cliente%TYPE
    );
    PROCEDURE sp_leer_clientes;
END PKG_CLIENTES;
/

-- BODY PKG_CLIENTES
CREATE OR REPLACE PACKAGE BODY PKG_CLIENTES AS
    -- PROCEDIMIENTOS
    PROCEDURE sp_agregar_cliente(
        p_telefono_cliente CLIENTE.Telefono_Cliente%TYPE,
        p_nombre_cliente CLIENTE.Nombre_Cliente%TYPE,
        p_apellido_cliente CLIENTE.Apellido_Cliente%TYPE,
        p_direccion_cliente CLIENTE.Direccion_Cliente%TYPE
    ) IS
    BEGIN
        INSERT INTO CLIENTE(ID_Cliente, Telefono_Cliente, Nombre_Cliente, Apellido_Cliente, Direccion_Cliente)
        VALUES (seq_cliente.NEXTVAL, p_telefono_cliente, p_nombre_cliente, p_apellido_cliente, p_direccion_cliente);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END sp_agregar_cliente;

    PROCEDURE sp_actualizar_cliente(
        p_id_cliente CLIENTE.ID_Cliente%TYPE,
        p_telefono_cliente CLIENTE.Telefono_Cliente%TYPE,
        p_nombre_cliente CLIENTE.Nombre_Cliente%TYPE,
        p_apellido_cliente CLIENTE.Apellido_Cliente%TYPE,
        p_direccion_cliente CLIENTE.Direccion_Cliente%TYPE
    ) IS
    BEGIN
        UPDATE CLIENTE
        SET Telefono_Cliente = p_telefono_cliente,
            Nombre_Cliente = p_nombre_cliente,
            Apellido_Cliente = p_apellido_cliente,
            Direccion_Cliente = p_direccion_cliente
        WHERE ID_Cliente = p_id_cliente;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END sp_actualizar_cliente;

    PROCEDURE sp_eliminar_cliente(
        p_id_cliente CLIENTE.ID_Cliente%TYPE
    ) IS
    BEGIN
        DELETE FROM CLIENTE
        WHERE ID_Cliente = p_id_cliente;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END sp_eliminar_cliente;

    PROCEDURE sp_leer_clientes IS
        c_cursor SYS_REFCURSOR;
        v_id_cliente CLIENTE.ID_Cliente%TYPE;
        v_telefono_cliente CLIENTE.Telefono_Cliente%TYPE;
        v_nombre_cliente CLIENTE.Nombre_Cliente%TYPE;
        v_apellido_cliente CLIENTE.Apellido_Cliente%TYPE;
        v_direccion_cliente CLIENTE.Direccion_Cliente%TYPE;
    BEGIN
        OPEN c_cursor FOR SELECT * FROM CLIENTE;
        DBMS_OUTPUT.PUT_LINE('Lista de Clientes:');
        DBMS_OUTPUT.PUT_LINE('------------------');
        LOOP
            FETCH c_cursor INTO v_id_cliente, v_telefono_cliente, v_nombre_cliente, v_apellido_cliente, v_direccion_cliente;
            EXIT WHEN c_cursor%NOTFOUND;
            -- Imprimir los datos de cada cliente en formato de lista
            DBMS_OUTPUT.PUT_LINE('- ID: ' || v_id_cliente);
            DBMS_OUTPUT.PUT_LINE('  Teléfono: ' || v_telefono_cliente);
            DBMS_OUTPUT.PUT_LINE('  Nombre: ' || v_nombre_cliente);
            DBMS_OUTPUT.PUT_LINE('  Apellido: ' || v_apellido_cliente);
            DBMS_OUTPUT.PUT_LINE('  Dirección: ' || v_direccion_cliente);
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
        CLOSE c_cursor;
    EXCEPTION
        WHEN OTHERS THEN
            IF c_cursor%ISOPEN THEN
                CLOSE c_cursor;
            END IF;
            RAISE;
    END sp_leer_clientes;
END PKG_CLIENTES;
/


//LLAMADOS
-- Llamar al procedimiento sp_agregar_cliente
BEGIN
    PKG_CLIENTES.sp_agregar_cliente('8945-7223', 'Amanda', 'Rivera', 'Belen');
    PKG_CLIENTES.sp_agregar_cliente('5726-9021', 'Carlos', 'Mendez', 'Hatillo');
    PKG_CLIENTES.sp_agregar_cliente('7026-4589', 'Ricardo', 'Perez', 'Desamparados');
    PKG_CLIENTES.sp_agregar_cliente('6230-4756', 'Armando', 'Zamora', 'San Juan');
    PKG_CLIENTES.sp_agregar_cliente('8560-7831', 'Kenneth', 'Castillo', 'Barrio Mexico');
END;
/

-- Llamar al procedimiento sp_actualizar_cliente
BEGIN
    PKG_CLIENTES.sp_actualizar_cliente(1, '8970-55-7289', 'Amanda', 'Riverao', 'Belen');
END;
/

-- Llamar al procedimiento sp_eliminar_cliente
BEGIN
    PKG_CLIENTES.sp_eliminar_cliente(1);
END;
/

-- Llamar al procedimiento sp_leer_clientes
BEGIN
    PKG_CLIENTES.sp_leer_clientes;
END;
/
