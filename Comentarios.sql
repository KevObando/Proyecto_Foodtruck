-- Crear la tabla COMENTARIOS
CREATE TABLE COMENTARIOS (
    ID_Comentario INT PRIMARY KEY,
    ID_Cliente Number(3,0),
    Comentario VARCHAR2(500),
    Calificacion NUMBER(1, 0),
    Fecha_Comentario DATE,
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

-- Triggers
ALTER TABLE COMENTARIOS
ADD (
    fecha_creacion DATE,
    creado_por VARCHAR2(100),
    modificado_por VARCHAR2(100),
    fecha_actualizacion DATE,
    accion VARCHAR2(10)
);


-- TRIGGERS DE LA TABLA COMENTARIOS
--CREADO POR
CREATE OR REPLACE TRIGGER TRG_COMENTARIOS_CREADO_POR
BEFORE INSERT ON COMENTARIOS
FOR EACH ROW
BEGIN
     :NEW.CREADO_POR:= USER;
END;
/

--MODIFICADO POR
CREATE OR REPLACE TRIGGER TRG_COMENTARIOS_MODIFICADO_POR
BEFORE UPDATE ON COMENTARIOS
FOR EACH ROW
BEGIN
  :NEW.MODIFICADO_POR:= USER;
END;
/

--FECHA_CREACION
CREATE OR REPLACE TRIGGER TRG_COMENTARIOS_FECHA_CREACION
BEFORE INSERT ON COMENTARIOS
FOR EACH ROW
BEGIN
  :NEW.FECHA_CREACION:= SYSDATE;
END;
/

--FECHA ACTUALIZACION
CREATE OR REPLACE TRIGGER TRG_COMENTARIOS_FECHA_ACTUALIZACION
BEFORE UPDATE ON COMENTARIOS
FOR EACH ROW
BEGIN
  :NEW.FECHA_ACTUALIZACION:= SYSDATE;
END;
/

--ACCION
CREATE OR REPLACE TRIGGER TRG_COMENTARIOS_ACCION
BEFORE INSERT OR UPDATE ON COMENTARIOS
FOR EACH ROW
BEGIN
 IF INSERTING THEN
 :NEW.ACCION:='INSERT';
 ELSIF UPDATING THEN
 :NEW.ACCION:='UPDATE';
 END IF;
END;
/



-- Crear secuencia para ID_Comentario
CREATE SEQUENCE seq_comentario
START WITH 1
INCREMENT BY 1;

-- PAQUETES
CREATE OR REPLACE PACKAGE PKG_COMENTARIOS AS
    -- ESPECIFICACION
    PROCEDURE leer_comentario (p_ID_Cliente IN CLIENTE.ID_Cliente%TYPE);
    PROCEDURE actualizar_comentario (
        p_ID_Comentario IN COMENTARIOS.ID_Comentario%TYPE,
        p_Comentario IN COMENTARIOS.Comentario%TYPE
    );
    PROCEDURE eliminar_comentario (p_ID_Comentario IN COMENTARIOS.ID_Comentario%TYPE);
    PROCEDURE insertar_comentario (
        p_ID_Cliente IN CLIENTE.ID_Cliente%TYPE,
        p_Comentario IN COMENTARIOS.Comentario%TYPE,
        p_Calificacion IN COMENTARIOS.Calificacion%TYPE
    );
END PKG_COMENTARIOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_COMENTARIOS AS
    -- IMPLEMENTACION
    PROCEDURE leer_comentario (p_ID_Cliente IN CLIENTE.ID_Cliente%TYPE) IS
        CURSOR c_comentarios IS
            SELECT COMENTARIOS.ID_Comentario, CLIENTE.Nombre_Cliente, COMENTARIOS.Comentario 
            FROM COMENTARIOS 
            JOIN CLIENTE ON COMENTARIOS.ID_Cliente = CLIENTE.ID_Cliente
            WHERE COMENTARIOS.ID_Cliente = p_ID_Cliente;
        v_ID_Comentario COMENTARIOS.ID_Comentario%TYPE;
        v_Nombre_Cliente CLIENTE.Nombre_Cliente%TYPE;
        v_comentario COMENTARIOS.Comentario%TYPE;
    BEGIN
        OPEN c_comentarios;
        LOOP
            FETCH c_comentarios INTO v_ID_Comentario, v_Nombre_Cliente, v_comentario;
            EXIT WHEN c_comentarios%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('ID del Comentario: ' || v_ID_Comentario);
            DBMS_OUTPUT.PUT_LINE('Nombre del Cliente: ' || v_Nombre_Cliente);
            DBMS_OUTPUT.PUT_LINE('Comentario: ' || v_comentario);
            DBMS_OUTPUT.PUT_LINE('-------------------------');
        END LOOP;
        CLOSE c_comentarios;
    EXCEPTION
        WHEN OTHERS THEN
            IF c_comentarios%ISOPEN THEN
                CLOSE c_comentarios;
            END IF;
            RAISE;
    END leer_comentario;

    PROCEDURE actualizar_comentario (
        p_ID_Comentario IN COMENTARIOS.ID_Comentario%TYPE,
        p_Comentario IN COMENTARIOS.Comentario%TYPE
    ) IS
    BEGIN
        UPDATE COMENTARIOS SET Comentario = p_Comentario WHERE ID_Comentario = p_ID_Comentario;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró el comentario con el ID proporcionado.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END actualizar_comentario;

    PROCEDURE eliminar_comentario (p_ID_Comentario IN COMENTARIOS.ID_Comentario%TYPE) IS
    BEGIN
        DELETE FROM COMENTARIOS WHERE ID_Comentario = p_ID_Comentario;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró el comentario con el ID proporcionado.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END eliminar_comentario;

    PROCEDURE insertar_comentario (
        p_ID_Cliente IN CLIENTE.ID_Cliente%TYPE,
        p_Comentario IN COMENTARIOS.Comentario%TYPE,
        p_Calificacion IN COMENTARIOS.Calificacion%TYPE
    ) IS
        v_existe_cliente CLIENTE.ID_Cliente%TYPE;
    BEGIN
        -- Verificar si el ID del cliente existe
        SELECT ID_Cliente INTO v_existe_cliente FROM CLIENTE WHERE ID_Cliente = p_ID_Cliente;

        -- Si el ID del cliente existe, insertar el comentario
        IF v_existe_cliente IS NOT NULL THEN
            INSERT INTO COMENTARIOS (ID_Comentario, ID_Cliente, Comentario, Calificacion, Fecha_Comentario)
            VALUES (seq_comentario.NEXTVAL, p_ID_Cliente, p_Comentario, p_Calificacion, SYSDATE);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Comentario agregado exitosamente.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('El ID del cliente no existe.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('El ID del cliente no existe.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END insertar_comentario;
END PKG_COMENTARIOS;
/
-- Llamar al procedimiento para leer los comentarios de un cliente
BEGIN
    PKG_COMENTARIOS.leer_comentario(1); -- Reemplaza 1 con el ID_Cliente cuyos comentarios deseas leer
END;
/

-- Llamar al procedimiento para actualizar un comentario
BEGIN
    PKG_COMENTARIOS.actualizar_comentario(1, 'Este es un nuevo comentario'); -- Reemplaza 1 con el ID_Comentario que deseas actualizar y 'Este es un nuevo comentario' con el nuevo comentario
END;
/

-- Llamar al procedimiento para eliminar un comentario
BEGIN
    PKG_COMENTARIOS.eliminar_comentario(1); -- Reemplaza 1 con el ID_Comentario que deseas eliminar
END;
/

-- Llamar al procedimiento para hacer un comentario
BEGIN
    PKG_COMENTARIOS.hacer_comentario(1, 'Este es un comentario', 5); -- Reemplaza 1 con el ID_Cliente que hace el comentario, 'Este es un comentario' con el comentario y 5 con la calificación
END;
/

