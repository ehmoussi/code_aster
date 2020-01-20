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
:py:class:`Model` --- Modeling definition
*****************************************
"""

import aster
from libaster import Model

from ..Utilities import injector


@injector(Model)
class ExtendedModel(object):
    cata_sdj = "SD.sd_modele.sd_modele"

    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        return (self.getMesh(), )

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        self.setMesh(state[0])
