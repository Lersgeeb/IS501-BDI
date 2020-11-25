# -*- coding: utf-8 -*-
"""
    Ejemplo mediante POO y BD, para el uso del Select en Python.
    @author geescobar@unah.hn
    @version 0.1
    @date 2020/11/25
"""

from ConnectionConfig import ConnectionConfig
from MySQLEngine import MySQLEngine

config = ConnectionConfig("localhost", "3306", "root", "root", "Example")
engine = MySQLEngine(config)
first10 =engine.select("SELECT * FROM Measure ORDER BY id ASC LIMIT 10")
last10 =engine.select("SELECT * FROM Measure ORDER BY id DESC LIMIT 10")

for id, device, temperature, date in first10:
    print("Registro: %s, %s, %s, %s" % (id, device, temperature, date ))

for id, device, temperature, date in last10:
    print("Registro: %s, %s, %s, %s" % (id, device, temperature, date ))
