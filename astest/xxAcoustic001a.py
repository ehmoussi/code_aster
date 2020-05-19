# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("xxContact001a.mmed")

MO2 = code_aster.Model(MA)
MO2.addModelingOnMesh(code_aster.Physics.Acoustic, code_aster.Modelings.Tridimensional)
MO2.build()

load = code_aster.AcousticLoad(MO2)
load.addImposedPressureOnGroupOfCells( ["FONDATION"], 1.+2.j )
load.addImposedNormalSpeedOnGroupOfCells( ["FONDATION"], 3.+4.j )
load.addImpedanceOnMesh( 5.+6.j )
load.build()
load.debugPrint(8)

# Test trivial
test.assertTrue( True )

FIN()
