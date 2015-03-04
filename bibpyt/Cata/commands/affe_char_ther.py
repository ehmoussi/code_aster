# coding=utf-8

from Cata.Syntax import *
from Cata.DataStructure import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================
# person_in_charge: mickael.abbas at edf.fr
AFFE_CHAR_THER=OPER(nom="AFFE_CHAR_THER",op=34,sd_prod=char_ther
                    ,fr=tr("Affectation de charges et conditions aux limites thermiques constantes"),
                    reentrant='n',
            UIinfo={"groupes":("Chargements","Thermique",)},
      regles=(AU_MOINS_UN('TEMP_IMPO','SOURCE','FLUX_REP','ECHANGE',
                          'ECHANGE_PAROI','PRE_GRAD_TEMP','LIAISON_DDL','LIAISON_GROUP',
                          'LIAISON_UNIF','LIAISON_CHAMNO','RAYONNEMENT','LIAISON_MAIL' ),),
         MODELE          =SIMP(statut='o',typ=(modele_sdaster) ),

         TEMP_IMPO       =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('TOUT','GROUP_MA','MAILLE','GROUP_NO','NOEUD'),
                   AU_MOINS_UN('TEMP','TEMP_MIL','TEMP_SUP','TEMP_INF'),),
             TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
             NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
             GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
             SANS_GROUP_MA   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             SANS_MAILLE     =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
             SANS_GROUP_NO   =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
             SANS_NOEUD      =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           TEMP            =SIMP(statut='f',typ='R'),
           TEMP_MIL        =SIMP(statut='f',typ='R'),
           TEMP_INF        =SIMP(statut='f',typ='R'),
           TEMP_SUP        =SIMP(statut='f',typ='R'), ),

         FLUX_REP        =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('TOUT','GROUP_MA','MAILLE'),
                   PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),
                   PRESENT_PRESENT('CARA_TORSION','GROUP_MA'),
                   AU_MOINS_UN('FLUN','FLUN_INF','FLUN_SUP','CARA_TORSION') ),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           FLUN            =SIMP(statut='f',typ='R'),
           FLUN_INF        =SIMP(statut='f',typ='R'),
           FLUN_SUP        =SIMP(statut='f',typ='R'),
           CARA_TORSION    =SIMP(statut='f',typ=table_sdaster),
         ),


         RAYONNEMENT     =FACT(statut='f',max='**',
           fr=tr("Attention, exprimer les températures en Celsius si rayonnement"),
           regles=(AU_MOINS_UN('TOUT','GROUP_MA','MAILLE'),
                   PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           SIGMA           =SIMP(statut='o',typ='R'),
           EPSILON         =SIMP(statut='o',typ='R'),
           TEMP_EXT        =SIMP(statut='o',typ='R'),
         ),

         ECHANGE         =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('TOUT','GROUP_MA','MAILLE'),
                   PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),
                   AU_MOINS_UN('COEF_H','COEF_H_INF','COEF_H_SUP'),
                   ENSEMBLE('COEF_H','TEMP_EXT',),
                   ENSEMBLE('COEF_H_INF','TEMP_EXT_INF'),
                             ENSEMBLE('COEF_H_SUP','TEMP_EXT_SUP'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           COEF_H          =SIMP(statut='f',typ='R'),
           TEMP_EXT        =SIMP(statut='f',typ='R'),
           COEF_H_INF      =SIMP(statut='f',typ='R'),
           TEMP_EXT_INF    =SIMP(statut='f',typ='R'),
           COEF_H_SUP      =SIMP(statut='f',typ='R'),
           TEMP_EXT_SUP    =SIMP(statut='f',typ='R'),
         ),

         SOURCE          =FACT(statut='f',max='**',
           regles=(UN_PARMI('SOUR','SOUR_CALCULEE',),
                   PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),
                   PRESENT_ABSENT('SOUR_CALCULEE','TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           SOUR            =SIMP(statut='f',typ='R'),
           SOUR_CALCULEE   =SIMP(statut='f',typ=(cham_elem) ),
         ),

         PRE_GRAD_TEMP  =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('TOUT','GROUP_MA','MAILLE'),
                   PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),
                   AU_MOINS_UN('FLUX_X','FLUX_Y','FLUX_Z'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           FLUX_X          =SIMP(statut='f',typ='R' ),
           FLUX_Y          =SIMP(statut='f',typ='R' ),
           FLUX_Z          =SIMP(statut='f',typ='R' ),
                         ),

         LIAISON_DDL     =FACT(statut='f',max='**',
           regles=(UN_PARMI('GROUP_NO','NOEUD', ),),
           GROUP_NO        =SIMP(statut='f',typ=grno,max='**'),
           NOEUD           =SIMP(statut='f',typ=no  ,max='**'),
           DDL             =SIMP(statut='f',typ='TXM',max='**',
                                 into=("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP") ),
           COEF_MULT       =SIMP(statut='o',typ='R',max='**'),
           COEF_IMPO       =SIMP(statut='o',typ='R' ),
         ),

         LIAISON_GROUP   =FACT(statut='f',max='**',
           regles=(UN_PARMI('GROUP_MA_1','MAILLE_1','GROUP_NO_1','NOEUD_1'),
                   UN_PARMI('GROUP_MA_2','MAILLE_2','GROUP_NO_2','NOEUD_2'),
                             EXCLUS('GROUP_MA_1','GROUP_NO_2'),
                             EXCLUS('GROUP_MA_1','NOEUD_2'),
                   EXCLUS('GROUP_NO_1','GROUP_MA_2'),
                             EXCLUS('GROUP_NO_1','MAILLE_2'),
                             EXCLUS('MAILLE_1','GROUP_NO_2'),
                             EXCLUS('MAILLE_1','NOEUD_2'),
                             EXCLUS('NOEUD_1','GROUP_MA_2'),
                             EXCLUS('NOEUD_1','MAILLE_2'),
                             EXCLUS('SANS_NOEUD','SANS_GROUP_NO'),),
           GROUP_MA_1      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_1        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_1      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_1         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           GROUP_MA_2      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_2        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_2      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_2         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           SANS_NOEUD      =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           SANS_GROUP_NO   =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           DDL_1           =SIMP(statut='f',typ='TXM',max='**',defaut="TEMP",
                                 into=("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP") ),
           COEF_MULT_1     =SIMP(statut='o',typ='R',max='**'),
           DDL_2           =SIMP(statut='f',typ='TXM',max='**',defaut="TEMP",
                                 into=("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP",) ),
           COEF_MULT_2     =SIMP(statut='o',typ='R',max='**'),
           COEF_IMPO       =SIMP(statut='o',typ='R' ),
           SOMMET          =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           TRAN            =SIMP(statut='f',typ='R',max='**'),
           ANGL_NAUT       =SIMP(statut='f',typ='R',max='**'),
           CENTRE          =SIMP(statut='f',typ='R',max='**'),
         ),

         LIAISON_MAIL    =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('GROUP_MA_MAIT','MAILLE_MAIT'),
                   AU_MOINS_UN('GROUP_MA_ESCL','MAILLE_ESCL','GROUP_NO_ESCL',
                               'NOEUD_ESCL'),),
           GROUP_MA_MAIT   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_MAIT     =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA_ESCL   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_ESCL     =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_ESCL   =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_ESCL      =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           TRAN            =SIMP(statut='f',typ='R',max='**' ),
           ANGL_NAUT       =SIMP(statut='f',typ='R',max='**' ),
           CENTRE          =SIMP(statut='f',typ='R',max='**' ),
           ELIM_MULT       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
           DISTANCE_MAX    =SIMP(statut='f',typ='R'),
         ),

         ECHANGE_PAROI   =FACT(statut='f',max='**',
           regles=(UN_PARMI('GROUP_MA_1','MAILLE_1','FISSURE'),
                   UN_PARMI('GROUP_MA_2','MAILLE_2','FISSURE'),),
           GROUP_MA_1      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_1        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA_2      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_2        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           FISSURE         =SIMP(statut='f',typ=fiss_xfem,validators=NoRepeat(),min=1,max=100,),
#          ----------------------
           b_paroi_maillee =BLOC(
             condition = "FISSURE == None",
             COEF_H        =SIMP(statut='o',typ='R'),
             TRAN          =SIMP(statut='f',typ='R',min=2,max=3),
                                 ),
#          ----------------------
           b_xfem         =BLOC(
             condition = "FISSURE != None",
             regles    =(UN_PARMI('COEF_H','TEMP_CONTINUE'),),
             COEF_H        =SIMP(statut='f',typ='R'),
             TEMP_CONTINUE =SIMP(statut='f',typ='TXM',into=("OUI",)),
                                 ),
         ),

         LIAISON_UNIF    =FACT(statut='f',max='**',
           regles=(UN_PARMI('GROUP_NO','NOEUD','GROUP_MA','MAILLE'),),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           DDL             =SIMP(statut='f',typ='TXM',max='**',defaut="TEMP",
                                 into=("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP") ),
         ),

         LIAISON_CHAMNO  =FACT(statut='f',max='**',
           CHAM_NO         =SIMP(statut='o',typ=cham_no_sdaster),# CO()# "il faut definir une structure de donnee generique chamno"
           COEF_IMPO       =SIMP(statut='o',typ='R' ),
           NUME_LAGR       =SIMP(statut='f',typ='TXM',defaut="NORMAL",into=("NORMAL","APRES") ),
         ),

         CONVECTION      =FACT(statut='f',max='**',
           VITESSE         =SIMP(statut='o',typ=(cham_no_sdaster) ),
         ),


         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),
)  ;
