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


    1: _("""
  Recherche des modes rigides de la matrice %(k1)s.
"""),

    2: _("""
  Matrice symétrique
"""),

    3: _("""
La matrice %(k1)s n'est pas symétrique.
Pour l'instant, la recherche des modes de corps rigide n'a pas été développée
pour une matrice non symétrique.
"""),

    4: _("""
  Matrice à valeurs réelles.
"""),

    5: _("""
La matrice %(k1)s est à valeurs complexes.
Pour l'instant, la recherche des modes de corps rigide n'a pas été développée
pour une matrice à valeurs complexes.
"""),

    6: _("""
Pivot nul détecté à la ligne %(i1)d.
Le degré de liberté correspondant est le suivant:
"""),

    7: _("""
%(i1)d modes de corps rigide ont été détectés.
"""),

    8: _("""
Attention : plus de six modes de corps rigide ont été détectés.

--> Conseil :
Si vous pensez avoir une seule structure dans le modèle, cela peut provenir de noeud(s) orphelin(s). Dans ce cas, vérifiez le maillage.
"""),

    9: _("""
  Factorisation de la matrice %(k1)s avec la méthode %(k2)s.
"""),

    10: _("""
  Matrice non-symétrique
"""),

    11: _("""
  Matrice à valeurs complexes.
"""),

    12: _("""
  Résultats de la factorisation de la matrice %(k1)s.
"""),

    13: _("""
  La matrice n'est pas définie positive et comporte %(i1)d zéros sur la diagonale.
"""),

    14: _("""
    Nombre maximum de décimales à perdre : %(i1)d
    Nombre de décimales perdues          : %(i2)d
    Numéro de la pire équation           : %(i3)d
    Nombre de pivots négatifs            : %(i4)d
    Code arrêt                           : %(i5)d
    Code retour                          : %(i6)d
"""),

    15: _("""
Problème lors de la factorisation de la matrice:
    Le pivot devient très grand à la ligne %(i1)d qui correspond au degré de liberté donné ci-dessus.
    On a perdu %(i2)d décimales.
"""),
}
