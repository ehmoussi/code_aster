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

# person_in_charge: j-pierre.lefebvre at edf.fr

from ..Objects import EvolutiveThermalLoad
from ..Objects import LinearDisplacementEvolutionContainer
from ..Objects import NonLinearEvolutionContainer
from ..Objects import EvolutiveLoad
from ..Objects import FullTransientResultsContainer
from ..Objects import FullHarmonicResultsContainer
from ..Objects import MechanicalModeContainer, MechanicalModeComplexContainer
from ..Objects import ModeEmpiContainer
from ..Objects import InputVariableEvolutionContainer
from .ExecuteCommand import ExecuteCommand


class ResultsReader(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.??` by assigning
    finite elements on a :class:`~code_aster.Objects.??`."""
    command_name = "LIRE_RESU"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        typ = keywords["TYPE_RESU"]
        if typ == "EVOL_THER":
            self._result = EvolutiveThermalLoad()
        elif typ == "EVOL_ELAS":
            self._result = LinearDisplacementEvolutionContainer()
        elif typ == "EVOL_NOLI":
            self._result = NonLinearEvolutionContainer()
        elif typ == "EVOL_CHAR":
            self._result = EvolutiveLoad()
        elif typ == "DYNA_TRANS":
            self._result = FullTransientResultsContainer()
        elif typ == "DYNA_HARMO":
            self._result = FullHarmonicResultsContainer()
        elif typ == "MODE_MECA":
            self._result = MechanicalModeContainer()
        elif typ == "MODE_EMPI":
            self._result = ModeEmpiContainer()
        elif typ == "MODE_MECA_C":
            self._result = MechanicalModeComplexContainer()
        elif typ == "EVOL_VARC":
            self._result = InputVariableEvolutionContainer()
        else:
            raise NotImplementedError("Type of result {0!r} not yet "
                                      "implemented".format(typ))

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if "MODELE" in keywords:
            self._result.appendModelOnAllRanks(keywords["MODELE"])
        elif "MAILLAGE" in keywords:
            self._result.setMesh(keywords["MAILLAGE"])
        self._result.update()


LIRE_RESU = ResultsReader.run
