import tkinter
import tkinter.colorchooser
import tkinter.filedialog
from .DrawApp import DrawingApplication
from .ConnectionConfig import ConnectionConfig
from .MySQLEngine import MySQLEngine

class Login:
    def __init__(self,engine):
        
        self.engine = engine
        self.adminState = False
        #Ventana para logear a los usuarios y sus atributos
        self.login = tkinter.Tk()
        self.login.title("Login")
        self.login.geometry("400x200")
        self.login.configure(background = 'white')
        self.login.resizable(0,0)

        #Espacio para ingresar un usuario
        self.userL = tkinter.Label(self.login,text='User: ',font = ('arial',15),bd=5,bg="white")
        self.userL.place(x=90,y=50)
        self.userE = tkinter.Entry(self.login)
        self.userE.place(x=150,y=50,height=30)
        
        #Espacio para ingresar una contraseña
        self.passL = tkinter.Label(self.login,text='Password: ',font = ('arial',15),bd=5,bg="white")
        self.passL.place(x=46,y=100)
        self.passE = tkinter.Entry(self.login,show="*")
        self.passE.place(x=150,y=100,height=30)

        #Boton para ejecutar la verificacion edl usuario 
        self.loginButton = tkinter.Button(self.login,text="LOGIN",cursor='hand2',command=self.getValues)
        self.loginButton.place(x=150,y=150)

       
    def getValues(self):

        userAcc = self.userE.get()
        passwordAcc =  self.passE.get()
        
        userID, admin = self.engine.loginUser(userAcc, passwordAcc)

        if userID:
            if admin == "ADMIN":
                self.adminState = True

            user = {"userId": userID, "username": userAcc}
            self.paint(user)
        else:
            tkinter.messagebox.showinfo(message="El usuario o la contraseña es incorrecta", title="Login error") 
       
    def paint(self, user):

        self.login.destroy()
        root = tkinter.Tk()  
        root.resizable(0,0)
        drawingApp = DrawingApplication(root, self.adminState, user, self.engine)  
        drawingApp.mainloop()