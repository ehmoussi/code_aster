#!/usr/bin/python
# coding: utf-8
# RESOLUTION CHAINEE
#
# Pour la validation, on regarde les valeurs de DY, PRE1 et SIYY
# en 4 noeuds situes sur le bord droit de la structure
#
# On regarde a 2 instants : 1. et 10 secondes.
# La solution est 1D selon l'axe vertical.
#
#   p = 3.E6 Pa
#
#    *---* N4   Y=5
#    !   !
#    !   !
#    !   ! N23
#    !   !
#    !   !
#    !   ! N27  Y=0
#    !   !
#    !   !
#    !   ! N31
#    !   !
#    !   !
#    *---* N1   Y=-5

import numpy

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


MAIL=code_aster.Mesh()
MAIL.readMedFile("wtnp129a.mmed")

DEFI_GROUP(reuse=MAIL,MAILLAGE=MAIL, CREA_GROUP_NO=_F( TOUT_GROUP_MA = 'OUI'))

MAILLIN = CREA_MAILLAGE(
                         MAILLAGE  = MAIL,
                         QUAD_LINE = _F(TOUT = 'OUI'),
                       )

MODELIN=AFFE_MODELE(MAILLAGE=MAILLIN,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='D_PLAN'));

MODMEC=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='D_PLAN_SI'));

MODHYD=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='D_PLAN_HS'));

MATPROJ = PROJ_CHAMP(
               METHODE='COLLOCATION',
               PROJECTION='NON',
               MODELE_1=MODHYD,
               MODELE_2=MODELIN)

MATPROJ2 = PROJ_CHAMP(
               METHODE='COLLOCATION',
               PROJECTION='NON',
               MODELE_1=MODHYD,
               MODELE_2=MODMEC)

##############################
# LISTE DES INSTANTS DE CALCUL
##############################

p_np1 = 10;
P_T1  = 1.E-4;
p_np2 = 9;
P_T2  = 1.E-3;
p_np3 = 10;
P_T3  = 1.E-2;
p_np4 = 20;
P_T4  = 1.E-1;
p_np5 = 25;
P_T5  = 1.;
p_np6 = 75;
P_T6  = 10.;

p_np7 = 47;
P_T7  = 100.;
p_np8 = 8;
P_T8  = 250.;

linsta =               P_T1 * numpy.arange(p_np1+1)/p_np1;
linstb = P_T1 + (P_T2-P_T1) * numpy.arange(1,p_np2+1)/p_np2;
linstc = P_T2 + (P_T3-P_T2) * numpy.arange(1,p_np3+1)/p_np3;
linstd = P_T3 + (P_T4-P_T3) * numpy.arange(1,p_np4+1)/p_np4;
linste = P_T4 + (P_T5-P_T4) * numpy.arange(1,p_np5+1)/p_np5;
linstf = P_T5 + (P_T6-P_T5) * numpy.arange(1,p_np6+1)/p_np6;
#linstg = P_T6 + (P_T7-P_T6) * numpy.arange(1,p_np7+1)/p_np7;
#linsth = P_T7 + (P_T8-P_T7) * numpy.arange(1,p_np8+1)/p_np8;

linst=list(linsta);
linst+=list(linstb);
linst+=list(linstc);
linst+=list(linstd);
linst+=list(linste);
linst+=list(linstf);
#linst+=list(linstg);
#linst+=list(linsth);


#############################################################
# Le python precedent est equivalent a la commande ASTER
# suivante
#############################################################

#LI=DEFI_LIST_REEL(DEBUT=0.0,
#                  INTERVALLE=(_F(JUSQU_A=1.E-4,
#                                 NOMBRE=10),
#                              _F(JUSQU_A=1.E-3,
#                                 NOMBRE=9),
#                             _F(JUSQU_A=1.E-2,
#                                 NOMBRE=10),
#                              _F(JUSQU_A=0.10000000000000001,
#                                 NOMBRE=20),
#                              _F(JUSQU_A=1.0,
#                                 NOMBRE=25),
#                              _F(JUSQU_A=10,
#                                 NOMBRE=30),
#                              _F(JUSQU_A=100,
#                                 NOMBRE=47),
#                              _F(JUSQU_A=1000,
#                                 NOMBRE=48),
#                              _F(JUSQU_A=10000,
#                                 NOMBRE=50)));

