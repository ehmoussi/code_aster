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

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


POST_NEWMARK=MACRO(nom="POST_NEWMARK",
                        op=OPS("Macro.post_newmark_ops.post_newmark_ops"),
                        fr=tr("Calcul des déplacements résiduels des ouvrages en remblai par méthode de Newmark"),
                        sd_prod=table_sdaster,
                        reentrant='n',
                        RAYON      = SIMP(statut='o',typ='R',fr="Rayon du cercle de glissement" ),
                        CENTRE_X = SIMP(statut='o',typ='R',fr="Position de la coordonée X du cercle de glissement"),
                        CENTRE_Y = SIMP(statut='o',typ='R',fr="Position de la coordonée Y du cercle de glissement"),
                        RESULTAT = SIMP(statut='o',typ=(dyna_trans,evol_noli),fr="Concept résultat du calcul dynamique"),
                        KY = SIMP(statut='o',typ='R',fr="Valeur de ky pour le calcul de l'accélération critique"),
                        GROUP_MA_CALC = SIMP(statut='o',typ=grma,max='**',fr="GROUP_MA associé au modèle utilisé"),
) ;
