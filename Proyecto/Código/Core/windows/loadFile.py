import tkinter
import tkinter.messagebox
#Ventana para Cargar o Descargar archivos
class LoadFile:

    def __init__(self, master, drawList, loadFunc,mode):
        self.loadFunc = loadFunc
        self.load = tkinter.Toplevel(master)
        self.load.geometry("500x470")
        self.load.resizable(0,0)

        if (mode == "load"):
            self.load.title("Upload drawings")
            self.nameLabel = tkinter.Label(self.load, text = "Upload Drawings", font=('arial', 20))
            self.buttonLoad = tkinter.Button(self.load, text="Open", font=('arial', 12), cursor='hand2', command=self.loadDraw)
        elif (mode == "download"):
            self.load.title("Download drawing")
            self.nameLabel = tkinter.Label(self.load, text = "Download Drawing", font=('arial', 20))
            self.buttonLoad = tkinter.Button(self.load, text="Download", font=('arial', 12), cursor='hand2', command=self.downloadDraw)
       
        self.nameLabel.place(x=50,y=20)

        self.list = tkinter.Listbox(self.load, font=('arial', 15))
        self.list.pack(pady=15)
        self.list.place(x=50,y=70,width=400, height=280)
        scrollbar = tkinter.Scrollbar(self.list, orient="vertical")
        scrollbar.config(command=self.list.yview)
        scrollbar.pack(side="right", fill="y")
        self.list.config(yscrollcommand=scrollbar.set)

        self.drawLabel = tkinter.Label(self.load, text = "Selected Drawing:", font=('arial', 12,'bold'))
        self.drawLabel.place(x=50,y=370)
        self.currentDrawLabel = tkinter.Label(self.load, text = "", font=('arial', 12))
        self.currentDrawLabel.place(x=190,y=370)
        
        self.drawDict = {}
        for drawID, drawName in drawList:    
            self.drawDict[drawName] = drawID
            self.list.insert('end', drawName)

        self.buttonLoad.place(x=50,y=420, width=80)
        
        self.list.bind('<<ListboxSelect>>', self.onselect)        

    def onselect(self,e):
        w = e.widget
        drawIndex = int(w.curselection()[0])
        value = w.get(drawIndex)
        self.currentDrawLabel.configure(text=value)

    def loadDraw(self):
        name = self.currentDrawLabel.cget('text')
        if(name):
            self.loadFunc(self.drawDict[name], name)
            self.load.destroy()
        else:
            tkinter.messagebox.showinfo(message="select a file", title="save error") 

    def downloadDraw(self):
        name = self.currentDrawLabel.cget('text')
        self.loadFunc(self.drawDict[name])
        self.load.destroy()
        
