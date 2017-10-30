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

# person_in_charge: guillaume.drouet@edf.fr
from collections import namedtuple

from ..Objects import (StaticModeDepl, StaticModeInterf, StaticModeForc,
                       StaticModePseudo)
from ..Utilities import force_list, unsupported
from .ExecuteCommand import ExecuteCommand
from .common_keywords import create_solver


_choices = ["MODE_STAT", "FORCE_NODALE", "PSEUDO_MODE", "MODE_INTERF"]
Case = namedtuple("Case", _choices)._make(_choices)

class StaticModeCalculation(ExecuteCommand):
    """Command that computes static modes."""
    command_name = "MODE_STATIQUE"
    _case = _solv = None

    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        unsupported(keywords, "MODE_STAT", "NOEUD")

    def create_result(self, keywords):
        """Initialize the solver object. The result will be created by *exec*.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.get("MODE_STAT"):
            self._case = Case.MODE_STAT
            self._solv = StaticModeDepl.create()
        elif keywords.get("FORCE_NODALE"):
            self._case = Case.FORCE_NODALE
            self._solv = StaticModeForc.create()
        elif keywords.get("PSEUDO_MODE"):
            self._case = Case.PSEUDO_MODE
            self._solv = StaticModePseudo.create()
        elif keywords.get("MODE_INTERF"):
            self._case = Case.MODE_INTERF
            self._solv = StaticModeInterf.create()
        else:
            raise SyntaxError("MODE_STATIQUE Commmand and catalog definition "
                              "are not consistent.")

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        solv = self._solv
        solv.setStiffMatrix(keywords["MATR_RIGI"])
        if keywords.get("MATR_MASS"):
            solv.setMassMatrix(keywords["MATR_MASS"])

        fact = keywords[self._case]
        if isinstance(fact, (list, tuple)):
            if len(fact) > 1:
                raise NotImplementedError("Several occurrences of {0} is not "
                                          "yet supported.".format(self._case))
            fact = fact[0]
        # MODE_STAT, FORCE_NODALE, MODE_INTERF: ExactlyOne("TOUT", "GROUP_NO")
        # PSEUDO_MODE: ExactlyOne("TOUT", "GROUP_NO", "DIRECTION", "AXE")
        if fact.get("TOUT"):
            solv.enableOnAllMesh()
        elif fact.get("GROUP_NO"):
            solv.WantedGroupOfNodes(force_list(fact["GROUP_NO"]))
            # only for PSEUDO_MODE
        elif self._case == Case.PSEUDO_MODE:
            if fact.get("DIRECTION"):
                solv.setNameForDirection(fact.get("NOM_DIR"))
                solv.WantedDirection(force_list(fact["DIRECTION"]))
            elif fact.get("AXE"):
                solv.WantedAxe(fact["AXE"])

        # Exactly one ("TOUT_CMP", "AVEC_CMP", "SANS CMP")
        if fact.get("TOUT_CMP"):
            solv.setAllComponents()
        elif fact.get("AVEC_CMP"):
            solv.WantedComponent(force_list(fact["AVEC_CMP"]))
        elif fact.get("SANS_CMP"):
            solv.UnwantedComponent(force_list(fact["SANS_CMP"]))

        # only for MODE_INTERF
        if self._case == Case.MODE_INTERF:
            if fact.get("NBMOD"):
                solv.setNumberOfModes(fact["NBMOD"])
            if fact.get("SHIFT"):
                solv.setShift(fact["SHIFT"])

        solver = create_solver(keywords.get("SOLVEUR"))
        if solver and self._case in (Case.PSEUDO_MODE, Case.MODE_INTERF):
            unsupported(keywords, "SOLVEUR", "", warning=True)

        solv.setLinearSolver(solver)
        self._result = solv.execute()


MODE_STATIQUE = StaticModeCalculation.run
