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
:py:class:`DynamicMacroElement` --- Assignment of material properties on mesh
************************************************************************
"""

import numpy

import aster
from libaster import DynamicMacroElement

from ..Utilities import injector
from .generalizedassemblymatrix_ext import VALM_triang2array


@injector(DynamicMacroElement)
class ExtendedDynamicMacroElement(object):
    cata_sdj = "SD.sd_macr_elem_dyna.sd_macr_elem_dyna"

    def EXTR_MATR_GENE(self,typmat) :

        if (typmat=='MASS_GENE') :
            macr_elem = self.sdj.MAEL_MASS
        elif (typmat=='RIGI_GENE') :
            macr_elem = self.sdj.MAEL_RAID
        elif (typmat=='AMOR_GENE') :
            macr_elem = self.sdj.MAEL_AMOR
        else:
            raise AsException("Le type de la matrice est incorrect")

        desc = macr_elem.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet matrice {0!r} n'existe pas"
                          .format(macr_elem.DESC.nomj()))
        desc = numpy.array(desc)

        matrice = VALM_triang2array(macr_elem.VALE.get(), desc[1])
        return matrice

    def RECU_MATR_GENE(self,typmat,matrice) :
        nommacr=self.getName()
        if (typmat=='MASS_GENE') :
            macr_elem = self.sdj.MAEL_MASS
        elif (typmat=='RIGI_GENE') :
            macr_elem = self.sdj.MAEL_RAID
        elif (typmat=='AMOR_GENE') :
            macr_elem = self.sdj.MAEL_AMOR
        else:
            raise AsException("Le type de la matrice est incorrect")
        nom_vale = macr_elem.VALE.nomj()

        desc = macr_elem.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet matrice {0!r} n'existe pas"
                          .format(macr_elem.DESC.nomj()))
        desc = numpy.array(desc)
        numpy.asarray(matrice)

        # On teste si la matrice python est de dimension 2
        if (len(numpy.shape(matrice)) != 2):
            raise AsException("La dimension de la matrice est incorrecte")

        # On teste si les tailles de la matrice jeveux et python sont identiques
        if (tuple([desc[1],desc[1]]) != numpy.shape(matrice)) :
            raise AsException("La dimension de la matrice est incorrecte")
        taille=desc[1]*desc[1]/2.0+desc[1]/2.0
        tmp=numpy.zeros([int(taille)])
        for j in range(desc[1]+1):
            for i in range(j):
                k=j*(j-1) // 2+i
                tmp[k]=matrice[j-1,i]
        aster.putvectjev(nom_vale,len(tmp),tuple((
            list(range(1,len(tmp)+1)))),tuple(tmp),tuple(tmp),1)
