# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

rank = code_aster.getMPIRank()

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMechanicalLoad001h")

model = AFFE_MODELE(MAILLAGE = pMesh2,
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
                                          )
char_meca2 = AFFE_CHAR_MECA(MODELE=model,
                            FORCE_NODALE=_F(GROUP_NO="N3",FX=10000.0)
                                          )
char_meca.debugPrint(10+rank)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

resu = MECA_STATIQUE(CHAM_MATER=AFFMAT,
                     MODELE=model,
                     CARA_ELEM=cara_elem,
                     EXCIT=(_F(CHARGE=char_meca),
                            _F(CHARGE=char_meca2),),
                     SOLVEUR=_F(METHODE='PETSC',
                                PRE_COND='SANS',
                                RESI_RELA=1.E-10,),)
resu.debugPrint(10+rank)

resu.printMedFile("test"+str(rank)+".med")
#from shutil import copyfile
#copyfile("test"+str(rank)+".med", "/home/siavelis/test"+str(rank)+".med")

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
sfon.debugPrint(10+rank)
sfon.updateValuePointers()

# DX displacement on nodes "N1" and "N3", comparison with sequential results
if rank == 0:
    test.assertAlmostEqual(sfon.getValue(0, 0), 0.0)
elif rank == 1:
    test.assertAlmostEqual(sfon.getValue(0, 0), 0.5305164769729844)

FIN()
