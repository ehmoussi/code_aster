import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sdll152a.mail")


MODI_MAILLAGE(reuse=MA, MAILLAGE=MA,
              ABSC_CURV=_F(NOEUD_ORIG='N001',
                           TOUT='OUI'))

DEFI_GROUP(reuse=MA, MAILLAGE=MA, CREA_GROUP_NO=_F(NOM='GRNO', NOEUD='N051'))

MODEL=AFFE_MODELE(MAILLAGE=MA,
                   AFFE    =(_F(GROUP_MA     = 'BEAM',
                                PHENOMENE    = 'MECANIQUE',
                                MODELISATION = 'POU_D_T')))

CARA=AFFE_CARA_ELEM(MODELE = MODEL,
                    POUTRE = _F(GROUP_MA = 'BEAM',
                                SECTION  = 'CERCLE',
                                CARA     = ('R','EP',),
                                VALE     = (0.5*0.040, 0.005)))

TYPEFLUI=DEFI_FLUI_STRU(    GRAPPE=_F(  COUPLAGE = 'NON') )


MAT=DEFI_MATERIAU(ELAS=_F(E   = 210.E9,
                               RHO = 7800.,
                               NU  = 0.3,
                               ))

CHMAT=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE    =_F(TOUT = 'OUI',
                               MATER = MAT))

CHDDL=AFFE_CHAR_MECA(MODELE =MODEL,
                     DDL_IMPO= (_F(GROUP_NO = 'CLAMPED',
                                   DX  = 0.0, DY  = 0.0, DZ  = 0.0,
                                   DRX = 0.0, DRY = 0.0, DRZ = 0.0),
                                _F(GROUP_MA = 'BEAM',
                                   DZ = 0.0)))

MELR=CALC_MATR_ELEM(MODELE=MODEL,
                    CHARGE=CHDDL,
                    CARA_ELEM=CARA,
                    CHAM_MATER=CHMAT,
                    OPTION='RIGI_MECA')

MELM=CALC_MATR_ELEM(MODELE=MODEL,
                    CHARGE=CHDDL,
                    CARA_ELEM=CARA,
                    CHAM_MATER=CHMAT,
                    OPTION='MASS_MECA')

NUM=NUME_DDL(MATR_RIGI=MELR)

MATRR=ASSE_MATRICE(MATR_ELEM=MELR,
                   NUME_DDL=NUM)

MATRM=ASSE_MATRICE(MATR_ELEM=MELM,
                   NUME_DDL=NUM)

MODES=CALC_MODES(MATR_RIGI=MATRR,
                 OPTION='PLUS_PETITE',
                 CALC_FREQ=_F(NMAX_FREQ=2),
                 MATR_MASS=MATRM)

MELES=CALC_FLUI_STRU(VITE_FLUI  = _F(VITE_MIN  = 1.,
                                     VITE_MAX  = 1.,
                                     NB_POIN   = 1),
                     BASE_MODALE= _F(MODE_MECA = MODES,
                                     AMOR_REDUIT = (0.15E-2,0.15E-2),
                                     ),
                     TYPE_FLUI_STRU=TYPEFLUI,
                     )

test.assertTrue( True )

FIN()
