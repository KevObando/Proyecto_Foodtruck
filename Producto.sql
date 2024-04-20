-- Módulo productos
-- Creación del paquete del módulo producto
CREATE OR REPLACE PACKAGE PKG_Producto AS
    PROCEDURE sp_inserta_producto(p_descripcion VARCHAR2, p_disponibilidad VARCHAR2, p_precio NUMBER);
    PROCEDURE sp_actualiza_producto(p_id_producto INT, p_descripcion VARCHAR2, p_disponibilidad VARCHAR2, p_precio NUMBER);
    PROCEDURE sp_elimina_producto(p_id_producto INT);
END PKG_Producto;
/


--SECUENCIA PARA HACER EL ID de productos
CREATE SEQUENCE seq_producto
START WITH 1
INCREMENT BY 1;
/

CREATE OR REPLACE PACKAGE BODY PKG_Producto AS
    PROCEDURE sp_inserta_producto(p_descripcion VARCHAR2, p_disponibilidad VARCHAR2, p_precio NUMBER) AS
    BEGIN
        INSERT INTO Producto (ID_Producto, Descripcion, Disponibilidad, Precio)
        VALUES (seq_producto.NEXTVAL, p_descripcion, p_disponibilidad, p_precio);
        
        DBMS_OUTPUT.PUT_LINE('Producto insertado satisfactoriamente');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al insertar el producto: ' || SQLERRM);
    END sp_inserta_producto;
    
    PROCEDURE sp_actualiza_producto(p_id_producto INT, p_descripcion VARCHAR2, p_disponibilidad VARCHAR2, p_precio NUMBER) AS
    BEGIN
        UPDATE Producto
        SET Descripcion = p_descripcion,
            Disponibilidad = p_disponibilidad,
            Precio = p_precio
        WHERE ID_Producto = p_id_producto;
        
        DBMS_OUTPUT.PUT_LINE('Producto actualizado satisfactoriamente');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró ningún producto con el ID proporcionado');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al actualizar el producto: ' || SQLERRM);
    END sp_actualiza_producto;
    
    PROCEDURE sp_elimina_producto(p_id_producto INT) AS
    BEGIN
        DELETE FROM Producto
        WHERE ID_Producto = p_id_producto;
        
        DBMS_OUTPUT.PUT_LINE('Producto eliminado satisfactoriamente');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró ningún producto con el ID proporcionado');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al eliminar el producto: ' || SQLERRM);
    END sp_elimina_producto;
END PKG_Producto;
/


-- Llamar al procedimiento sp_agregar_producto
BEGIN
    PKG_Producto.sp_inserta_producto('Sandwich', 'Disponible', 3500);
    PKG_Producto.sp_inserta_producto('Taco', 'Disponible', 2800);
    PKG_Producto.sp_inserta_producto('Chalupa', 'Disponible', 4000);
    PKG_Producto.sp_inserta_producto('Perro caliente', 'Disponible', 3900);
    PKG_Producto.sp_inserta_producto('Pizza personal', 'Disponible', 2500);
END;
/

--Llamar al procedimiento sp_actualiza_producto
BEGIN
    PKG_Producto.sp_actualiza_producto(1, 'Sandwich', 'Disponible', 4000);
END;
/

---Llamar al procedimiento sp_elimina_producto
BEGIN
    PKG_Producto.sp_elimina_producto(5);
END;
/    