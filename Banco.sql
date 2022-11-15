create database banco_5502
use banco_5502

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

insert into cliente values ('ABC123','Adriana Batiz','CDMX')
insert into cliente values ('BCD234','Beatriz Cardenas','Queretaro')
insert into cliente values ('CDE345','Carlos Diaz','Guadalajara')
insert into cliente values ('EFG567','Elena Robles','Merida')
insert into cliente values ('FGH678','Fabiola Gonzalez','Queretaro')
insert into cliente values ('DEF456','Miguel Huerta','CDMX')


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

--retiro de 3000 en la cuneta 1

BEGIN TRANSACTION
BEGIN TRY
     insert into movimiento(fecha,monto,no_cuenta)
     values('2021-18-07',-3000,1)

     update cuenta set saldo = saldo - 3000 where no_cuenta=1
	 COMMIT
END TRY
BEGIN CATCH
     ROLLBACK
END CATCH
----------------------------------------------------------------------
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
------------------------------------------------------------------------
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
select * from cuenta
select * from movimiento
-- Deposito a la cuenta 2 de 5,000
exec sp_movimiento 2, 5000

-- Deposito de 2000 a la cuenta 2
exec sp_movimiento 2, 2000

-- Retiro de 3500 en la cuenta 2
exec sp_movimiento 2, -3500

-- Retiro de 4000 en la cuenta 2
exec sp_movimiento 2, -4000

------------------------------------------------------------------
-- Crear un procedimiento que permita realizar transferencias
-- desde una cuenta de origen a una cuenta destino
-- exec sp_transferir 2, 1, 500
------------------------------------------------------------------
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
-------------------------------------------------------------------
select * from cuenta
select * from movimiento

exec sp_transferir 2, 1, 500

exec sp_transferir  2, 1, 4000
-------------------------------------
-- Crear un procedimiento para crear cuentas nuevas
-- exec sp_crearCuenta 'ASD123', 'Adriana Zedillo', 'Monterrey', 'Ahorro', 2500
-- Se crea una cuenta nueva para un cliente que puede o no ya estar registrado

create procedure sp_crearCuenta @rfc varchar(13), @nombre varchar(25), @ciudad varchar(25), @tipo varchar(7), @monto money
as
begin transaction
begin try
	if not exists (select * from cliente where rfc = @rfc)
	begin
		insert into cliente values(@rfc, @nombre, @ciudad)
	end
	insert into cuenta (tipo, rfc) values (@tipo, @rfc)
	declare @noCuenta int
	select @noCuenta = @@IDENTITY
	insert into movimiento(fecha, monto, no_cuenta)
	values(GETDATE(), @monto, @noCuenta)
	commit
end try
begin catch
	rollback
end catch
-------------------------------------------------------------------------------------------------
exec sp_crearCuenta 'ASD123', 'Adriana Zedillo', 'Monterrey', 'Ahorro', 2500