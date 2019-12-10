# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


MAIL=code_aster.Mesh()
MAIL.readMedFile("wtnl100g.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='D_PLAN_HMD'));

#  LISTE DES INSTANTS DE CALCUL

LI=DEFI_LIST_REEL(DEBUT=0.0,
                  INTERVALLE=(_F(JUSQU_A=1.E-4,
                                 NOMBRE=1),
                              _F(JUSQU_A=1.E-3,
                                 NOMBRE=9),
                              _F(JUSQU_A=1.E-2,
                                 NOMBRE=30),
                              _F(JUSQU_A=0.10000000000000001,
                                 NOMBRE=40),
                              _F(JUSQU_A=1.0,
                                 NOMBRE=50),
                              _F(JUSQU_A=10,
                                 NOMBRE=45),
                              _F(JUSQU_A=100,
                                 NOMBRE=47),
                              _F(JUSQU_A=250,
                                 NOMBRE=8)));

linst=LI.getValues()
lenlinst=len(linst)
p_inst_fin=linst[-1];

UN=DEFI_CONSTANTE(VALE=1.0);

ZERO=DEFI_CONSTANTE(VALE=0.0);

BIDON=DEFI_CONSTANTE(VALE=0.0);

#
#
#K=k*mu/(rhow*g)

KINT=DEFI_CONSTANTE(VALE=1.E-08);

#


THMALP1 = DEFI_CONSTANTE(VALE=0.000100)

MATERIAU=DEFI_MATERIAU(ELAS=_F(E=1.E7,
                               NU=0.0,
                               RHO=2800.0,
                               ALPHA=1.0000000000000001E-05),
                       COMP_THM='LIQU_SATU',
                       THM_INIT=_F(PRE1=1.E6,
                                   PORO=0.5,
                                   TEMP=293.0,
                                   PRE2=1.E5,
                                   PRES_VAPE=2320.0),
                       THM_DIFFU=_F(RHO=2800.0,
                                    BIOT_COEF=1.0,
                                    PESA_X=0.0,
                                    PESA_Y=0.0,
                                    PESA_Z=0.0,
                                    CP=660.0,
                                    PERM_IN=KINT,
                                    R_GAZ=8.3149999999999995,
                                    SATU_PRES=UN,
                                    D_SATU_PRES=ZERO,
                                    PERM_LIQU=UN,
                                    D_PERM_LIQU_SATU=ZERO,
                                    PERM_GAZ=BIDON,
                                    D_PERM_SATU_GAZ=BIDON,
                                    D_PERM_PRES_GAZ=BIDON),
                       THM_LIQU=_F(RHO=1000.0,
                                   UN_SUR_K=0.0,
                                   VISC=UN,
                                   D_VISC_TEMP=ZERO,
                                   ALPHA=THMALP1,
                                   CP=4180.0),
                       THM_GAZ=_F(MASS_MOL=0.02896,
                                  CP=1000.0,
                                  VISC=BIDON,
                                  D_VISC_TEMP=BIDON),
                       THM_VAPE_GAZ=_F(MASS_MOL=0.017999999999999999,
                                       CP=1870.0,
                                       VISC=BIDON,
                                       D_VISC_TEMP=BIDON));

CHMAT0=AFFE_MATERIAU(MAILLAGE=MAIL,
                     AFFE=_F(TOUT='OUI',
                             MATER=MATERIAU));

CHAR1=AFFE_CHAR_CINE(MODELE=MODELE,
                    MECA_IMPO=(_F(GROUP_NO='HAUT',
                                  PRE1=0.0),
                               _F(GROUP_NO='BAS',
                                  DX=0.0,
                                  DY=0.0),
                               _F(GROUP_NO='BORDVERT',
                                  DX=0.0)));

CHAR2=AFFE_CHAR_MECA(MODELE=MODELE,
                    PRES_REP=_F(GROUP_MA='FACESUP',
                                PRES=1.0));

RESU1=STAT_NON_LINE(MODELE=MODELE,
                    CHAM_MATER=CHMAT0,
                    EXCIT=(_F(CHARGE=CHAR1),
                           _F(CHARGE=CHAR2)),
                    SCHEMA_THM=_F(PARM_THETA=0.57,),
                    COMPORTEMENT=_F(RELATION='KIT_HM',
                                 RELATION_KIT=('ELAS','LIQU_SATU','HYDR_UTIL')),
                    INCREMENT=_F(LIST_INST=LI,
                                 INST_FIN=p_inst_fin),
                    NEWTON=_F(MATRICE='TANGENTE',REAC_INCR=3,REAC_ITER=0),
                    CONVERGENCE=_F(ITER_GLOB_MAXI=10),
                    SOLVEUR=_F(METHODE='MUMPS'),
);

MATPROJ = PROJ_CHAMP(METHODE='COLLOCATION',PROJECTION='NON',
               MAILLAGE_1=MAIL,
               MAILLAGE_2=MAIL)

RESU1=CALC_CHAMP(reuse=RESU1,
                 RESULTAT=RESU1,
                 CRITERES=('SIEQ_ELGA','SIEQ_ELNO','EPEQ_ELGA','EPEQ_ELNO'),
                 VARI_INTERNE=('VARI_ELNO'),
                 DEFORMATION=('EPSI_ELNO'),
                 CONTRAINTE=('SIEF_ELNO'))


RESU1=CALC_CHAMP(reuse =RESU1,
              RESULTAT=RESU1,
              CONTRAINTE='SIEF_NOEU',VARI_INTERNE='VARI_NOEU',CRITERES='SIEQ_NOEU');

SIGMA2=POST_RELEVE_T(ACTION=_F(OPERATION='EXTRACTION',
                               INTITULE='SIGMA',
                               RESULTAT=RESU1,
                               NOM_CHAM='SIEF_NOEU',
                               INST=(0.0001,0.001,0.01,0.1,1.0,10.0,50.21276596,100.0,193.75,250.0),
                               GROUP_NO='BORDVERT',
                               NOM_CMP=('SIXX','SIYY','SIZZ','SIXY')));

VARIN2=POST_RELEVE_T(ACTION=_F(OPERATION='EXTRACTION',
                               INTITULE='VARI',
                               RESULTAT=RESU1,
                               NOM_CHAM='VARI_NOEU',
                               INST=(0.0001,0.001,0.01,0.1,1.0,10.0,50.21276596,100.0,193.75,250.0),
                               GROUP_NO='BORDVERT',
                               TOUT_CMP='OUI'));

DEPLA2=POST_RELEVE_T(ACTION=_F(OPERATION='EXTRACTION',
                               INTITULE='DEPL',
                               RESULTAT=RESU1,
                               NOM_CHAM='DEPL',
                               INST=(0.0001,0.001,0.01,0.1,1.0,10.0,50.21276596,100.0,193.75,250.0),
                               GROUP_NO='BORDVERT',
                               TOUT_CMP='OUI'));

MODHYD=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='D_PLAN_HS'));

