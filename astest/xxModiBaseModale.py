import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

POUTRE0 = code_aster.Mesh()
POUTRE0.readMedFile("sdll118a.mmed")

POUTRE0=DEFI_GROUP( reuse=POUTRE0,   MAILLAGE=POUTRE0,
  CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

POUTRE=CREA_MAILLAGE(MAILLAGE=POUTRE0,
    CREA_POI1=(
        _F(NOM_GROUP_MA='N1',   NOEUD = 'N1', ),
        _F(NOM_GROUP_MA='N101', NOEUD = 'N101', ),
    ),
)

MODELE=AFFE_MODELE(
                MAILLAGE=POUTRE,AFFE=(
                    _F(
                TOUT = 'OUI',
                PHENOMENE = 'MECANIQUE',
                MODELISATION = 'POU_D_T'),
                    _F(
                GROUP_MA = ('N1',  'N101',),
                PHENOMENE = 'MECANIQUE',
                MODELISATION = 'DIS_TR'))
                        )

CARA=AFFE_CARA_ELEM(
                MODELE=MODELE,
                POUTRE=_F(

       GROUP_MA = 'TOUT',

                SECTION = 'CERCLE',
                CARA = ( 'R', 'EP',),
                VALE = (6.50E-03, 2.10E-03,)),
                DISCRET=(_F(
                GROUP_MA = ('N1',  'N101',),
                CARA = 'K_TR_D_N',
                VALE = (0.,  0.,  0.,  6.29,  0.,  6.29,)),
                        _F(
                GROUP_MA = ('N1',  'N101',),
                CARA = 'M_TR_D_N',
                VALE = (0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,)),
                           ))

MAT=DEFI_MATERIAU(
                ELAS=_F(
                E = 2.80E+9,
                NU = 0.3,
                RHO = 1500.)
                          )

CHMAT=AFFE_MATERIAU(
                MAILLAGE=POUTRE,
                    AFFE=_F(
                TOUT = 'OUI',
                MATER = MAT)
                          )

CHARG=AFFE_CHAR_MECA(
                  MODELE=MODELE,DDL_IMPO=(

                _F( NOEUD = 'N1',  DX = 0.,  DY = 0.,  DZ = 0.),
                _F( NOEUD = 'N101',  DX = 0.,  DZ = 0.),
                _F(
                TOUT = 'OUI',
                DRY = 0.))
                           )

MELR=CALC_MATR_ELEM(
                    MODELE=MODELE,
                    CHARGE=CHARG,
                 CARA_ELEM=CARA,
                CHAM_MATER=CHMAT,
                    OPTION='RIGI_MECA'
                           )

MELM=CALC_MATR_ELEM(
                    MODELE=MODELE,
                    CHARGE=CHARG,
                 CARA_ELEM=CARA,
                CHAM_MATER=CHMAT,
                    OPTION='MASS_MECA'
                           )

NUM=NUME_DDL(   MATR_RIGI=MELR)

MATR=ASSE_MATRICE(
                MATR_ELEM=MELR,
                 NUME_DDL=NUM
                         )

MATM=ASSE_MATRICE(
                MATR_ELEM=MELM,
                 NUME_DDL=NUM
                         )

MODES=CALC_MODES(MATR_RIGI=MATR,
                 OPTION='PLUS_PETITE',
                 CALC_FREQ=_F(NMAX_FREQ=2,
                              ),
                 MATR_MASS=MATM,
                 )

RHOFLUI=DEFI_FONCTION(
                NOM_PARA='Y',
                    VALE=(0., 1.E+3, 1., 1.E+3,)
                          )

VISC=DEFI_FONCTION(
                NOM_PARA='Y',
                    VALE=(0., 1.1E-6, 1., 1.1E-6,)
                          )

TYPEFLU=DEFI_FLUI_STRU(
                FAISCEAU_AXIAL=_F(
                GROUP_MA = 'MA_TUY_000001',
                VECT_X = (0., 1., 0.,),
                PROF_RHO_FLUI = RHOFLUI,
                PROF_VISC_CINE = VISC,
                CARA_ELEM = CARA,
                PESANTEUR = (10., 0., -1., 0.,),
                RUGO_TUBE = 1.E-5,
                CARA_PAROI = ('YC', 'ZC', 'R', ),
                VALE_PAROI = (0.0, 0.0, 0.025,))
                           )

MELAS=CALC_FLUI_STRU(
                VITE_FLUI=_F( VITE_MIN = 0.0,
                              VITE_MAX = 8.0,
                              NB_POIN = 9),
                BASE_MODALE=_F( MODE_MECA = MODES,
                                NUME_ORDRE = (1,  2 ),
                                AMOR_UNIF = 0.048),
                TYPE_FLUI_STRU=TYPEFLU,
                IMPRESSION=_F( PARA_COUPLAGE = 'OUI',
                               DEFORMEE = 'NON')
                           )



MODES=MODI_BASE_MODALE( reuse=MODES,
                          BASE=MODES,
                BASE_ELAS_FLUI=MELAS,
                NUME_VITE_FLUI=2,
                             )

test.assertTrue( True )

FIN()
