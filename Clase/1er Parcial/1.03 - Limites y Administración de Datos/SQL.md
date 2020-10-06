@author geescobar@unah.hn
@date 2020/10/05

DEfinición Clase Lunes 05 de Octubre de 2020
===

La explicación de la clase del día de hoy se hará:
- Se definirá mediante teoría, usando un archivo Markdown, distintos conceptos de instrucciones de SQL.
- Se definirá código SQL para aplicar la teoría anterior.
- Se Ejecutará el código SQL para demostrar la teoría.

Otras sentencias de Manipulación de Datos SQL
===

Aliasing en tablas
-----

Se aplica mediante la palabra reservada **AS** en atributos o en relaciones para generar un alias temporal para mostrar un dato con un nombre distinto o para aplicar nomenclatura específica.

Límite
---

Se aplica mediante la palabra reservada **LIMIT**. Si solo necesita un número específico de  filas de un conjunto de resultados, utilice una cláusula LIMIT en la consulta, en lugar de recuperar todo el conjunto de resultados.

Mediante **LIMIT** es posible generar la visualización  de resultados mediante "páginas de datos", limitando la cantidad de filas y las filas que se muestran en pantalla.


Otras sentencias de SQL para Administración de los Datos
===

Algunas de las sentencias anteriores son:

- SHOW DATABASES.
- SHOW TABLES.
- DESCRIBE.

SHOW CREATE DATABASE
-----

Se utiliza mediante **SHOW CREATE DATABASE dataBaseName;** y permite visualizar el código DDS para la creación de la base de datos.

SHOW CREATE TABLE
-----

SE utiliza mediante **SHOW CREATE TABLE tableName;** y permite visualizar el código DDS para la creación de la tabla de base de datos.

DROP DATABASE IF EXIST
-----
Permite eliminar una base de datos 


Para ejecutar dentro de la base de datos
-----
source DDS_DMS.sql