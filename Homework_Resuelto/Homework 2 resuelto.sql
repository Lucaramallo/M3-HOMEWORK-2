/*
## Homework 02

... Los datos provienen de una empresa, area MKTNG.CVS

Con el objetivo de asegurarse de que la calidad de la información
con la que se va a trabajar sea la óptima,
es necesario realizar una lista de propuestas de mejora teniendo en cuenta los siguientes puntos:

1) ¿Qué tan actualizada está la información?
	La tabla ventas al 2020 ultimo dato cargado
        
 ¿La forma en que se actualiza ó mantiene esa información se puede mejorar?
	La verdad que si. tenemos tablas a diferente nivel de actualizacion (fecha de los datos)
    
2) ¿Los datos están completos en todas las tablas?
	No, hay valores faltantes. 

3) ¿Se conocen las fuentes de los datos?
	Sí, Area mktng provinientes de la empresa en cuestion.

4) Al integrar éstos datos, es prudente que haya una normalización
	respecto de nombrar las tablas y sus campos.
	Sí claro, para luego poder trabajarlas con mayor facilidad y para ordenar los datos,
    de esta forma prevenimos errores en los datos, por consiguiente, la informacon y claro
    en nuestras futuras conclusiones.

5) Es importante revisar la consistencia de los datos:
 ¿Se pueden relacionar todas las tablas al modelo? 
 ¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros?
 ¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)?
	Canal de venta = Dimension
	Cliente = Dimension

	Compra, gasto y Venta = tablas de Hecho.
	** las tablas de Hechos, casi seguro que siempre tendrán una columna fecha **
	** tmb suelen estar llenas de ID

 ¿Hay claves duplicadas?
	Sí, en tabla emppleado por ej id 1674 se repite y lo tienen asignado dos empleados diferentes.

 ¿Cuáles son variables cualitativas y cuáles son cuantitativas?
 ¿Qué acciones podemos aplicar sobre las mismas?

	El id no es cuantitativa... me sirve sacar un promedio de ID?... NO! no sirve de nada
    dif del promedio de ingresos, de ventas, de unidades vendidas de un prod por ej...
    

 


### Limpieza, Valores faltantes y Normalización

6) Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno en cada una de las tablas. Descartar columnas que consideres que no tienen relevancia.
7) Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente. De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva sobre ese problema.
8) Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.
9) Utilizar la funcion provista 'UC_Words' para modificar a letra capital los campos que contengan descripciones para todas las tablas.
10) Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.
11) Generar dos nuevas tablas a partir de la tabla 'empelado' que contengan las entidades Cargo y Sector.
12) Generar una nueva tabla a partir de la tabla 'producto' que contenga la entidad Tipo de Producto.
13) Es necesario contar con una tabla de localidades del país con el fin de evaluar la apertura de una nueva sucursal y mejorar nuestros datos. 
A partir de los datos en las tablas cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias.
Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y Provincia de las tablas cliente, sucursal y proveedor.
14) Es necesario discretizar el campo edad en la tabla cliente.
*/






/* cambiar Nombres de campos con altertable*/
use henry_m3;

-- El comando ALTER TABLE en SQL se utiliza para modificar la estructura de una tabla existente
-- en una base de datos relacional.
-- Algunas de las modificaciones que se pueden realizar con ALTER TABLE son:

-- 1 Agregar una nueva columna a una tabla existente.
-- 2 Eliminar una columna de una tabla existente.
-- 3 Modificar la definición de una columna existente, por ejemplo, cambiando su tipo de datos o su longitud máxima.
-- 4 Cambiar el nombre de una tabla existente.
-- 5 Agregar una restricción de integridad a una tabla existente.
-- 6 Modificar una restricción de integridad existente.

ALTER TABLE `cliente` CHANGE `ID` `IdCliente` INT(11) NOT NULL;
ALTER TABLE `empleado` CHANGE `IDEmpleado` `IdEmpleado` INT(11) NULL DEFAULT NULL;
ALTER TABLE `proveedor` CHANGE `IDProveedor` `IdProveedor` INT(11) NULL DEFAULT NULL;
ALTER TABLE `sucursal` CHANGE `ID` `IdSucursal` INT(11) NULL DEFAULT NULL;
-- COLLATE es una palabra clave en SQL que se utiliza para especificar la regla de ordenación (sorting) 
-- y la codificación de caracteres que se utilizará para comparar y clasificar los datos
-- de texto en una consulta o una operación de base de datos.
ALTER TABLE `tipo_gasto` CHANGE `Descripcion` `Tipo_Gasto` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL;
ALTER TABLE `producto` CHANGE `IDProducto` `IdProducto` INT(11) NULL DEFAULT NULL;
ALTER TABLE `producto` CHANGE `Concepto` `Producto` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NULL DEFAULT NULL;

