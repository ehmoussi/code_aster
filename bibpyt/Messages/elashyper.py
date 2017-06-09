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

    97 : _(u"""
 La loi de comportement ELAS_HYPER ne peut pas être utilisée avec le modèle %(k1)s.
 Modèles disponibles: 3D, 3D_SI, C_PLAN, D_PLAN
"""),

    98 : _(u"""
 Le coefficient de Poisson ne permet pas de calculer le module de compressibilité car il provoquerait une division par zéro.
 Si vous voulez un matériau quasi incompressible:
  - Renseignez directement le module de compressibilité (paramètre K dans DEFI_MATERIAU/ELAS_HYPER)
  - Choisissez un coefficient de Poisson proche de 0.5 mais pas strictement égal (par exemple 0.499)
"""),

}
