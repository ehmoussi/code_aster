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

# person_in_charge: mathieu.courtois at edf.fr

from ..Objects import GeneralizedAssemblyMatrixComplex
from .ExecuteCommand import ExecuteCommand


class MissImpedanceReader(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.GeneralizedAssemblyMatrixComplex` by assigning
    finite elements on a :class:`~code_aster.Objects.GeneralizedAssemblyMatrixComplex`."""
    command_name = "LIRE_IMPE_MISS"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = GeneralizedAssemblyMatrixComplex()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.setGeneralizedDOFNumbering(keywords["NUME_DDL_GENE"])


LIRE_IMPE_MISS = MissImpedanceReader.run
