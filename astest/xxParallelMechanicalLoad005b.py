#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

nProc = code_aster.getMPINumberOfProcs()

rank = code_aster.getMPIRank()

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMesh003a")

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
                           LIAISON_DDL=_F(GROUP_NO=("N1", "N3"),
                                          DDL=('DX','DX'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           DDL_IMPO=_F(GROUP_NO="N1",DX=1.0),)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

LI = DEFI_LIST_REEL(DEBUT=0.0,
                    INTERVALLE=_F(JUSQU_A=1.0, NOMBRE=1),)

resu = STAT_NON_LINE(CHAM_MATER=AFFMAT,
                     METHODE='NEWTON',
                     COMPORTEMENT=_F(RELATION='ELAS',),
                     CONVERGENCE=_F(RESI_GLOB_RELA=1.e-10,),
                     EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_meca,),),
                     INCREMENT=_F(LIST_INST=LI),
                     MODELE=model,
                     NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                     SOLVEUR=_F(METHODE='PETSC',RESI_RELA=1.e-8,PRE_COND='LDLT_SP'),)

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 2)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()

if rank == 0:
    test.assertAlmostEqual(sfon.getValue(0, 0), 1.0)
    test.assertAlmostEqual(sfon.getValue(2, 0), 0.5175556151165849)
elif rank == 1:
    test.assertAlmostEqual(sfon.getValue(0, 0), 1.0)
    test.assertAlmostEqual(sfon.getValue(1, 2), 0.5175556151165849)

FIN()
