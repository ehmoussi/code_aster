
# coding: utf-8

import code_aster
import math


from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAILLAG=LIRE_MAILLAGE(FORMAT="ASTER",INFO=1);

MODELEIN=AFFE_MODELE(MAILLAGE=MAILLAG,
                     AFFE=(_F(GROUP_MA=('SURF','LH','LG'),
                              PHENOMENE='MECANIQUE',
                              MODELISATION='C_PLAN')));

LN1=FORMULE(NOM_PARA=('X','Y'),VALE='Y-0.5');
LN2=FORMULE(NOM_PARA=('X','Y'),VALE='Y-1.5');
LN3=FORMULE(NOM_PARA=('X','Y'),VALE='Y-2.5');
LN4=FORMULE(NOM_PARA=('X','Y'),VALE='Y-3.5');

FISS1=DEFI_FISS_XFEM(MAILLAGE=MAILLAG,
                     TYPE_DISCONTINUITE='INTERFACE',
                     DEFI_FISS=_F(FONC_LN=LN1),
                     INFO=1);
FISS2=DEFI_FISS_XFEM(MAILLAGE=MAILLAG,
                     TYPE_DISCONTINUITE='INTERFACE',
                     DEFI_FISS=_F(FONC_LN=LN2),
                     INFO=1);
FISS3=DEFI_FISS_XFEM(MAILLAGE=MAILLAG,
                     TYPE_DISCONTINUITE='INTERFACE',
                     DEFI_FISS=_F(FONC_LN=LN3),
                     INFO=1);
FISS4=DEFI_FISS_XFEM(MAILLAGE=MAILLAG,
                     TYPE_DISCONTINUITE='INTERFACE',
                     DEFI_FISS=_F(FONC_LN=LN4),
                     INFO=1);

MODELEK=MODI_MODELE_XFEM(MODELE_IN=MODELEIN,
                         FISSURE=(FISS1,FISS2,FISS3,FISS4),
                         INFO=1);



E=100.0E6
nu=0.0
ACIER=DEFI_MATERIAU(ELAS=_F(E=E,
                            NU=nu,
                            RHO=7800.0));

CHAMPMAT=AFFE_MATERIAU(MAILLAGE=MAILLAG,
                       MODELE=MODELEK,
                       AFFE=_F(TOUT='OUI',
                                MATER=ACIER));

def pression(y) :
   if y >=3.5 : return 40e6
   if y < 3.5 and y >= 2.5 : return 30e6
   if y < 2.5 and y >= 1.5 : return 20e6
   if y < 1.5 and y >= 0.5 : return 10e6
   if y < 0.5 : return 0

PRESSION = FORMULE(VALE='(Y-0.5)*1e6',NOM_PARA='Y');

def depx(y) :
   return y/5

def depy(y) :
   return 0

CH1=AFFE_CHAR_MECA_F(MODELE=MODELEK,
                     PRES_REP=(_F(GROUP_MA='LG',PRES = PRESSION)));

CH2=AFFE_CHAR_MECA(MODELE=MODELEK,
                   DDL_IMPO=(_F(GROUP_MA='LD',DX=0,H1X=0,H2X=0,H3X=0,H4X=0,
                                              DY=0,H1Y=0,H2Y=0,H3Y=0,H4Y=0),
                             ),
                   );

L_INST=DEFI_LIST_REEL(DEBUT=0.0,
                      INTERVALLE=_F(JUSQU_A=1.0,
                                    NOMBRE=1));

UTOT1=STAT_NON_LINE(MODELE=MODELEK,INFO=1,
                    CHAM_MATER=CHAMPMAT,
                    EXCIT=(_F(CHARGE=CH1),
                           _F(CHARGE=CH2)),
                    COMPORTEMENT=_F(RELATION='ELAS',
                                 GROUP_MA='SURF'),
                    INCREMENT=_F(LIST_INST=L_INST),
                    SOLVEUR=_F(METHODE='MUMPS',
   ),
                    NEWTON=_F(REAC_ITER=1),
                    CONVERGENCE=_F(ARRET='OUI',RESI_GLOB_RELA=1E-14),
                    ARCHIVAGE=_F(CHAM_EXCLU='VARI_ELGA'),
                    );

