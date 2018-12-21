import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sdnd122a.mail")

MO = AFFE_MODELE( MAILLAGE = MA,
        AFFE = (_F(  MAILLE=('M1','P2',), PHENOMENE='MECANIQUE', MODELISATION = 'DIS_T'),
                ),)

CARA_ELE =AFFE_CARA_ELEM(  MODELE=MO,
                          DISCRET=(_F(  MAILLE = ('P2',  ),
                                        CARA = 'M_T_D_N',  VALE = 1.),
                                   _F(  MAILLE = 'M1',  CARA = 'K_T_D_L',
                                        VALE = (10., 0., 0.,),  REPERE = 'GLOBAL'),
                                   _F(  MAILLE = 'P2',  CARA = 'K_T_D_N',
                                        VALE = (0, 0., 0.,),  ),
                         ),)

CDL=AFFE_CHAR_CINE(  MODELE=MO,MECA_IMPO=( _F(  NOEUD='N1', DX = 0., DY = 0., DZ = 0.,),
                                            _F(  NOEUD='N2', DY = 0., DZ = 0.,),
                  ),)

Ke=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                  MODELE=MO,
                  CARA_ELEM=CARA_ELE,);

Me=CALC_MATR_ELEM(OPTION='MASS_MECA',
                  MODELE=MO,
                  CARA_ELEM=CARA_ELE,);

NUM=NUME_DDL(MATR_RIGI=Ke,);

K=ASSE_MATRICE(MATR_ELEM=Ke,
               NUME_DDL=NUM,
               CHAR_CINE=CDL,);

M=ASSE_MATRICE(MATR_ELEM=Me,
               NUME_DDL=NUM,
               CHAR_CINE=CDL,);

MODES=CALC_MODES(MATR_RIGI=K,
                 CALC_FREQ=_F(FREQ=(0.01,10.,),
                              ),
                 OPTION='BANDE',
                 SOLVEUR=_F(METHODE='MUMPS',
                            ),
                 MATR_MASS=M,
                 SOLVEUR_MODAL=_F(METHODE='SORENSEN',
                                  ),
                 )


MNL = MODE_NON_LINE(MATR_RIGI=K,   INFO=1,
                 MATR_MASS=M,
                 ETAT_INIT=_F(MODE_LINE = MODES,NUME_ORDRE = 1,
                              DIR_EVOLUTION=1,),
                 SOLVEUR=_F(METHODE='MUMPS', RESI_RELA=1.e-10),
                 RESOLUTION=_F(METHODE='EHMAN',
                            NB_HARM_LINE=5,
                            NB_HARM_NONL=200,
                            NB_PAS_MAN=1,
                            NB_BRANCHE=105,
                            NB_ORDRE_MAN=20,
                            PREC_MAN=1.E-14,
                            PREC_NEWTON=1.E-09,
                            ITER_NEWTON_MAXI=15),
                 CHOC=(_F(NOEUD='N2',
                          OBSTACLE = 'PLAN',
                          NOM_CMP='DX',
                          JEU=0.01,
                          RIGI_NOR=50.,
                          PARA_REGUL=0.00005,),
                      ),
                 )

test.assertTrue( True )

FIN()
