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

"""
:py:mod:`common_keywords` --- Helper functions for executors
************************************************************

Here are defined helper functions shared by several commands.
It reflects the common catalog definitions available from
:mod:`code_aster.Cata.Commons`.
"""

from ..Objects import (GcpcSolver, LdltSolver, MultFrontSolver, MumpsSolver,
                       PetscSolver, getGlossary)
from ..Utilities import unsupported


def create_solver(solver_keyword):
    """Create the solver object from the SOLVEUR factor keyword.

    Arguments:
        solver_keyword (dict): Content of the SOLVEUR factor keyword.

    Returns:
        :class:`~code_aster.Objects.BaseLinearSolver` (derivated of):
        Instance of a solver or *None* if none is selected.
    """
    if not solver_keyword:
        return None
    for key, value in solver_keyword.iteritems():
        if key not in ("METHODE", "RENUM", "PRE_COND", "RESI_RELA"):
            unsupported(solver_keyword, "", key, warning=True)
    method = solver_keyword["METHODE"]
    renum = solver_keyword["RENUM"]
    precond = solver_keyword["PRE_COND"]
    resiRela = solver_keyword["RESI_RELA"]

    glossary = getGlossary()
    solverInt = glossary.getSolver(method)
    renumInt = glossary.getRenumbering(renum)

    selected_solver = {"MULT_FRONT": MultFrontSolver, "LDLT": LdltSolver,
                       "MUMPS": MumpsSolver, "PETSC": PetscSolver,
                       "GCPC": GcpcSolver
                       }.get(method)
    if selected_solver:
        solver = selected_solver.create(renumInt)
    else:
        solver = None

    if precond != None:
        precondInt = glossary.getPreconditioning(precond)
        solver.setPreconditioning(precondInt)
    if resiRela != None:
        solver.setSolverResidual(resiRela)
    return solver
