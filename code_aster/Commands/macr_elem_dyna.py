# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

from ..Objects import DynamicMacroElement
from .ExecuteCommand import ExecuteCommand


class DynamicMacroElementDefinition(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.DynamicMacroElement`"""
    command_name = "MACR_ELEM_DYNA"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """

        self._result = DynamicMacroElement()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.setMechanicalMode(keywords["BASE_MODALE"])
        dofNum = keywords["BASE_MODALE"].getDOFNumbering()
        if dofNum is not None:
            self._result.setDOFNumbering(dofNum)
        matrRigi = keywords.get("MATR_RIGI")
        if matrRigi is not None:
            self._result.setStiffnessMatrix(matrRigi)
        matrMass = keywords.get("MATR_MASS")
        if matrMass is not None:
            self._result.setMassMatrix(matrMass)
        matrAmor = keywords.get("MATR_AMOR")
        if matrAmor is not None:
            self._result.setDampingMatrix(matrAmor)
        matrImpe = keywords.get("MATR_IMPE")
        if matrImpe is not None:
            self._result.setImpedanceMatrix(matrImpe)
        matrImpeRigi = keywords.get("MATR_IMPE_RIGI")
        if matrImpeRigi is not None:
            self._result.setImpedanceStiffnessMatrix(matrImpeRigi)
        matrImpeMass = keywords.get("MATR_IMPE_MASS")
        if matrImpeMass is not None:
            self._result.setImpedanceMassMatrix(matrImpeMass)
        matrImpeAmor = keywords.get("MATR_IMPE_AMOR")
        if matrImpeAmor is not None:
            self._result.setImpedanceDampingMatrix(matrImpeAmor)

MACR_ELEM_DYNA = DynamicMacroElementDefinition.run
