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

from ..Objects import (GenericMechanicalLoad, KinematicsLoad,
                       ParallelMechanicalLoad, StaticMechanicalSolver)
from ..Supervis.ExecuteCommand import ExecuteCommand
from ..Utilities import force_list, unsupported
from .calc_champ import CALC_CHAMP
from .common_keywords import create_solver


class MechanicalSolver(ExecuteCommand):
    """Solver for static linear mechanical problems."""
    command_name = "MECA_STATIQUE"

    def create_result(self, keywords):
        """Does nothing, creating by *exec*."""

    @staticmethod
    def _addLoad(mechaSolv, fkw):
        load = fkw["CHARGE"]
        func = fkw.get("FONC_MULT")

        if func !=  None:
            if isinstance(load, KinematicsLoad):
                mechaSolv.addKinematicsLoad(load, func)
            elif isinstance(load, GenericMechanicalLoad):
                mechaSolv.addMechanicalLoad(load, func)
            elif isinstance(load, ParallelMechanicalLoad):
                mechaSolv.addParallelMechanicalLoad(load, func)
            else:
                assert False
        else:
            if isinstance(load, KinematicsLoad):
                mechaSolv.addKinematicsLoad(load)
            elif isinstance(load, GenericMechanicalLoad):
                mechaSolv.addMechanicalLoad(load)
            elif isinstance(load, ParallelMechanicalLoad):
                mechaSolv.addParallelMechanicalLoad(load)
            else:
                assert False

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        model = keywords["MODELE"]
        matOnMesh = keywords["CHAM_MATER"]
        caraElem = keywords.get("CARA_ELEM")

        mechaSolv = None
        if caraElem != None:
            mechaSolv = StaticMechanicalSolver(model, matOnMesh, caraElem)
        else:
            mechaSolv = StaticMechanicalSolver(model, matOnMesh)

        inst = keywords.get("INST")
        if inst != None:
            mechaSolv.setTimeStepManager([inst])
        listInst = keywords.get("LIST_INST")
        if listInst != None:
            mechaSolv.setTimeStepManager(listInst.getValues())

        fkw = force_list(keywords.get("EXCIT", []))
        for curDict in fkw:
            self._addLoad(mechaSolv, curDict)

        solver = create_solver(keywords.get("SOLVEUR"))
        mechaSolv.setLinearSolver(solver)
        self._result = mechaSolv.execute()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if self._result is not None:
            contrainte = []
            if keywords["MODELE"].existsMultiFiberBeam():
                contrainte.append("STRX_ELGA")
            if keywords.get("OPTION") == "SIEF_ELGA":
                contrainte.append("SIEF_ELGA")

            if contrainte:
                CALC_CHAMP(reuse=self._result,
                        RESULTAT=self._result,
                        CONTRAINTE=contrainte)
            else:
                self._result.update()

MECA_STATIQUE = MechanicalSolver.run
