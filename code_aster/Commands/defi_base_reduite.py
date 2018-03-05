# coding: utf-8

# Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
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

from ..Objects import ModeEmpiContainer
from .ExecuteCommand import ExecuteCommand


class ReducedBaseDefinition(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.Mesh`"""
    command_name = "DEFI_BASE_REDUITE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.has_key("reuse"):
            self._result = keywords["reuse"]
        else:
            self._result = ModeEmpiContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if keywords.has_key("reuse"):
            self._result.update()
        elif(keywords.has_key("OPERATION") and
             keywords["OPERATION"] == "TRONCATURE"):
            self._result.setModel(keywords["MODELE_REDUIT"])
        else:
            resultat = keywords["RESULTAT"]
            if(resultat is not None):
                self._result.appendModelOnAllRanks(resultat.getModel())

DEFI_BASE_REDUITE = ReducedBaseDefinition.run
