# Analisis del Proyecto

Base de Datos A
=======

Análisis Sobre El Diseño

---- 

- Está base de datos A surge de la necesidad de poder llevar acabo el almacenamiento de datos de aplicación de dibujo. Se empezó por crear cada una de las tablas, pero esto sin antes analizar la naturaleza de la aplicación y de sus posibles escenarios, todas la tablas creadas fueron analizadas y pensadas de tal forma, que así se llevarán acabo todas las consultas de las peticiones realizadas por el usuario en la aplicacíon y por su puesto un registro total de todo lo que hagan los usuarios, ademas cumpliendo con los items de la definción del proyecto.
- La tabla Config se definió con el objetivo de guardar la información de configuración, esto se llevo acabo mediante discusión entre grupo y surgieron algunas dudas del cómo,al final se relaizaron algunas pruebas acerca de su funcionamiento y pudimos establecer su defición con éxito.
- La tabla Role se definió con el objetivo de asignar un role a cada usuario además es una forma de identificar en la aplicación los permisos que posee que posee cada usuario.
- La tabla Account se definió de tal manera que se guardarán los datos de los usuarios, asignandole un identificador para poder saber .
- La tabla LogBook surge de la necesidad de llevar un registro de todos lo movimiento que realiza el usario.
- La tabla Action se definió con el objetivo de identificar que acción realiza el usuario, y de esta forma se guardará en el registro 
- La tabla Element se definió con el fin de poder identificar si el usuario configuró, dibujo o si el admin realizo una modificación en los usuario.  
- La tabla Drawing la definimos de tal forma que cuando el usuario realizo un dibujo este se guarde ahí, asignando un nombre de archivo, fecha y un identificador a cada dibujo, para cuando queramos ahcer una consulta, sepamos a que usuario pertenece.
- Creamos procedimientos almacenados y triggers esto para poder obtener información de manera dinámica y definiendo eventos automáticos para la inserción de datos.

Base de Datos B
=======

Análisis Sobre El Diseño

---- 

- Está base de datos surge de la necesidad de tener un respaldo de la base de datos A, llevamos acabo una discusión acerca de su funcionamiento y de todos sus posibles pros y contras a la hora de la guardar dichos datos. 
- La tabla Config se definió con el objetivo de guardar la información de configuración de la Base de datos A, es una réplica exacta de la tabla en A y sus datos.
- La tabla Role se definió con el objetivo de guardar los datos de la table Role A en la tabla Role B, dichas tablas son exactamente iguales, por ende sus datos también tiene que ser iguales.
- La tabla Account se definió con el propósito de que los datos de Account en A se guarden en Account en B,esto para crear un respaldo todos los usuario, dichos datos tiene que ser exactamente igual en ambas.
- La tabla Drawing en B es exactamente igual a la tabla Drawing en A, la definimos de tal forma que se guarden los mismos datos en ambas con la exepcion de que el atributo JSON en A lo definimos como tipo de dato json y en B como tipo de dato BLOB esto porqué guardaremos un archivo compreso de respaldo en dicho atributo en B.   
 
# Bitacora del Proyecto

Para lograr un mayor entendimiento sobre los objetivos planteados acerca el proyecto, se llevaron a cabo varias reuniones para hacer el análisis y plantear la estructura y diseño del mismo.
La etapa de elaboración se inició con el diseño de la arquitectura MVC (modelo, vista, controlador) del proyecto.  Para el modelo se hará uso de Mysql 5.7 como DDL y DML para elaborar la construcción de la base de datos. Esto es debido a los requisitos planteados en el proyecto. Para la vista se hará uso de la librería de tkinter disponible en python para llevar a cabo la construcción de la interfaz y se hará uso del código de acceso libre brindado en el libro de “Data Structures and Algorithms with Python” para hacer una interfaz el cual nos permita hacer una aplicación para la elaboración de dibujos. Esta interfaz será modificada de tal manera que se le verán conectadas más interfaces para generar todas las funcionalidades requeridas. Por último el controlador será elaborado con python. En esta parte es donde se llevara a cabo las funcionalidades necesarias, para ejecutar las tareas de creación y manipulación de datos.

**Autenticación**

El primer elemento a elaborar fue un sistema de autenticado para que los usuarios previamente creados por el administrador puedan acceder a la aplicación de dibujo. Para esto fue necesario hacer una nueva interfaz el cual pida a los usuarios su nombre de usuario y contraseña. Ambos se hicieron usando el objeto Entry de Tkinter. También agregamos un botón para cuando el usuario decida enviar los datos agregados. Al botón se le conecto un controlador de eventos el cual ejecutara un procedimiento almacenado previamente creado en la base de datos, el cual llevara a cabo el proceso de autenticado. Si el proceso envía el ID del usuario entonces habrá iniciado sesión exitosamente y se abrirá la aplicación de dibujo.

