import tkinter
import tkinter.messagebox
#Guardar archivo
class SaveFile:

    def __init__(self, userId, drawJson, insertDraw = None):
        
        self.userID = userId
        self.drawJson = drawJson
        self.insertDraw = insertDraw

        self.save = tkinter.Tk()
        self.save.title("Save Drawing")
        self.save.geometry("350x120")
        self.save.resizable(0,0)
        self.nameLabel = tkinter.Label(self.save, text = "File name: ", font=('arial', 17))
        self.nameLabel.place(x=20,y=20)
        self.filename = tkinter.Entry(self.save, font=('arial',13))
        self.filename.place(x=140,y=20, height=30 )
        self.buttonSave = tkinter.Button(self.save, text="Save", font=('arial', 14), cursor='hand2', command=self.saveDraw)
        self.buttonSave.place(x=140 ,y=70, width=100 )
        self.save.mainloop()

    def saveDraw(self):
        name = self.filename.get()
        if(name):
            drawID = self.insertDraw(name, self.userID, self.drawJson)
            if drawID:
                self.save.destroy()
            else:
                tkinter.messagebox.showinfo(message="Nombre del archivo existente en su lista", title="save error")     
        else:
            tkinter.messagebox.showinfo(message="Add a file name", title="save error") 