#-----------------------------------------------------------
#             POST-TRAITEMENT POUR LA VISUALISATION
#-----------------------------------------------------------

MA_XFEM=POST_MAIL_XFEM(MODELE=MODELEK);


MOD_VISU=AFFE_MODELE(MAILLAGE=MA_XFEM,
                     AFFE=_F(GROUP_MA='SURF',
                     PHENOMENE='MECANIQUE',
                     MODELISATION='C_PLAN',
                ))

RES_XFEM=POST_CHAM_XFEM(MODELE_VISU  = MOD_VISU,
                        RESULTAT        = UTOT1)

TABDEP=POST_RELEVE_T(ACTION=_F(INTITULE='DEPLACEMENT SUR LES LEVRES',
                               RESULTAT=RES_XFEM,
                               NOM_CHAM='DEPL',
                               INST=1.0,
                               GROUP_NO=('NFISSU'),
                               TOUT_CMP='OUI',
                               OPERATION='EXTRACTION'));




# solution analytique :
#    - deplacement
def ux(X,Y):
    return (2.-X)*pression(Y)/E

UX=FORMULE(NOM_PARA=('X','Y',),VALE='ux(X,Y)',ux=ux)

#    - contraintes
def Sxx(X,Y):
    return -pression(Y)

SXX=FORMULE(NOM_PARA=('X','Y',),VALE='Sxx(X,Y)',Sxx=Sxx);

# objects needed for evaluation are hold by the formulas themself.
del ux
del Sxx

# calcul de l'erreur en terme de norme en energie
Scal=CREA_CHAMP(OPERATION='EXTR',
                TYPE_CHAM='ELGA_SIEF_R',
                RESULTAT=UTOT1,
                NOM_CHAM='SIEF_ELGA',
                NUME_ORDRE=1)

tabNRJ=POST_ERREUR(OPTION='ENER_RELA',
                   CHAM_GD=Scal,
                   MODELE=MODELEK,
                   DEFORMATION='PETIT',
                   CHAM_MATER=CHAMPMAT,
                   GROUP_MA='SURF',
                   SIXX=SXX)

IMPR_TABLE(TABLE=tabNRJ)

# calcul de l'erreur en terme de norme L2 du deplacement
Ucal=CREA_CHAMP(OPERATION='EXTR',
                TYPE_CHAM='NOEU_DEPL_R',
                RESULTAT=UTOT1,
                NOM_CHAM='DEPL',
                NUME_ORDRE=1)

tabL2=POST_ERREUR(OPTION='DEPL_RELA',
                  CHAM_GD=Ucal,
                  MODELE=MODELEK,
                  GROUP_MA='SURF',
                  DX=UX)

IMPR_TABLE(TABLE=tabL2)


TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='ANALYTIQUE',
           VALE_CALC=22000000.0,
           VALE_REFE=2.2e+7,
           NOM_PARA='REFERENCE',
           FILTRE=_F(NOM_PARA='GROUP_MA',
                     VALE_K='TOTAL'),
           TABLE=tabNRJ,
           );

TEST_TABLE(CRITERE='ABSOLU',
           VALE_CALC=0.920532482048,
           NOM_PARA='ERREUR RELATIVE',
           FILTRE=_F(NOM_PARA='GROUP_MA',
                     VALE_K='TOTAL'),
           TABLE=tabNRJ,
           );

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='ANALYTIQUE',
           VALE_CALC=0.765941686205,
           VALE_REFE=0.765941686205,
           NOM_PARA='REFERENCE',
           FILTRE=_F(NOM_PARA='GROUP_MA',
                     VALE_K='TOTAL'),
           TABLE=tabL2,
           );

TEST_TABLE(CRITERE='ABSOLU',
           VALE_CALC=0.920762510703,
           NOM_PARA='ERREUR RELATIVE',
           FILTRE=_F(NOM_PARA='GROUP_MA',
                     VALE_K='TOTAL'),
           TABLE=tabL2,
           );


test.printSummary()

FIN()
