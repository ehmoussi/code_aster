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

    1 : _(u"""
Il y a trop de chargements de type fonction à gérer pour CALC_G.
"""),

    2 : _(u"""
 La combinaison de chargements de même type n'est pas autorisée car l'un des chargements
 contient une charge exprimée par une formule.
 Pour réaliser cette combinaison, vous devez transformer votre charge 'formule' en charge 'fonction'
 (via l'opérateur DEFI_FONCTION ou CALC_FONC_INTERP)
"""),

    3 : _(u"""
 La combinaison des chargements n'a pas de sens physique (pesanteur, déformation initiale ou rotation).
 Pour un chargement de type ROTATION, utilisez plutôt FORCE_INTERNE.
"""),

    4 : _(u"""
 La combinaison 'fonction multiplicatrice' et 'chargement de type fonction' n'est pas autorisée car
 votre chargement %(k1)s contient une charge exprimée par une formule.
 Pour réaliser cette combinaison, vous devez transformer votre charge 'formule' en charge 'fonction'
 (via l'opérateur DEFI_FONCTION ou CALC_FONC_INTERP).
 On poursuit sans tenir compte de la fonction multiplicatrice.
"""),

    5 : _(u"""
 Une fissure XFEM de type cohésive n'est utilisable qu'avec les lissages LAGRANGE/LAGRANGE_NO_NO,
 en 3D, avec l'option CALC_K_G.
"""),

    6 : _(u"""
 La recherche du point d'intersection entre la loi cohésive et la pénalisation de Lagrange a demandé beaucoup d'itération.
 Une modification des paramètres de la loi cohésive comme PENA_LAGR rendra le calcul plus rapide pour le même résultat.
"""),

}
