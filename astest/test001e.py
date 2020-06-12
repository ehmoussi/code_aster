
import code_aster
code_aster.init()

test = code_aster.TestCase()

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001f.mmed")

# Definition du modele Aster
monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh(code_aster.Physics.Mechanics,
                              code_aster.Modelings.Tridimensional)

monModel.build()

charCine = code_aster.KinematicsMechanicalLoad()
charCine.setModel(monModel)
charCine.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dx,
                                           0., "Bas")
test.assertEqual( charCine.getType(), "CHAR_CINE_MECA" )

# Impossible d'affecter un blocage en temperature sur un DEPL
with test.assertRaises( RuntimeError ):
    charCine.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Temp,
                                               0., "Haut")

charCine.build()

code_aster.close()
