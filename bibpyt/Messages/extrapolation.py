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


# Pour la méthode EXTRAPOLATION de DEFI_LIST_INST

cata_msg = {

    1: _(u"""On tente une extrapolation linéaire sur les résidus."""),

    2: _(u"""
          L'extrapolation sur les résidus n'est pas possible.
          On utilise un autre résidu que RESI_GLOB_RELA ou RESI_GLOB_MAXI pour l'évaluation de la convergence.
          Ce n'est pas prévu.
"""),

    3: _(u"""L'extrapolation sur les résidus n'est pas possible car il n'y a pas assez de valeurs pour la faire."""),

    10: _(u"""L'extrapolation sur les résidus a échoué."""),

    11: _(u"""L'extrapolation sur les résidus a réussi."""),

    12: _(u"""On passe en mode de découpe manuelle du pas de temps."""),

}
