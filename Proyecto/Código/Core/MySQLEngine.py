import mysql.connector
import gzip
class MySQLEngine:

    def __init__(self, config):
        self.server = config.server
        self.port = config.port
        self.user = config.user
        self.password = config.password
        self.database = config.database

        self.start()

    def start(self):
        self.con = mysql.connector.connect(
            host = self.server,
            port = self.port,
            user = self.user,
            password = self.password,
            database = self.database
        )

        #Enlace
        self.link = self.con.cursor()
    
    def select(self, query=""):
        self.link.execute(query)

        return self.link.fetchall()

    def insert(self, tableName, argsList = [], dataElement = ()):
        tupleStr = []
        for _ in range(len(dataElement)):
            tupleStr.append("%s")

        addElement = "INSERT INTO %s (%s) VALUES (%s)" % (tableName, ",".join(argsList), ",".join(tupleStr) )

        self.link.execute(addElement, dataElement)
        elementId = self.link.lastrowid
        self.con.commit()
        return elementId

    def update(self, elementID, tableName, argsList = [], dataList = []):
        updateList = []
        for i in range(len(dataList)):
            updateList.append("%s = %s" % (argsList[i], dataList[i]))

        updateSQL = "UPDATE %s SET %s WHERE id = %s" % (tableName, ",".join(updateList), elementID)
        try:
            self.link.execute(updateSQL)
            self.con.commit()
            return True
        except:
            print("Error durante la actualización")
            return False

    def generalCallProcedure(self, procedureName, argsList):
        result_args = self.link.callproc(procedureName, argsList)
        return result_args[-1]

    def insertDraw(self, name, userId, drawJson):
        compressJson = gzip.compress(bytes(drawJson,'utf-8'))
        #print('-'*30)
        #print(compressJson)
        #print('-'*30)
        result = self.generalCallProcedure("CreateDrawing_SP", [name, userId, drawJson, drawJson, "@drawID"])
        print(result)
        return result

    def getDraws(self, userId):
        result = self.select("SELECT Drawing.id, AES_DECRYPT(UNHEX(Drawing.txt_fileName),'root') FROM Drawing JOIN Account ON Drawing.accountId=Account.id WHERE Account.id=%s" % userId)
        return result

    def getOperatorUser(self):
        result = self.select("SELECT * FROM OperatorUsers")
        return result

    def getDrawByID(self, drawID):
        result = self.generalCallProcedure("GetDrawingByID_SP", [drawID, '@drawing_json'])
        return result

    def updateDraw(self, drawID, drawJson):
        compressJson = gzip.compress(bytes(drawJson,'utf-8'))
        self.generalCallProcedure("UpdateDrawingByID_SP", [drawID, drawJson, drawJson])

        
    def loginUser(self, userAcc, passwordAcc):
        userID = self.generalCallProcedure('Auth_SP',[userAcc, passwordAcc, '@userID'])
        admin = self.generalCallProcedure('GetRole_SP',[userAcc, passwordAcc, '@userID'])
        return (userID, admin)

    def getUserConfig(self,userID):
        configID,penColor,fillColor,width,radius,userID = self.select("SELECT id, AES_DECRYPT(UNHEX(txt_penColor), 'root'), AES_DECRYPT(UNHEX(txt_fillColor), 'root'), AES_DECRYPT(UNHEX(int_width), 'root'), AES_DECRYPT(UNHEX(int_radius), 'root'), accountId FROM Config WHERE accountId=%s" % userID)[0]
        if( type(penColor) != str ):
            penColor= penColor.decode("utf-8")    
        if( type(fillColor) != str ):
            fillColor= fillColor.decode("utf-8")    
        if( type(width) != str ):
            width= width.decode("utf-8")
        if( type(radius) != str ):    
            radius= radius.decode("utf-8")    

        return (configID,penColor,fillColor,width,radius,userID)

    def updateUserConfigByAdmin(self, configValues):
        self.generalCallProcedure('UpdateConfigByAdmin_SP', configValues)

    def createOperatorUser(self, username, password):
        return self.generalCallProcedure('AddAccount_SP', [username, password, '@exist'])

    def updateOperatorUser(self, userID, username, password):
        return self.generalCallProcedure('UpdateAccount_SP', [userID, username, password, '@exist'])

    def updateUserConfigByUser(self, configValues):
        self.generalCallProcedure('UpdateConfigByUser_SP', configValues)
    
    def deleteDrawByID(self, drawID):
        self.generalCallProcedure('DeleteDrawingByID_SP', [drawID])

    def deleteUserByID(self, userID):
        self.generalCallProcedure('DeleteAccountByID_SP',[userID])
