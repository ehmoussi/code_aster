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

# person_in_charge: nicolas.sellenet@edf.fr
"""
:py:class:`Surface` --- Representation of Surface
**********************************************
"""

import aster
from libaster import Surface

from ..Utilities import injector


class ExtendedSurface(injector(Surface), Surface):
    cata_sdj = "SD.sd_nappe.sd_nappe"

    def Valeurs(self):
        """
        Retourne une liste contenant les paramètres et les valeurs
        """
        values = self.exportValuesToPython()
        parameters = self.exportParametersToPython()
        return [parameters, values]
