DROP DATABASE IF EXISTS Tienda_Manga;
CREATE DATABASE Tienda_Manga CHARACTER SET utf8mb4;
USE Tienda_Manga;
 
CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_autor VARCHAR(255) NOT NULL
);
 
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT
);
 
CREATE TABLE manga (
    id_manga INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    categoria VARCHAR(20),
    autor_id INT,
    FOREIGN KEY (autor_id) REFERENCES autor(id_autor)
);
 
CREATE TABLE venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);
 
CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_manga INT NOT NULL,
    cantidad INT NOT NULL,
    descuento DECIMAL(4,2),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    FOREIGN KEY (id_manga) REFERENCES manga(id_manga)
);
 
DELIMITER //
 
CREATE PROCEDURE insertar_autor(IN nombre_aut VARCHAR(255))
BEGIN
  IF nombre_aut = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nombre del autor es obligatorio';
  ELSE
    INSERT INTO autor(nombre_autor) VALUES (nombre_aut);
  END IF;
END;
//
 
CREATE PROCEDURE insertar_cliente(
  IN nom VARCHAR(100),
  IN ape VARCHAR(100),
  IN correo VARCHAR(255),
  IN tel VARCHAR(20),
  IN dir TEXT
)
BEGIN
  IF nom = '' OR ape = '' OR correo = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nombre, apellido y correo son obligatorios';
  ELSE
    INSERT INTO cliente(nombre, apellido, email, telefono, direccion)
    VALUES (nom, ape, correo, tel, dir);
  END IF;
END;
//
 
CREATE PROCEDURE insertar_manga(
  IN titulo VARCHAR(255),
  IN precio DECIMAL(10,2),
  IN stock INT,
  IN autor INT
)
BEGIN
  DECLARE cat VARCHAR(20);
  IF precio < 5 THEN SET cat = 'bajo';
  ELSEIF precio BETWEEN 5 AND 10 THEN SET cat = 'medio';
  ELSE SET cat = 'caro';
  END IF;
 
  INSERT INTO manga(titulo, precio, stock, categoria, autor_id)
  VALUES (titulo, precio, stock, cat, autor);
END;
//
 
CREATE PROCEDURE insertar_venta(
  IN cliente INT,
  IN manga INT,
  IN cantidad INT,
  IN fecha_compra DATETIME
)
BEGIN
  DECLARE descu DECIMAL(4,2);
  IF cantidad BETWEEN 3 AND 4 THEN SET descu = 0.05;
  ELSEIF cantidad > 4 THEN SET descu = 0.10;
  ELSE SET descu = 0.00;
  END IF;
 
  INSERT INTO venta(id_cliente, fecha) VALUES (cliente, fecha_compra);
  SET @idv := LAST_INSERT_ID();
 
  INSERT INTO detalle_venta(id_venta, id_manga, cantidad, descuento)
  VALUES (@idv, manga, cantidad, descu);
END;
//
 
DELIMITER ;
 
-- Autores
CALL insertar_autor('Eiichiro Oda');
CALL insertar_autor('Atsushi Ohkubo');
CALL insertar_autor('Hajime Isayama');
CALL insertar_autor('Masashi Kishimoto');
CALL insertar_autor('Koyoharu Gotouge');
 
-- Clientes
CALL insertar_cliente('Juan', 'Pérez', 'juan.perez@email.com', '1234567890', 'Calle Ficticia 123, Ciudad, País');
CALL insertar_cliente('Maria', 'Orozco', 'maria.orozco@email.com', '1234567890', 'Manzana azul 13, Ciudad, País');
CALL insertar_cliente('Luis', 'Torres', 'luis.torres@email.com', '1122334455', 'Av. Central 45, Ciudad, País');
 
-- Mangas
CALL insertar_manga('One Piece', 15.00, 100, 1);
CALL insertar_manga('Fire Force', 10.00, 80, 2);
CALL insertar_manga('Attack on Titan', 12.75, 60, 3);
CALL insertar_manga('Naruto', 8.25, 90, 4);
CALL insertar_manga('Demon Slayer', 14.00, 70, 5);
 
-- Ventas con fechas distintas y hora
CALL insertar_venta(1, 1, 1, '2025-09-10 10:15:00'); -- Juan compra One Piece
CALL insertar_venta(2, 2, 2, '2025-09-11 14:30:00'); -- Maria compra Fire Force
CALL insertar_venta(3, 3, 3, '2025-09-12 09:45:00'); -- Luis compra Attack on Titan
CALL insertar_venta(1, 4, 4, '2025-09-13 16:00:00'); -- Juan compra Naruto
CALL insertar_venta(2, 5, 5, '2025-09-14 18:20:00'); -- Maria compra Demon Slayer
 
SELECT id_cliente,
       CONCAT(nombre, ' ', apellido) AS nombre_completo,
       email, telefono, direccion
FROM cliente;
 
SELECT m.id_manga, m.titulo, m.precio, m.stock, m.categoria, a.nombre_autor AS autor
FROM manga m, autor a
WHERE m.autor_id = a.id_autor;
 
SELECT v.id_venta,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       m.titulo AS manga,
       dv.cantidad,
       dv.descuento
FROM detalle_venta dv, venta v, cliente c, manga m
WHERE dv.id_venta = v.id_venta
  AND v.id_cliente = c.id_cliente
  AND dv.id_manga = m.id_manga;
  SELECT v.id_venta,
       DATE_FORMAT(v.fecha, '%Y-%m-%d %H:%i') AS fecha_hora,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       m.titulo AS manga
FROM venta v, cliente c, detalle_venta dv, manga m
WHERE v.id_cliente = c.id_cliente
  AND dv.id_venta = v.id_venta
  AND dv.id_manga = m.id_manga;