# -*- coding: utf-8 -*-
from Core.ConnectionConfig import ConnectionConfig
from Core.MySQLEngine import MySQLEngine
from Core.Login import Login
from configparser import ConfigParser
import os

config = ConfigParser()
config.read(os.path.join(os.path.dirname(__file__), 'Core', 'config.ini'))
config.read('.core/config.ini')

host = config['mysql']['host']
port = config['mysql']['port']
user = config['mysql']['user']
password = config['mysql']['password']
database = config['mysql']['database']


sqlConfig = ConnectionConfig(host, port, user, password, database)
engine = MySQLEngine(sqlConfig)

window = Login(engine)
window.login.mainloop()