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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`MeshCoordinatesField` --- Fields of mesh coordinates
***************************************************************
"""

import numpy

import aster
from libaster import MeshCoordinatesField

from ..Utilities import injector
from .fieldonnodes_ext import post_comp_cham_no


@injector(MeshCoordinatesField)
class ExtendedMeshCoordinatesField(object):
    cata_sdj = "SD.sd_champ.sd_cham_no_class"

    def EXTR_COMP(self, comp=' ', lgno=[], topo=0):
        """ retourne les valeurs de la composante comp du champ sur la liste
        de groupes de noeuds lgno avec eventuellement l'info de la
        topologie si topo>0. Si lgno est une liste vide, c'est equivalent
        a un TOUT='OUI' dans les commandes aster

        Arguments:
            comp (str): Name of the component.
            lgno (list[str]): List of groups of nodes.
            topo (int): ``topo == 1`` means to return informations about the
                support of the field.

        Returns:
            :py:class:`.post_comp_cham_no`: Object containing the values and,
            eventually, the topological informations of the support.
        """

        ncham = self.getName()
        ncham = ncham + (19 - len(ncham)) * ' '
        nchams = aster.get_nom_concept_unique('_')
        ncmp = comp + (8 - len(comp)) * ' '

        aster.prepcompcham(ncham, nchams, ncmp, "NO      ", topo, lgno)

        valeurs = numpy.array(
            aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.V'))

        if (topo > 0):
            noeud = (
                aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.N'))
        else:
            noeud = None

        if comp[:1] == ' ':
            comp = (aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.C'))
            aster.prepcompcham(
                "__DETR__", nchams, ncmp, "NO      ", topo, lgno)
            return post_comp_cham_no(valeurs, noeud, comp)
        else:
            aster.prepcompcham(
                "__DETR__", nchams, ncmp, "NO      ", topo, lgno)
            return post_comp_cham_no(valeurs, noeud)
