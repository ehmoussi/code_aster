import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sdnd101a.mail")

MA=DEFI_GROUP( reuse=MA,   MAILLAGE=MA,
  CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

MODELE=AFFE_MODELE(   MAILLAGE=MA,
                         AFFE=_F( TOUT = 'OUI', PHENOMENE = 'MECANIQUE',
                        MODELISATION = 'DIS_T'))

CHAMPCAR=AFFE_CARA_ELEM(  MODELE=MODELE,DISCRET=(
                _F(
       GROUP_MA = 'TOUT',
 CARA = 'K_T_D_N', VALE = ( 1.E+04, 1.E+04, 1.E+04, )),
                        _F(  GROUP_MA = 'TOUT', CARA = 'M_T_D_N', VALE = 100.))
                         )

CHARGE=AFFE_CHAR_MECA(  MODELE=MODELE,
             DDL_IMPO=_F( TOUT = 'OUI',  DY = 0., DZ = 0.0)
                        )

RIGIELEM=CALC_MATR_ELEM(  MODELE=MODELE,  CHARGE=CHARGE,
                         CARA_ELEM=CHAMPCAR,
                         OPTION='RIGI_MECA')

MASSELEM=CALC_MATR_ELEM(  MODELE=MODELE,  CHARGE=CHARGE,
                         CARA_ELEM=CHAMPCAR,
                         OPTION='MASS_MECA')

VECTELEM=CALC_VECT_ELEM(   CHARGE=CHARGE,  OPTION='CHAR_MECA')

NUMEROTA=NUME_DDL(   MATR_RIGI=RIGIELEM )

MATRRIGI=ASSE_MATRICE(MATR_ELEM=RIGIELEM,NUME_DDL=NUMEROTA)

MATRMASS=ASSE_MATRICE(MATR_ELEM=MASSELEM,NUME_DDL=NUMEROTA)

VECTASS=ASSE_VECTEUR(VECT_ELEM=VECTELEM,NUME_DDL=NUMEROTA)

MODES=CALC_MODES(MATR_RIGI=MATRRIGI,
                 OPTION='PLUS_PETITE',
                 CALC_FREQ=_F(NMAX_FREQ=10,
                              ),
                 MATR_MASS=MATRMASS,
                 )

VITEPHYS=CREA_CHAMP( OPERATION='AFFE', PROL_ZERO='OUI', TYPE_CHAM='NOEU_DEPL_R',
MAILLAGE=MA,
                             CHAM_NO=VECTASS,
                            AFFE=_F(  TOUT = 'OUI',
                                   NOM_CMP = 'DX',
                                   VALE = 1.)
                          )

NUMEGE=NUME_DDL_GENE(   BASE=MODES,
                          STOCKAGE='DIAG' )

VITINI=PROJ_VECT_BASE(  BASE=MODES,  VECT_ASSE=VITEPHYS,
                          NUME_DDL_GENE=NUMEGE,
                          TYPE_VECT='VITE')

test.assertTrue( True )

FIN()
