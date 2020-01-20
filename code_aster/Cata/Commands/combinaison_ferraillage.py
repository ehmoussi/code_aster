# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2018 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2018 Kobe Innovation Engineering - www.kobe-ie.com
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
# aslint: disable=W4004

from ..Commons import *
from ..Language.DataStructure import *
from ..Language.Syntax import *


# definition of macro return types (both in-out arguments and return types)
def combinaison_ferraillage_prod ( self, **args ):
    return mult_elas

# definition of macro catalogue
COMBINAISON_FERRAILLAGE = MACRO(
    nom = 'COMBINAISON_FERRAILLAGE',
    op = OPS('code_aster.MacroCommands.combinaison_ferraillage_ops.combinaison_ferraillage_ops'),
    fr = tr("COMBINAISON_FERRAILLAGE"),
    sd_prod = combinaison_ferraillage_prod,
    reentrant = 'o:RESULTAT',
    reuse = SIMP ( statut = 'c', typ = CO ),

    RESULTAT = SIMP ( statut = 'o', typ = mult_elas ),

    COMBINAISON   = FACT ( statut = 'o', min = 1 , max = '**',
        TYPE = SIMP ( statut = 'o', typ = 'TXM',
                      into = (
                               'ELS_CARACTERISTIQUE',
                               'ELU_FONDAMENTAL',
                               'ELU_ACCIDENTEL',
                              )
                    ),
        regles = ( UN_PARMI ( 'NOM_CAS', 'NUME_ORDRE' ), ),
           NOM_CAS = SIMP ( statut = 'f', typ = 'TXM', min = 1, max = '**' ),
        NUME_ORDRE = SIMP ( statut = 'f', typ = 'I', min = 1, max = '**' ),
    ),

    CODIFICATION  = SIMP ( statut = 'f', typ = 'TXM', defaut = 'EC2' ,
                           into = ('EC2','UTILISATEUR') ),

    b_ec2 = BLOC (
        condition = "equal_to('CODIFICATION', 'EC2')",
        fr = tr ("Paramètres de la méthode EC2"),
        AFFE = FACT ( statut = 'o', min = 1 , max = '**',
            regles = ( UN_PARMI ( 'TOUT', 'GROUP_MA' ), ),
                TOUT = SIMP ( statut = 'f', typ = 'TXM', into = ('OUI',) ),

            GROUP_MA = SIMP ( statut = 'f', typ = grma,
                              validators=NoRepeat() , max='**'),
            TYPE_STRUCTURE = SIMP ( statut = 'o', typ = 'TXM',
                          into = (
                                   # 'POUTRE', TODO: next release
                                   # 'POTEAU', TODO: next release
                                   '2D',
                                  )
                        ),
            UNITE_CONTRAINTE = SIMP(statut='o',typ='TXM', into=("MPa","Pa"),
                                    fr=tr("Unité des contraintes du problème.")),
            C_INF            = SIMP(statut='o',typ='R',
                                    fr=tr("Enrobage des armatures inférieures")),
            C_SUP            = SIMP(statut='o',typ='R',
                                    fr=tr("Enrobage des armatures supérieures")),
            ALPHA_E          = SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient d'équivalence acier/béton (ELS)")),
            RHO_ACIER        = SIMP(statut='f',typ='R', defaut=-1,
                                    fr=tr("Densité volumique des aciers")),
            GAMMA_S_FOND     = SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul des aciers pour la combinaison fondamentale")),
            GAMMA_C_FOND     = SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton pour la combinaison fondamentale")),
            GAMMA_S_ACCI     = SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul des aciers pour la combinaison accidentelle")),
            GAMMA_C_ACCI     = SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton pour la combinaison fondamentale")),
            FYK              = SIMP(statut='f',typ='R',
                                    fr=tr("Limite d'élasticité caractéristique dans l'acier")),
            FCK              = SIMP(statut='f',typ='R',
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul des aciers")),
            ALPHA_CC         = SIMP(statut='f',typ='R',defaut=1.,
                                    fr=tr("Coefficient de sécurité sur la résistance de calcul du béton en compression (ELU)")),
            SIGS_ELS         = SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte ultime de dimensionnement des aciers (ELS)")),
            SIGC_ELS         = SIMP(statut='f',typ='R',
                                    fr=tr("Contrainte ultime de dimensionnement du béton (ELS)")),
            UTIL_COMPR       = SIMP(statut='f',typ='TXM',defaut='NON', into=("OUI","NON"),
                                    fr=tr("Prise en compte de la compression pour les aciers transversaux")),
            CLASSE_ACIER     = SIMP(statut='f',typ='TXM',defaut='B', into=("A","B","C"),
                                    fr=tr("Classe de ductilité des aciers")),
            b_iconst_ec2 = BLOC(condition = """ greater_than("RHO_ACIER", 0)""",
                                fr=tr("Calcul du critère de difficulté de bétonnage si RHO_ACIER > 0"),
                ALPHA_REINF      = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier par mètre cube de béton")),
                ALPHA_SHEAR      = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier d'effort tranchant")),
                ALPHA_STIRRUPS   = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de longueur des épingles d'acier effort tranchant")),
                RHO_CRIT         = SIMP(statut='f',typ='R',defaut=150,
                                        fr=tr("Densité volumique d'armature critique")),
                DNSTRA_CRIT      = SIMP(statut='f',typ='R',defaut=0.006,
                                        fr=tr("Ferraillage d'effort tranchant critique")),
                L_CRIT           = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Longueur critique des epingle d'aciers d'effort tranchant")),
                ),
        ),
    ),

    b_uti = BLOC (
        condition = "equal_to('CODIFICATION', 'UTILISATEUR')",
        fr = tr ("Paramètres de la méthode UTILISATEUR"),
        AFFE = FACT ( statut = 'o', min = 1 , max = '**',
            regles = ( UN_PARMI ( 'TOUT', 'GROUP_MA' ), ),
                TOUT = SIMP ( statut = 'f', typ = 'TXM', into = ('OUI',) ),

            GROUP_MA = SIMP ( statut = 'f', typ = grma,
                              validators=NoRepeat() , max='**'),
            TYPE_STRUCTURE = SIMP ( statut = 'o', typ = 'TXM',
                          into = (
                                   # 'POUTRE', TODO: next release
                                   # 'POTEAU', TODO: next release
                                   '2D',
                                  )
                        ),
            ENROBG     = SIMP(statut='o',typ='R',
                              fr=tr("Enrobage des armatures")),
            CEQUI      = SIMP(statut='f',typ='R',
                              fr=tr("Coefficient d'équivalence acier/béton (ELS)")),
            RHO_ACIER  =SIMP(statut='f',typ='R', defaut=-1,
                              fr=tr("Densité volumique des aciers")),
            SIGM_ACIER = SIMP(statut='o',typ='R',
                              fr=tr("Contrainte admissible des aciers")),
            SIGM_BETON = SIMP(statut='o',typ='R',
                              fr=tr("Contrainte admissible dans le béton")),
            PIVA       = SIMP(statut='f',typ='R',
                              fr=tr("Valeur de déformation pour le pivot A")),
            PIVB       = SIMP(statut='f',typ='R',
                              fr=tr("Valeur de déformation pour le pivot B")),
            b_iconst_util = BLOC(condition = """ greater_than("RHO_ACIER", 0)""",
                                  fr=tr("Calcul du critère de difficulté de bétonnage si RHO_ACIER > 0"),
                ALPHA_REINF      = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier par mètre cube de béton")),
                ALPHA_SHEAR      = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de densité d'acier d'effort tranchant")),
                ALPHA_STIRRUPS   = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Coefficient de pondération du ration de longueur des épingles d'acier effort tranchant")),
                RHO_CRIT         = SIMP(statut='f',typ='R',defaut=150,
                                        fr=tr("Densité volumique d'armature critique")),
                DNSTRA_CRIT      = SIMP(statut='f',typ='R',defaut=0.006,
                                        fr=tr("Ferraillage d'effort tranchant critique")),
                L_CRIT           = SIMP(statut='f',typ='R',defaut=1,
                                        fr=tr("Longueur critique des epingle d'aciers d'effort tranchant")),
                ),
        ),
    ),
)
