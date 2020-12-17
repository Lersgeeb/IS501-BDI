import tkinter

class Draws:
    def __init__(self,engine,userID):
        self.engine = engine
        self.userID = userID
        self.drawWindow = tkinter.Tk()
        self.drawWindow.geometry("500x470")
        self.drawWindow.resizable(0,0)
        self.nameLabel = tkinter.Label(self.drawWindow, text = "Draw Manager", font=('arial', 20))
        self.nameLabel.place(x=50,y=20)

        self.list = tkinter.Listbox(self.drawWindow, font=('arial', 15))
        self.list.pack(pady=15)
        self.list.place(x=50,y=70,width=400, height=280)
        scrollbar = tkinter.Scrollbar(self.list, orient="vertical")
        scrollbar.config(command=self.list.yview)
        scrollbar.pack(side="right", fill="y")
        self.list.config(yscrollcommand=scrollbar.set)

        self.drawLabel = tkinter.Label(self.drawWindow, text = "Selected Drawing:", font=('arial', 12,'bold'))
        self.drawLabel.place(x=50,y=370)
        self.currentDrawLabel = tkinter.Label(self.drawWindow, text = "", font=('arial', 12))
        self.currentDrawLabel.place(x=190,y=370)

        self.result = self.engine.getDraws(self.userID)
       
        self.drawsDict = {}
        for drawID, drawName in self.result:    
            self.drawsDict[drawName] = drawID
            self.list.insert('end', drawName)

        self.buttonLoad = tkinter.Button(self.drawWindow, text="Delete", font=('arial', 12), cursor='hand2', command=self.deleteDraw)
        self.buttonLoad.place(x=50,y=420, width=80)
        
        self.list.bind('<<ListboxSelect>>', self.onselect)        

    def onselect(self,e):
        w = e.widget
        drawIndex = int(w.curselection()[0])
        self.value = w.get(drawIndex)
        self.currentDrawLabel.configure(text=self.value)

    def deleteDraw(self):
        print(self.drawsDict[self.value])
        self.engine.deleteDrawByID(self.drawsDict[self.value])
        self.updateDraws()
    
    def updateDraws(self):

        self.list.delete(0,tkinter.END)
        result = self.engine.getDraws(self.userID)
        self.draws = {}
        counter = 0
        for drawID, fileName in result:
            self.draws[fileName] = drawID
            self.list.insert(counter, fileName)
            counter += 1