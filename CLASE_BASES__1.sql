CREATE OR REPLACE PACKAGE pack_sal_emp IS 
v_salario_nuevo empleados.salario%TYPE := null;
v_salario_viejo empleados.salario%TYPE := null;
v_cod_emple empleados.CodigoEmpleado%TYPE := null;
v_all_col empleados%ROWTYPE := NULL;

END;


