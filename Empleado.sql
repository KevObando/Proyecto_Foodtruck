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


