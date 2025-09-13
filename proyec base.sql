CREATE DATABASE tienda_manga;
USE tienda_manga;
CREATE TABLE manga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255),
    editorial VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    descripcion TEXT,
    fecha_lanzamiento DATE
);
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT
);
CREATE TABLE venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);
CREATE TABLE detalle_venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT,
    manga_id INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES venta(id),
    FOREIGN KEY (manga_id) REFERENCES manga(id)
);
CREATE TABLE autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    biografia TEXT
);
CREATE TABLE editoriales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT
);
ALTER TABLE manga ADD COLUMN autor_id INT;
ALTER TABLE manga ADD COLUMN editorial_id INT;

ALTER TABLE manga
    ADD CONSTRAINT fk_autor FOREIGN KEY (autor_id) REFERENCES autores(id),
    ADD CONSTRAINT fk_editorial FOREIGN KEY (editorial_id) REFERENCES editoriales(id);
  
INSERT INTO manga (titulo, autor, editorial, precio, stock, descripcion, fecha_lanzamiento)
VALUES ('One Piece', 'Eiichiro Oda', 'Shueisha', 10.99, 100, 'Un manga épico de aventuras en el mar.', '1997-07-22');

INSERT INTO cliente (nombre, apellido, email, telefono, direccion)
VALUES ('Juan', 'Pérez', 'juan.perez@email.com', '1234567890', 'Calle Ficticia 123, Ciudad, País');

INSERT INTO venta (cliente_id, fecha, total)
VALUES (1, '2025-09-11', 10.99);

INSERT INTO detalle_venta (venta_id, manga_id, cantidad, precio_unitario, subtotal)
VALUES (1, 1, 1, 10.99, 10.99);

select * from cliente;

INSERT INTO manga (titulo, autor, editorial, precio, stock, descripcion, fecha_lanzamiento)
VALUES ('Fire Force', 'Atsushi Ohkubo', 'Shueisha', 10.99, 100, 'Un manga épico basado en infernales.', '1997-07-22');

INSERT INTO cliente (nombre, apellido, email, telefono, direccion)
VALUES ('Maria', 'Orozco', 'Maria.Orozco@email.com', '1234567890', 'Manzana azul 13, Ciudad, País');

INSERT INTO venta (cliente_id, fecha, total)
VALUES (1, '2025-10-11', 10.99);

INSERT INTO detalle_venta (venta_id, manga_id, cantidad, precio_unitario, subtotal)
VALUES (1, 1, 1, 10.99, 10.99);

select * from cliente;


