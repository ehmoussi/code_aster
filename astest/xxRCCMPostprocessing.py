# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


MAT=DEFI_MATERIAU(  ELAS=_F( E = 200000.,  NU = 0.3,  ALPHA = 1.0E-5),
                    RCCM=_F(  M_KE = 2.,
                              N_KE = 0.2,
                              SM = 200.,
                              SY_02 = 200.)
                               )

T_TOT1 = LIRE_TABLE (UNITE=35, FORMAT='ASTER',SEPARATEUR=' ',
                      NUME_TABLE=1,)

T_TH1 = LIRE_TABLE (UNITE=35, FORMAT='ASTER',SEPARATEUR=' ',
                      NUME_TABLE=2,)

PMPB1=POST_RCCM(TYPE_RESU_MECA='EVOLUTION',
                OPTION='PM_PB',
                TYPE_RESU='DETAILS',
                MATER=MAT,
                TITRE='CALCUL DE PM_PB (DETAILS), SITUATION 1, EVOLUTION',
                TRANSITOIRE=_F(  TABL_RESU_MECA = T_TOT1,
                                 TABL_SIGM_THER = T_TH1  )
                 )


test.assertEqual(PMPB1.getType(), "TABLE_SDASTER")

test.printSummary()

FIN()
