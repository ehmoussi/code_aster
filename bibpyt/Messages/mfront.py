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
  Une erreur a été détectée par MFront. Le calcul ne peut pas continuer.

  Conseil : Vérifiez le nombre de propriété matériau fournit à la loi
  de comportement.
"""),

    2 : _(u"""
  Une variable utilisée ou produite par MFront a dépassée les bornes physiques
  ou les bornes de corrélation de la loi de comportement.

  Conseils : Vérifiez les coefficients matériau donnés à la loi de comportement.
"""),

    3 : _(u"""
  Erreur générique dans MFront, le calcul ne peut pas continuer.
"""),

}
