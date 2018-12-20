# coding=utf-8
import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


MA1=code_aster.Mesh()
MA1.readAsterMeshFile("sdld25a.mail")

MA=CREA_MAILLAGE(MAILLAGE=MA1,CREA_POI1=_F(NOM_GROUP_MA='MASSE1',GROUP_NO='MASSE1'),)
MA = DEFI_GROUP(reuse=MA, MAILLAGE=MA,
                CREA_GROUP_MA=_F(NOM="G1", MAILLE=( 'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9', )))

MAT=DEFI_MATERIAU(  ELAS=_F(  E = 2.E+11,  NU = 0.3,  RHO = 0.)  )

MODELE=AFFE_MODELE(  MAILLAGE=MA,AFFE=(
                        _F(  TOUT = 'OUI', PHENOMENE = 'MECANIQUE',
                               MODELISATION = 'DIS_T'),
                             _F(  GROUP_MA = 'MASSE1', PHENOMENE = 'MECANIQUE',
                               MODELISATION = 'DIS_T')) )

CHMAT=AFFE_MATERIAU(  MAILLAGE=MA,
                             MODELE=MODELE,AFFE=(
                               _F(  GROUP_MA = 'G1',    MATER = MAT),
                               _F(  GROUP_MA = 'MASSE1',    MATER = MAT))  )

CARA_ELE=AFFE_CARA_ELEM(  MODELE=MODELE,DISCRET=(
                  _F(  GROUP_MA = 'MASSE1', REPERE = 'GLOBAL',
                            CARA = 'M_T_D_N', VALE = 10.),
                  _F(  GROUP_MA = 'MASSE1', REPERE = 'GLOBAL',
                            CARA = 'K_T_D_N', VALE = (0.,0.,0.)),
                  _F(  GROUP_MA = 'MASSE1', REPERE = 'GLOBAL',
                            CARA = 'A_T_D_N', VALE = (0.,0.,0.)),
                          _F(  GROUP_MA = 'RESSORT',
                            CARA = 'K_T_D_L', VALE = ( 1.E+5, 0., 0.,)),
                          _F(  GROUP_MA = 'AMORT',
                            CARA = 'A_T_D_L', VALE = ( 50., 0., 0.,))) )

COND_LIM=AFFE_CHAR_MECA(  MODELE=MODELE,DDL_IMPO=(
                  _F(  GROUP_NO = 'A_ET_B', DX = 0., DY = 0., DZ = 0.),
                           _F(  GROUP_NO = 'MASSE',         DY = 0., DZ = 0.)) )

MELR=CALC_MATR_ELEM(  MODELE=MODELE,  OPTION='RIGI_MECA',
                          CHARGE=COND_LIM,  CARA_ELEM=CARA_ELE )

MELM=CALC_MATR_ELEM(  MODELE=MODELE,  OPTION='MASS_MECA',
                          CHARGE=COND_LIM,  CARA_ELEM=CARA_ELE )

MELC=CALC_MATR_ELEM(  MODELE=MODELE,  OPTION='AMOR_MECA',
                          CHARGE=COND_LIM,  CARA_ELEM=CARA_ELE )

#

NUM=NUME_DDL(  MATR_RIGI=MELR )

MATASSR=ASSE_MATRICE(  MATR_ELEM=MELR,   NUME_DDL=NUM  )

MATASSM=ASSE_MATRICE(  MATR_ELEM=MELM,   NUME_DDL=NUM  )

MATASSC=ASSE_MATRICE(  MATR_ELEM=MELC,   NUME_DDL=NUM  )

TABL_MAS=POST_ELEM(  MODELE=MODELE,
                         CHAM_MATER=CHMAT,   CARA_ELEM=CARA_ELE,
                        MASS_INER=_F(  TOUT = 'OUI')                   )

