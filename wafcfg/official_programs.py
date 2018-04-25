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

import os.path as osp

from waflib import Errors


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


def check_prerequisites_package(self, yammdir, minvers):
    """Check for version of the prerequisites package.

    Can only be used if prerequisites are installed with a 'Yamm' package.

    Arguments:
        self (Configure): Configure object.
        yammdir (str): Directory path of prerequisites installation.
        minvers (str): Minimal required version of the prerequisites package.
    """
    self.start_msg("Checking prerequisites version >= {0}".format(minvers))

    filename = osp.join(yammdir, 'VERSION')
    if osp.isfile(filename):
        with open(filename, 'rb') as fvers:
            version = fvers.read().strip()
        ok = version >= minvers
    else:
        version = "not found"
        ok = False

    self.end_msg(version, 'GREEN' if ok else 'YELLOW')
    if not ok:
        msg = ("Official prerequisites not found! "
            "Please install updated prerequisites using: "
            "install_env --prerequisites")
        raise Errors.ConfigurationError(msg)
