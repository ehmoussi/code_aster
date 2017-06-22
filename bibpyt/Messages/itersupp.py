# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: josselin.delmas at edf.fr

# Pour la méthode ITER_SUPPL de DEFI_LIST_INST

cata_msg = {


    2: _(u"""          On ne peux pas tenter d'autoriser des itérations de Newton supplémentaires car on dépasse déjà le nombre
                   d'itérations maximum autorisé <%(i1)d>.
"""),

    3: _(u"""          On estime qu'on va pouvoir converger en <%(i1)d> itérations de Newton."""),

    4: _(u"""          L'extrapolation des résidus donne un nombre d'itérations inférieur à ITER_GLOB_ELAS et ITER_GLOB_MAXI.
                   Cela peut se produire si vous avez donné ITER_GLOB_ELAS inférieur à ITER_GLOB_MAXI et que l'extrapolation du
                   nombre d'itérations est faite en régime élastique."""),


    5: _(u"""          L'extrapolation des résidus donne un nombre d'itérations <%(i1)d> supérieur au maximum autorisé <%(i2)d>"""),

    6: _(u""" <Action><Échec> Échec dans la tentative d'autoriser des itérations de Newton supplémentaires."""),

    7: _(u""" <Action> On autorise des itérations de Newton supplémentaires."""),

}
