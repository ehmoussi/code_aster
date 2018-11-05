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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`ElementaryMatrix` --- Elementary Matrix
**************************************************
"""

import aster
from libaster import ElementaryMatrixDisplacementDouble
from libaster import ElementaryMatrixDisplacementComplex
from libaster import ElementaryMatrixTemperatureDouble
from libaster import ElementaryMatrixPressureComplex

from ..Utilities import injector


class ExtendedElementaryMatrixDisplacementDouble(injector(ElementaryMatrixDisplacementDouble),
                                                 ElementaryMatrixDisplacementDouble):
    cata_sdj = "SD.sd_matr_elem.sd_matr_elem"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a ElementaryMatrix
        object during unpickling.
        """
        return (self.getName(), )

class ExtendedElementaryMatrixDisplacementComplex(injector(ElementaryMatrixDisplacementComplex),
                                                  ElementaryMatrixDisplacementComplex):
    cata_sdj = "SD.sd_matr_elem.sd_matr_elem"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a ElementaryMatrix
        object during unpickling.
        """
        return (self.getName(), )

class ExtendedElementaryMatrixTemperatureDouble(injector(ElementaryMatrixTemperatureDouble),
                                                ElementaryMatrixTemperatureDouble):
    cata_sdj = "SD.sd_matr_elem.sd_matr_elem"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a ElementaryMatrix
        object during unpickling.
        """
        return (self.getName(), )

class ExtendedElementaryMatrixPressureComplex(injector(ElementaryMatrixPressureComplex),
                                              ElementaryMatrixPressureComplex):
    cata_sdj = "SD.sd_matr_elem.sd_matr_elem"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a ElementaryMatrix
        object during unpickling.
        """
        return (self.getName(), )
