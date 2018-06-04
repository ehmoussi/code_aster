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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1 : _(u"""
Définition d'une liaison unilatérale.
 -> Cette fonctionnalité suppose la symétrie de la matrice obtenue après assemblage.

Il est possible de forcer la matrice à être symétrique en renseignant MATR_RIGI_SYME='OUI' sous le mot-clé facteur NEWTON ou d'utiliser ALGO_CONT='PENALISATION' dans LIAISON_UNILATER.
    
"""),

    42: _(u"""
Définition d'une liaison unilatérale.
Le nombre de COEF_MULT n'est pas égal au nombre de grandeurs contenus dans
le vecteur NOM_CMP
"""),

    43: _(u"""
Définition d'une liaison unilatérale.
Il y a trop de grandeurs dans le vecteur NOM_CMP (limité à 30)
"""),

    48 : _(u"""
Définition d'une liaison unilatérale.
Aucun noeud n'est affecté par une liaison unilatérale.
"""),

    58: _(u"""
Définition d'une liaison unilatérale.
La composante %(k2)s existe sur le noeud %(k1)s
"""),


    75: _(u"""
Définition d'une liaison unilatérale.
La composante %(k2)s est inexistante sur le noeud %(k1)s
"""),

}
