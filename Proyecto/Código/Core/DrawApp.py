# The imports include turtle graphics and tkinter modules. 
# The colorchooser and filedialog modules let the user
# pick a color and a filename.
from .windows.saveFile import SaveFile
from .windows.loadFile import LoadFile
from .windows.admin import Admin
import turtle
import tkinter
import tkinter.colorchooser
import tkinter.filedialog
import json
import re

# The following classes define the different commands that 
# are supported by the drawing application. 
class GoToCommand:
    def __init__(self,x,y,width=1,color="black"):
        self.x = x
        self.y = y
        self.width = width
        self.color = color
        
    # The draw method for each command draws the command
    # using the given turtle
    def draw(self,turtle):
        turtle.width(self.width)
        turtle.pencolor(self.color)
        turtle.goto(self.x,self.y)
        
    # The __str__ method is a special method that is called
    # when a command is converted to a string. The string
    # version of the command is how it appears in the graphics
    # file format. 
    def __str__(self):
        return '{ "command": "GoTo", "x":%s, "y":%s, "width":%s, "color":"%s" }' % (self.x, self.y, self.width, self.color)
        
class CircleCommand:
    def __init__(self,radius, width=1,color="black"):
        self.radius = radius
        self.width = width
        self.color = color
        
    def draw(self,turtle):
        turtle.width(self.width)
        turtle.pencolor(self.color)
        turtle.circle(self.radius)
        
    def __str__(self):
        return '{ "command": "Circle", "radius":%s, "width":%s, "color":"%s" }' % (self.radius, self.width, self.color)
        
class BeginFillCommand:
    def __init__(self,color):
        self.color = color
        
    def draw(self,turtle):
        turtle.fillcolor(self.color)
        turtle.begin_fill()
        
    def __str__(self):
        return '{ "command": "BeginFill", "color":"%s" }' % (self.color)
        
class EndFillCommand:
    def __init__(self):
        pass
    
    def draw(self,turtle):
        turtle.end_fill()
        
    def __str__(self):
        return '{ "command": "EndFill" }'
        
class PenUpCommand:
    def __init__(self):
        pass
    
    def draw(self,turtle):
        turtle.penup()
        
    def __str__(self):
        return '{ "command": "PenUp" }' 
        
class PenDownCommand:
    def __init__(self):
        pass
    
    def draw(self,turtle):
        turtle.pendown()
        
    def __str__(self):
        return '{ "command": "PenDown" }'

# This is the PyList container object. It is meant to hold a  
class PyList:
    def __init__(self):
        self.gcList = []
        
    # The append method is used to add commands to the sequence.
    def append(self,item):
        self.gcList = self.gcList + [item]
        
    # This method is used by the undo function. It slices the sequence
    # to remove the last item
    def removeLast(self):
        self.gcList = self.gcList[:-1]
       
    # This special method is called when iterating over the sequence.
    # Each time yield is called another element of the sequence is returned
    # to the iterator (i.e. the for loop that called this.)
    def __iter__(self):
        for c in self.gcList:
            yield c
    
    # This is called when the len function is called on the sequence.        
    def __len__(self):
        return len(self.gcList)            
        
