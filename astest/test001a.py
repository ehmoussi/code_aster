#!/usr/bin/python
# coding: utf-8

import code_aster

# Creation du maillage
mesh = code_aster.Mesh()
# help(mesh)

# Relecture du fichier MED
mesh.readMedFile("test001a.mmed")
# mesh.readMedFile("epicu01b.mail.med")

coord = mesh.getCoordinates()
# help(coord)

# test impression au format MED
#TODO only field named with 8 chars can currently be printed
# coord.printMEDFile( "coord.med" )
#import os.path as osp
# assert osp.isfile( "coord.med" )

# Acces uniquement en lecture verifie !
print "coord[3] ",coord[3]

try:
    coord[3] = 5.0
except:
    print "coord is read-only"

# Definition du modele Aster
model = code_aster.Model()
model.setSupportMesh(mesh)
model.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

model.build()

# Definition du modele Aster
model2 = code_aster.Model()
model2.setSupportMesh(mesh)
try:
    model2.addModelingOnAllMesh(code_aster.Thermal, code_aster.DKT)
except Exception as e:
    print e


# Verification du comptage de référence sur le maillage
del mesh

mesh2 = model.getSupportMesh()
assert mesh2.hasGroupOfElements('Tout')

# Vérification du debug
mesh2.debugPrint()
