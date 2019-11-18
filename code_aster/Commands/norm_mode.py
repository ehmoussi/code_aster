# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

from ..Objects import MechanicalModeContainer
from ..Objects import MechanicalModeComplexContainer
from ..Objects import BucklingModeContainer
from ..Supervis import logger
from .ExecuteCommand import ExecuteCommand


class NormMode(ExecuteCommand):
    """Command that creates a :class:`~code_aster.Objects.DOFNumbering`."""
    command_name = "NORM_MODE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        modeType = keywords["MODE"].getType()
        toReuse = keywords.get("reuse")
        if modeType == "MODE_MECA":
            if toReuse is not None:
                self._result = toReuse
            else:
                self._result = MechanicalModeContainer()
            return
        if modeType == "MODE_MECA_C":
            if toReuse is not None:
                self._result = toReuse
            else:
                self._result = MechanicalModeComplexContainer()
            return
        if modeType == "MODE_FLAMB":
            if toReuse is not None:
                self._result = toReuse
            else:
                self._result = BucklingModeContainer()
            return
        raise TypeError("unexpected type for keyword MODE")

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.setDOFNumbering(keywords["MODE"].getDOFNumbering())


NORM_MODE = NormMode.run
