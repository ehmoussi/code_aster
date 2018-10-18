#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

model = AFFE_MODELE( MAILLAGE = mail1,
                     AFFE = _F( MODELISATION = "3D",
                                PHENOMENE = "MECANIQUE",
                                TOUT = "OUI", ), )

MATER1 = DEFI_MATERIAU( ELAS = _F( E = 200000.0,
                                   NU = 0.3, ), )

AFFMAT = AFFE_MATERIAU( MAILLAGE = mail1,
                        AFFE = _F( TOUT = 'OUI',
                                   MATER = MATER1, ), )

load = AFFE_CHAR_CINE( MODELE = model,
                       MECA_IMPO = ( _F( GROUP_MA = "Bas", DX = 0. ),
                                     _F( GROUP_MA = "Bas", DY = 0. ),
                                     _F( GROUP_MA = "Bas", DZ = 0. ), ), )

load2 = AFFE_CHAR_CINE( MODELE = model,
                        MECA_IMPO = ( _F( GROUP_MA = "Haut", DZ = 1. ), ), )

resu = MECA_STATIQUE( MODELE = model,
                      CHAM_MATER = AFFMAT,
                      EXCIT = ( _F( CHARGE = load, ),
                                _F( CHARGE = load2, ), ),
                      SOLVEUR = _F( METHODE = "MUMPS",
                                    RENUM = "METIS", ), )

resu=CALC_CHAMP(reuse=resu,
                RESULTAT=resu,TOUT_ORDRE='OUI',
                CONTRAINTE=('SIGM_ELNO'),
                )

# Debut du TEST_RESU
z=mail1.getCoordinates()
x=z.EXTR_COMP(topo=1)
test.assertAlmostEqual(x.valeurs.sum(), 40.5)
test.assertEqual(x.comp[0:3],('X', 'Y', 'Z'))
test.assertEqual(x.noeud[-3:],(27, 27, 27))


MyFieldOnElements = resu.getRealFieldOnElements("SIGM_ELNO", 1)
z=MyFieldOnElements.EXTR_COMP('SIXX',topo=1)
test.assertEqual(len(z.valeurs), 64)

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
#sfon.debugPrint()
sfon.updateValuePointers()

test.assertAlmostEqual(sfon.getValue(5, 3), -0.159403241003)

resu2 = CREA_RESU(OPERATION = 'AFFE',
                 TYPE_RESU = 'EVOL_ELAS',
                 NOM_CHAM = 'DEPL',
                 AFFE = _F(CHAM_GD = MyFieldOnNodes,
                           MODELE = model,
                           CHAM_MATER = AFFMAT,
                           INST=0.,
                           )
                 )
resu2.listFields()
dispField=resu2.getRealFieldOnNodes("DEPL", 1)
test.assertEqual(MyFieldOnNodes.EXTR_COMP().valeurs.sum(), dispField.EXTR_COMP().valeurs.sum())

IMPR_JEVEUX ( ENTITE='MEMOIRE' )


test.printSummary()
# Fin du TEST_RESU

FIN()
