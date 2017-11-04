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

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import AssemblyMatrixDouble
from ..Supervis import logger
from .ExecuteCommand import ExecuteCommand


class MatrixAssembler(ExecuteCommand):
    """Command that creates a
    :class:`~code_aster.Objects.AssemblyMatrixDouble`."""
    command_name = "ASSE_MATRICE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = AssemblyMatrixDouble.create()

    def check_syntax(self, keywords):
        """Check the syntax passed to the command. *keywords* will contain
        default keywords after executing this method.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        logger.warn("'check_syntax' is disabled in ASSE_MATRICE!")


ASSE_MATRICE = MatrixAssembler.run
