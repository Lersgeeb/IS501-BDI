/*-------------------------------Inicializando indexeddb-------------------------------*/
/*  
    ! request.onerror
    ? Se ejecutara cuando exista un error en la inicialización de la base de datos.

    ! request.onsuccess
    ? Se ejecutara cuando la base de datos exista y esté actualizada.

    ! request.onupgradeneeded
    ? Se ejecutara cuando no exista o deba ser actualizada la base de datos.
    ? En esta función se puede declarar la estructura de una o varias tablas.
*/

var db;
var request = indexedDB.open("myDatabase");

request.onerror = e => {
    console.error("Database error: " + e.target.errorCode);
}

request.onsuccess = e => {
  db = e.target.result;
  console.log("success");
  setCurrentValue();
};

request.onupgradeneeded = e => { 
    var db = e.target.result;
    var objectStore = db.createObjectStore("texts", { keyPath: "id",  autoIncrement:true });
    console.log('upgrading database')
  };

/*-------------------------------Event Listeners-------------------------------*/
/*
    ! Event Listeners btn
    ? Agregando eventos a los botones del control 3
*/

document.getElementById('accept-btn').addEventListener('click', () => {
    const task = document.querySelector('input[name="control1"]:checked').value;
    taskManager(task);
})

document.getElementById('clr-btn').addEventListener('click', () => {
    document.getElementById('text-input').value = '';
})


/*-------------------------------Funcionalidad principal del script-------------------------------*/
/*  
    ! pos (var)
    ? La variable global indica la posición de la fila activa dentro de la tabla.

    ! taskManager (fun)
    ? Decide que tarea ejecutar basado en la decisión del usuario en el control 1.

    ! addText (fun)
    ? Inicia una transacción y agrega el elemento que se encuentra en la casilla del control 2.
    ? Al final borra el elemento agregado de la casilla 2 y vuelve a asignarse al valor según la fila activa.

    ! removeText (fun)
    ? Basado en la posisción actual dentro de la tabla se eliminara la fila correspondiente.
    ? Hace uso de un cursor para navegar por la tabla saltando hasta la fila deseada y luego es eliminada.

    ! updateText (fun)
    ? Basado en la posisción actual dentro de la tabla se actualizara la fila correspondiente.
    ? Hace uso de un cursor para navegar por la tabla saltando hasta la fila deseada y luego es actualizada con el dato contenido en el control 2.

    ! prevText (fun)
    ? Cambia la posición de la fila al anterior elemento.
    ? De no haber anterior elemento entonces la posición no cambiara

    ! nextText (fun)
    ? Cambia la posición de la fila al siguiente elemento
    ? De no haber siguiente elemento entonces la posición no cambiara

    ! setFirst (fun)
    ? Cambia la posición de la fila primer elemento

    ! setLast (fun)
    ? Cambia la posición de la fila al último elemento
    ? Hace uso del cursor para navegar por todos los elementos de la tabla actualizando el valor de la posición en cada ciclo hasta llegar al último.  

    ! setCurrentValue (fun)
    ? Cambia el valor del control 2 basado en la posicion actual;
    ? Hace uso del cursor para navegar por la tabla saltando hasta la fila deseada para obtenter el contenido correspondiente.
*/


var pos = 0;

function taskManager(task) {
    switch(task) {
        case 'Agregar':
            addText();
            break;

        case 'Eliminar':
            removeText();
            break;

        case 'Modificar':
            updateText();
            break;
            
        case 'Anterior':
            prevText();
            break;

        case 'Siguiente':
            nextText();
            break;


        case 'Primero':
            setFirst();
            break;

        case 'Último':
            setLast();
            break;
    }
} 

function addText(){
    text = document.getElementById('text-input').value
    const tx = db.transaction("texts", "readwrite");
    const texts= tx.objectStore("texts");
    texts.add({content:text});
    document.getElementById('text-input').value = '';
    setCurrentValue();
    alert("El elemento ha sido agregado");
}

function removeText(){
    const objectStore = db.transaction("texts", "readwrite").objectStore("texts");
    let advanced = pos === 0;
    
    objectStore.openCursor().onsuccess = (e) => {
        var cursor = e.target.result; 
        if (cursor){
            if (!advanced) {
                advanced = true;
                cursor.advance(pos);
            }
            else{
                cursor.delete();
                document.getElementById('text-input').value = '';
                alert("El elemento ha sido Eliminado");
            }
        }
    }
}

function updateText(){
    const objectStore = db.transaction("texts", "readwrite").objectStore("texts");
    let advanced = pos === 0;
    
    objectStore.openCursor().onsuccess = (e) => {
        var cursor = e.target.result; 
        if (cursor){
            if (!advanced) {
                advanced = true;
                cursor.advance(pos);
            }
            else{
                content = document.getElementById('text-input').value;
                newValue = cursor.value;
                newValue.content = content;
                cursor.update(newValue);
                alert("El elemento ha sido actualizado");
            }
        }
    }
}

function prevText(){
    setCurrentValue(-1);
}

function nextText(){
    setCurrentValue(1);
}


function setFirst(){
    pos=0;
    setCurrentValue();
}

function setLast(){
    const objectStore = db.transaction("texts").objectStore("texts");
    pos = -1;
    objectStore.openCursor().onsuccess = (e) => {
        var cursor = e.target.result; 
        if (cursor){
            pos++;
            cursor.continue();
            document.getElementById('text-input').value = cursor.value.content;
        }
        else {
            if(pos<0){
                pos = 0;
            }
            console.log("No more entries!");
        }
    }
}

function setCurrentValue(move = 0){
    const objectStore = db.transaction("texts").objectStore("texts");
    pos = pos + move;
    if(pos<0){
        pos = 0;
    } 
    let advanced = pos === 0;
    
    objectStore.openCursor().onsuccess = (e) => {
        var cursor = e.target.result; 
        if (cursor){
            if (!advanced) {
                advanced = true;
                cursor.advance(pos);
            }
            else{
                document.getElementById('text-input').value = cursor.value.content;
            }
        }
        else {
            pos = pos - move;
            console.log("No more entries!");
        }
    }
}

