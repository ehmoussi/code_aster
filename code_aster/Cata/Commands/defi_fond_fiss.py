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

# person_in_charge: sam.cuvilliez at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_FOND_FISS=OPER(nom="DEFI_FOND_FISS",
                    op=55,
                    sd_prod=fond_fiss,
                    reentrant='n',

    MAILLAGE  = SIMP(statut='o',typ=maillage_sdaster ),
    INFO      =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),

    # definition du fond de fissure
    FOND_FISS = FACT(statut='o',max=2,

                     TYPE_FOND = SIMP(statut='f',typ='TXM',into=("OUVERT","FERME","INF","SUP"),defaut="OUVERT"),
                     GROUP_NO = SIMP(statut='f',typ=grno,max=1   ),
                     GROUP_MA = SIMP(statut='f',typ=grma,max=1   ),
                     regles=(UN_PARMI('GROUP_NO','GROUP_MA'),),

                     # possibilite d'ordonnencement automatique du fond si groupe de mailles
                     b_grma = BLOC(condition = """exists("GROUP_MA") and not equal_to("TYPE_FOND", 'FERME')""",
                                   NOEUD_ORIG    =SIMP(statut='c',typ=no,  max=1),
                                   GROUP_NO_ORIG =SIMP(statut='f',typ=grno,max=1),
                                   regles=(EXCLUS('NOEUD_ORIG','GROUP_NO_ORIG'),),

                                   # si ordo
                                   b_ordo = BLOC(condition = """exists("NOEUD_ORIG") or exists("GROUP_NO_ORIG")""",
                                                 NOEUD_EXTR    = SIMP(statut='c',typ=no,  max=1),
                                                 GROUP_NO_EXTR = SIMP(statut='f',typ=grno,max=1),
                                                 regles=(EXCLUS('NOEUD_EXTR','GROUP_NO_EXTR'),),
                                                ),
                                  ),
                     # possibilite d'ordonnencement automatique du fond si groupe de mailles
                     b_grma_ferme= BLOC(condition = """exists("GROUP_MA") and equal_to("TYPE_FOND", 'FERME')""",
                                        NOEUD_ORIG    =SIMP(statut='c',typ=no,  max=1),
                                        GROUP_NO_ORIG =SIMP(statut='f',typ=grno,max=1),
                                        regles=(EXCLUS('NOEUD_ORIG','GROUP_NO_ORIG'),),

                                        # si ordo
                                        b_ordo_ferme = BLOC(condition = """exists("NOEUD_ORIG") or exists("GROUP_NO_ORIG")""",
                                                            MAILLE_ORIG   = SIMP(statut='c',typ=ma,  max=1),
                                                            GROUP_MA_ORIG = SIMP(statut='f',typ=grma,  max=1),
                                                            regles=(UN_PARMI('MAILLE_ORIG','GROUP_MA_ORIG'),),
                                                           ),
                                       ),
                    # definition des directions des tangentes aux bords (uniquement pour les fonds non fermes)
                    b_dtan = BLOC(condition = """not equal_to("TYPE_FOND", 'FERME')""",
                                  DTAN_ORIG       =SIMP(statut='f',typ='R',max='**'),
                                  DTAN_EXTR       =SIMP(statut='f',typ='R',max='**'),
                                  VECT_GRNO_ORIG  =SIMP(statut='f',typ=grno,validators=NoRepeat(),max=2),
                                  VECT_GRNO_EXTR  =SIMP(statut='f',typ=grno,validators=NoRepeat(),max=2),
                                  regles=(EXCLUS('DTAN_ORIG','VECT_GRNO_ORIG'),
                                             EXCLUS('DTAN_EXTR','VECT_GRNO_EXTR'),),
                                 ),
                    ),

    CONFIG_INIT  = SIMP(statut='f',typ='TXM',into=("COLLEE","DECOLLEE"), defaut="COLLEE"),

    SYME         = SIMP(statut='o',typ='TXM',into=("OUI","NON"),),

#   remarque : dans le cas symetrique, il faut soit LEVRE_SUP, soit DTAN_ORIG
#   mais impossible de faire une regle.

    LEVRE_SUP =FACT(statut='f',max=1,
                    regles=(UN_PARMI('GROUP_MA','MAILLE'),),
                    GROUP_MA =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
                    MAILLE   =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
                    ),

    b_levre_inf  = BLOC(condition = """exists("LEVRE_SUP") and equal_to("SYME", 'NON')""",

                        LEVRE_INF =FACT(statut='o',max=1,
                                        regles=(UN_PARMI('GROUP_MA','MAILLE'),),
                                        GROUP_MA =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
                                        MAILLE   =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
                                        ),
                        ),

    # dans le cas decolle
    b_decolle    = BLOC(condition = """equal_to("CONFIG_INIT", 'DECOLLEE')""",
                     NORMALE   =SIMP(statut='o',typ='R',max=3),),

    PREC_NORM    = SIMP(statut='f',typ='R',defaut=0.1),

)
