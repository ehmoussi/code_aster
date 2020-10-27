# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: mathieu.courtois at edf.fr

"""
This module provides an interface to PETSc objects for linear algebric
operations.

NB: The Cython language is required to build this interface.
"""

# silently pass to build documentation without the interface build
try:
    from Petsc4PyTest import *
except ImportError as exc:
    print("Module Petsc4PyTest unavailable: {}".format(exc))

from libaster import _petscInitializeWithOptions, petscFinalize


def petscInitialize(options=" "):
    """Starts the PETSc interface with options.

    Arguments:
        options[str]: PETSc options
    """
    _petscInitializeWithOptions(options)
