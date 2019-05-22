--EJERCICIO 2
select puesto
from empleados;

select distinct empleados.nombre as "Nombre Empleado", empleados.CodigoEmpleado as "Código del Empleado",  
count(clientes.CodigoCliente) as "Clientes que atiende"
from empleados, clientes
where clientes.codigoempleadorepventas = empleados.codigoempleado
and initcap(empleados.Puesto)= 'Representante Ventas'
group by empleados.CodigoEmpleado, empleados.nombre
order by empleados.codigoempleado;

--EJERCICIO 3
--VERSIÓN 1

select distinct clientes.nombrecliente
from pedidos, clientes
where pedidos.codigocliente = clientes.codigocliente
and fechapedido between to_date('2008-01-01','YYYY-MM-DD') and to_date('2008-12-31''YYYY-MM-DD');

--VERSIÓN 2

SELECT NOMBRECLIENTE
FROM CLIENTES 
WHERE CODIGOCLIENTE IN (SELECT CODIGOCLIENTE
                        FROM PEDIDOS
                        WHERE EXTRACT(YEAR FROM FECHAPEDIDO)=2008);

--EJERCICIO 4
SELECT CIUDAD,NOMBRECLIENTE
FROM CLIENTES
WHERE CIUDAD IN(SELECT DISTINCT CIUDAD
                  FROM OFICINAS);
                  
--EJERCICIO 5
SELECT INITCAP(C.NOMBRECLIENTE), P.CANTIDAD
FROM PAGOS P, CLIENTES C
WHERE P.CODIGOCLIENTE = C.CODIGOCLIENTE
AND (CANTIDAD = (SELECT MAX(CANTIDAD)
                  FROM PAGOS)
OR CANTIDAD = (SELECT MIN(CANTIDAD)
                FROM PAGOS));

SELECT * FROM PAGOS;

--EJERCICIO 6
ALTER TABLE EMPLEADOS ADD SALARIO NUMBER(10);
ALTER TABLE EMPLEADOS ADD COMISION NUMBER(6);

--EJERCICIO 7
--VERSION 1
CREATE OR REPLACE PROCEDURE p7_salari_comi 
IS

BEGIN
      UPDATE EMPLEADOS SET SALARIO = 1100
          WHERE UPPER(PUESTO) = 'SECRETARIA';
      UPDATE EMPLEADOS SET SALARIO = 1500
          WHERE UPPER(PUESTO) = 'DIRECTOR OFICINA';
      UPDATE EMPLEADOS SET SALARIO = 1800
          WHERE UPPER(PUESTO) = 'SUBDIRECTOR MARKETING';
      UPDATE EMPLEADOS SET SALARIO = 1800
          WHERE UPPER(PUESTO) = 'SUBDIRECTOR VENTAS';
      UPDATE EMPLEADOS SET SALARIO = 1700
          WHERE UPPER(PUESTO) = 'REPRESENTANTE VENTAS';
      UPDATE EMPLEADOS SET SALARIO = 2200
          WHERE UPPER(PUESTO) = 'DIRECTOR GENERAL';
END;   

--VERSION 2
CREATE OR REPLACE PROCEDURE p7_salari_comi2
(P_PUESTO EMPLEADOS.PUESTO%TYPE)
IS
BEGIN
  CASE 
    WHEN P_PUESTO = 'SECRETARIA' THEN
      UPDATE EMPLEADOS SET SALARIO = 1100
      WHERE UPPER(puesto) = 'SECRETARIA';
    WHEN P_PUESTO = 'DIRECTOR OFICINA' THEN  
      UPDATE EMPLEADOS SET SALARIO = 1500
      WHERE UPPER(puesto) = 'DIRECTOR OFICINA';
    WHEN P_PUESTO ='SUBDIRECTOR MARKETING' THEN
      UPDATE EMPLEADOS SET SALARIO = 1800
      WHERE UPPER(puesto) = 'SUBDIRECTOR MARKETING';
    WHEN P_PUESTO ='SUBDIRECTOR VENTAS' THEN
      UPDATE EMPLEADOS SET SALARIO = 1800
      WHERE UPPER(puesto) = 'SUBDIRECTOR VENTAS';  
    WHEN P_PUESTO = 'REPRESENTANTE VENTAS' THEN
      UPDATE EMPLEADOS SET SALARIO = 1700
      WHERE UPPER(puesto) = 'REPRESENTANTE VENTAS';
    WHEN P_PUESTO = 'DIRECTOR GENERAL' THEN
      UPDATE EMPLEADOS SET SALARIO = 2200
      WHERE UPPER(puesto) = 'DIRECTOR GENERAL';
  END CASE;
END;

--

--EJERCICIO 8
ALTER TRIGGER sal_emp DISABLE;

