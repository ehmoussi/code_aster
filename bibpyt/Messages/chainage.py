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
# person_in_charge: sylvie.granet at edf.fr

from code_aster import _

cata_msg = {

    1 : _("""
Vous cherchez à faire du chaînage HM avec une modélisation Thermo-hydro-mécanique comportant de la mécanique.
Le chaînage est donc inutile !
"""),

    2 : _("""
Le champ d'entrée div(u) est mal construit. Il manque soit l'instant actuel soit l'instant précédent de div(u).
"""),

    3 : _("""
Vous n'êtes pas sur une modélisation autorisée pour faire du chaînage.
Le chaînage ne fonctionne pas sur la modélisation %(k1)s.

Conseil : Vérifiez que votre modélisation %(k2)s est sans mécanique
"""),

    4 : _("""
Vous n'êtes pas sur une modélisation autorisée pour faire du chaînage.
Le chaînage ne fonctionne pas sur la modélisation %(k1)s.

Conseil : Vérifiez que votre modélisation %(k2)s est 'D_PLAN' ou '3D'
ou une modélisation THM
"""),

    5 : _("""
Il n'est pas possible de faire du chaînage avec un coefficient d'emmagasinement non nul.
"""),

    6 : _("""
L'instant %(r1)e spécifié en entrée doit être supérieur au dernier
instant trouvé dans la SD résultat %(k1)s.
"""),

    7 : _("""
  Impression du champ %(k1)s à l'instant %(r1)e sur le modèle %(k2)s
"""),

    12 : _("""
Vous cherchez à faire du chaînage HM dans une modélisation qui ne le permet pas.
"""),

}
