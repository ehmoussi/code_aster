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
:py:class:`PrestressingCable` --- Definition of pretension cable
****************************************************************
"""

from libaster import PrestressingCable

from ..Utilities import injector


@injector(PrestressingCable)
class ExtendedPrestressingCable(object):
    cata_sdj = "SD.sd_cabl_precont.sd_cabl_precont"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a PrestressingCable
        object during unpickling.
        """
        return (self.getName(), self.getModel(), self.getMaterialField(),
                self.getElementaryCharacteristics())