lenlinst=len(linst)

UN=DEFI_CONSTANTE(VALE=1.0);

ZERO=DEFI_CONSTANTE(VALE=0.0);

BIDON=DEFI_CONSTANTE(VALE=0.0);

#
#
#K=k*mu/(rhow*g)
#

KINT=DEFI_CONSTANTE(VALE=1.E-08);
#

MATERIAU=DEFI_MATERIAU(ELAS=_F(E=5.8E9,
                               NU=0.0,
                               RHO=2800.0,
                               ALPHA=1.0000000000000001E-05),
                       COMP_THM = 'LIQU_SATU',
                       THM_LIQU=_F(RHO=1000.0,
                                   UN_SUR_K=0.5E-9,
                                   VISC=UN,
                                   D_VISC_TEMP=ZERO),
                       THM_INIT=_F(PRE1=1.E6,
                                   PORO=0.5),
                       THM_DIFFU=_F(
                                    RHO=2800.0,
                                    BIOT_COEF=1.0,
                                    PESA_X=0.0,
                                    PESA_Y=0.0,
                                    PESA_Z=0.0,
                                    PERM_IN=KINT));

CHMAT0=AFFE_MATERIAU(MAILLAGE=MAIL,
                     AFFE=_F(TOUT='OUI',
                             MATER=MATERIAU));

CHARMEC=AFFE_CHAR_CINE(MODELE=MODMEC,
                    MECA_IMPO=(_F(GROUP_MA='BAS',
                                 DX=0.0,
                                 DY=0.0),
                              _F(GROUP_MA=('GAUCHE','DROITE'),
                                 DX=0.0)));

CHARHYD=AFFE_CHAR_CINE(MODELE=MODHYD,
                       MECA_IMPO=(_F(GROUP_MA='HAUT',
                                 PRE1=2.E6)));

CHAINAGE_THM(
             TYPE_CHAINAGE = 'INIT',
             MODELE_MECA   = MODMEC,
             MODELE_HYDR   = MODHYD,
             MATR_MH       = CO('MATMH'),
             MATR_HM1      = CO('MATHM1'),
             MATR_HM2      = CO('MATHM2'),
);


UNPAS=DEFI_LIST_REEL(DEBUT=linst[0],
                     INTERVALLE=_F(JUSQU_A=linst[1],
                                   NOMBRE=1));

UNPASSUB =DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST =UNPAS ),
                         ECHEC=_F(
                                  SUBD_METHODE='MANUEL',
                                  SUBD_PAS  = 4,
                                  SUBD_NIVEAU=5));

MATEHY=AFFE_MATERIAU(MAILLAGE=MAIL,
                     AFFE=_F(TOUT='OUI',
                             MATER=MATERIAU));


PRELIQ=STAT_NON_LINE(MODELE=MODHYD,
                    CHAM_MATER=MATEHY,
                    EXCIT=_F(CHARGE=CHARHYD),
                    SOLVEUR=_F(METHODE='MUMPS'),
                    ARCHIVAGE=_F(LIST_INST=UNPAS),
                    COMPORTEMENT=_F(RELATION='KIT_H',
                                 RELATION_KIT=('LIQU_SATU','HYDR_UTIL')),
                    INCREMENT=_F(LIST_INST=UNPASSUB));


REPTOT=CHAINAGE_THM(RESU_HYDR=PRELIQ,
                    MODELE_MECA=MODMEC,
                    TYPE_CHAINAGE='HYDR_MECA',
                    MATR_HM1=MATHM1,
                    MATR_HM2=MATHM2,
                    INST=linst[1]);

test.assertEqual(REPTOT.getType(), "EVOL_VARC")


test.printSummary()

FIN()
