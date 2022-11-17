create database Tienda
use Tienda

create table cliente(
id_cliente int primary key identity (1,1),
nombre varchar(30) not null,
ciudad varchar(30) not null,
estado varchar(30),
pais varchar(30)
)

create table ventas(
id_venta int primary key identity (1,1),
fecha datetime not null,
subtotal money,
iva int,
total money,
estatus varchar(10) check(estatus in('Pagada','Cancelada')),
forma_pago varchar(15) check(forma_pago in('Tarjeta Credito', 'Vales', 'Tarjeta Debito', 'Efectivo', 'Sin Pago')),
id_cliente int,
foreign key(id_cliente) references cliente(id_cliente) on delete cascade on update cascade
)

create table producto(
id_producto int primary key identity (1,1),
nombre VarChar(max),
marca varchar(max),
modelo varchar(max),
categoria varchar(max),
precio int
)

create table item(
precio money,
cantidad int not null,
importe int,
id_venta int,
id_producto int,
foreign key(id_venta) references ventas(id_venta) on delete cascade on update cascade,
foreign key (id_producto) references producto(id_producto) on delete cascade on update cascade
)

select * from cliente
select * from ventas
select * from producto
select * from item

-- - crear un Procedimiento Almacenado que permita obtener los precios de la tabla Productos de acuerdo con su ID y agregarlo en la tabla Items y al mismo tiempo
-- - calcule el importe de acuerdo con la cantidad contenida en cada registro de Items
go
create procedure obtenerprecio
as
begin
select producto.precio,producto.id_producto from producto join item on producto.id_producto = item.id_producto
update item set item.precio = producto.precio from producto where item.id_producto = producto.id_producto
update item set item.importe = precio * 1.16
end

exec obtenerprecio

-- - Crear un segundo procedimiento almacenado que calcule el subtotal, IVA y Total de cada una de las ventas que contiene la tabla Ventas.
-- - Considerando que el monto del IVA es el 16% del subtotal.
go
create procedure precioimporte
as
begin
update ventas set ventas.subtotal = item.importe from item where ventas.id_cliente = item.id_venta
update ventas set ventas.iva = 16
update ventas set total = subtotal * 1.16
end

exec precioimporte

-- - Crear una Vista que muestre los datos de cada cliente y la cantidad de ventas que pertenecen a cada uno de los clientes.
go
create view datoscliente_venta
as
select nombre,ciudad,estado,pais,ventas.id_cliente, count(ventas.id_cliente) as compras from ventas,cliente where ventas.id_cliente = cliente.id_cliente
group by nombre,ciudad,estado,pais,ventas.id_cliente

select * from datoscliente_venta

-- - Crear una Vista que muestre los datos de los productos y la cantidad de ventas en las que aparece cada uno de los productos.
go
create view datosproducto_venta
as
select nombre,marca,modelo,categoria,producto.id_producto, count(ventas.id_cliente) as ventas from ventas,producto where ventas.id_cliente = producto.id_producto
group by nombre,marca,modelo,categoria,producto.id_producto,ventas.id_cliente

select * from datosproducto_venta

-- - Crear una consulta que muestre los 5 productos más vendidos.
go
create view top_vendidos
as
select top 5 nombre,marca,modelo,categoria,producto.id_producto, count(ventas.id_cliente) as ventas from ventas,producto where ventas.id_cliente = producto.id_producto
group by nombre,marca,modelo,categoria,producto.id_producto,ventas.id_cliente
order by ventas desc

select * from top_vendidos