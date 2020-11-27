# -*- coding: utf-8 -*-
"""
    Ejemplo mediante POO y BD, para el uso del Select en Python.
    @author geescobar@unah.hn
    @version 0.1
    @date 2020/11/26
"""

from ConnectionConfig import ConnectionConfig
from MySQLEngine import MySQLEngine

config = ConnectionConfig("localhost", "3306", "root", "root", "Example")

engine = MySQLEngine(config)
result = engine.select("SELECT * FROM CountMonth2020")
for month, count in result:
    print("Registro: %s, %s" % (month, count))

engine = MySQLEngine(config)
result = engine.select("SELECT * FROM CountByDayOnNovember2020")
for hour, count in result:
    print("Registro: %s, %s" % (hour, count))
