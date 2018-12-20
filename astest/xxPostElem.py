import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sdll108b.mmed")

MA=DEFI_GROUP( reuse=MA,   MAILLAGE=MA,
                     CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

MAT=DEFI_MATERIAU(  ELAS=_F(  E = 1.92276E+11, NU = 0.3, RHO = 0.) )

CHMAT=AFFE_MATERIAU(  MAILLAGE=MA,
                         AFFE=_F(  GROUP_MA = 'POU_D_T',   MATER = MAT)  )

MOD=AFFE_MODELE(  MAILLAGE=MA,AFFE=(
                   _F(  GROUP_MA = 'POU_D_T',  PHENOMENE = 'MECANIQUE',
                          MODELISATION = 'POU_D_T'),
                        _F(  GROUP_MA = 'MAS_COIN',  PHENOMENE = 'MECANIQUE',
                          MODELISATION = 'DIS_T'),
                        _F(  GROUP_MA = 'MAS_INTE',  PHENOMENE = 'MECANIQUE',
                          MODELISATION = 'DIS_T'))                 )

CARLEM=AFFE_CARA_ELEM(   MODELE=MOD,
                 POUTRE=_F(  GROUP_MA = 'POU_D_T',
                          SECTION = 'GENERALE',
                          CARA = ('A',  'IZ', 'IY', 'AY', 'AZ', 'JX',
                                 'EZ', 'EY', 'RY', 'RZ', 'RT', ),
                          VALE = ( 7.0370E-04,  2.7720E-07,  2.7720E-07,
                                  2.0,  2.0,  5.5450E-07, 0.0,  0.0,
                                  0.030,  0.030,  0.030,        )),DISCRET=(
                 _F(  GROUP_MA = 'MAS_COIN',  CARA = 'M_T_D_N',
                           VALE = 4.444),
                 _F(  GROUP_MA = 'MAS_COIN',  CARA = 'K_T_D_N',
                           VALE = (0.,0.,0.)),
                         _F(  GROUP_MA = 'MAS_INTE',  CARA = 'M_T_D_N',
                           VALE = 0.783))
                         )

COND_LIM=AFFE_CHAR_MECA(  MODELE=MOD,
                   DDL_IMPO=_F(  GROUP_NO = 'ENCASTRE',
                              DX = 0.,   DY = 0.,   DZ = 0.,
                              DRX = 0.,  DRY = 0.,  DRZ = 0.)       )

TABL_MAS=POST_ELEM(  MODELE=MOD,
                         CHAM_MATER=CHMAT,   CARA_ELEM=CARLEM,
                         MASS_INER=(_F(  TOUT = 'OUI',),
                                 _F( GROUP_MA = ( 'POU_D_T',  'MAS_COIN',
                                                 'MAS_INTE', ))) )

test.assertTrue( True )

FIN()
