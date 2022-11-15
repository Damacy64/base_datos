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

-- - 