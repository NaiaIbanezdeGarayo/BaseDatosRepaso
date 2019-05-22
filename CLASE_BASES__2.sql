/*EJERCICIO 1*/

CREATE OR REPLACE PROCEDURE num_emple_oficio_2
( p_oficio emple.oficio%TYPE,
  p_cursor OUT SYS_REFCURSOR,
  p_estado OUT VARCHAR2)
AS
  V_ERROR VARCHAR2(250);
  
BEGIN
IF nmax_oficio(p_oficio) > 5
  THEN
    p_estado :='MAS de 5 empleados';
    ELSIF nmax_oficio(p_oficio) IS NULL
    THEN
      p_estado:='No hay empleados con ese oficio';
    END IF;
    OPEN p_cursor FOR
          SELECT dept_no,dnombre
          FROM depart
          WHERE dept_no IN(SELECT dept_no
                            FROM emple
                            WHERE UPPER(OFICIO)=UPPER(p_oficio)
                            GROUP BY dept_no
                            HAVING COUNT(*)=nmax_oficio(p_oficio));
EXCEPTION
    WHEN OTHERS THEN
    NULL;
END num_emple_oficio_2;
---------------
DECLARE
     p_departamentos SYS_REFCURSOR;
     p_dept_no depart.dept_no%TYPE;
     p_dnombre depart.dnombre%TYPE;
     p_estado VARCHAR2 (100);
BEGIN
  NUM_EMPLE_OFICIO_2 ('programador',p_departamentos, p_estado);
  FETCH p_departamentos INTO v_dept_no,v_dnombre;
  IF p_departamentos%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE(p_estado);
  ELSE
  WHILE p_departamentos%FOUND LOOP
    dbms_output.put_line('El departamento ' ||to_char(v_dept_no) || ' '|| v_dnombre||
    ' tiene ' ||to_char(nmax_oficio('programados'))|| ' empleados ' ||p_estado);
    FETCH p_departamentos INTO v_dept_no, v_dnombre;
  END LOOP;
  END IF;
END;  
