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

cata_msg = {

    2 : _(u"""
Le sommet de numéro global %(i1)i n'appartient pas à la maille %(i2)i
"""),

    3 : _(u"""
Le nombre de voisins %(i1)i est trop grand
"""),

    4 : _(u"""
Le nombre de sommets communs %(i1)i est trop grand
"""),

    5 : _(u"""
Le nombre de mailles %(i1)i est inférieur à un.
"""),
    6 : _(u"""
Le type de voisinage %(k1)s est inconnu.
"""),
    7 : _(u"""
Le type de voisinage %(k1)s a une longueur %(i1)i trop grande
"""),

    9 : _(u"""
Le type de modélisation volumes finis  %(i1)i  est inconnu.
Ce message est un message d'erreur développeur.
Contactez le support technique.

"""),

    11 : _(u"""
L'option  %(k1)s est inconnue
"""),
    12 : _(u"""
En 3D et en VF on peut utiliser uniquement des hexaèdres a 27 DDL et des tétraèdres a 27 DDL.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),
    13 : _(u"""
L'élément %(k1)s et la face  %(i1)i est non plane
"""),

}
