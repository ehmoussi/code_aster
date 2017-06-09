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

    1: _(u"""
 le fichier IDEAS est vide
 ou ne contient pas de DATASET traite par l'interface
"""),

    2: _(u"""
 couleur inconnue
"""),

    3: _(u"""
  attention le DATASET 2420 apparaît plusieurs fois.
"""),

    4: _(u"""
  attention le DATASET 18 apparaît plusieurs fois.
"""),

    5: _(u"""
 groupe  %(k1)s  de longueur supérieure à 8 (troncature du nom)
"""),

    6: _(u"""
 le nom du groupe est invalide:  %(k1)s  : non traité
"""),

    7: _(u"""
 le nom du groupe  %(k1)s  est tronqué :  %(k2)s
"""),

    8: _(u"""
 le nom du groupe ne peut commencer par COUL_ : non traité
"""),

    9: _(u"""
  aucun système de coordonnés n'est défini
"""),

    10: _(u"""
  attention système de coordonnées autre que cartésien non relu dans ASTER.
"""),

    11: _(u"""
  attention votre maillage utilise plusieurs systèmes de coordonnées
  vérifiez qu'ils sont tous identiques
  ASTER ne gère qu'un système de coordonnées cartésien unique.
"""),
}
