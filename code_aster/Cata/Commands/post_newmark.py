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

from ..Language.Syntax import *
from ..Language.DataStructure import *
from ..Commons import *


POST_NEWMARK=MACRO(nom="POST_NEWMARK",
                        op=OPS("Macro.post_newmark_ops.post_newmark_ops"),
                        fr=tr("Calcul des déplacements résiduels des ouvrages en remblai par méthode de Newmark"),
                        sd_prod=table_sdaster,
                        reentrant='n',
                        regles=(UN_PARMI('RAYON','MAILLAGE_GLIS'),
#                                ENSEMBLE('RAYON', 'CENTRE_X','CENTRE_Y'),
                                ),
                        MAILLAGE_GLIS = SIMP(statut='f',typ=maillage_sdaster,fr='Maillage de la zone de glissement'),
                        RAYON      = SIMP(statut='f',typ='R',fr="Rayon du cercle de glissement" ),
                        b_RAYON =BLOC ( condition = """exists("RAYON")""",
                                CENTRE_X = SIMP(statut='o',typ='R',fr="Position de la coordonée X du cercle de glissement"),
                                CENTRE_Y = SIMP(statut='o',typ='R',fr="Position de la coordonée Y du cercle de glissement"),
                        ),
                        b_MAIL_GLIS =BLOC ( condition = """exists("MAILLAGE_GLIS")""",
                            GROUP_MA_GLIS = SIMP(statut='f',typ=grma,max='**',fr="GROUP_MA associé à la zone de glissement"),
                            GROUP_MA_LIGNE = SIMP(statut='f',typ=grma,max='**',fr="GROUP_MA associé à la ligne de glissement"),
                        ),
                        RESULTAT = SIMP(statut='o',typ=(dyna_trans,evol_noli),fr="Concept résultat du calcul dynamique"),
                        KY = SIMP(statut='o',typ='R',fr="Valeur de ky pour le calcul de l'accélération critique"),
                        GROUP_MA_CALC = SIMP(statut='o',typ=grma,max='**',fr="GROUP_MA associé au modèle utilisé"),
) ;
