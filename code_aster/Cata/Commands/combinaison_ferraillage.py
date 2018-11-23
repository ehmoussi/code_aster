# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2018 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2018 Kobe Innovation Engineering - www.kobe-ie.com
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
# aslint: disable=W4004

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# definition of macro return types (both in-out arguments and return types)
def combinaison_ferraillage_prod ( self, **args ):
    return mult_elas

# definition of macro catalogue
COMBINAISON_FERRAILLAGE = MACRO(
    nom = 'COMBINAISON_FERRAILLAGE',
    op = OPS('Macro.combinaison_ferraillage_ops.combinaison_ferraillage_ops'),

    # Need to include Macro directory in export or copy files inside C_A Macro
    # dir (and adapt next line) :

    #
    fr = tr("COMBINAISON_FERRAILLAGE"),

    #
    sd_prod = combinaison_ferraillage_prod,
    reentrant = 'o:RESULTAT',
    reuse = SIMP ( statut = 'c', typ = CO ),
    #
    RESULTAT = SIMP ( statut = 'o', typ = mult_elas ),

    #
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

    CODIFICATION  = SIMP ( statut = 'd', typ = 'TXM', defaut = 'EC2' ,
                           into = ('EC2','UTILISATEUR') ),

    MODELE  = SIMP ( statut = 'o', typ = modele_sdaster ),

    CARA_ELEM  = SIMP ( statut = 'o', typ = cara_elem ),

    #
    b_ec2 = BLOC (
        condition = "equal_to('CODIFICATION', 'EC2')",
        fr = tr ("Paramètres de la méthode EC2"),
        AFFE = FACT ( statut = 'o', min = 1 , max = '**',
            regles = ( UN_PARMI ( 'TOUT', 'GROUP_MA' ), ),
                TOUT = SIMP ( statut = 'f', typ = 'TXM',
                              into = ('OUI','NON') ),
            GROUP_MA = SIMP ( statut = 'f', typ = grma,
                              validators=NoRepeat() , max='**'),
            TYPE_STRUCTURE = SIMP ( statut = 'o', typ = 'TXM',
                          into = (
                                   'POUTRE',
                                   'POTEAU',
                                   '2D',
                                  )
                        ),
            UNITE_CONTRAINTE = SIMP(statut='o',typ='TXM', into=("MPa","Pa"),fr=tr("Unité des contraintes du problème.")),
            C_INF            = SIMP(statut='o',typ='R'), # enrobage armatures inférieures
            C_SUP            = SIMP(statut='o',typ='R'), # enrobage armatures supérieures
            ALPHA_E          = SIMP(statut='f',typ='R'), # coefficient d'équivalence acier/béton  (pour ELS)
            FYK              = SIMP(statut='f',typ='R'), # contrainte admissible dans l'acier
            GAMMA_S          = SIMP(statut='f',typ='R'), # coefficient de sécurité sur la résistance de calcul des aciers
            FCK              = SIMP(statut='f',typ='R'), # contrainte admissible dans le béton
            GAMMA_C          = SIMP(statut='f',typ='R'), # coefficient de sécurité sur la résistance de calcul du béton
            ALPHA_CC         = SIMP(statut='f',typ='R',defaut=1.), # coefficient intervennant à l'ELU
            SIGS_ELS         = SIMP(statut='f',typ='R'), # contrainte ultime de dimensionnement de l'acier pour l'ELS
            SIGC_ELS         = SIMP(statut='f',typ='R'), # contrainte ultime de dimensionnement du béton pour l'ELS
            E_S              = SIMP(statut='f',typ='R'), # valeur du Module d'Young de l'acier (pour ELU)
            CLASSE_ACIER     = SIMP(statut='f',typ='TXM',defaut='B', into=("A","B","C")), # classe de ductilité des aciers
        ),
    ),

    b_uti = BLOC (
        condition = "equal_to('CODIFICATION', 'UTILISATEUR')",
        fr = tr ("Paramètres de la méthode UTILISATEUR"),
        AFFE = FACT ( statut = 'o', min = 1 , max = '**',
            regles = ( UN_PARMI ( 'TOUT', 'GROUP_MA' ), ),
              TOUT = SIMP ( statut = 'f', typ = 'TXM',
                              into = ('OUI','NON') ),
            GROUP_MA = SIMP ( statut = 'f', typ = grma,
                              validators=NoRepeat() , max='**'),
            TYPE_STRUCTURE = SIMP ( statut = 'o', typ = 'TXM',
                          into = (
                                   'POUTRE',
                                   'POTEAU',
                                   '2D',
                                  )
                        ),
            ENROBG     = SIMP(statut='o',typ='R'), # enrobage armatures
            CEQUI      = SIMP(statut='f',typ='R'), # coefficient d'équivalence acier/béton  (pour ELS)
            SIGM_ACIER = SIMP(statut='o',typ='R'), # contrainte admissible dans l'acier
            SIGM_BETON = SIMP(statut='o',typ='R'), # contrainte admissible dans le béton
            PIVA       =SIMP(statut='f',typ='R'), # valeur du pivot a  (pour ELU)
            PIVB       =SIMP(statut='f',typ='R'), # valeur du pivot b  (pour ELU)
            ES         =SIMP(statut='f',typ='R'), # valeur du Module d'Young de l'acier (pour ELU)
        ),
    ),
)


# INFODEV
#
# Moving file in bibpyt/Macro
#
# INFODEV
