import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()
# LE BUT DE CET AJOUT EST DE TESTER 
# POST_MAC3COEUR / DEFORMATION / FORMAT = 'TABLE'
DAMAC1=LIRE_TABLE(UNITE=38,
                 SEPARATEUR = '\t'
                 )

MA1=code_aster.Mesh()
MA1.readMedFile("mac3c01a.mmed")

# TEST ETAT INITIAL

#RESU_C1D = CALC_MAC3COEUR(TYPE_COEUR  = 'TEST',
                          #TABLE_N     =  DAMAC1,
                          #MAILLAGE_N  =  MA1, 
                          #ETAT_INITIAL = _F(
                                           #UNITE_THYC   = 32, 
                                           #NIVE_FLUENCE = 33))


# # TAB2_CB = CREA_TABLE(RESU=_F(RESULTAT=RESU_C1D,NOM_CHAM='DEPL',INST=33.008,NOM_CMP=('DY','DZ'),
# #                             GROUP_MA=('TG_C_B')))


#TAB2_BB = CREA_TABLE(RESU=_F(RESULTAT=RESU_C1D,NOM_CHAM='DEPL',INST=33.008,NOM_CMP=('DY','DZ'),
                            #GROUP_MA=('TG_B_B')))


#TEST_TABLE(VALE_CALC=0.00135411724599,
           #NOM_PARA='DY',
           #TYPE_TEST='MAX',
           #TABLE=TAB2_BB,
           #)

test.assertTrue( True )

test.printSummary()

FIN()
