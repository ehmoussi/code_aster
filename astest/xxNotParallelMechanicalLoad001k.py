# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

rank = code_aster.getMPIRank()

Mesh2 = code_aster.Mesh()
Mesh2.readMedFile("xxNotParallelMechanicalLoad001i.med")

model = AFFE_MODELE(MAILLAGE = Mesh2,
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
                           LIAISON_DDL=_F(GROUP_NO=("N1", "N3"),
                                          DDL=('DX','DX'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           ROTATION=_F(VITESSE=3.0,
                                        AXE=(0.0, 0.0, 1.0),),
                           )

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               RHO=1000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=Mesh2,
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

resu.printMedFile("test.med")
#from shutil import copyfile
#copyfile("test.med", "/home/siavelis/test.med")

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
sfon.debugPrint(10+rank)
sfon.updateValuePointers()


test.assertAlmostEqual(sfon.getValue(2, 0), 0.24803723404255318)
test.assertAlmostEqual(sfon.getValue(3, 0), 0.24803723404255318)

FIN()
