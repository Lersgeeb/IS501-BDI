import mysql.connector
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

        #versión texto de con
        print("Versión de texto del objeto de conexión a MySQL: %s" % (self.con))

        #Enlace
        self.link = self.con.cursor()
    
    def select(self, query=""):
        self.link.execute(query)

        return self.link.fetchall()
