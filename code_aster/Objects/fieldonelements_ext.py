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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`FieldOnElementsDouble` --- Fields defined per element
****************************************************************
"""

from libaster import FieldOnElementsDouble
from ..Utilities import injector


@injector(FieldOnElementsDouble)
class ExtendedFieldOnElementsDouble(object):
    cata_sdj = "SD.sd_champ.sd_cham_elem_class"

    def EXTR_COMP(self, comp, lgma=[], topo=0):
        """Retourne les valeurs de la composante comp du champ sur la liste
        de groupes de mailles lgma avec eventuellement l'info de la
        topologie si topo>0. Si lgma est une liste vide, c'est equivalent
        a un TOUT='OUI' dans les commandes aster

        Arguments:
            comp (str): Name of the component.
            lgma (list[str]): List of groups of elements.
            topo (int): ``topo == 1`` means to return informations about the
                support of the field.

        Returns:
            :py:class:`.post_comp_cham_el`: Object containing the values and,
            eventually, the topological informations of the support.
        """
        import numpy
        import aster

        ncham = self.getName()
        ncham = ncham + (19 - len(ncham)) * ' '
        nchams = aster.get_nom_concept_unique('_')
        ncmp = comp + (8 - len(comp)) * ' '

        aster.prepcompcham(ncham, nchams, ncmp, "EL      ", topo, lgma)

        valeurs = numpy.array(
            aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.V'))

        if (topo > 0):
            maille = (
                aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.M'))
            point = (
                aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.P'))
            sous_point = (
                aster.getvectjev(nchams + (19 - len(nchams)) * ' ' + '.SP'))
        else:
            maille = None
            point = None
            sous_point = None

        aster.prepcompcham("__DETR__", nchams, ncmp, "EL      ", topo, lgma)

        return post_comp_cham_el(valeurs, maille, point, sous_point)


class post_comp_cham_el:
    """Container object that store the results of
    :py:meth:`code_aster.Objects.FieldOnElementsDouble.EXTR_COMP`.

    The support of the field may be unknown. In this case, :py:attr:`maille`,
    :py:attr:`point` and :py:attr:`sous_point` are set to *None*.

    Attributes:
        valeurs (numpy.ndarray): Values of the field.
        maille (list[int]): List of elements numbers.
        point (list[int]): List of points numbers in the element.
        sous_point (list[int]): List of subpoints numbers in the element.
    """

    def __init__(self, valeurs, maille=None, point=None, sous_point=None):
        self.valeurs = valeurs
        self.maille = maille
        self.point = point
        self.sous_point = sous_point
