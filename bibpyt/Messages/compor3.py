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


    2 : _(u"""Dans le KIT_DDI, on ne peut pas coupler GRANGER avec %(k1)s."""),

    3 : _(u"""Dans le KIT_DDI, on ne peut pas coupler BETON_UMLV avec %(k1)s."""),

    4 : _(u"""Dans le KIT_DDI, on ne peut pas coupler GLRC avec %(k1)s."""),

    6 : _(u"""Dans le KIT_DDI, la loi de fluage %(k1)s n'est pas autorisée."""),

    7 : _(u"""Dans le KIT_DDI, FLUA_PORO_BETON ne peux être couplé qu’avec le modèle d’endommagement ENDO_PORO_BETON."""),

    8 : _(u"""Vous avez demandé à utiliser un comportement avec des phases métallurgiques de type %(k1)s, mais le matériau est défini avec des variables de commande de type %(k2)s."""),


    83 : _(u"""
 Vous utilisez le modèle BETON_UMLV avec un modèle d'endommagement.
 La mise à jour des contraintes sera faite suivant les déformations totales et non pas suivant un schéma incrémental.
"""),

    91 : _(u"""
   La loi métallurgique META_LEMA_ANI n'est utilisable qu'avec le zirconium.
"""),
}