MODE_MEC=CALC_MODES(MATR_RIGI=MATASSR,
                    OPTION='PLUS_PETITE',
                    CALC_FREQ=_F(NMAX_FREQ=8,
                                 ),
                    MATR_MASS=MATASSM,
                    )


# MODE_MEC=NORM_MODE(reuse=MODE_MEC,   MODE=MODE_MEC,   NORME='MASS_GENE',)

#
###--->> REFERENCE : CODE DE CALCUL POUX

TEST_RESU(RESU=(_F(PARA='FREQ',
                   NUME_MODE=1,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=5.5273931669183,
                   VALE_REFE=5.5300000000000002,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=2,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=10.886839289456,
                   VALE_REFE=10.890000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=3,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=15.91549430919,
                   VALE_REFE=15.92,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=4,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=20.460565087967,
                   VALE_REFE=20.460000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=5,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=24.383951950093,
                   VALE_REFE=24.379999999999999,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=6,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=27.56644477109,
                   VALE_REFE=27.57,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=7,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=29.911345117011,
                   VALE_REFE=29.91,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=8,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=31.347404377423,
                   VALE_REFE=31.350000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                ),
          )

#
###--->> REFERENCE : FICHE DE VALIDATION (DYNAM S&M)

TEST_RESU(RESU=(_F(PARA='FREQ',
                   NUME_MODE=1,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=5.5273931669183,
                   VALE_REFE=5.5250000000000004,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=2,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=10.886839289456,
                   VALE_REFE=10.887,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=3,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=15.91549430919,
                   VALE_REFE=15.923999999999999,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=4,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=20.460565087967,
                   VALE_REFE=20.460999999999999,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=5,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=24.383951950093,
                   VALE_REFE=24.390000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=6,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=27.56644477109,
                   VALE_REFE=27.565999999999999,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=7,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=29.911345117011,
                   VALE_REFE=29.911000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                _F(PARA='FREQ',
                   NUME_MODE=8,
                   RESULTAT=MODE_MEC,
                   VALE_CALC=31.347404377423,
                   VALE_REFE=31.347000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,),
                ),
          )

A_0_5=DEFI_FONCTION(  NOM_PARA='FREQ',
                            INTERPOL='LOG',
                          VALE=( 1., 1.,  3., 25.,  13., 25.,  33., 1., ),
                           TITRE='AMORTISSEMENT 0.5 # '             )

A_5_0=DEFI_FONCTION(  NOM_PARA='FREQ',
                            INTERPOL='LOG',
                          VALE=( 1., 1.,  3., 10.,  13., 10.,  33., 1., ),
                           TITRE='AMORTISSEMENT 5.0 # '             )

SPECT=DEFI_NAPPE(  NOM_PARA='AMOR',
                         INTERPOL=( 'LIN',  'LOG', ),
                       PARA=(     0.005,  0.05,  ),
                       FONCTION=( A_0_5,  A_5_0, ),
                         TITRE='CAS TEST &CODE   COMMANDE &COMMANDE'
                     )

LISS_SPECTRE(SPECTRE=(_F(NAPPE=SPECT, NOM='TEST', BATIMENT='BATIMENT', 
                         COMMENTAIRE='PRECISIONS', DIRECTION = 'X',),), 
             OPTION = 'CONCEPTION',
             NB_FREQ_LISS = 50,
             FREQ_MIN = 0.5,
             FREQ_MAX = 35.5,
             ZPA   = 2.25793,
             BORNE_X=(0.1,100),
             BORNE_Y=(0.01,100),
             ECHELLE_X = 'LOG',
             ECHELLE_Y = 'LOG',
             LEGENDE_X = 'Frequence (Hz)',
             LEGENDE_Y = 'Pseudo-acceleration (g)',)


SISM_SPE=COMB_SISM_MODAL(  MODE_MECA=MODE_MEC,
                           AMOR_REDUIT=(
                               0.00868241,  0.01710101,  0.02500000,
                               0.03213938,  0.03830222,  0.04331841,
                               0.04698464,  0.04924040, ),
                            MASS_INER=TABL_MAS,
                            CORR_FREQ='NON',
                            MONO_APPUI = 'OUI',
                            EXCIT=_F(AXE = ( 1.,  0.,  0., ),
                                    SPEC_OSCI = SPECT,
                                    NATURE = 'ACCE'),
                            COMB_MODE=_F(  TYPE = 'SRSS'),
                            OPTION=( 'ACCE_ABSOLU',),
                            TITRE=( 'CAS TEST &CODE &RL DATE &DATE',)
                     )

test.assertEqual(SISM_SPE.getType(), "MODE_MECA")

###--->> REFERENCE : FICHE DE VALIDATION (DYNAM S&M)

TEST_RESU(RESU=(_F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='A',
                   NOM_CMP='DX',
                   VALE_CALC=1.1363736792287,
                   VALE_REFE=1.0,
                   REFERENCE='SOURCE_EXTERNE',
                   CRITERE='RELATIF',
                   NOEUD_CMP=('DIR', 'X'),
                   PRECISION=0.14999999999999999,),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P1',
                   NOM_CMP='DX',
                   VALE_CALC=10.449843284531,
                   VALE_REFE=10.449999999999999,
                   REFERENCE='SOURCE_EXTERNE',
                   CRITERE='RELATIF',
                   NOEUD_CMP=('DIR', 'X'),
                   PRECISION=0.029999999999999999,),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P2',
                   NOM_CMP='DX',
                   VALE_CALC=19.029947319229,
                   VALE_REFE=19.030000000000001,
                   REFERENCE='SOURCE_EXTERNE',
                   CRITERE='RELATIF',
                   NOEUD_CMP=('DIR', 'X'),
                   PRECISION=0.02,),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P3',
                   NOM_CMP='DX',
                   VALE_CALC=25.317694891527,
                   VALE_REFE=25.309999999999999,
                   REFERENCE='SOURCE_EXTERNE',
                   CRITERE='RELATIF',
                   NOEUD_CMP=('DIR', 'X'),
                   PRECISION=1.E-2,),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P4',
                   NOM_CMP='DX',
                   VALE_CALC=28.945354190646,
                   VALE_REFE=28.940000000000001,
                   REFERENCE='SOURCE_EXTERNE',
                   CRITERE='RELATIF',
                   NOEUD_CMP=('DIR', 'X'),
                   PRECISION=1.E-2,),
                ),
          )