/*Tipos de Datos*/
-- Agregar columna, luego de la columna especificada
-- Es buena practica crear nuevas columnas porque si tengo errores al cambiar , por. como en este caso 
-- al registro 2400 por ej, van a cambiar todos los valores hasta alli...

ALTER TABLE `cliente` 	ADD `Latitud` DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER `Y`, 
						ADD `Longitud` DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER `Latitud`;
UPDATE cliente SET Y = '0' WHERE Y = ''; -- Reemplazo valores faltantes en Y where Y = ''
UPDATE cliente SET X = '0' WHERE X = ''; -- Reemplazo valores faltantes en Y where X = ''
-- Actualización de los campos de valores, 
-- REPLACE(valor a alterar,'sustituir la coma','por un punto')
UPDATE `cliente` SET Latitud = REPLACE(Y,',','.'); 
UPDATE `cliente` SET Longitud = REPLACE(X,',','.');
-- aca con el replace pueblo la col latitud, 
-- con los valores de Y sustituyendole a esos valores la 'coma' por 'punto'.
-- SELECT * FROM `cliente`;
ALTER TABLE `cliente` DROP `Y`; -- elimina columna Y, porque ya tengo lat como nueva col
ALTER TABLE `cliente` DROP `X`; -- elimina columna X, porque ya poseo long como nueva col

ALTER TABLE `empleado` ADD `Salario` DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER `Salario2`;
UPDATE `empleado` SET Salario = Salario2;
ALTER TABLE `empleado` DROP `Salario2`;

ALTER TABLE `producto` ADD `Precio` DECIMAL(15,3) NOT NULL DEFAULT '0' AFTER `Precio2`;
UPDATE `producto` SET Precio = REPLACE(Precio2,',','.');
ALTER TABLE `producto` DROP `Precio2`;
-- con salario y producto hago una sustitucion de columna por una mejor definida, como en el paso anterior.alter

ALTER TABLE `sucursal` 	ADD `Latitud` DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER `Longitud2`, 
						ADD `Longitud` DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER `Latitud`;
UPDATE `sucursal` SET Latitud = REPLACE(Latitud2,',','.');
UPDATE `sucursal` SET Longitud = REPLACE(Longitud2,',','.');
-- SELECT * FROM `sucursal`;
ALTER TABLE `sucursal` DROP `Latitud2`;
ALTER TABLE `sucursal` DROP `Longitud2`;

-- Lo mismo para sucursal y precio.

UPDATE `venta` set `Precio` = 0 WHERE `Precio` = '';
ALTER TABLE `venta` CHANGE `Precio` `Precio` DECIMAL(15,3) NOT NULL DEFAULT '0';
-- como venta posee espacios vacios, tengo que llenarlos con '0' primero, y luego le paso el DECIMAL.



/*Columnas sin usar*/
ALTER TABLE `cliente` DROP `col10`; -- No es necesaria la col 10, la dropeo de una

-- SELECT * FROM cliente;




/*Imputar Valores Faltantes*/
UPDATE `cliente` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
-- como no puedo sacar el prom de los domiciolios, completo con sin dato.

-- el TRIM, es una funcion que corta los caracteres que son espacios DE ADELANTE Y ATRAS.
-- SELECT TRIM('            HOLA MUNDO      ');

UPDATE `cliente` SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);
UPDATE `cliente` SET Nombre_y_Apellido = 'Sin Dato' WHERE TRIM(Nombre_y_Apellido) = "" OR ISNULL(Nombre_y_Apellido);
UPDATE `cliente` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);

UPDATE `empleado` SET Apellido = 'Sin Dato' WHERE TRIM(Apellido) = "" OR ISNULL(Apellido);
UPDATE `empleado` SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE `empleado` SET Sucursal = 'Sin Dato' WHERE TRIM(Sucursal) = "" OR ISNULL(Sucursal);
UPDATE `empleado` SET Sector = 'Sin Dato' WHERE TRIM(Sector) = "" OR ISNULL(Sector);
UPDATE `empleado` SET Cargo = 'Sin Dato' WHERE TRIM(Cargo) = "" OR ISNULL(Cargo);

