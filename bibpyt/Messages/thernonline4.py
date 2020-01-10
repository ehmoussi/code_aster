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

from code_aster.Utilities import _

cata_msg = {

    1 : _("""
Il y a un chargement de type convection dans les chargements appliqués.
Ce n'est possible qu'avec THER_NON_LINE_MO.
"""),

    85 : _("""
   Arrêt : absence de convergence au numéro d'instant : %(i1)d
                                  lors de l'itération : %(i2)d
"""),

    94 : _("""Le champ de séchage issu du concept %(k1)s n'est pas calculé à l'instant %(i3)i"""),

    96 : _("""Le séchage ne peut pas être mélangé à un autre comportement."""),

    97 : _("""EVOL_THER_SECH est un mot-clé obligatoire pour le séchage de type SECH_GRANGER et SECH_NAPPE."""),

    98 : _("""Le concept %(k1)s  n'est pas un champ de température"""),

    99 : _("""Pour le séchage, le concept EVOL_THER %(k1)s  ne contient aucun champ de température."""),

}
