# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


# Mesh
mesh = code_aster.Mesh()
mesh.readMedFile("xxMechanicalLoad001a.mmed")


model = AFFE_MODELE(MAILLAGE=mesh,
                 AFFE=_F(TOUT='OUI',
                         PHENOMENE='THERMIQUE',
                         MODELISATION='PLAN',),)


thermal_load = AFFE_CHAR_THER(MODELE=model,
                              TEMP_IMPO=_F(TOUT="OUI",
                                           TEMP=1))

fct=DEFI_FONCTION(
                  NOM_PARA='ABSC',
                  ABSCISSE=(0.00000000000000E+00, 1.00000000000000E+00),
                  ORDONNEE=(1000., 1000.,),
                         )

thermal_load_f = AFFE_CHAR_THER_F(MODELE=model,
                                  TEMP_IMPO=_F(TOUT="OUI",
                                               TEMP=fct))


test.assertEqual(thermal_load.getType(), "CHAR_THER")
test.assertEqual(thermal_load_f.getType(), "CHAR_THER")


test.printSummary()

FIN()
