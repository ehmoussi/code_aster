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

    3 : _(u"""
 Observations: il y aura, au maximum, %(i1)d observations à chaque instant sélectionné pour cela.
"""),

    6 : _(u"""
 Erreur dans les données d'observation
 pour "NOM_CHAM"  %(k1)s , il faut renseigner  %(k2)s ou  %(k3)s
"""),


    8 : _(u"""
 Variation de la déformation supérieure au seuil fixé :
    seuil en valeur relative : %(r1)f
    entité : %(k1)s
    composante : %(k2)s
    numéro ordre : %(i1)d
"""),

    37 : _(u"""
  Observations: %(i1)d réalisations pour ce pas de temps
"""),

    38 : _(u"""
  Observations: une réalisation pour ce pas de temps
"""),

    39 : _(u"""
  Observations: pas de réalisation pour ce pas de temps
"""),


}
