# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

rank = code_aster.getMPIRank()

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMechanicalLoad003a")

model = AFFE_MODELE(MAILLAGE = pMesh2,
                    AFFE = _F(MODELISATION = "D_PLAN",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),
                    DISTRIBUTION=_F(METHODE='CENTRALISE',),)

char_cin = AFFE_CHAR_CINE(MODELE=model,
                          MECA_IMPO=(_F(GROUP_NO="N2",
                                        DX=0.,DY=0.,DZ=0.,),
                                     _F(GROUP_NO="N4",
                                        DX=0.,DY=0.,DZ=0.,),),)

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           LIAISON_DDL=_F(GROUP_NO=("N3", "N5"),
                                          DDL=('DX','DY'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           DDL_IMPO=_F(GROUP_NO="N3",DX=1.0))
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
                                PRE_COND='SANS',),)
resu.debugPrint(10+rank)

resu.printMedFile("test"+str(rank)+".med")

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
sfon.debugPrint(10+rank)
sfon.updateValuePointers()

resu1 = [0.6980073863837113, 1.0]
test.assertAlmostEqual(sfon.getValue(1, 0), resu1[rank])
resu2 = [0.5461603079530792, 0.5461603079530792]
test.assertAlmostEqual(sfon.getValue(1, 2), resu2[rank])

FIN()
