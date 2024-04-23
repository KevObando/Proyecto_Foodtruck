---Módulo compras-----
SET SERVEROUTPUT ON

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

--secuencia para el id del pedido
CREATE SEQUENCE SEQ_PEDIDO
START WITH 1
INCREMENT BY 1;

--secuencia para el id de la tabla pedido_producto
CREATE SEQUENCE SEQ_Pedido_Producto
START WITH 1
INCREMENT BY 1;

-- Función para calcular el monto total
CREATE OR REPLACE FUNCTION calcular_monto_total(p_ID_Pedido IN INT)
RETURN NUMBER
AS
    v_total NUMBER(10, 2);
BEGIN
    SELECT SUM(pp.Cantidad * pr.Precio)
    INTO v_total
    FROM PEDIDO_PRODUCTO pp
    INNER JOIN PRODUCTO pr ON pp.ID_Producto = pr.ID_Producto
    WHERE pp.ID_Pedido = p_ID_Pedido;
    
    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
END calcular_monto_total;

---procedimiento para relacionar los pedidos con los productos que compró
CREATE OR REPLACE PROCEDURE sp_producto_pedido(
    p_ID_Pedido IN PEDIDO_PRODUCTO.ID_Pedido%TYPE,
    p_ID_Producto IN PEDIDO_PRODUCTO.ID_Producto%TYPE,
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
        DBMS_OUTPUT.PUT_LINE('Error: ID de la compra está repetido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar los productos del pedido: ' || SQLERRM);
END sp_producto_pedido;

--Procedimiento almacenado para la realización de pedidos
CREATE OR REPLACE PROCEDURE sp_REALIZAR_PEDIDO (
    p_Estado_Pedido IN PEDIDO.Estado_Pedido%TYPE,
    p_Fecha IN PEDIDO.Fecha%TYPE,
    p_ID_Cliente IN PEDIDO.ID_Cliente%TYPE,
    p_ID_Empleado IN PEDIDO.ID_Empleado%TYPE
)
AS
    v_monto number;
    idPedi int;
BEGIN
    -- Insertar el pedido
    idPedi:= SEQ_PEDIDO.NEXTVAL;
    
    --calcular el valor del monto del pedido
    v_monto:= calcular_monto_total(idPedi);
    
    INSERT INTO PEDIDO (ID_Pedido, Estado_Pedido, Monto_total, Fecha, ID_Cliente, ID_Empleado)
    VALUES (idPedi, p_Estado_Pedido, v_monto, p_Fecha, p_ID_Cliente, p_ID_Empleado);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido insertado satisfactoriamente');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: ID de pedido duplicado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar el pedido: ' || SQLERRM);
END sp_REALIZAR_PEDIDO;


exec sp_REALIZAR_PEDIDO('En proceso', sysdate, 101, 1);


/
CREATE OR REPLACE VIEW vista_pedido AS
SELECT 
    ID_Pedido,
    Estado_Pedido,
    Monto_total,
    Fecha,
    ID_Cliente,
    ID_Empleado
FROM PEDIDO;
