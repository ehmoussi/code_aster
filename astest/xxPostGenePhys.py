import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAILLAG0 = code_aster.Mesh()
MAILLAG0.readAsterMeshFile("sdld103a.mail")

MAILLAG0=DEFI_GROUP(reuse=MAILLAG0,
                    MAILLAGE=MAILLAG0,
                    CREA_GROUP_NO=_F( NOM='GROUP_NO_GN5',
                                      NOEUD=('NO5',),),);


MAILLAGE=CREA_MAILLAGE(MAILLAGE=MAILLAG0,
    CREA_POI1=(
        _F(NOM_GROUP_MA='GROUP_NO_MASSES',   GROUP_NO='GROUP_NO_MASSES', ),
    ),
)

MODELE=AFFE_MODELE(MAILLAGE=MAILLAGE,
                   AFFE=(_F(PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'DIS_T',
                            GROUP_MA = 'GROUP_MA_RESSORT'),
                         _F(PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'DIS_T',
                            GROUP_MA = 'GROUP_NO_MASSES')));

CARA_ELE=AFFE_CARA_ELEM(  MODELE=MODELE,DISCRET=(
                _F(  CARA = 'K_T_D_L',  REPERE = 'GLOBAL',
                     GROUP_MA = 'GROUP_MA_RESSORT',
                     VALE = (10000., 0., 10000., )),
                _F(  CARA = 'M_T_L',  REPERE = 'GLOBAL',
                     GROUP_MA = 'GROUP_MA_RESSORT',
                     VALE = (0., 0., 0., 0., 0., 0., 0., 0., 0.,
                             0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., )),
                _F(  CARA = 'M_T_D_N',  GROUP_MA = 'GROUP_NO_MASSES',  VALE = 10.)));

CON_LIM=AFFE_CHAR_MECA(  MODELE=MODELE,DDL_IMPO=(
               _F(  GROUP_NO = 'GROUP_NO_ENCASTRE',  DX = 0.,  DY = 0.,  DZ = 0.),
               _F(  GROUP_NO = 'GROUP_NO_MASSES',    DY = 0.,  DZ = 0.)));

L_INST=DEFI_LIST_REEL(DEBUT=0.,
                      INTERVALLE=_F(JUSQU_A = 1., PAS = 0.0001) )
L_FREQ=DEFI_LIST_REEL(VALE=(0.10,0.20,0.30,0.41,0.52))

ACCE1 = FORMULE(NOM_PARA='INST',VALE='2.E+05*INST**2')
ACCELER1=CALC_FONC_INTERP(FONCTION=ACCE1,
                          LIST_PARA=L_INST,
                          NOM_PARA = 'INST',
                          PROL_DROITE='LINEAIRE',
                          PROL_GAUCHE='LINEAIRE',
                          NOM_RESU='ACCE')

RESPHYA2=DYNA_LINE(MODELE=MODELE,
                   CARA_ELEM=CARA_ELE,
                   TYPE_CALCUL='TRAN',
                   BASE_CALCUL='GENE',
                   ENRI_STAT = 'OUI',
                   ORTHO = 'OUI',
                   RESU_GENE=CO("TRANMONO"),
                   BASE_RESU=CO("MODEMONO"),
                   CHARGE=CON_LIM,
                   BANDE_ANALYSE=9.3,
                   SCHEMA_TEMPS=_F(SCHEMA='DIFF_CENTRE',),
                   EXCIT=(_F(DIRECTION=( 1., 0., 0.,),
                             TYPE_APPUI='MONO',
                             FONC_MULT = ACCELER1,),),
                   INCREMENT=_F(INST_FIN= 1.,
                                PAS = 0.0001),
                   )

L_INST1=DEFI_LIST_REEL(DEBUT=0.,
                      INTERVALLE=_F(JUSQU_A = 1., PAS = 0.1) )

PGP_MOA= POST_GENE_PHYS(RESU_GENE=TRANMONO,
                        MODE_MECA=MODEMONO,
                          OBSERVATION=(
                                      _F(LIST_INST=L_INST1,
                                         NOM_CHAM = 'ACCE_ABSOLU',
                                         ACCE_MONO_APPUI=ACCELER1,
                                         DIRECTION=( 1., 0., 0., ),
                                         NOM_CMP = 'DX',
                                         NOEUD = ('NO2'),),
                                      _F(LIST_INST=L_INST1,
                                         NOM_CHAM = 'ACCE',
                                         NOM_CMP = 'DX',
                                         NOEUD = ('NO2'),),
                        ),)

test.assertTrue( True )

FIN()
