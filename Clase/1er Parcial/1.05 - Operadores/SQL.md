Operadores
=====

Los operadores =,<>, <=, <, >,  >=, >, <<, >> <=>, AND, OR o LIKE se pueden usar en expresiones en la lista de columnas de salida (a la izquierda de FROM) en instrucciones SELECT. También pueden aplicarse en los condicionales WHERE. Por ejemplo:

    SELECT col1 = 1 AND col2 = 2 FROM my_table;

Like
----

EL operador LIKE se usa en la cláusula WHERE para buscar un patron específico sobre un atributo.

Hay dos comodines que se usan comónmente junto con el operador LIKE. Los comodines siguientes pueden variar según SGBD.

- % El signo de procentaje representa cero, uno o varios caracteres (.*).

-_ El guión bajo representa un sólo carácter.

Algunos de los ejemplos tradicionales para el uso de Like se muestran a continuacion:

- Atributo LIKE 'z__%': Buscar cualquier valor que comience con "z" que tenga al menos 3 caracteres de longitud.
- Atributo LIKE '_z%': Buscar cualquier valor que tengan "z" en la segunda posición.
- Atribbuto LIKE '%z': Buscar cualquier valor que termine con una "z".
- Atributo LIKE '%hn%': Buscar cualquier valor que tenga "hn" en cualquier posición del campo.


In
----
El operador IN es una abreviatura de múltiples condiciones OR. El operadore IN permite especificar varios valores en una cláusula WHERE.

    WHERE atributo IN (value1, value2, ....);
    WHERE atributo IN (SELECT STATEMENT);

Group by, max, min, avg, sum
----
La función COUNT() devuelve el número de filas que coincide con un criterio específico y es la que hemos usado antes para verificar la "existencia de cantidad" de "tareas para un usuario, gerencia, etc".

- La función MIN() devuelve el valor mas pequeño de la columna seleccionada.
- La función MAX() devuelve el valor mas grande de la columna seleccionada.
- La función AVG() devuelve el valor promedio de una columna numérica.
- La función SUM() devuelve la suma total de una columna numérica.

Order By
----
La palabra clave ORDER BY se utiliza para ordenar el conjunto de resultados en orden ascendente (ASC) o descendente (DESC).

Having
----
La cláusula HAVING se usa en SQL para cuando existen condicionales que no pueden aplicarse en el WHERE.

    GROUP BY atributo(s) HAVING condicional



