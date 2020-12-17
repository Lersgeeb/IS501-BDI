## Controlador 

- Módulo de compresion de archivos json baseB []

- Encriptacion de archivos json personalizado []

- Queries para la conexion de la base de datos y el controlador (**Vistas, SP , Inserts, Selects, Deletes y Update**) [x]


## Inicio de sesion

- Crear una configuracion por defecto cada vez que se cree un usuario, **usar Triggers** [x]

- cuando inicie sesión un usuario se debe asignar la ultima configuracion declarada por el usuario. **Usar un procedimiento almacenado** [x]


## Drawing App

- Crear un atributo (currentDrawID) que almacene el ID del dibujo si es que se ha cargado uno previamente. [x]

- Mostrar en la interfaz el nombre del dibujo actual se es que se cargo previamente, de lo contrario mostrar "Untitled". [x]

- Cada vez que se guarde un dibujo que se ha cargado previamente se sobrescribira en la base de datos. [x]

- Crear un boton Save-as para guardar nuevos dibujos sin importar si se ha cargado uno previamente. [x]

- Cada vez que se cambie la configuracion se debera alterar tal informacion a la base de datos. [x]

- Crear opcion de descarga en el menu file [x]

## Admin

- Cada vez que el admin seleccione un usuario se deberan mostrar en pantalla sus configuraciones correspondientes [x]

- Agregar funcionalidad a los botones de Agregar, modificar y borrar usuario [x]

- Alterar la configuracion del usuario cuando se oprima el boton guardar [x]

- *(opcional)*  Se puede hacer uso de Regex para hacer validaciones para los datos de configuraciones agregados. [x]

- Interfaz para ver los dibujos de un/todos usuario y eliminarlos [x]

## Cargar dibujo

- Al seleccionar un dibujo y oprimir "open" se debera visualizar el dibujo en la ventana Drawing App y se debera almacenar el currentDrawID [x]


## Guardar dibujo

- Al guardar un dibujo se debera alterar el atributo de currentDrawID [x]


## Base de datos


- Se debe agregar foreign constraint de tal manera que cuando se elimine un usuario tambien se eliminen todos los dibujos, esto se hara mediante la regla **"CASCADE"** [X]

- La creación de registro mediante triggers [x]

- Aplicar Case-Sensitive [X]

- Crear Triggers para poblar la base de datos B []

- Encriptación  en base de datos []