**Aplicación de dibujo**

En el proyecto se brindó de un código base el cual contiene la interfaz del dibujo y su respectiva funcionalidad. Esta aplicación hacia uso de XML para guardar los dibujos como objetos como archivos. Para el proyecto fue necesario convertir todos los métodos que hacían uso de ello y cambiarlas por JSON. Al momento que el usuario inicia sesión se le debería abrir la aplicación con un dibujo en blanco. También deberían de mostrar la última configuración establecida por el usuario. La configuración serán los elementos de entrada para editar el dibujo mostrado en pantalla. Esto quiere decir, la anchura del lápiz, radio del círculo, colores de lápiz y relleno. Cada vez que el usuario cambie un elemento de estas configuraciones entonces se debería guardarse en la base de datos. Para lograrlo también se hace uso de un procedimiento almacenado.
También fue necesario alterar opciones del menú el cual interactuaban directamente con el equipo al momento de guardar y cargar documentos. Para esto fue necesario crear nuevas interfaces los cuales actuaran como intermediarios de la base de dato y el usuario. Estas ventanas son para cargar, guardar y descargar dibujos. Para el usuario administrador se mostraría una opción más, esta ventana será para hacer modificaciones de otras cuentas de menor rango.

**Guardar Dibujo**

En esta interfaz la principal tarea será preguntar el usuario el nombre para llevar a cabo la creación del dibujo actual en la aplicación. Este proceso se llevara a cabo con un procedimiento almacenado el cual retornara el nuevo ID si el dibujo ha sido creado exitosamente. En cambio sí existe un dibujo con el mismo nombre entonces se enviara un valor NULL. Esta ventana mediante el uso de CallBack cambiara el estado de la aplicación del dibujo. Cuando se guarde el dibujo entonces la ventana se cerrara y el estado del dibujo actual de la aplicación de dibujo se actualizara.
Al momento de guardar un archivo que se haya cargado previamente entonces la aplicación de dibujo no preguntara el nombre de un nuevo dibujo y solo modificara el dibujo que se encuentra en el estado de la aplicación de dibujo.
Cargar Dibujo
Esta interfaz contendrá una lista con todos los dibujos creados por el usuario. Entonces el usuario tendrá que seleccionar el dibujo y oprimir el botón de cargar. Esto al igual que la interfaz de guardar se llevara a cabo con un CallBack que alterara el estado de la aplicación de dibujo. Haciendo que se actualice la ventana con el dibujo seleccionado.
Descargar Dibujo
La interfaz de dibujo funcionara en un principio como el de cargar dibujos. Este mostrara una lista de los dibujos del usuario, luego al momento de oprimir el botón de descargar entonces se abrirá una ventana el cual preguntara la dirección en el equipo donde se deberá guardar el nuevo dibujo y su nombre. 

**Administrador**

Esta ventana solo estará disponible para el usuario administrador. En ella se podrá crear, modificar, eliminar, ver dibujos y cambiar configuraciones de los usuarios. En ella se deberá agregar una lista que muestre todos los usuarios operadores y al momento de seleccionar uno entonces deberá alterar el estado del usuario actual y deberá activar la opción de poder manipularlo. Para el caso de agregar nuevo usuario no es necesario tener un usuario seleccionado. En el caso de actualización y agregado de usuario entonces se abrirá una nueva ventana que preguntara el nombre del usuario y la contraseña. El botón de eliminar solo necesitara tener un elemento seleccionado previamente para ejecutar su tarea. El botón de dibujo abrirá una nueva ventana el cual mostrara los dibujos del usuario seleccionado. El administrador tendrá la opción de eliminar un dibujo desde ese apartado. También se encuentra un segmento que muestra la configuración actual del usuario seleccionado y permite modificarlo.

**Librerías implementadas**

*Expresiones regulares*

Se agregó el uso de expresiones regulares para hacer las validaciones de los valores entrantes de la configuración. Esto se debe a que las configuraciones se guardan con cualquier modificación que se haga. Para esto fue necesario agregar un filtro de los valores entrantes para que no se guarde en la base de datos valores que son invalidos.

## Martes 24 de Noviembre

- (Ariel) Hoy se discutio por primera vez la definición del proyecto utilizando Discord como plataforma de reuniones.

## Viernes 27 de Noviembre

- (Ariel, Caleb y Gabriel) Se creó el diagrama Entidad Relación inicial y el modelo MVC para comenzar a trabajar y analizar como crear
el programa.

