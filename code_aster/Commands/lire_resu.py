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

# person_in_charge: j-pierre.lefebvre at edf.fr

from ..Objects import (LoadResult, ThermalResult,
                       FullHarmonicResult,
                       FullTransientResult,
                       ExternalVariablesResult,
                       ElasticResult,
                       ModeResultComplex, ModeResult,
                       EmpiricalModeResult, NonLinearResult)
from ..Supervis import ExecuteCommand


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
        if "reuse" in keywords:
            self._result = keywords["reuse"]
        elif typ == "EVOL_THER":
            self._result = ThermalResult()
        elif typ == "EVOL_ELAS":
            self._result = ElasticResult()
        elif typ == "EVOL_NOLI":
            self._result = NonLinearResult()
        elif typ == "EVOL_CHAR":
            self._result = LoadResult()
        elif typ == "DYNA_TRANS":
            self._result = FullTransientResult()
        elif typ == "DYNA_HARMO":
            self._result = FullHarmonicResult()
        elif typ == "MODE_MECA":
            self._result = ModeResult()
        elif typ == "MODE_EMPI":
            self._result = EmpiricalModeResult()
        elif typ == "MODE_MECA_C":
            self._result = ModeResultComplex()
        elif typ == "EVOL_VARC":
            self._result = ExternalVariablesResult()
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
