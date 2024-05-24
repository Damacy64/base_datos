create database banco
use banco

create table cliente(
rfc varchar(13) primary key,
nombre varchar(25)not null,
ciudad varchar(25)not null
)

create table cuenta(
no_cuenta int primary key identity (1,1),
tipo varchar(7) check (tipo in ('Ahorro','Cheques')),
saldo money default(0) check(saldo >=0),
rfc varchar(13),
foreign key (rfc) references cliente(rfc) on delete cascade on update cascade
)

create table movimiento(
id_movimiento int primary key identity(1,1),
fecha datetime not null,
monto money not null,
no_cuenta int,
foreign key(no_cuenta) references cuenta(no_cuenta) on delete cascade on update cascade
)
--insertamos datos en la tabla cliente
insert into cliente values ('ABC123','Adriana Batiz','CDMX')
insert into cliente values ('BCD234','Beatriz Cardenas','Queretaro')
insert into cliente values ('CDE345','Carlos Diaz','Guadalajara')
insert into cliente values ('EFG567','Elena Robles','Merida')
insert into cliente values ('FGH678','Fabiola Gonzalez','Queretaro')
insert into cliente values ('DEF456','Miguel Huerta','CDMX')

--insertamos datos en la tabla cuenta
insert into cuenta(tipo,rfc) values ('Ahorro','ABC123')
insert into cuenta(tipo,rfc) values ('Cheques','ABC123')
insert into cuenta(tipo,rfc) values ('Ahorro','BCD234')
insert into cuenta(tipo,rfc) values ('Cheques','CDE345')
insert into cuenta(tipo,rfc) values ('Ahorro','CDE345')
insert into cuenta(tipo,rfc) values ('Ahorro','DEF456')
insert into cuenta(tipo,rfc) values ('Ahorro','EFG567')
insert into cuenta(tipo,rfc) values ('Cheques','ABC123')

select * from cliente
select * from cuenta
select * from movimiento

--deposito de 1000 en la cuenta 1 del cliente ABC123
insert into movimiento(fecha,monto,no_cuenta)
values(GETDATE(),1000,1)

update cuenta set saldo = saldo + 1000 where no_cuenta=1

--deposito de 3500 en la cuenta 1
insert into movimiento(fecha,monto,no_cuenta)
values(GETDATE(),3500,1)

update cuenta set saldo = saldo + 3500 where no_cuenta=1

--retiro de 2300 en la cuenta 1
insert into movimiento(fecha,monto,no_cuenta)
values(GETDATE(),-2300,1)

update cuenta set saldo = saldo - 2300 where no_cuenta=1
--creamos un trigger para actualizar el saldo
create trigger tr_actSaldo on movimiento after insert
as
begin transaction
begin try
	declare @noCuenta int, @monto money
	select @noCuenta = no_cuenta, @monto = monto from inserted

	update cuenta SET saldo = saldo + @monto where no_cuenta = @noCuenta
	commit
end try
begin catch
	rollback
end catch
--creamos un procedimiento almacenado para el retiro
create procedure sp_movimiento @noCuenta int, @monto money
as
begin transaction
begin try
	insert into movimiento(fecha, monto, no_cuenta)
	values (getDate(), @monto, @noCuenta)
	commit
end try
begin catch
	rollback
end catch
--------------------------------------------------------------------
-- Deposito a la cuenta 2 de 5,000
exec sp_movimiento 2, 5000
-- Deposito de 2000 a la cuenta 2
exec sp_movimiento 2, 2000
-- Retiro de 3500 en la cuenta 2
exec sp_movimiento 2, -3500
-- Retiro de 4000 en la cuenta 2
exec sp_movimiento 2, -4000
-- Crear un procedimiento que permita realizar transferencias
create procedure sp_transferir @noCuentaO int, @noCuentaD int, @monto money
as
begin transaction
begin try
	-- Retiro en la cuenta de origen
	insert into movimiento(fecha, monto, no_cuenta)
	values(GETDATE(), @monto * -1, @noCuentaO)
	-- Deposito en la cuenta destino
	insert into movimiento(fecha, monto, no_cuenta)
	values(GETDATE(), @monto, @noCuentaD)
	commit
end try
begin catch
	rollback
end catch
---------------------------------------
exec sp_transferir 2, 1, 500

exec sp_transferir  2, 1, 4000