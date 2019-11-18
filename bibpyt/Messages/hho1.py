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

    2: _("""
Vous voulez une quadrature d'ordre %(i1)d ce qui supérieur au maximum autorisé (max = %(i2)d)
"""),

    3: _("""
Vous voulez une quadrature d'ordre %(i1)d ce qui inférieur au minimum autorisé (min = 0)
"""),

    4: _("""
Échec de la factorisation de Cholesky: la matrice n'est pas symétrique définie positive
"""),

    5: _("""
Échec de la factorisation LU: la matrice n'est pas factorisable
"""),

    8: _("""
Condensation statique: la matrice de la cellule n'est pas symétrique définie positive
    Problème avec le pivot : %(i1)d

    Conseil: Essayez d'augmenter le coefficient de stabilisation
"""),

    9: _("""
Condensation statique: échec de la résolution du système local
    Problème avec l'élément : %(i1)d
"""),

    10: _("""
Bases HHO:
Vous voulez une base de degré %(i1)d ce qui supérieur au maximum autorisé (max = %(i2)d)
"""),

    11: _("""
Bases HHO:
Vous voulez une base de degré négatif %(i1)d ce qui inférieur au minimum autorisé (min = 0)
"""),

    12: _("""
Quadratures HHO:
Vous voulez une quadrature d'ordre supérieur au maximum autorisé par votre quadrature
"""),

    13: _("""
Condensation statique: la matrice de la cellule n'est pas factorisable
    Problème avec le pivot : %(i1)d

    Conseil: Essayez d'augmenter le coefficient de stabilisation
"""),

}