## Miercoles 2 de Diciembre  

- (Fernando) Se creo la ventana para administrar el login y el empiezo de la clase de autentificacion de usuario ya sea normal o de administrador  

- (Caleb y Josúe): Realizamos una reestructuración del diagrama ER y se comenzó con los archivos DDS.sql y DMS.sql para cada base de datos acorde. Asímimsmo, una mejor completación del diseño MVC.

- (Gabriel): Se editó el código de la  aplicación de dibujo de tal manera que funcione alrededor de archivos json y no en doumentos XML como estaba implementado en un principio. 

## Jueves 3 de Diciembre  

- (Caleb y Josué) Se actualizó el diagrama entidad relación (ER), agregando a los atributos su respectivo tipo de dato y además mejorando el diseño.

- (Gabriel): Se creó un procedimiento almacenado de tal manera que se pueda usar para llevar a cabo la tarea de autenticación. Tambien se creó la clase de MySQLEngine para crear una conexión de la base de datos con los archivos python y se agregó un método para hacer llamados a procedimientos almacenados.

## Viernes 4 de Diciembre  

- (Gabriel y Fernando) Arreglo de bug de la venta de login, se conecto el mysqlConector con la ventana de login para poder hacer las verificaciones, se creo la clase encriptación al igual que la ventana para las modificaciones del usuario. El programa ya distigue entre los tipos de usuario. Se agregaron variables para futuros arreglos como lo es el engine y el id de usuario con su nombre casi listo para poder almacenar info en la base de datos.

- (Caleb y Josué) Completación del archivo DDS.sql para la base de datos A asi como su diagrama ER.

## Sabado 5 de Diciembre

- (Gabriel y Fernando): Se crearon las ventanas para la carga y guardado de dibujo. Se implementaron las interfaces creadas al proyecto. Tambien se alteraron métodos de la aplicación del dibujo, estos cambios abarcan la manera en como el programa guardaba los archivos json, el programa original guardaba los archivos json en el directorio seleccionado por el usuario. Debido a esto se necesito alterar el proceso de guardado y carga de tal manera que todo los archivos guardados se encuentren en la base de datos. Para cargar un dibujo ahora es necesario hacer transacciones tomando en cuenta el usuario actual. 

## Domingo 6 de Diciembre

- (Gabriel): Se creó la ventana para la administración de usuarios el cual solamente sera accedido por el usuario con privilegios de Administrador. Se agregó una vista a la base de datos para la visualizacion de los usuarios operadores, esta ha sido implementada en la ventana del administrador. En el mySQLEngine se creó un método general para el insertado de datos y tambien se agregaron los metodos necesarios para la visualizacion de los usuarios operadores seleccionando la vista creada previamente.

## Lunes 7 de Diciembre

- (Gabriel): Se modificó el programa de tal manera que al momento de cargar un dibujo la pantalla del dibujo se actualice con el dibujo seleccionado.

- (Caleb y Josué): Se comenzaron a trabajar en los triggers para automatizar la bitacora en la base A.

## Martes 8 de Diciembre

- (Gabriel): Se llevó a cabo la tarea de elaborar el código necesario para generar la carga de los dibujos en el programa. Esto consiste en crear un atributo con el id del dibujo en la aplicación que se vaya alterando cada vez que se haya cargado o creado un nuevo dibujo.

- (Caleb y Josué): Se crearón más Triggers para los otros eventos existentes mencionados en la definición del proyecto. Asi como la documentación del los scripts SQL.

## Miercoles 9 de Diciembre

- (Gabriel): Se cambiaron algunas consultas basicas dentro del motor de mysql por procedimientos almacenados escritos en la parte de la base de datos.

- (Caleb y Josué): Se agregó el campo "txt_elementName" en la bitacora de la base A, esto con la intención de obtener una tabla de registros más detallada. Asímismo se logró hacer una comparación de contraseña más exacta (tomando en cuenta las mayusculas y minusculas).

## Viernes 11 de Diciembre

- (Gabriel y Fernando) Se organizaron algunas funciones de la ventana de admin al igual que se agregaron la funcionalidad completa de agregar usuarios y poder modificarlos cambiando su nombre y contraseña, se implemento correctamente la verificación en las tablas para verificar si al agregar un usuario el usuario ya existe en la base de datos y de igual forma para la modificacion de un usuario no puede agregar el mismo nombre de un usuario ya existente. Se agrego el reconocimiento de la configuración de el lapiz su color el radio y lo ancho de lapiz y desde el modo usuario se puede modificarlos y que se guarden los valores en la base de datos.
