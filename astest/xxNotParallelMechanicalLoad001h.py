#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

rank = code_aster.getMPIRank()

Mesh2 = code_aster.Mesh()
Mesh2.readMedFile("xxNotParallelMechanicalLoad001h.med")

model = AFFE_MODELE(MAILLAGE = Mesh2,
                    AFFE = _F(MODELISATION = "POU_D_T",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),
                    DISTRIBUTION=_F(METHODE='CENTRALISE',),)

cara_elem =AFFE_CARA_ELEM(MODELE=model,
                          POUTRE=_F(GROUP_MA='poutre',
                                    SECTION='CERCLE',
                                    CARA='R', VALE=0.3,),
                          )

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           DDL_POUTRE=_F(ANGL_VRIL=0.0, DX=0.0, DY=0.0, DZ=0.0, GROUP_NO='N1'),
                           FORCE_NODALE=_F(GROUP_NO="N3",FX=10000.0)
                           )

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=Mesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

resu = MECA_STATIQUE(CHAM_MATER=AFFMAT,
                     MODELE=model,
                     CARA_ELEM=cara_elem,
                     EXCIT=(_F(CHARGE=char_meca,),),
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


test.assertAlmostEqual(sfon.getValue(0, 0), 0.5305164769729844)
test.assertAlmostEqual(sfon.getValue(1, 0), 0.0)
