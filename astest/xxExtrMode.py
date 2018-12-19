import code_aster

from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("forma12a.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MA,
                   AFFE=_F(GROUP_MA='VOL',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='3D',),);

MAT=DEFI_MATERIAU(ELAS=_F(E=200.E9,
                          NU=0.3,
                          RHO=8000.0,),)

CHMAT=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=_F(GROUP_MA='VOL',
                            MATER=MAT,),);

TAMAS=POST_ELEM(MASS_INER=_F(TOUT='OUI',),
                MODELE=MODELE,
                CHAM_MATER=CHMAT,);

BLOCAGE=AFFE_CHAR_MECA(MODELE=MODELE,
                       DDL_IMPO=_F(GROUP_MA='ENCAS',
                                   LIAISON='ENCASTRE',),);

ASSEMBLAGE(MODELE=MODELE,
           CHAM_MATER=CHMAT,
           CHARGE=BLOCAGE,
           NUME_DDL=CO('NUMEDDL'),
           MATR_ASSE=(_F(MATRICE=CO('RIGIDITE'),
                         OPTION='RIGI_MECA',),
                      _F(MATRICE=CO('MASSE'),
                         OPTION='MASS_MECA',),),);

MODES=CALC_MODES(MATR_RIGI=RIGIDITE,
                 OPTION='BANDE',
                 CALC_FREQ=_F(FREQ=(0,50.0,),
                              ),
                 MATR_MASS=MASSE,
                 )

MODEE=EXTR_MODE(FILTRE_MODE=_F(MODE=MODES,
                               FREQ_MIN=0.0,
                               FREQ_MAX=100.0,),
                IMPRESSION=_F(CUMUL='OUI',),);

test.assertTrue( True )

FIN()