PREIMP=AFFE_CHAR_CINE(MODELE=MODHYD,
                      MECA_IMPO=_F(GROUP_NO='HAUT',
                                   PRE1=0));

CHAINAGE_THM(
             TYPE_CHAINAGE = 'INIT',
             MODELE_MECA   = MODELE,
             MODELE_HYDR   = MODHYD,
             MATR_MH       = CO('MATMH'),
             MATR_HM1      = CO('MATHM1'),
             MATR_HM2      = CO('MATHM2'),
)

test.assertEqual(MATMH.getType(), "CORRESP_2_MAILLA")
test.assertEqual(MATHM1.getType(), "CORRESP_2_MAILLA")
test.assertEqual(MATHM2.getType(), "CORRESP_2_MAILLA")

UNPAS=DEFI_LIST_REEL(DEBUT=linst[0],
                     INTERVALLE=_F(JUSQU_A=linst[1],
                                   NOMBRE=1));

UNPASSUB =DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST =UNPAS ),
                         ECHEC=_F(
                                  SUBD_METHODE='MANUEL',
                                  SUBD_PAS  = 4,
                                  SUBD_NIVEAU=5));

RESU1b=EXTR_RESU(RESULTAT=RESU1,
                 ARCHIVAGE=_F(LIST_INST=UNPAS),)

DEFVHY=CHAINAGE_THM(RESU_MECA=RESU1b,
                    MODELE_HYDR=MODHYD,
                    MATR_MH=MATMH,
                    TYPE_CHAINAGE='MECA_HYDR',
                    INST=linst[1])

test.assertEqual(DEFVHY.getType(), "EVOL_VARC")


test.printSummary()

FIN()
