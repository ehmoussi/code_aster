#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMesh001a")
rank = code_aster.getMPIRank()

model = AFFE_MODELE(MAILLAGE = pMesh2,
                    AFFE = _F(MODELISATION = "3D",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),
                    DISTRIBUTION=_F(METHODE='CENTRALISE',),)

char_cin = AFFE_CHAR_CINE(MODELE=model,
                          MECA_IMPO=_F(GROUP_NO="COTE_H",
                                       DX=0.,DY=0.,DZ=0.,),)

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           LIAISON_DDL=_F(GROUP_NO=("A", "B"),
                                          DDL=('DX','DX'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           DDL_IMPO=_F(GROUP_NO="A",DX=1.0))
char_meca.debugPrint(10+rank)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

resu = MECA_STATIQUE(CHAM_MATER=AFFMAT,
                     MODELE=model,
                     EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_meca,),),
                     SOLVEUR=_F(METHODE='PETSC',
                                PRE_COND='SANS',
                                RESI_RELA=1.E-10,),)
resu.debugPrint(10+rank)

resu.printMedFile("test"+str(rank)+".med")

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
sfon.debugPrint(10+rank)
sfon.updateValuePointers()

value = [1., 1., 0., 0.]
test.assertAlmostEqual(sfon.getValue(0, 0), value[rank])
value = [0.0712953407513, 0.0609114486676, -0.00116776983364, 0.000584732584462]
test.assertAlmostEqual(sfon.getValue(240, 0), value[rank])

test.printSummary()