UPDATE `producto` SET Producto = 'Sin Dato' WHERE TRIM(Producto) = "" OR ISNULL(Producto);
UPDATE `producto` SET Tipo = 'Sin Dato' WHERE TRIM(Tipo) = "" OR ISNULL(Tipo);

UPDATE `proveedor` SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE `proveedor` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
UPDATE `proveedor` SET Ciudad = 'Sin Dato' WHERE TRIM(Ciudad) = "" OR ISNULL(Ciudad);
UPDATE `proveedor` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE `proveedor` SET Pais = 'Sin Dato' WHERE TRIM(Pais) = "" OR ISNULL(Pais);
UPDATE `proveedor` SET Departamento = 'Sin Dato' WHERE TRIM(Departamento) = "" OR ISNULL(Departamento);

UPDATE `sucursal` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
UPDATE `sucursal` SET Sucursal = 'Sin Dato' WHERE TRIM(Sucursal) = "" OR ISNULL(Sucursal);
UPDATE `sucursal` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE `sucursal` SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);

/*Tabla ventas limpieza y normalizacion*/
/*
select * from venta where Precio = '' or Cantidad = '';
select count(*) from venta;
*/

UPDATE venta v JOIN producto p ON (v.IdProducto = p.IdProducto) 
SET v.Precio = p.Precio
WHERE v.Precio = 0;
-- poblame la columna precio de venta 
-- con los precios de los prod definidos en la tabla prod
-- segun id de prod... donde el precio de venta sea 0.

-- SELECT * FROM venta; -- PARA VER LOS CAMBIOS

/*Tabla auxiliar O 'DE AUDITORIA' donde se guardarán registros con problemas:
1-Cantidad en Cero
*/

