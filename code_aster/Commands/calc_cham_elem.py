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

from ..Objects import FieldOnElementsDouble
from ..Supervis.ExecuteCommand import ExecuteCommand


class CalcChamElem(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.FieldOnElementsDouble`.
    """
    command_name = "CALC_CHAM_ELEM"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = FieldOnElementsDouble()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.setModel(keywords["MODELE"])

CALC_CHAM_ELEM = CalcChamElem.run
