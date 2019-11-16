# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

from code_aster import _

cata_msg = {

    1 : _("""
 Le modèle contient des POU_D_EM avec des variables de commandes définies dans AFFE_MATERIAU.
 Le calcul linéaire n'est pas possible.

 Conseil :  Il est possible de faire ce même calcul avec STAT_NON_LINE en précisant sous
            COMPORTEMENT/RELATION='MULTIFIBRE'
"""),

    25 : _("""
 Le chargement contient plus d'une charge répartie.
 Le calcul n'est pas possible pour les modèles de poutre.
"""),

}
