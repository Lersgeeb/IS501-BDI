import tkinter
import re
import tkinter.messagebox
from .userInput import UserInput
from .Draws import Draws

class Admin:

    def __init__(self,master,engine):
        self.engine = engine

        #Ventana principal
        self.userMgmt = tkinter.Toplevel(master)
        self.userMgmt.title("Admin Managment")
        self.userMgmt.geometry("500x700")
        self.userMgmt.resizable(0,0)

        #Label de la tabla de la lista de usuarios
        self.userListLabel = tkinter.Label(self.userMgmt, text = "Operators users", font=('arial', 18, 'bold'))
        self.userListLabel.place(x=50,y=20)

        #Botón para crear nuevos usuarios operadores
        self.addButton = tkinter.Button(self.userMgmt, text="Add", font=('arial', 12), cursor='hand2', command=self.addUser)
        self.addButton.place(x=370,y=20, width=80)

        #Widget para la lista de usuarios
        self.list = tkinter.Listbox(self.userMgmt, font=('arial', 15))
        self.list.pack(pady=15)
        self.list.place(x=50,y=70,width=400, height=280)
        scrollbar = tkinter.Scrollbar(self.list, orient="vertical")
        scrollbar.config(command=self.list.yview)
        scrollbar.pack(side="right", fill="y")
        self.list.config(yscrollcommand=scrollbar.set)

        usersList = engine.getOperatorUser()
        self.users = {}
        counter = 0
        for userID, username in usersList:
            self.users[username] = userID
            self.list.insert(counter, username)
            counter += 1

        self.list.bind('<<ListboxSelect>>', self.onselect)

        #label para usuario seleccionado
        self.userLabel = tkinter.Label(self.userMgmt, text = "Selected User:", font=('arial', 12,'bold'))
        self.userLabel.place(x=50,y=370)

        #Label del nombre del actual usuario seleccionado
        self.currentUserLabel = tkinter.Label(self.userMgmt, text = "", font=('arial', 12))
        self.currentUserLabel.place(x=170,y=370)
        
        #User admin butons
        self.buttonUpdate = tkinter.Button(self.userMgmt, text="Update", font=('arial', 12), cursor='hand2', command=self.updateUser)
        self.buttonUpdate.place(x=50,y=400, width=80)
        
        self.buttonDelete = tkinter.Button(self.userMgmt, text="Delete", font=('arial', 12), cursor='hand2',command=self.deleteUser)
        self.buttonDelete.place(x=150,y=400, width=80)

        self.buttonDraws = tkinter.Button(self.userMgmt, text="Draws", font=('arial', 12), cursor='hand2',command=self.drawsMgmt)
        self.buttonDraws.place(x=250,y=400, width=80)
        
        #Label de la configuración del usuario
        self.userConfigLabel = tkinter.Label(self.userMgmt, text = "User Config", font=('arial', 18, 'bold'))
        self.userConfigLabel.place(x=50,y=455)

        #Input PenColor
        self.penColorLabel = tkinter.Label(self.userMgmt, text = "PenColor: ", font=('arial', 14))
        self.penColorLabel.place(x=100,y=500)
        self.penColorEntry = tkinter.Entry(self.userMgmt, font=('arial',13))
        self.penColorEntry.place(x=200,y=500, height=28 )

        #Input FillColor
        self.fillColorLabel = tkinter.Label(self.userMgmt, text = "FillColor: ", font=('arial', 14))
        self.fillColorLabel.place(x=100,y=535)
        self.fillColorEntry = tkinter.Entry(self.userMgmt, font=('arial',13))
        self.fillColorEntry.place(x=200,y=535, height=28 )

        #Input Radius
        self.radiusLabel = tkinter.Label(self.userMgmt, text = "Radius: ", font=('arial', 14))
        self.radiusLabel.place(x=100,y=570)
        self.radiusEntry = tkinter.Entry(self.userMgmt, font=('arial',13))
        self.radiusEntry.place(x=200,y=570, height=28 )

        #Input Width
        self.widthLabel = tkinter.Label(self.userMgmt, text = "Width: ", font=('arial', 14))
        self.widthLabel.place(x=100,y=605)
        self.widthEntry = tkinter.Entry(self.userMgmt, font=('arial',13))
        self.widthEntry.place(x=200,y=605, height=28 )

        #save config
        self.saveConfigButton = tkinter.Button(self.userMgmt, text="Save Config", font=('arial', 12), cursor='hand2',command=self.saveConfig)
        self.saveConfigButton.place(x=185,y=650, width=120)
    
    def drawsMgmt(self):
        userID = self.users[self.username]
        Draws(self.engine,userID)

    def onselect(self,e):

        w = e.widget
        index = w.curselection()
        self.username = w.get(index)
        self.currentUserLabel.configure(text=self.username)

        userID = self.users[self.username]
        #Agregar sus valores de configuracion para
        
        self.penColorEntry.delete(0,tkinter.END)
        self.fillColorEntry.delete(0,tkinter.END)
        self.radiusEntry.delete(0,tkinter.END)
        self.widthEntry.delete(0,tkinter.END)
       
        configList = self.engine.getUserConfig(userID)

        self.penColorEntry.insert(0,configList[1])
        self.fillColorEntry.insert(0,configList[2])
        self.widthEntry.insert(0,configList[3])
        self.radiusEntry.insert(0,configList[4])

    def addUser(self):
        mode = "signUp"
        UserInput(self.userMgmt,self.engine, "", self.updateOperatorUser, mode)
        

    def updateUser(self):
        mode = "update"
        self.currentUserLabel.configure(text="")
        oldUsername = self.username
        self.username = None
        UserInput(self.userMgmt,self.engine, oldUsername, self.updateOperatorUser, mode)
       
    def deleteUser(self):
        userID = self.users[self.username]
        self.engine.deleteUserByID(userID)
        self.currentUserLabel.configure(text="")
        self.username = None
        self.updateOperatorUser()

    def saveConfig(self):
        if(self.username):
            userID = self.users[self.username]

            patternColor = "^#[a-fA-F0-9]{6}$" 
            resultPenColor = re.match(patternColor,self.penColorEntry.get())
            resultFillColor = re.match(patternColor,self.fillColorEntry.get())
        
            patterNumberSize = r"^\d+$"

            resultRadius = re.match(patterNumberSize,self.radiusEntry.get())
            resultWidth = re.match(patterNumberSize,self.widthEntry.get())

            if resultPenColor and resultFillColor and resultRadius and resultWidth:
                self.engine.updateUserConfigByAdmin([userID,self.penColorEntry.get(),self.fillColorEntry.get(),self.radiusEntry.get(),self.widthEntry.get()])
            else:
                tkinter.messagebox.showinfo(message="Configuracion incompleta o incorrecta", title="Config error") 
        else:
            tkinter.messagebox.showinfo(message="No se ha seleccionado un usuario", title="Config error") 


    def updateOperatorUser(self):

        self.list.delete(0,tkinter.END)
        usersList = self.engine.getOperatorUser()
        self.users = {}
        counter = 0
        for userID, username in usersList:
            self.users[username] = userID
            self.list.insert(counter, username)
            counter += 1
