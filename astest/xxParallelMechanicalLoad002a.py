# coding: utf-8

import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init()

import os

pMesh2 = code_aster.Mesh()
pMesh2.readMedFile("xxParallelMechanicalLoad002a.med")
DEFI_GROUP(reuse=pMesh2, MAILLAGE=pMesh2, CREA_GROUP_NO=_F(TOUT_GROUP_MA='OUI',))

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
                           DDL_IMPO=_F(GROUP_NO="A",DX=1.0),)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,
                               RHO=1.e-3,),)

char_vol=AFFE_CHAR_MECA(MODELE=model,
                        PESANTEUR=_F(GRAVITE=9.81,
                        DIRECTION=(0.,0.,-1.,),),)


AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

LI = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=1.0, NOMBRE=1),)

resu = STAT_NON_LINE(CHAM_MATER=AFFMAT,
                     METHODE='NEWTON',
                     COMPORTEMENT=_F(RELATION='ELAS',),
                     CONVERGENCE=_F(RESI_GLOB_RELA=1.e-8),
                     EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_vol,),
                            _F(CHARGE=char_meca,),
                            ),
                     INCREMENT=_F(LIST_INST=LI),
                     MODELE=model,
                     NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                     SOLVEUR=_F(METHODE='PETSC',RESI_RELA=1.e-5,PRE_COND='JACOBI'),)


#if (parallel):
   #rank = code_aster.getMPIRank()
   #myFile='par.txt'
   #os.system("sed 's/Mat_.*\=/par\ \=/g' /tmp/par.txt > /tmp/par_clean.txt && mv /tmp/par_clean.txt /tmp/par.txt")
   #if (rank==0): os.system( """grep -v %% /tmp/%s | grep -v zzz | grep -v \] | grep -v Mat | awk '{print $3}' | LANG=en_US.UTF-8  sort -g > /tmp/%s_sorted"""%(myFile,myFile) )
   #if (rank==0): os.system( """grep -v Object /tmp/rhs_par.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/rhs_par_sorted.txt  """)
   #if (rank==0): os.system( """grep -v Object /tmp/sol_par.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/sol_par_sorted.txt  """)
#else:
   #myFile='seq.txt'
   #os.system("sed 's/Mat_.*\=/seq\ \=/g' /tmp/seq.txt > /tmp/seq_clean.txt && mv /tmp/seq_clean.txt /tmp/seq.txt")
   #os.system("grep -v %% /tmp/%s | grep -v zzz | grep -v \] | grep -v Mat | awk '{print $3}' | LANG=en_US.UTF-8  sort -g > /tmp/%s_sorted"%(myFile,myFile))
   #os.system( """grep -v Object /tmp/rhs_seq.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/rhs_seq_sorted.txt  """)
   #os.system( """grep -v Object /tmp/sol_seq.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/sol_seq_sorted.txt  """)

#if (parallel):
    #rank = code_aster.getMPIRank()
    #if (rank==0): os.system( """cp fort.11 /tmp/ddl0.txt """ )
    #if (rank==1): os.system( """cp fort.12 /tmp/ddl1.txt """ )
    #if (rank==2): os.system( """cp fort.13 /tmp/ddl2.txt """ )
    #if (rank==3): os.system( """cp fort.14 /tmp/ddl3.txt """ )
#else:
    #os.system( """cp fort.11 /tmp/ddl_seq.txt """ )

# if parallel:
#     rank = code_aster.getMPIRank()
#     resu.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     resu.printMedFile('/tmp/seq.resu.med')

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 2)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()

test.assertAlmostEqual(sfon.getValue(0, 0), 0.0)
test.assertAlmostEqual(sfon.getValue(240, 0), 0.02832458511648515)

test.printSummary()

FIN()
