# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from ..Commons import *
from ..Language.DataStructure import *
from ..Language.Syntax import *


def calc_ferraillage_prod(RESULTAT,**args):
   if args.get('__all__'):
       return (evol_elas, evol_noli, dyna_trans, mult_elas)

   if AsType(RESULTAT) is not None : return AsType(RESULTAT)
   raise AsException("type de concept resultat non prevu")


CALC_FERRAILLAGE=OPER(nom="CALC_FERRAILLAGE", op=175, sd_prod=calc_ferraillage_prod,
                      reentrant='o:RESULTAT',
                      fr=tr("calcul de cartes de densité de ferraillage "),

         reuse           =SIMP(statut='c', typ=CO),
         RESULTAT        =SIMP(statut='o',typ=(evol_elas,evol_noli,dyna_trans,mult_elas,) ),
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
         CODIFICATION =SIMP(statut='f',typ='TXM', defaut='EC2',into=('BAEL91','EC2')),

         b_BAEL91 = BLOC(condition = """ equal_to("CODIFICATION", 'BAEL91')""",
                          fr=tr("utilisation du BAEL91"),
#          mot clé facteur répétable pour assigner les caractéristiques locales par zones topologiques (GROUP_MA)
           AFFE               =FACT(statut='o',max='**',
             regles           =(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
             TOUT             =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             GROUP_MA         =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             MAILLE           =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
             UNITE_CONTRAINTE =SIMP(statut='o',typ='TXM', into=("MPa","Pa"),
                                    fr=tr("Unité des contraintes du problème.")),
             C_INF            =SIMP(statut='o',typ='R',
                                    fr=tr("Enrobage des armatures inférieures")),
             C_SUP            =SIMP(statut='o',typ='R',
                                    fr=tr("Enrobage des armatures supérieures")),
             N                =SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient d'équivalence acier/béton (ELS)")),
             RHO_ACIER        =SIMP(statut='f',typ='R', defaut=-1,
                                   fr=tr("Densité volumique des aciers")),
             FE               =SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte admissible dans l'acier")),
             GAMMA_S          =SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul des aciers à l'ELU")),
             FCJ              =SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte admissible dans le béton")),
             GAMMA_C          =SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton à l'ELU")),
             ALPHA_CC         =SIMP(statut='f',typ='R',defaut=0.85,
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton en compression (ELU)")),
             SIGS_ELS         =SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte ultime de dimensionnement des aciers à l'ELS")),
             SIGC_ELS         =SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte ultime de dimensionnement du béton à l'ELS")),
             b_iconst_bael = BLOC(condition = """ greater_than("RHO_ACIER", 0)""",
                                  fr=tr("Calcul du critère de difficulté de bétonnage si RHO_ACIER > 0"),
                ALPHA_REINF      =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier par mètre cube de béton")),
                ALPHA_SHEAR      =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier d'effort tranchant")),
                ALPHA_STIRRUPS   =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de longueur des épingles d'acier d'effort tranchant")),
                RHO_CRIT         =SIMP(statut='f',typ='R',defaut=150,
                                        fr=tr("Densité volumique d'armature critique")),
                DNSTRA_CRIT      =SIMP(statut='f',typ='R',defaut=0.006,
                                        fr=tr("Ferraillage d'effort tranchant critique")),
                L_CRIT           =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Longueur critique des épingles d'aciers d'effort tranchant")),
                ),
             ),),

         b_EC2 = BLOC(condition = """ equal_to("CODIFICATION", 'EC2')""",
                          fr=tr("utilisation de l'eurocode 2"),
#          mot clé facteur répétable pour assigner les caractéristiques locales par zones topologiques (GROUP_MA)
           AFFE               =FACT(statut='o',max='**',
             regles           =(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
             TOUT             =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             GROUP_MA         =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             MAILLE           =SIMP(statut='c',typ=ma,validators=NoRepeat(),max='**'),
             UNITE_CONTRAINTE =SIMP(statut='o',typ='TXM', into=("MPa","Pa"),
                                    fr=tr("Unité des contraintes du problème")),
             C_INF            =SIMP(statut='o',typ='R',
                                    fr=tr("Enrobage des armatures inférieures")),
             C_SUP            =SIMP(statut='o',typ='R',
                                    fr=tr("Enrobage des armatures supérieures")),
             ALPHA_E          =SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient d'équivalence acier/béton (ELS)")),
             RHO_ACIER        =SIMP(statut='f',typ='R', defaut=-1,
                                    fr=tr("Densité volumique des aciers")),
             FYK              =SIMP(statut='f',typ='R',
                                    fr=tr("Limite d'élasticité caractéristique dans l'acier")),
             GAMMA_S          =SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul des aciers")),
             FCK              =SIMP(statut='f',typ='R',
                                    fr=tr("Résistance caractéristique du béton en compression à 28 jours")),
             GAMMA_C          =SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton")),
             ALPHA_CC         =SIMP(statut='f',typ='R',defaut=1.,
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton en compression (ELU)")),
             SIGS_ELS         =SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte ultime de dimensionnement des aciers (ELS)")),
             SIGC_ELS         =SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte ultime de dimensionnement du béton (ELS)")),
             UTIL_COMPR       =SIMP(statut='f',typ='TXM',defaut='NON', into=("OUI","NON"),
                                    fr=tr("Prise en compte de la compression pour les aciers transversaux")),
             CLASSE_ACIER     =SIMP(statut='f',typ='TXM',defaut='B', into=("A","B","C"),
                                    fr=tr("Classe de ductilité des aciers")),
             b_iconst_ec2 = BLOC(condition = """ greater_than("RHO_ACIER", 0)""",
                                 fr=tr("Calcul du critère de difficulté de bétonnage si RHO_ACIER > 0"),
                ALPHA_REINF      =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier par mètre cube de béton")),
                ALPHA_SHEAR      =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier d'effort tranchant")),
                ALPHA_STIRRUPS   =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de longueur des épingles d'acier effort tranchant")),
                RHO_CRIT         =SIMP(statut='f',typ='R',defaut=150,
                                        fr=tr("Densité volumique d'armature critique")),
                DNSTRA_CRIT      =SIMP(statut='f',typ='R',defaut=0.006,
                                        fr=tr("Ferraillage d'effort tranchant critique")),
                L_CRIT           =SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Longueur critique des epingle d'aciers d'effort tranchant")),
                ),
             ),),
      )


##############################################################################################################
# Remarques :
#-----------
#     l'épaisseur des coques sera récupérée automatiquemen tvia le cara_elem sous-jacent au résultat

#     Le résultat produit est un champ constant par éléments associé à la grandeur FER2_R
#     qui comporte les composantes :
#        DNSXI    densité d'acier de flexion suivant X, peau inf
#        DNSXS    densité d'acier de flexion suivant X, peau sup
#        DNSYI    densité d'acier de flexion suivant Y, peau inf
#        DNSYS    densité d'acier de flexion suivant Y, peau sup
#        DNST     densité d'acier d'effort tranchant
#        DNSVOL   densité volumique totalte d'acier
#        CONSTRUC critère de constructibilité

#     Arrêt en erreur si:
#        - EFGE_ELNO n'a pas été précédemment calculé et n'est donc pas présent dans la structure de données RESULTAT
#        - si aucun CARA_ELEM n'est récupérable via la structure de données RESULTAT
