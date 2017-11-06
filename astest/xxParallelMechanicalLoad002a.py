#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

pMesh2 = code_aster.ParallelMesh.create()
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

b = code_aster.PartialMesh.create(pMesh2, ["COTE_B", "COTE_H"])

a = code_aster.PartialMesh.create(pMesh2, ["A", "B"])

model1 = AFFE_MODELE(MAILLAGE=a,
                     AFFE=_F(TOUT='OUI',
                             PHENOMENE='MECANIQUE',
                             MODELISATION='DIS_TR',),
                     DISTRIBUTION=_F(METHODE='CENTRALISE',),)

char_meca1 = AFFE_CHAR_MECA(MODELE=model1,
                            LIAISON_DDL=_F(GROUP_NO=("A", "B"),
                                           DDL=('DX','DX'),
                                           COEF_MULT=(1.0,-1.0),
                                           COEF_IMPO=0,),
                            DDL_IMPO=_F(GROUP_NO="A",DX=1.0))

char_meca = code_aster.ParallelMechanicalLoad.create(char_meca1, model)
#char_meca.debugPrint(10+rank)

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

resu.printMedFile("test"+str(rank)+".med")
