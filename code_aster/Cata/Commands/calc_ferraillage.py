# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: jessica.haelewyn at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def calc_ferraillage_prod(RESULTAT,**args):
   if AsType(RESULTAT) != None : return AsType(RESULTAT)
   raise AsException("type de concept resultat non prevu")


CALC_FERRAILLAGE=OPER(nom="CALC_FERRAILLAGE",op=175,sd_prod=calc_ferraillage_prod,
         reentrant='o:RESULTAT',
         fr=tr("calcul de cartes de densité de ferraillage "),

         reuse=SIMP(statut='c', typ=CO),
         RESULTAT        =SIMP(statut='o',typ=(evol_elas,evol_noli,dyna_trans,) ),
#
#====
# Sélection des numéros d'ordre pour lesquels on fait le calcul :
#====
#
         TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
         LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
         INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
         LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),
         FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
         LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),

         b_acce_reel     =BLOC(condition="""(exists("FREQ"))or(exists("LIST_FREQ"))or(exists("INST"))or(exists("LIST_INST"))""",
            CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
            b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                 PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
            b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                 PRECISION       =SIMP(statut='o',typ='R',),),
         ),

#
#====
# Définition des grandeurs caractéristiques
#====
#
         TYPE_COMB    =SIMP(statut='o',typ='TXM',into=('ELU','ELS')),
         CODIFICATION =SIMP(statut='o',typ='TXM', defaut='UTILISATEUR',into=('UTILISATEUR','BAEL91','EC2')),

         b_UTILISATEUR = BLOC(condition = """ equal_to("CODIFICATION", 'UTILISATEUR')""",
                          fr=tr("utilisation sans réglementation spécifique. Version aster <= 13"),
#          mot clé facteur répétable pour assigner les caractéristiques locales par zones topologiques (GROUP_MA)
           AFFE  =FACT(statut='o',max='**',
             regles=(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
             TOUT       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             GROUP_MA   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             MAILLE     =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
             ENROBG     =SIMP(statut='o',typ='R'), # enrobage armatures
             CEQUI      =SIMP(statut='f',typ='R'), # coefficient d'équivalence acier/béton  (pour ELS)
             SIGM_ACIER =SIMP(statut='o',typ='R'), # contrainte admissible dans l'acier
             SIGM_BETON =SIMP(statut='o',typ='R'), # contrainte admissible dans le béton
             PIVA       =SIMP(statut='f',typ='R'), # valeur du pivot a  (pour ELU)
             PIVB       =SIMP(statut='f',typ='R'), # valeur du pivot b  (pour ELU)
             ES         =SIMP(statut='f',typ='R'), # valeur du Module d'Young de l'acier (pour ELU)
             ),),

         b_BAEL91 = BLOC(condition = """ equal_to("CODIFICATION", 'BAEL91')""",
                          fr=tr("utilisation du BAEL91"),
#          mot clé facteur répétable pour assigner les caractéristiques locales par zones topologiques (GROUP_MA)
           AFFE  =FACT(statut='o',max='**',
             regles=(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
             UNITE_CONTRAINTE =SIMP(statut='o',typ='TXM', into=("MPa","Pa"),fr=tr("Unité des contraintes du problème.")),
             TOUT       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             GROUP_MA   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             MAILLE     =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
             C_INF      =SIMP(statut='o',typ='R'), # enrobage armatures inférieures
             C_SUP      =SIMP(statut='o',typ='R'), # enrobage armatures supérieures
             N          =SIMP(statut='f',typ='R'), # coefficient d'équivalence acier/béton  (pour ELS)
             FE         =SIMP(statut='f',typ='R'), # contrainte admissible dans l'acier
             FCJ        =SIMP(statut='f',typ='R'), # contrainte admissible dans le béton
             GAMMA_C    =SIMP(statut='f',typ='R'), # coefficient de sécurité sur la résistance de calcul du béton
             GAMMA_S    =SIMP(statut='f',typ='R'), # coefficient de sécurité sur la résistance de calcul des aciers
             ALPHA_CC   =SIMP(statut='f',typ='R',defaut=0.85), # coefficient intervennant à l'ELU
             SIGS_ELS   =SIMP(statut='f',typ='R'), # contrainte ultime de dimensionnement de l'acier pour l'ELS
             SIGC_ELS   =SIMP(statut='f',typ='R'), # contrainte ultime de dimensionnement du béton pour l'ELS
             E_S        =SIMP(statut='f',typ='R'), # valeur du Module d'Young de l'acier (pour ELU)
             ),),

         b_EC2 = BLOC(condition = """ equal_to("CODIFICATION", 'EC2')""",
                          fr=tr("utilisation de l'eurocode 2"),
#          mot clé facteur répétable pour assigner les caractéristiques locales par zones topologiques (GROUP_MA)
           AFFE  =FACT(statut='o',max='**',
             regles=(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
             UNITE_CONTRAINTE =SIMP(statut='o',typ='TXM', into=("MPa","Pa"),fr=tr("Unité des contraintes du problème.")),
             TOUT             =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             GROUP_MA         =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             MAILLE           =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
             C_INF            =SIMP(statut='o',typ='R'), # enrobage armatures inférieures
             C_SUP            =SIMP(statut='o',typ='R'), # enrobage armatures supérieures
             ALPHA_E          =SIMP(statut='f',typ='R'), # coefficient d'équivalence acier/béton  (pour ELS)
             FYK              =SIMP(statut='f',typ='R'), # contrainte admissible dans l'acier
             GAMMA_S          =SIMP(statut='f',typ='R'), # coefficient de sécurité sur la résistance de calcul des aciers
             FCK              =SIMP(statut='f',typ='R'), # contrainte admissible dans le béton
             GAMMA_C          =SIMP(statut='f',typ='R'), # coefficient de sécurité sur la résistance de calcul du béton
             ALPHA_CC         =SIMP(statut='f',typ='R',defaut=1.), # coefficient intervennant à l'ELU
             SIGS_ELS         =SIMP(statut='f',typ='R'), # contrainte ultime de dimensionnement de l'acier pour l'ELS
             SIGC_ELS         =SIMP(statut='f',typ='R'), # contrainte ultime de dimensionnement du béton pour l'ELS
             E_S              =SIMP(statut='f',typ='R'), # valeur du Module d'Young de l'acier (pour ELU)
             CLASSE_ACIER     =SIMP(statut='f',typ='TXM',defaut='B', into=("A","B","C")), # classe de ductilité des aciers
             ),),
      )


##############################################################################################################
# Remarques :
#-----------
#        l'épaisseur des coques sera récupérée automatiquement
#        via le cara_elem sous-jacent au résultat

# Le résultat produit est un champ constant par éléments associé à la grandeur FER2_R
# qui comporte les composantes :
#
#     DNSXI  densité d'acier longitudinal suivant X, peau inf
#     DNSXS  densité d'acier longitudinal suivant X, peau sup
#     DNSYI  densité d'acier longitudinal suivant Y, peau inf
#     DNSYS  densité d'acier longitudinal suivant Y, peau sup
#     DNST   densité d'acier transversal à l'ELU
#     SIGMBE contrainte beton
#     EPSIBE deformation béton

# arrêt en erreur si:
# - EFGE_ELNO n'a pas été précédemment calculé et n'est donc pas présent dans la structure de données RESULTAT
# - si aucun CARA_ELEM n'est récupérable via la structure de données RESULTAT
