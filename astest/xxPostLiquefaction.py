import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz403a.mmed")

MOD = AFFE_MODELE(MAILLAGE = MA,
                  AFFE     = (_F(TOUT='OUI',
                                 PHENOMENE    ='MECANIQUE',
                                 MODELISATION = 'D_PLAN_HM_SI',),),
                  VERI_JACOBIEN = 'NON',);

RESUREF = LIRE_RESU(TYPE_RESU  = 'EVOL_NOLI',
                    FORMAT     = 'MED',
                    MODELE     = MOD,
                    FORMAT_MED = (_F(NOM_RESU = 'U_9',
                                     NOM_CHAM = 'SIEF_ELGA'),) ,
                    UNITE      = 21,
                    TOUT_ORDRE = 'OUI',);

RESU = LIRE_RESU(TYPE_RESU  = 'EVOL_NOLI',
                 FORMAT     = 'MED',
                 MODELE     = MOD,
                 FORMAT_MED = (_F( NOM_RESU = 'EAU',
                                   NOM_CHAM = 'SIEF_ELGA'),) ,
                 UNITE      = 22,
                 TOUT_ORDRE = 'OUI',);

POSTLIQ = POST_LIQUEFACTION(RESU_REF = RESUREF,
                    INST_REF = 94608000.,
                            AXE      = 'Y',
                    RESULTAT = RESU,)

test.assertTrue( True )

FIN()