#
###--->> REFERENCE : CODE DE CALCUL POUX

TEST_RESU(RESU=(_F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='A',
                   NOM_CMP='DX',
                   VALE_CALC=1.1363736792287,
                   VALE_REFE=1.0,
                   REFERENCE='SOURCE_EXTERNE',
                   CRITERE='RELATIF',
                   NOEUD_CMP=('DIR', 'X'),
                   PRECISION=0.14999999999999999,),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P1',
                   NOM_CMP='DX',
                   VALE_CALC=10.449843284531,
                   VALE_REFE=10.449999999999999,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,
                   NOEUD_CMP=('DIR', 'X'),),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P2',
                   NOM_CMP='DX',
                   VALE_CALC=19.029947319229,
                   VALE_REFE=19.030000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,
                   NOEUD_CMP=('DIR', 'X'),),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P3',
                   NOM_CMP='DX',
                   VALE_CALC=25.317694891527,
                   VALE_REFE=25.32,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,
                   NOEUD_CMP=('DIR', 'X'),),
                _F(RESULTAT=SISM_SPE,
                   NOM_CHAM='ACCE_ABSOLU',
                   NOEUD='P4',
                   NOM_CMP='DX',
                   VALE_CALC=28.945354190646,
                   VALE_REFE=28.949999999999999,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,
                   NOEUD_CMP=('DIR', 'X'),),
                ),
          )

test.printSummary()

FIN()
