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

    2 : _("""
  option %(k1)s : pour l élément  %(k2)s  il faut ajouter dans le %(k3)s
 le nombre de composante calculées du flux
"""),

    5 : _("""
  Pour l'option %(k1)s, le nombre de couches est limité à 1,
  or vous en avez définies %(i1)d !
  Veuillez contacter votre assistance technique.
"""),

    6 : _("""
  Pour ce type d'opération, il n'est pas permis d'utiliser la structure de
  données résultat existante %(k1)s derrière le mot clé reuse.
"""),

    7 : _("""
  Erreur développeur : le champ n'a pas été créé car aucun type élément
  ne connaît le paramètre %(k1)s de l'option %(k2)s.
"""),
}
