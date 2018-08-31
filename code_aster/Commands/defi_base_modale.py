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

from ..Objects import MechanicalModeContainer
from .ExecuteCommand import ExecuteCommand


class ModalBasisDef(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.ModalBasisDefinition`"""
    command_name = "DEFI_BASE_MODALE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """

        self._result = MechanicalModeContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if keywords.has_key("CLASSIQUE") and keywords["CLASSIQUE"]:
            self._result.setStructureInterface(keywords["CLASSIQUE"][0]["INTERF_DYNA"])
            self._result.setDOFNumbering(keywords["CLASSIQUE"][0]["MODE_MECA"][0].getDOFNumbering())
        elif keywords.has_key("RITZ") and keywords["RITZ"] and keywords["RITZ"][0].has_key("INTERF_DYNA"):
            self._result.setStructureInterface(keywords["RITZ"][0]["INTERF_DYNA"])


DEFI_BASE_MODALE = ModalBasisDef.run
