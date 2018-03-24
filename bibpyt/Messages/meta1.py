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

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1  : _(u"""
 Erreur dans CALC_META: le résultat thermique doit contenir au moins deux pas de temps.
"""),

    2  : _(u"""
 Erreur dans CALC_META: le résultat thermique donné pour l'état initial doit être le même que le résultat de CALC_META.
"""),

    44 : _(u"""
Erreur dans CALC_META: l'état métallurgique initial produit par CREA_CHAMP est incomplet.
Pour l'acier, il faut renseigner les cinq phases.
"""),

    45 : _(u"""
Erreur dans CALC_META: l'état métallurgique initial produit par CREA_CHAMP est incomplet.
Pour le Zircaloy, il faut renseigner les trois phases.
"""),

    46 : _(u"""
Erreur dans CALC_META: l'état métallurgique initial produit par CREA_CHAMP est incomplet.
Pour l'acier, il faut renseigner la taille de grain.
"""),

    47 : _(u"""
Erreur dans CALC_META: l'état métallurgique initial produit par CREA_CHAMP est incomplet.
Pour le Zircaloy, il faut renseigner l'instant de transition.
"""),

    46 : _(u"""
Erreur dans CALC_META: La somme des phases vaut %(r1)12.4E.
"""),
}