DROP TABLE IF EXISTS `aux_venta`;
CREATE TABLE IF NOT EXISTS `aux_venta` (
  `IdVenta`				INTEGER,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCliente`			INTEGER, 
  `IdSucursal`			INTEGER,
  `IdEmpleado`			INTEGER,
  `IdProducto`			INTEGER,
  `Precio`				FLOAT,
  `Cantidad`			INTEGER,
  `Motivo`				INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
 -- CREO TABLA AUX COCN MISMOS CAMPOS QUE VENTA,
 -- AGREGANDOLE EL CAMPO MOTIVO, DEBIDO A QUE TENEMOS QUE ARREGLAR AHORA CANTIDAD, 
 -- ANTES YA ARREGLAMOS EL PRECIO.

UPDATE venta SET Cantidad = REPLACE(Cantidad, '\r', ''); -- saco el /r
-- /r ES EL RETURN CARRIGE return carrio maquina de escribir.
-- se detectó que habia muchos valores con el '\r', y como está presente el campo no está vacio, por lo que
-- genera inconsistencias al intentar reemplazar los valores '' nulos..

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, 0, 1 
FROM venta WHERE Cantidad = '' or Cantidad is null;
-- poble con la tabla anterior (averiguar lo del 0,1)
-- lo del cero y uno viene mas abajo..
UPDATE venta SET Cantidad = '1' WHERE Cantidad = '' or Cantidad is null; -- si hubo una venta por lo menos uno se vendió
ALTER TABLE `venta` CHANGE `Cantidad` `Cantidad` INTEGER NOT NULL DEFAULT '0';



/*Chequeo de claves duplicadas, ej, id iempleado*/
SELECT IdCliente, COUNT(*) FROM cliente GROUP BY IdCliente HAVING COUNT(*) > 1;
SELECT IdSucursal, COUNT(*) FROM sucursal GROUP BY IdSucursal HAVING COUNT(*) > 1;
SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY IdEmpleado HAVING COUNT(*) > 1;
SELECT IdProveedor, COUNT(*) FROM proveedor GROUP BY IdProveedor HAVING COUNT(*) > 1;
SELECT IdProducto, COUNT(*) FROM producto GROUP BY IdProducto HAVING COUNT(*) > 1;
-- sleeccioname id cliente agrupado por id cliente donde la agrupacion de mayor a 1,
-- quiere decir que entonces hay dos regstros con el mismo idcliente

-- select count(*) from empleado;





SELECT e.*, s.IdSucursal
FROM empleado e JOIN sucursal s
	ON (e.Sucursal = s.Sucursal);
    
select distinct Sucursal from empleado
where Sucursal NOT IN (select Sucursal from sucursal);

/*Generacion de clave única tabla empleado mediante creacion de clave subrogada*/
UPDATE empleado SET Sucursal = 'Mendoza1' WHERE Sucursal = 'Mendoza 1';
UPDATE empleado SET Sucursal = 'Mendoza2' WHERE Sucursal = 'Mendoza 2';
-- UPDATE empleado SET Sucursal = 'Córdoba Quiroz' WHERE Sucursal = 'Cordoba Quiroz';

ALTER TABLE `empleado` ADD `IdSucursal` INT NULL DEFAULT '0' AFTER `Sucursal`;

UPDATE empleado e JOIN sucursal s
	ON (e.Sucursal = s.Sucursal)
SET e.IdSucursal = s.IdSucursal;

ALTER TABLE `empleado` DROP `Sucursal`;





ALTER TABLE `empleado` ADD `CodigoEmpleado` INT NULL DEFAULT '0' AFTER `IdEmpleado`;

UPDATE empleado SET CodigoEmpleado = IdEmpleado;
UPDATE empleado SET IdEmpleado = (IdSucursal * 1000000) + CodigoEmpleado;
-- es como aplicarle un hash...

-- sigo con el...
/*Chequeo de claves duplicadas*/
SELECT * FROM `empleado`;
SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY IdEmpleado HAVING COUNT(*) > 1;

/*Modificacion de la clave foranea de empleado en venta*/
UPDATE venta SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;




/*Normalizacion tabla empleado*/
DROP TABLE IF EXISTS `cargo`;
CREATE TABLE IF NOT EXISTS `cargo` (
  `IdCargo` integer NOT NULL AUTO_INCREMENT,
  `Cargo` varchar(50) NOT NULL,
  PRIMARY KEY (`IdCargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
-- creo nurva tabla para los cargos ya que muchos empleados poseen el mismo cargo por ejemplo-

DROP TABLE IF EXISTS `sector`;
CREATE TABLE IF NOT EXISTS `sector` (
  `IdSector` integer NOT NULL AUTO_INCREMENT,
  `Sector` varchar(50) NOT NULL,
  PRIMARY KEY (`IdSector`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
-- lo mismo con sector, varios empleados pueden pertenecer al mismo sector.

-- Ahora pueblo las tablas solo con los valores unicos, razonablemente
INSERT INTO cargo (Cargo) SELECT DISTINCT Cargo FROM empleado ORDER BY 1; 
INSERT INTO sector (Sector) SELECT DISTINCT Sector FROM empleado ORDER BY 1;

select * from cargo;
select * from sector;

ALTER TABLE `empleado` 	ADD `IdSector` INT NOT NULL DEFAULT '0' AFTER `IdSucursal`, 
						ADD `IdCargo` INT NOT NULL DEFAULT '0' AFTER `IdSector`;
-- agrego las nuevas columnas.. 
UPDATE empleado e JOIN cargo c ON (c.Cargo = e.Cargo) SET e.IdCargo = c.IdCargo;
UPDATE empleado e JOIN sector s ON (s.Sector = e.Sector) SET e.IdSector = s.IdSector;
-- cargo con los valores...
ALTER TABLE `empleado` DROP `Cargo`;
ALTER TABLE `empleado` DROP `Sector`;

-- Elimino las ya, no necesarias
SELECT * FROM `empleado`;




/*Normalización tabla producto*/
ALTER TABLE `producto` ADD `IdTipoProducto` INT NOT NULL DEFAULT '0' AFTER `Precio`;



-- Ahora lo mismo con tipo de producto..
DROP TABLE IF EXISTS `tipo_producto`;
CREATE TABLE IF NOT EXISTS `tipo_producto` (
  `IdTipoProducto` int(11) NOT NULL AUTO_INCREMENT,
  `TipoProducto` varchar(50) NOT NULL,
  PRIMARY KEY (`IdTipoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- agrego los tipos unicos de prod...
INSERT INTO tipo_producto (TipoProducto) SELECT DISTINCT Tipo FROM producto ORDER BY 1;
-- Los actualizo en la nueva tabla..
UPDATE producto p JOIN tipo_producto t ON (p.Tipo = t.TipoProducto) SET p.IdTipoProducto = t.IdTipoProducto;
-- verifico
SELECT * FROM `producto`;
-- dropeo la obsoleta
ALTER TABLE `producto`
  DROP `Tipo`;