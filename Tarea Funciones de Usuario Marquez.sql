CREATE DATABASE Funciones;
USE Funciones;

# Tablas Necesarias

CREATE TABLE Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    Existencia INT NOT NULL
);
CREATE TABLE Ordenes (
    OrdenID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT,
    Cantidad INT NOT NULL,
    Fecha DATE NOT NULL,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL
);
CREATE TABLE Transacciones (
    TransaccionID INT AUTO_INCREMENT PRIMARY KEY,
    CuentaID INT NOT NULL,
    TipoTransaccion ENUM('deposito', 'retiro') NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    Fecha DATE NOT NULL
);

# Inserción de Datos

-- Ejercicio 1: CalcularTotalOrden
-- Insertar productos
INSERT INTO Productos (Nombre, Precio, Existencia) VALUES
('Producto A', 100.00, 50),
('Producto B', 200.00, 30),
('Producto C', 150.00, 20);

-- Insertar orden
INSERT INTO Ordenes (ProductoID, Cantidad, Fecha) VALUES
(1, 2, '2025-01-06'),
(2, 1, '2025-01-06'),
(3, 3, '2025-01-06');

-- Ejercicio 2: CalcularEdad
-- Insertar cliente
INSERT INTO Clientes (Nombre, FechaNacimiento) VALUES
('Juan Pérez', '1990-05-15'),
('María Gómez', '1985-10-25');

-- Ejercicio 4: CalcularSaldo
-- Insertar transacciones
INSERT INTO Transacciones (CuentaID, TipoTransaccion, Monto, Fecha) VALUES
(1, 'deposito', 500.00, '2025-01-06'),
(1, 'retiro', 100.00, '2025-01-07'),
(1, 'deposito', 200.00, '2025-01-08'),
(2, 'retiro', 50.00, '2025-01-06'),
(2, 'deposito', 300.00, '2025-01-07');

# Ejercicio 1: CalcularTotalOrden
DELIMITER $$
CREATE FUNCTION CalcularTotalOrden2(id_orden INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    DECLARE iva DECIMAL(10, 2);
    SET iva = 0.15;
    SELECT SUM(P.precio * O.cantidad) INTO total
    FROM Ordenes O
    JOIN Productos P ON O.ProductoID = P.ProductoID 
    WHERE O.OrdenID = id_orden;
    IF total IS NULL THEN
        SET total = 0;
    END IF;
    SET total = total + (total * iva);
    RETURN total;
END $$
DELIMITER ;


# Ejercicio 2: CalcularEdad

DELIMITER $$

CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE)
RETURNS INT
DETERMINISTIC 
BEGIN 
    DECLARE edad INT;
    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    RETURN edad;
END $$
DELIMITER ;

# Ejercicio 3: VerificarStock

DELIMITER $$
CREATE FUNCTION VerificarStock(producto_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    SELECT Existencia INTO stock
    FROM Productos
    WHERE ProductoID = producto_id;
    IF stock > 0 THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END $$
DELIMITER ;

# Ejercicio 4: CalcularSaldo
DELIMITER $$
CREATE FUNCTION CalcularSaldo(id_cuenta INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE saldo DECIMAL(10, 2);
    SELECT SUM(CASE
        WHEN tipo_transaccion = 'deposito' THEN monto
        WHEN tipo_transaccion = 'retiro' THEN -monto
        ELSE 0
    END) INTO saldo
    FROM Transacciones
    WHERE cuenta_id = id_cuenta;
    IF saldo IS NULL THEN
        SET saldo = 0;
    END IF;
    RETURN saldo;
END $$
DELIMITER ;

# Ejercicio 1
SELECT CalcularTotalOrden2(1);

# Ejercicio 2
SELECT CalcularEdad('1990-05-15');
SELECT CalcularEdad('1985-10-25');

# Ejercicio 3
SELECT VerificarStock(1);
SELECT VerificarStock(2);

# Ejercicio 4
SELECT CalcularSaldo(1);
SELECT CalcularSaldo(2);

#Christian Márquez