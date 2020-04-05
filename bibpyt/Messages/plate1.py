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


cata_msg = {
     1 : _("""On ne sait pas calculer l'option %(k1)s avec une élasticité de type %(k2)s pour cet élément."""),

     4 : _("""Problème dans le calcul de l'option FORC_NODA / REAC_NODA :
Le nombre de sous-point du champ de contrainte contenu dans la SD n'est pas cohérent avec ce qui a été défini dans AFFE_CARA_ELEM.
Il est probable que le champ de contrainte a été extrait sur un seul sous-point.
Il est impératif d'utiliser un champ de contrainte complet pour le calcul de FORC_NODA.
"""),

    40 : _("""L'élément de plaque ne peut pas être orienté. Par défaut, pour orienter l'élément, on y projette l'axe global X.
L'axe de référence pour le calcul du repère local est ici normal à l'élément.
Il faut donc modifier l'axe de référence en utilisant ANGL_REP ou VECTEUR dans AFFE_CARA_ELEM."""),

    75 : _("""Les matériaux de coque homogénéisées (ELAS_COQUE) sont interdits en non-linéaire."""),
}
