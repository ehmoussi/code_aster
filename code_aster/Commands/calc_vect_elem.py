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

from ..Objects import (ElementaryVectorDisplacementDouble,
                       ElementaryVectorPressureComplex,
                       ElementaryVectorTemperatureDouble)
from ..Supervis.ExecuteCommand import ExecuteCommand


class ComputeElementaryVector(ExecuteCommand):

    """Command that creates elementary vectors."""
    command_name = "CALC_VECT_ELEM"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords['OPTION'] == "CHAR_MECA": self._result = ElementaryVectorDisplacementDouble()
        elif keywords['OPTION'] == "CHAR_THER": self._result = ElementaryVectorTemperatureDouble()
        elif keywords['OPTION'] == "CHAR_ACOU": self._result = ElementaryVectorPressureComplex()
        else: raise NotImplementedError("Must be implemented")

    def post_exec(self, keywords):
        """Store references to ElementaryVector objects.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        self._result.update()

CALC_VECT_ELEM = ComputeElementaryVector.run
