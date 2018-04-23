# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
Common to all official platforms: force support of essential external programs.
"""

def configure(self):
    opts = self.options
    # force to fail if a program is not found
    opts.with_prog_gmsh = True
    # salome: only required by few testcases
    # europlexus: not available on all platforms
    opts.with_prog_miss3d = True
    opts.with_prog_homard = True
    opts.with_prog_ecrevisse = True
    opts.with_prog_xmgrace = True
