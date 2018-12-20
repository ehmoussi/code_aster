import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("fdlv101a.mmed")

EAU=DEFI_MATERIAU( THER=_F( LAMBDA = 1., RHO_CP = 1000.))

ACIER=DEFI_MATERIAU( ELAS=_F( RHO = 7800.,  NU = 0.3, E = 2.E11))

CHAMMAT1=AFFE_MATERIAU(  MAILLAGE=MA,AFFE=(
                       _F( GROUP_MA = 'FLUIDE', MATER = EAU),
                       _F( GROUP_MA = 'INTERFAC', MATER = EAU))   )

CHAMMAT2=AFFE_MATERIAU(  MAILLAGE=MA,AFFE=(
                       _F( GROUP_MA = 'CYLINDRE', MATER = ACIER),
                       _F( GROUP_MA = 'CYLEXT', MATER = ACIER))    )

FLUIDE1=AFFE_MODELE( MAILLAGE=MA,AFFE=(
                     _F( GROUP_MA = 'FLUIDE',
                MODELISATION = 'PLAN',  PHENOMENE = 'THERMIQUE'),
                     _F( GROUP_MA = 'INTERFAC',
                MODELISATION = 'PLAN',  PHENOMENE = 'THERMIQUE'))   )

INTERF1=AFFE_MODELE( MAILLAGE=MA,
                     AFFE=_F( GROUP_MA = 'INTERFAC',
                MODELISATION = 'PLAN',  PHENOMENE = 'THERMIQUE')   )

STRUCT=AFFE_MODELE( MAILLAGE=MA,AFFE=(
                     _F( GROUP_MA = 'CYLINDRE',
                MODELISATION = 'D_PLAN',  PHENOMENE = 'MECANIQUE'),
                     _F( GROUP_MA = 'CYLEXT',
                MODELISATION = 'D_PLAN',  PHENOMENE = 'MECANIQUE'),
                     _F( GROUP_MA = 'RESSORT',
                MODELISATION = '2D_DIS_T',  PHENOMENE = 'MECANIQUE'),
                     _F( GROUP_MA = 'RESSOREX',
                MODELISATION = '2D_DIS_T',  PHENOMENE = 'MECANIQUE'))
                          )

CHARGE=AFFE_CHAR_THER( MODELE=FLUIDE1,
                    TEMP_IMPO=_F( GROUP_NO = 'TEMPIMPO', TEMP = 0.)  )

CHAMPCAR=AFFE_CARA_ELEM( MODELE=STRUCT,
                         DISCRET_2D=(_F( GROUP_MA = 'RESSORT', CARA = 'K_T_D_N',
                                         VALE = (1.E7, 1.E7, )),
                                     _F( GROUP_MA = 'RESSORT', CARA = 'M_T_D_N',
                                         VALE = (0.0, )),
                                     _F( GROUP_MA = 'RESSOREX', CARA = 'K_T_D_N',
                                         VALE = (5.E6, 5.E6, )),
                                     _F( GROUP_MA = 'RESSOREX', CARA = 'M_T_D_N',
                                         VALE = (0.0, ))))

CHARGS=AFFE_CHAR_MECA( MODELE=STRUCT,DDL_IMPO=(
                   _F( GROUP_NO = 'ACCROCHE', DY = 0.),
                   _F( GROUP_NO = 'ACCREXT',  DY = 0.))    )

MEL_KSTR=CALC_MATR_ELEM( MODELE=STRUCT,
                               CARA_ELEM=CHAMPCAR,
                              CHAM_MATER=CHAMMAT2,  OPTION='RIGI_MECA',
                               CHARGE=(CHARGS, )
                               )

MEL_MSTR=CALC_MATR_ELEM( MODELE=STRUCT,
                               CARA_ELEM=CHAMPCAR,
                              CHAM_MATER=CHAMMAT2,  OPTION='MASS_MECA',
                               CHARGE=CHARGS       )

NUSTR=NUME_DDL(MATR_RIGI=MEL_KSTR)

MATASKS=ASSE_MATRICE( MATR_ELEM=MEL_KSTR,  NUME_DDL=NUSTR)

MATASMS=ASSE_MATRICE( MATR_ELEM=MEL_MSTR,  NUME_DDL=NUSTR)

MODES=CALC_MODES(MATR_RIGI=MATASKS,
                 OPTION='PLUS_PETITE',
                 CALC_FREQ=_F(NMAX_FREQ=2,
                              ),
                 MATR_MASS=MATASMS,
                 )

NUMGEN=NUME_DDL_GENE(       BASE=MODES,
                             STOCKAGE='PLEIN'    )

MATRAJ=CALC_MATR_AJOU( MODELE_FLUIDE=FLUIDE1,
                         MODELE_INTERFACE=INTERF1,
                        OPTION='MASS_AJOU',
                         NUME_DDL_GENE=NUMGEN,
                        CHARGE=CHARGE,
                        CHAM_MATER=CHAMMAT1,
                        MODE_MECA=MODES)

test.assertTrue( True )

FIN()
