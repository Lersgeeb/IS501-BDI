var db;
var request = indexedDB.open("myDatabase");
var pos = 0;


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
    
    objectStore.transaction.oncomplete = e => {
        var customerObjectStore = db.transaction("texts", "readwrite").objectStore("texts");
        customerObjectStore.add({content:"Hola"});
    }
    
    console.log('upgrading database')
  };

document.getElementById('accept-btn').addEventListener('click', () => {
    const task = document.querySelector('input[name="control1"]:checked').value;
    taskManager(task);
})

document.getElementById('clr-btn').addEventListener('click', () => {
    document.getElementById('text-input').value = '';
})

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
            pos = 0;
            console.log("No more entries!");
        }
    }
}

function setCurrentValue(move = 0){
    const objectStore = db.transaction("texts").objectStore("texts");
    pos = pos + move;
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

