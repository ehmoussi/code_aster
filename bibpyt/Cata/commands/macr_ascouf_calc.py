# coding=utf-8

from Cata.Descriptor import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: samuel.geniaut at edf.fr

def macr_ascouf_calc_prod(self,MODELE,CHAM_MATER,CARA_ELEM,FOND_FISS,RESU_THER,**args):
  self.type_sdprod(MODELE,modele_sdaster)
  if CHAM_MATER != None:self.type_sdprod(CHAM_MATER,cham_mater)
  if CARA_ELEM  != None:self.type_sdprod(CARA_ELEM,cara_elem)
  if FOND_FISS  != None:self.type_sdprod(FOND_FISS,fond_fiss)
  if RESU_THER  != None:self.type_sdprod(RESU_THER,evol_ther)
  return evol_noli

MACR_ASCOUF_CALC=MACRO(nom="MACR_ASCOUF_CALC",
                       op=OPS('Macro.macr_ascouf_calc_ops.macr_ascouf_calc_ops'),
                       sd_prod=macr_ascouf_calc_prod,
                       fr=tr("Réalise l'analyse thermomécanique du coude dont le maillage a "
                            "été concu par MACR_ASCOUF_MAIL"),
                       reentrant='n',
                       UIinfo={"groupes":("Résolution","Outils-métier",)},

         TYPE_MAILLAGE   =SIMP(statut='o',typ='TXM',
                               into=("SAIN",
                                     "FISS_COUDE",
                                     "FISS_AXIS_DEB",
                                     "SOUS_EPAIS_COUDE"
                                     ) ),

         MAILLAGE        =SIMP(statut='o',typ=maillage_sdaster ),
         MODELE          =SIMP(statut='o',typ=CO,),
         CHAM_MATER      =SIMP(statut='f',typ=CO,),
         CARA_ELEM       =SIMP(statut='f',typ=CO,),
         FOND_FISS       =SIMP(statut='f',typ=CO,),
         RESU_THER       =SIMP(statut='f',typ=CO,),

         AFFE_MATERIAU   =FACT(statut='o',max=3,
           regles=(UN_PARMI('TOUT','GROUP_MA'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,into=("COUDE","BOL") ),
           MATER           =SIMP(statut='o',typ=mater_sdaster ),
           TEMP_REF        =SIMP(statut='f',typ='R',defaut= 0.E+0 ),
         ),

         PRES_REP        =FACT(statut='f',
           PRES            =SIMP(statut='o',typ='R' ),
           EFFE_FOND_P1    =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
           PRES_LEVRE      =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
           FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
         ),

         ECHANGE         =FACT(statut='f',
           COEF_H          =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
           TEMP_EXT        =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
         ),

         TORS_P1         =FACT(statut='f',max=6,
           regles=(AU_MOINS_UN('FX','FY','FZ','MX','MY','MZ'),),
           FX              =SIMP(statut='f',typ='R' ),
           FY              =SIMP(statut='f',typ='R' ),
           FZ              =SIMP(statut='f',typ='R' ),
           MX              =SIMP(statut='f',typ='R' ),
           MY              =SIMP(statut='f',typ='R' ),
           MZ              =SIMP(statut='f',typ='R' ),
           FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
         ),


         COMPORTEMENT       =C_COMPORTEMENT('MACR_ASCOUF_CALC'),

#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('MACR_ASCOUF_CALC'),
#-------------------------------------------------------------------

         CONVERGENCE     =C_CONVERGENCE(),

         NEWTON          =C_NEWTON(),

         RECH_LINEAIRE   =C_RECH_LINEAIRE(),

         INCREMENT       =C_INCREMENT('MECANIQUE'),

         THETA_3D        =FACT(statut='f',max='**',
           R_INF           =SIMP(statut='o',typ='R' ),
           R_SUP           =SIMP(statut='o',typ='R' ),
         ),

         ENERGIE         =FACT(statut='f',max=1,
           CALCUL          =SIMP(statut='f',typ='TXM',into=("OUI",),defaut="OUI",),
         ),

         IMPR_TABLE      =FACT(statut='f',
           regles=(UN_PARMI('TOUT_PARA','NOM_PARA', ),
            PRESENT_PRESENT('TOUT_PARA','ANGLE',    ),
            PRESENT_PRESENT('TOUT_PARA','R_CINTR',  ),
                   UN_PARMI('POSI_CURV_LONGI','POSI_ANGUL',),),
           NOM_PARA        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=4,
                                 into=("TRESCA_MEMBRANE",
                                       "TRESCA_MFLE",
                                       "TRESCA",
                                       "SI_LONG"
                                       "SI_RADI"
                                       "SI_CIRC"
                                       ) ),
           TOUT_PARA       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           ANGLE           =SIMP(statut='f',typ='R', ),
           R_CINTR         =SIMP(statut='f',typ='R', ),
           POSI_CURV_LONGI =SIMP(statut='f',typ='R', ),
           POSI_ANGUL      =SIMP(statut='f',typ='R', ),
           TRANSFORMEE     =SIMP(statut='f',typ='TXM',defaut="COUDE",into=("COUDE","TUBE") ),
         ),

         IMPRESSION      =FACT(statut='f',
           FORMAT          =SIMP(statut='f',typ='TXM',defaut="RESULTAT",
                                 into=("RESULTAT","ASTER","IDEAS","CASTEM") ),

           b_format_ideas  =BLOC(condition="FORMAT=='IDEAS'",fr=tr("version Ideas"),
             VERSION         =SIMP(statut='f',typ='I',defaut=5,into=(4,5)),
           ),

           b_format_castem =BLOC(condition="FORMAT=='CASTEM'",fr=tr("version Castem"),
             NIVE_GIBI       =SIMP(statut='f',typ='I',defaut=10,into=(3,10)),
           ),

         ),

         TITRE           =SIMP(statut='f',typ='TXM' ),

         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),
)  ;
