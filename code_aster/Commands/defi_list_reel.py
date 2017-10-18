# coding: utf-8

# Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

# person_in_charge: mathieu.courtois@edf.fr

import numpy as np

from ..Objects import ListOfFloats
from .ExecuteCommand import ExecuteCommand


class ListOfFloatsDefinition(ExecuteCommand):
    """Command that creates a :py:class:`~code_aster.Objects.ListOfFloats`."""
    command_name = "DEFI_LIST_REEL"

    def create_result(self, keywords):
        """Initialize the result object.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = ListOfFloats()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        vale = keywords.get('VALE')
        if vale is not None:
            values = np.array(vale)
        else:
            start = keywords['DEBUT']
            values = np.array([])
            for factkw in keywords['INTERVALLE']:
                stop = factkw['JUSQU_A']
                step = factkw.get('PAS')
                if step is None:
                    step = (stop - start) / factkw['NOMBRE']
                if step > stop - start:
                    raise ValueError("PAS is greater than the interval")
                values = np.concatenate((values, np.arange(start, stop, step)))
                if abs(stop - values[-1]) < 1.e-3 * step:
                    values = values[:-1]
                start = stop
            values = np.concatenate((values, np.array([stop])))

        self._result.setValues(values)


DEFI_LIST_REEL = ListOfFloatsDefinition()
