---M�dulo compras-----

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

---secuencia para el id del pedido
CREATE SEQUENCE SEQ_PEDIDO
START WITH 1
INCREMENT BY 1;
/



CREATE OR REPLACE PROCEDURE sp_REALIZAR_PEDIDO (
    p_Estado_Pedido IN PEDIDO.Estado_Pedido%TYPE,
    p_Monto_Total IN PEDIDO.Monto_Total%TYPE,
    p_Fecha IN PEDIDO.Fecha%TYPE,
    p_ID_Cliente IN PEDIDO.ID_Cliente%TYPE,
    p_ID_Empleado IN PEDIDO.ID_Empleado%TYPE
)
AS
BEGIN
    -- Insertar el pedido
    INSERT INTO PEDIDO (ID_Pedido, Estado_Pedido, Monto_Total, Fecha, ID_Cliente, ID_Empleado)
    VALUES (SEQ_PEDIDO.NEXTVAL, p_Estado_Pedido, p_Monto_Total, p_Fecha, p_ID_Cliente, p_ID_Empleado);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido insertado satisfactoriamente');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: ID de pedido duplicado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar el pedido: ' || SQLERRM);
END sp_REALIZAR_PEDIDO;
/

-- Invocar el procedimiento almacenado con valores de ejemplo
EXEC sp_REALIZAR_PEDIDO('Activo', 2000, SYSDATE, 101, 1);
EXEC sp_REALIZAR_PEDIDO('Activo', 3000, SYSDATE, 102, 3);




--secuencia para el id de la tabla pedido_producto
CREATE SEQUENCE SEQ_Pedido_Producto
START WITH 1
INCREMENT BY 1;
/


---procedimiento para relacionar los pedidos con los productos que compr�
CREATE OR REPLACE PROCEDURE sp_producto_pedido(
p_ID_Pedido IN PEDIDO_PRODUCTO.ID_Pedido%TYPE,
p_ID_Producto IN PEDIDO_PRODUCTO.ID_Pedido%TYPE,
p_Cantidad IN PEDIDO_PRODUCTO.Cantidad%TYPE )
AS
BEGIN
    -- Insertar el producto y la cantidad
    INSERT INTO PEDIDO_PRODUCTO (Id_Pedido_Producto, ID_Pedido, ID_Producto, Cantidad)
    VALUES (SEQ_Pedido_Producto.NEXTVAL, p_ID_Pedido, p_ID_Producto, p_Cantidad);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido insertado satisfactoriamente');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: ID de la compra est� repetido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar los productos del pedido: ' || SQLERRM);
END sp_producto_pedido;
/
EXEC sp_producto_pedido(1, 1, 2);
/



select * from producto;
select * from pedido;
select * from cliente;
select * from empleado;