# This class defines the drawing application. The following line says that
# the DrawingApplication class inherits from the Frame class. This means 
# that a DrawingApplication is like a Frame object except for the code
# written here which redefines/extends the behavior of a Frame. 
class DrawingApplication(tkinter.Frame):
    def __init__(self, master=None,adminState=False, user = None,engine = None, currentDraw = {}):
        super().__init__(master)
        self.currentDraw = currentDraw
        self.user = user
        self.engine = engine
        self.adminState = adminState
        self.pack()
        self.buildWindow()    
        self.graphicsCommands = PyList()


    # This method is called to create all the widgets, place them in the GUI,
    # and define the event handlers for the application.
    def buildWindow(self):
        
        self.configArray = self.engine.getUserConfig(self.user["userId"])

        self.penColorDB = self.configArray[1]
        self.fillColorDB = self.configArray[2]
        self.radiusDB = self.configArray[4]
        self.widthDB = self.configArray[3]

        # The master is the root window. The title is set as below. 
        self.master.title("Untitled - Usuario: %s" % (self.user["username"]))
        # Here is how to create a menu bar. The tearoff=0 means that menus
        # can't be separated from the window which is a feature of tkinter.
        bar = tkinter.Menu(self.master)
        fileMenu = tkinter.Menu(bar,tearoff=0)
        
        # This code is called by the "New" menu item below when it is selected.
        # The same applies for loadFile, addToFile, and saveFile below. The 
        # "Exit" menu item below calls quit on the "master" or root window. 
        def newWindow():
            # This sets up the turtle to be ready for a new picture to be 
            # drawn. It also sets the sequence back to empty. It is necessary
            # for the graphicsCommands sequence to be in the object (i.e. 
            # self.graphicsCommands) because otherwise the statement:
            # graphicsCommands = PyList()
            # would make this variable a local variable in the newWindow 
            # method. If it were local, it would not be set anymore once the
            # newWindow method returned.
            theTurtle.clear()
            theTurtle.penup()
            theTurtle.goto(0,0)
            theTurtle.pendown()  
            screen.update()
            screen.listen()
            self.currentDraw = {}
            updateTitle()
            self.graphicsCommands = PyList()
            
        fileMenu.add_command(label="New",command=newWindow)

        # The parse function adds the contents of an json file to the sequence.
        def parse(drawJsonStr):
            drawJSON = json.loads(drawJsonStr)
            
            for commandElement in drawJSON["GraphicsCommands"]:
                command = commandElement["command"]
                attr = commandElement
                if command == "GoTo":
                    x = float(attr["x"])
                    y = float(attr["y"])
                    width = float(attr["width"])
                    color = attr["color"].strip()
                    cmd = GoToCommand(x,y,width,color)
        
                elif command == "Circle":
                    radius = float(attr["radius"])
                    width = float(attr["width"])
                    color = attr["color"].strip()
                    cmd = CircleCommand(radius,width,color)
        
                elif command == "BeginFill":
                    color = attr["color"].strip()
                    cmd = BeginFillCommand(color)
        
                elif command == "EndFill":
                    cmd = EndFillCommand()
                    
                elif command == "PenUp":
                    cmd = PenUpCommand()
                    
                elif command == "PenDown":
                    cmd = PenDownCommand()
                else:
                    raise RuntimeError("Unknown Command: " + command) 
        
                self.graphicsCommands.append(cmd)
        
        #Guardar los dibujos
        def saveFileButton():
            drawJson = createJson()

            if("id" in self.currentDraw):
                self.engine.updateDraw(self.currentDraw["id"], drawJson)
            else:
                SaveFile(self.user["userId"], drawJson, newDrawSave)

        def saveAsFileButton():
            drawJson = createJson()
            self.currentDraw = {}
            SaveFile(self.user["userId"], drawJson, newDrawSave)

        #Abrir los dibujos
        def loadFileButton():
            #result es una lista de tuplas que representan un dibujo como (id, nombre)
            result = self.engine.getDraws(self.user["userId"])
            LoadFile(self, result, updateDrawScreen,"load")
            
        #Actualizar la pantalla de dibujo
        def updateDrawScreen(drawID, name):        
            if type(name) != str : 
                name = name.decode("utf-8")    
            drawJson = self.engine.getDrawByID(drawID)
            if type(drawJson) != str : 
                drawJson = drawJson.decode("utf-8")

            
            self.currentDraw = {
                "id" : drawID,
                "name" : name,
                "fileJson" : json.dumps(json.loads(drawJson))
            }
            
            
            #Vacia el dibujo 
            updateTitle()
            newWindow()            
            self.graphicsCommands = PyList()
            parse(drawJson)
               
            #Hace el dibujo   
            for cmd in self.graphicsCommands:
                cmd.draw(theTurtle)
            
            #Actualiza la interfaz del dibujo
            screen.update()
            
        fileMenu.add_command(label="Load",command=loadFileButton)

        def newDrawSave(nameDraw, userID, drawJson):
            drawID = self.engine.insertDraw(nameDraw, userID, drawJson)
            if(drawID != 0):                
                self.currentDraw = {
                    "id" : drawID,
                    "name" : nameDraw,
                    "fileJson" : drawJson
                }
                updateTitle()
                return drawID
            else:
                return False


        fileMenu.add_command(label="Save",command=saveFileButton)

        fileMenu.add_command(label="Save as",command=saveAsFileButton)

        def download(drawID):
            drawJson = self.engine.getDrawByID(drawID)
            filename = tkinter.filedialog.asksaveasfilename(title="Save Picture As...")
            filename = "%s.json" % filename    
            jsonConvert = json.loads(drawJson)
            jsonStr = str(json.dumps(jsonConvert))
            file = open(filename, "w")
            file.write(jsonStr)
            file.close() 


        def downloadButton():
            result = self.engine.getDraws(self.user["userId"])
            LoadFile(self, result, download,"download") 

           
        fileMenu.add_command(label="Download",command=downloadButton)
        
        #Ventana de administrador 
        if self.adminState:

            def adminMgmt():
                Admin(self,self.engine)

            fileMenu.add_command(label="Configure",command=adminMgmt)

        # The write function writes an Json file to the given filename
        def createJson():
            jsonDraw = {"GraphicsCommands":[]}
            
            for cmd in self.graphicsCommands:
                jsonstring = str(cmd)
                jsoncommand = json.loads(jsonstring)
                jsonDraw["GraphicsCommands"].append(jsoncommand)
              
            return json.dumps(jsonDraw)

        def updateTitle():
            self.master.title("%s - Usuario: %s" % (
                self.currentDraw["name"] if "name" in self.currentDraw else "Untitled",
                self.user["username"]
            ))


        #fileMenu.add_command(label="Exit",command=self.master.quit)

        bar.add_cascade(label="File",menu=fileMenu)
        
        # This tells the root window to display the newly created menu bar.
        self.master.config(menu=bar)    
        
        # Here several widgets are created. The canvas is the drawing area on 
        # the left side of the window. 
        canvas = tkinter.Canvas(self,width=600,height=600)
        canvas.pack(side=tkinter.LEFT)
        
        # By creating a RawTurtle, we can have the turtle draw on this canvas. 
        # Otherwise, a RawTurtle and a Turtle are exactly the same.
        theTurtle = turtle.RawTurtle(canvas)
        
        # This makes the shape of the turtle a circle. 
        theTurtle.shape("circle")
        screen = theTurtle.getscreen()
        
        # This causes the application to not update the screen unless 
        # screen.update() is called. This is necessary for the ondrag event
        # handler below. Without it, the program bombs after dragging the 
        # turtle around for a while.
        screen.tracer(0)
    
        # This is the area on the right side of the window where all the 
        # buttons, labels, and entry boxes are located. The pad creates some empty 
        # space around the side. The side puts the sideBar on the right side of the 
        # this frame. The fill tells it to fill in all space available on the right
        # side. 
        sideBar = tkinter.Frame(self,padx=5,pady=5)
        sideBar.pack(side=tkinter.RIGHT, fill=tkinter.BOTH)
        
        # This is a label widget. Packing it puts it at the top of the sidebar.
        pointLabel = tkinter.Label(sideBar,text="Width")
        pointLabel.pack()

        
        def configHandler(event=None):
            
            patternColor = r"^#[a-fA-F0-9]{6}$" 
            resultPenColor = re.match(patternColor,penEntry.get())
            resultFillColor = re.match(patternColor,fillEntry.get())
      
            patterNumberSize = r"^\d+$"

            resultRadius = re.match(patterNumberSize,radiusEntry.get())
            resultWidth = re.match(patterNumberSize,widthEntry.get())

            if resultPenColor and resultFillColor and resultRadius and resultWidth:
                self.engine.updateUserConfigByUser([self.user["userId"],penEntry.get(),fillEntry.get(),radiusEntry.get(),widthEntry.get()])
            else:
                print("Valores de la configuracion incompletos")


        
        # This entry widget allows the user to pick a width for their lines. 
        # With the widthSize variable below you can write widthSize.get() to get
        # the contents of the entry widget and widthSize.set(val) to set the value
        # of the entry widget to val. Initially the widthSize is set to 1. str(1) is 
        # needed because the entry widget must be given a string. 

        widthSize = tkinter.StringVar()
        widthEntry = tkinter.Entry(sideBar,textvariable=widthSize)
        widthEntry.bind("<KeyRelease>", configHandler) #keyup 
        widthEntry.pack()
        widthSize.set(str(self.widthDB))
        


        radiusLabel = tkinter.Label(sideBar,text="Radius")
        radiusLabel.pack()
        radiusSize = tkinter.StringVar()
        radiusEntry = tkinter.Entry(sideBar,textvariable=radiusSize)
        radiusEntry.bind("<KeyRelease>", configHandler) #keyup 
        radiusSize.set(str(self.radiusDB))
        radiusEntry.pack()
        
        # A button widget calls an event handler when it is pressed. The circleHandler
        # function below is the event handler when the Draw Circle button is pressed. 
        def circleHandler():
            # When drawing, a command is created and then the command is drawn by calling
            # the draw method. Adding the command to the graphicsCommands sequence means the
            # application will remember the picture. 
            cmd = CircleCommand(float(radiusSize.get()), float(widthSize.get()), penColor.get())
            cmd.draw(theTurtle)
            self.graphicsCommands.append(cmd)
            
            # These two lines are needed to update the screen and to put the focus back
            # in the drawing canvas. This is necessary because when pressing "u" to undo,
            # the screen must have focus to receive the key press. 
            screen.update()
            screen.listen()
        
        # This creates the button widget in the sideBar. The fill=tkinter.BOTH causes the button
        # to expand to fill the entire width of the sideBar.
        circleButton = tkinter.Button(sideBar, text = "Draw Circle", command=circleHandler)
        circleButton.pack(fill=tkinter.BOTH)             

        # The color mode 255 below allows colors to be specified in RGB form (i.e. Red/
        # Green/Blue). The mode allows the Red value to be set by a two digit hexadecimal
        # number ranging from 00-FF. The same applies for Blue and Green values. The 
        # color choosers below return a string representing the selected color and a slice
        # is taken to extract the #RRGGBB hexadecimal string that the color choosers return.

        screen.colormode(255)
        penLabel = tkinter.Label(sideBar,text="Pen Color")
        penLabel.pack()
        penColor = tkinter.StringVar()
        penEntry = tkinter.Entry(sideBar,textvariable=penColor)
        penEntry.bind("<KeyRelease>", configHandler) #keyup 
        penEntry.pack()
        # This is the color black.
        penColor.set(self.penColorDB)  

       
        def getPenColor():
            color = tkinter.colorchooser.askcolor()
            if color != None:
                penColor.set(str(color)[-9:-2])
                configHandler()

            
        penColorButton = tkinter.Button(sideBar, text = "Pick Pen Color", command=getPenColor)
        penColorButton.pack(fill=tkinter.BOTH)           
            

        fillLabel = tkinter.Label(sideBar,text="Fill Color")
        fillLabel.pack()
        fillColor = tkinter.StringVar()
        fillEntry = tkinter.Entry(sideBar,textvariable=fillColor)
        fillEntry.bind("<KeyRelease>", configHandler) #keyup 
        fillEntry.pack()
        fillColor.set(self.fillColorDB)     
        
        def getFillColor():
            color = tkinter.colorchooser.askcolor()
            if color != None:  
                fillColor.set(str(color)[-9:-2])       
                configHandler()  
   
        fillColorButton = \
            tkinter.Button(sideBar, text = "Pick Fill Color", command=getFillColor)
        fillColorButton.pack(fill=tkinter.BOTH) 


        def beginFillHandler():
            cmd = BeginFillCommand(fillColor.get())
            cmd.draw(theTurtle)
            self.graphicsCommands.append(cmd)
            
        beginFillButton = tkinter.Button(sideBar, text = "Begin Fill", command=beginFillHandler)
        beginFillButton.pack(fill=tkinter.BOTH) 
        
        def endFillHandler():
            cmd = EndFillCommand()
            cmd.draw(theTurtle)
            self.graphicsCommands.append(cmd)
            
        endFillButton = tkinter.Button(sideBar, text = "End Fill", command=endFillHandler)
        endFillButton.pack(fill=tkinter.BOTH) 
 
        penLabel = tkinter.Label(sideBar,text="Pen Is Down")
        penLabel.pack()
        
        def penUpHandler():
            cmd = PenUpCommand()
            cmd.draw(theTurtle)
            penLabel.configure(text="Pen Is Up")
            self.graphicsCommands.append(cmd)

        penUpButton = tkinter.Button(sideBar, text = "Pen Up", command=penUpHandler)
        penUpButton.pack(fill=tkinter.BOTH) 
       
        def penDownHandler():
            cmd = PenDownCommand()
            cmd.draw(theTurtle)
            penLabel.configure(text="Pen Is Down")
            self.graphicsCommands.append(cmd)

        penDownButton = tkinter.Button(sideBar, text = "Pen Down", command=penDownHandler)
        penDownButton.pack(fill=tkinter.BOTH)          

        # Here is another event handler. This one handles mouse clicks on the screen.
        def clickHandler(x,y): 
            # When a mouse click occurs, get the widthSize entry value and set the width of the 
            # pen to the widthSize value. The float(widthSize.get()) is needed because
            # the width is an integer, but the entry widget stores it as a string.
            cmd = GoToCommand(x,y,float(widthSize.get()),penColor.get())
            cmd.draw(theTurtle)
            self.graphicsCommands.append(cmd)          
            screen.update()
            screen.listen()
           
        # Here is how we tie the clickHandler to mouse clicks.
        screen.onclick(clickHandler)  
        
        def dragHandler(x,y):
            cmd = GoToCommand(x,y,float(widthSize.get()),penColor.get())
            cmd.draw(theTurtle)
            self.graphicsCommands.append(cmd)  
            screen.update()
            screen.listen()
            
        theTurtle.ondrag(dragHandler)
        
        # the undoHandler undoes the last command by removing it from the 
        # sequence and then redrawing the entire picture. 
        def undoHandler():
            if len(self.graphicsCommands) > 0:
                self.graphicsCommands.removeLast()
                theTurtle.clear()
                theTurtle.penup()
                theTurtle.goto(0,0)
                theTurtle.pendown()
                for cmd in self.graphicsCommands:
                    cmd.draw(theTurtle)
                screen.update()
                screen.listen()
                
        screen.onkeypress(undoHandler, "u")
        screen.listen()
   
# The main function in our GUI program is very simple. It creates the 
# root window. Then it creates the DrawingApplication frame which creates 
# all the widgets and has the logic for the event handlers. Calling mainloop
# on the frames makes it start listening for events. The mainloop function will 
# return when the application is exited. 
def main():
    root = tkinter.Tk()  
    drawingApp = DrawingApplication(root)  
    drawingApp.mainloop()


