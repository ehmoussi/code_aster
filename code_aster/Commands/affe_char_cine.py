# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import (KinematicsAcousticLoad, KinematicsMechanicalLoad,
                       KinematicsThermalLoad)
from ..Supervis.ExecuteCommand import ExecuteCommand


class KinematicsLoadDefinition(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.KinematicsLoad`."""
    command_name = "AFFE_CHAR_CINE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.get( "MECA_IMPO" ) is not None:
            self._result = KinematicsMechanicalLoad()
        elif keywords.get( "THER_IMPO" ) is not None:
            self._result = KinematicsThermalLoad()
        elif keywords.get( "ACOU_IMPO" ) is not None:
            self._result = KinematicsAcousticLoad()
        elif keywords.get( "EVOL_IMPO" ) is not None:
            if (keywords.get( "EVOL_IMPO" ).getType() in ('EVOL_ELAS', 'EVOL_NOLI') ):
                self._result = KinematicsMechanicalLoad()
            elif keywords.get( "EVOL_IMPO" ).getType() == 'EVOL_THER':
                self._result = KinematicsThermalLoad()
            elif keywords.get( "EVOL_IMPO" ).getType() == 'EVOL_ACOU':
                self._result = KinematicsAcousticLoad()
            else:
                raise NotImplementedError("Must be implemented")
        else:
            raise NotImplementedError("Must be implemented")
        self._result.setModel(keywords["MODELE"])


AFFE_CHAR_CINE = KinematicsLoadDefinition.run