CREATE OR REPLACE TRIGGER sal_emp
AFTER UPDATE OF SALARIO
  ON EMPLEADOS 
DECLARE
v_nombre_emp empleados.nombre%TYPE;
BEGIN 
      IF pack_sal_emp.v_all_col.salario > 3000 THEN
        UPDATE EMPLEADOS 
        SET COMISION = (0.02 * pack_sal_emp.v_all_col.salario)
        WHERE CodigoEmpleado = pack_sal_emp.v_all_col.codigoEmpleado;
      ELSE 
        UPDATE EMPLEADOS 
        SET COMISION = (0.05 * pack_sal_emp.v_all_col.salario)
        WHERE CodigoEmpleado = pack_sal_emp.v_all_col.codigoEmpleado;
        
      END IF;
END;   

---------------------------------
ALTER TRIGGER trigger_update_values DISABLE;
CREATE OR REPLACE TRIGGER trigger_update_values
AFTER UPDATE OF SALARIO ON EMPLEADOS
FOR EACH ROW
BEGIN
-- IF UPDATING THEN
  pack_sal_emp.v_all_col.salario := :new.salario;
  
  pack_sal_emp.v_all_col.codigoEmpleado := :old.CodigoEmpleado;
--END IF;
END; 



---------------------------------------------------------------
--VERSION 2
CREATE OR REPLACE TRIGGER trigger_update_insert_V2
AFTER INSERT OR UPDATE OF SALARIO ON EMPLEADOS
FOR EACH ROW
BEGIN
IF UPDATING THEN
  pack_sal_emp.v_all_col := :new.salario;
  pack_sal_emp.v_all_col_old := :old.salario;
  pack_sal_emp.v_cod_emple := :old.CodigoEmpleado;
ELSE 
  pack_sal_emp.v_all_col.CodigoEmpleado := :new.CodigoEmpleado;
  pack_sal_emp.v_all_col.Nombre := :new.Nombre;
  pack_sal_emp.v_all_col.Apellido1 := :new.Apellido1;
  pack_sal_emp.v_all_col.Apellido2 := :new.Apellido2 ;
  pack_sal_emp.v_all_col.Extension := :new.Extension;
  pack_sal_emp.v_all_col.Email := :new.Email;
  pack_sal_emp.v_all_col.CodigoOficina := :new.CodigoOficina;
  pack_sal_emp.v_all_col.CodigoJefe := :new.CodigoJefe;
  pack_sal_emp.v_all_col.Puesto := :new.Puesto;
  -- pack_sal_emp.v_all_col.Comision := :new.Comision; ES LO QUE SE VA A INSERTAR O CAMBIAR
  pack_sal_emp.v_all_col.Salario := :new.Salario;
  
END IF;
END; 

-----------------------------------  

CREATE OR REPLACE TRIGGER sal_emp_V2
AFTER INSERT OR UPDATE OF SALARIO
  ON EMPLEADOS 
DECLARE
v_nombre_emp empleados.nombre%TYPE;
BEGIN 

      IF pack_sal_emp.v_salario_nuevo > 3000 THEN
        UPDATE EMPLEADOS 
        SET COMISION = (0.02 * pack_sal_emp.v_all_col)
        WHERE CodigoEmpleado = pack_sal_emp.v_cod_emple;
      ELSE 
        UPDATE EMPLEADOS 
        SET COMISION = (0.05 * pack_sal_emp.v_all_col)
        WHERE CodigoEmpleado = pack_sal_emp.v_cod_emple;
        
      END IF;
END; 


UPDATE EMPLEADOS SET SALARIO = 2000
WHERE CodigoEmpleado = 1;

DELETE FROM EMPLEADOS WHERE CODIGOEMPLEADO = 33; 
INSERT INTO empleados VALUES (33,'Naia','Joestar','Speedwagon','2442','naia.joestar@gmail.com','TAL-ES',2,'Representante Ventas',5000,null);
INSERT INTO empleados VALUES (36,'JulenCani','Joestar','Speedwagon','2442','naia.joestar@gmail.com','TAL-ES',3,'Representante Ventas',5000,null);
ROLLBACK;

SELECT * FROM EMPLEADOS;

SELECT * FROM EMPLEADOS; 

desc empleados;

--------------------------------------------------------
DROP TRIGGER tri_bor_ofic;

CREATE OR REPLACE TRIGGER TRI_BOR_OFICI
BEFORE DELETE ON OFICINAS
FOR EACH ROW

  BEGIN
        UPDATE EMPLEADOS
        SET CODIGOOFICINA = 'SIN'
        WHERE UPPER(CODIGOOFICINA) = UPPER(:OLD.COGIDOOFICINA);
  END;
        

