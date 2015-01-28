#!/usr/bin/python
# coding: utf-8

import code_aster

# Creation du maillage
mesh = code_aster.Mesh()

# Relecture du fichier MED
mesh.readMEDFile("test001a.mmed")
# mesh.readMEDFile("epicu01b.mail.med")

#help(mesh)

coord = mesh.getCoordinates()

#help(coord)

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
    model2.addElementaryModeling(code_aster.Thermal, code_aster.DKT)
except Exception as e:
    print e


# Verification du comptage de référence sur le maillage
del mesh

mesh2 = model.getSupportMesh()
assert mesh2.hasGroupOfElements('Tout')
