#!/usr/bin/python

import code_aster
test = code_aster.TestCase()

# Creation du maillage
monMaillage = code_aster.Mesh()

# test de relecture d'un fichier Gmsh
monMaillage.readGmshFile("ssnv187a.msh")

# test du format Gibi
mtest = code_aster.Mesh()
mtest.readGibiFile("zzzz364a.mgib")

coord = monMaillage.getCoordinates()

# check readonly access
print "coord[3] ", coord[3]
test.assertEqual( coord[3], 1.0 )

with test.assertRaises(TypeError):
    coord[3] = 5.0

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

# delete monMaillage and check that the C++ object still exists because
# referenced by the model object
del monMaillage
with test.assertRaises(NameError):
    monMaillage.getCoordinates()

# delete/overwrite monModel, coord object still exists
monModel = 1
test.assertEqual( coord[3], 1.0 )

test.printSummary()
