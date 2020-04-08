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
Configuration for Calibre 9  MPI

. $HOME/dev/codeaster/devtools/etc/env_unstable_mpi.sh

waf_mpi configure --use-config=calibre9_mpi --prefix=../install/mpi
waf_mpi install -p
"""

import calibre9_std
YAMMROOT = calibre9_std.YAMMROOT

def configure(self):
    opts = self.options
    opts.parallel = True

    calibre9_std.configure(self)
    self.env["CONFIG_PARAMETERS"]["addmem"] = 1000

    self.env.LIBPATH_PARMETIS = YAMMROOT + '/prerequisites/Parmetis_aster-403_aster3/lib'
    self.env.INCLUDES_PARMETIS = YAMMROOT + '/prerequisites/Parmetis_aster-403_aster3/include'

    self.env.LIBPATH_SCOTCH = YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/MPI/lib'
    self.env.INCLUDES_SCOTCH = YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/MPI/include'

    self.env.LIBPATH_MUMPS = YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/MPI/lib'
    self.env.INCLUDES_MUMPS = YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/MPI/include'

    self.env.LIBPATH_PETSC = YAMMROOT + '/prerequisites/Petsc_mpi-3123_aster/lib'
    self.env.INCLUDES_PETSC = YAMMROOT + '/prerequisites/Petsc_mpi-3123_aster/include'

    opts.enable_parmetis = True
    opts.enable_petsc = True
