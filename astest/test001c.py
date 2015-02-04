#!/usr/bin/python

import code_aster

# Creation du maillage
monMaillage = code_aster.Mesh()

# test de relecture d'un fichier Gmsh
monMaillage.readGmshFile("ssnv187a.msh")

# test du format Gibi
mtest = code_aster.Mesh()
mtest.readGibiFile("zzzz364a.mgib")

coord = monMaillage.getCoordinates()

#help(coord)

# Acces uniquement en lecture verifie !
print "coord[3] ",coord[3]

try:
    coord[3] = 5.0
except:
    print "coord is read-only"

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

print "Ecrasement de monMaillage !! L'objet C++ ne doit pas etre supprime"
del monMaillage
# On force python a supprimer cet objet !!! Sinon, il ne le fait pas en presence du try except precedent
try:
    monMaillage.getCoordinates()
except:
    pass

print "Ecrasement de monModel"
monModel = 1

print "coord[3] doit toujours etre accessible : ",coord[3]

print "Fin"
