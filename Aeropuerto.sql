-- - creamos la base de datos "aeropuerto"
create database aeropuerto
use aeropuerto

-- - creamos las distintas tablas que contrenda la BD
create table Pasajeros(
id_pasajero int primary key identity(1,1),
nombre varchar(30),
apellido_m varchar(30),
apellido_p varchar(30),
edad int,
genero varchar(9) check (genero in ('Masculino', 'Femenino')),
telefono varchar(10),
correo varchar(30),
pasaporte varchar(30),
nacimiento date
)

create table Pilotos(
id_piloto int primary key identity(1,1),
nombre varchar(30),
apellido varchar(30),
edad int,
genero varchar(9) check (genero in ('Masculino', 'Femenino')),
cedula varchar(8)
)

create table Vuelos(
folio int primary key identity (1,1),
pais_o varchar(20),
pais_d varchar(20),
num_pasajeros int,
fecha_salida datetime,
fecha_llegada datetime,
aeropuerto_o varchar (30),
aeropuerto_d varchar (30),
precio money,
id_piloto int,
foreign key (id_piloto) references Pilotos(id_piloto) on delete cascade on update cascade
)

create table Tickets(
num_ticket int primary key identity (1,1),
id_pasajero int,
folio int,
foreign key (id_pasajero) references Pasajeros(id_pasajero) on delete cascade on update cascade,
foreign key (folio) references Vuelos(folio) on delete cascade on update cascade
)

-- - insertamos los datos de prueba
-- - Pasajeros
INSERT INTO Pasajeros(nombre,apellido_p,genero,pasaporte) VALUES('Diego','Martinez','Masculino','E12345A')
INSERT INTO Pasajeros(nombre,apellido_p,genero,pasaporte) VALUES('David','Saldaña','Masculino','A234874D')
INSERT INTO Pasajeros(nombre,apellido_p,genero,pasaporte) VALUES('Javier','Lopez','Masculino','C1678426F')
INSERT INTO Pasajeros(nombre,apellido_p,genero,pasaporte) VALUES('Salvador','Sandoval','Masculino','G9875641K')
INSERT INTO Pasajeros(nombre,apellido_p,genero,pasaporte) VALUES('Brenda','Lobaton','Femenino','P2367519T')
-- - Pilotos
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Juan', 'Pérez', 'Masculino', '12345678')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('María', 'González', 'Femenino', '23456789')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Carlos', 'López', 'Masculino', '34567890')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Ana', 'Martínez', 'Femenino', '45678901')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Pedro', 'Sánchez', 'Masculino', '56789012')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Laura', 'Díaz', 'Femenino', '67890123')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Miguel', 'Rodríguez', 'Masculino', '78901256')
INSERT INTO Pilotos(nombre,apellido,genero,cedula) VALUES ('Sofía', 'López', 'Femenino', '89012345')
-- - Vuelos
INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('Estados Unidos', 'Francia', '2024-04-20 08:00:00', '2024-04-21 12:00:00', 'JFK', 'CDG', 500,1)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('España', 'Italia', '2024-04-22 10:00:00', '2024-04-23 14:00:00', 'MAD', 'FCO', 300,2)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('Alemania', 'Reino Unido', '2024-04-24 12:00:00', '2024-04-25 16:00:00', 'FRA', 'LHR', 250,3)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('Japón', 'Australia', '2024-04-26 14:00:00', '2024-04-27 18:00:00', 'NRT', 'SYD', 800,4)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('Brasil', 'Argentina', '2024-04-28 16:00:00', '2024-04-29 20:00:00', 'GRU', 'EZE', 200,5)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('Canadá', 'México', '2024-04-30 18:00:00', '2024-05-01 22:00:00', 'YYZ', 'MEX', 400,6)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('China', 'India', '2024-05-02 20:00:00', '2024-05-03 00:00:00', 'PEK', 'DEL', 600,7)

INSERT INTO Vuelos (pais_o, pais_d, fecha_salida, fecha_llegada, aeropuerto_o, aeropuerto_d, precio,id_piloto) 
VALUES ('Rusia', 'Sudáfrica', '2024-05-04 22:00:00', '2024-05-05 02:00:00', 'SVO', 'JNB', 700,8)
-- - Tickets
INSERT INTO Tickets (id_pasajero,folio) VALUES (1,1)
INSERT INTO Tickets (id_pasajero,folio) VALUES (2,1)
INSERT INTO Tickets (id_pasajero,folio) VALUES (3,5)

-- -Mostramos resultados de las tablas
SELECT * FROM Pasajeros
SELECT * FROM Pilotos
SELECT * FROM Vuelos
SELECT * FROM Tickets