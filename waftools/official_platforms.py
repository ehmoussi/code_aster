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
Additional checkings on official platforms
"""

import os
import os.path as osp

from waflib import Configure, Errors


def configure(self):
    opts = self.options
    if os.environ.get('OFFICIAL_PLATFORM'):
        # force to fail if a prerequisite is not found
        opts.enable_all = True
        # force to fail if a program is not found
        opts.with_prog_gmsh = True
        # opts.with_prog_salome: only required by few testcases
        opts.with_prog_run_miss3d = True
        opts.with_prog_homard = True
        opts.with_prog_ecrevisse = True
        opts.with_prog_mfront = True
        opts.with_prog_xmgrace = True
        opts.with_prog_gracebat = True
        opts.with_prog_mdump = True
        self.check_prerequisites_package(os.environ['PREREQ_PATH'],
                                         os.environ['PREREQ_VERSION'])

@Configure.conf
def check_prerequisites_package(self, yammdir, minvers):
    """Check for version of the prerequisites package.

    Can only be used if prerequisites are installed with a 'Yamm' package.

    Arguments:
        self (Configure): Configure object.
        yammdir (str): Directory path of prerequisites/tools installation.
        minvers (str): Minimal required version of the prerequisites package.
    """
    self.start_msg("Checking prerequisites version >= {0}".format(minvers))

    filename = osp.join(yammdir, 'VERSION')
    if osp.isfile(filename):
        with open(filename, 'r') as fvers:
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
