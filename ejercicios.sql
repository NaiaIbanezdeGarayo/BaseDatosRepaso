/*2. Consultar el código de empleado y el número de clientes al que atiende 
cada empleado que es representante de ventas. Las cabeceras serán respectivamente
“Código del Empleado” y “Clientes que atiende”.
Modifica la consulta de tal forma que todos los representantes de ventas tienen que salir,
incluidpos quellos que no atienden a ningun cliente*/
select puesto
from empleados;

select distinct empleados.nombre as "Nombre Empleado", empleados.CodigoEmpleado as "Código del Empleado",  
count(clientes.CodigoCliente) as "Clientes que atiende"
from empleados, clientes
where clientes.codigoempleadorepventas = empleados.codigoempleado
and initcap(empleados.Puesto)= 'Representante Ventas'
group by empleados.CodigoEmpleado, empleados.nombre
order by empleados.codigoempleado;

/*3.-Listar el nombre de los clientes que hayan hecho pedidos en 2008.*/
select distinct clientes.nombrecliente
from pedidos, clientes
where pedidos.codigocliente = clientes.codigocliente
and fechapedido between to_date('2008-01-01') and to_date('2008-12-31');

/*4.-Visualizar los clientes que residan en la misma ciudad donde hay una oficina,
indicando dónde está la oficina.*/
select initcap(clientes.NombreCliente), oficinas.ciudad
from clientes, oficinas
where clientes.ciudad = oficinas.ciudad;

/*5.- Sacar cuál fue el cliente que hizo el pago con mayor cuantía y el que hizo el pago con menor cuantía.*/
select distinct Clientes.nombrecliente, max(pagos.cantidad) as "Pago Maximo" , min(pagos.cantidad) as "Pago minimo"
from clientes, pagos
where clientes.codigocliente = pagos.codigocliente
group by clientes.nombrecliente;