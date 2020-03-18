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

"""
:py:mod:`toolbox` --- Toolbox for the developers
------------------------------------------------
"""


from .config import CFG
from .utils import run_command


def make_shared(lib, src):
    """Build a shared library from a fortran source file.

    Arguments:
        lib (str): Result library.
        src (str): Fortran source file.

    Returns:
        int: exit code.
    """
    cmd = [CFG.get("FC")]
    cmd.extend(CFG.get("FCFLAGS"))
    cmd.extend(["-shared", "-o", lib, src])
    return run_command(cmd)
