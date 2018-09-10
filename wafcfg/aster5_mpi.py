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
Configuration for aster5 + Intel MPI

. $HOME/dev/codeaster/devtools/etc/env_unstable_mpi.sh

waf_mpi configure --use-config=aster5_mpi --prefix=../install/mpi
waf_mpi install -p
"""

import aster5_std
ASTER_ROOT = aster5_std.ASTER_ROOT
YAMMROOT = aster5_std.YAMMROOT

def configure(self):
    opts = self.options

    # parallel must be set before calling intel.configure() to use MPI wrappers
    opts.parallel = True
    aster5_std.configure(self)
    self.env['ADDMEM'] = 800

    self.env.append_value('OPT_ENV_FOOTER', [
        '. /etc/profile.d/lmod.sh',
        'module load impi/2016.0.047'])

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Parmetis_aster-403_aster3/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/MPI/lib',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster3/MPI/lib',
        YAMMROOT + '/prerequisites/Petsc_mpi-382_aster1/lib',
    ])

    self.env.prepend_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Parmetis_aster-403_aster3/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/MPI/include',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster3/MPI/include',
        YAMMROOT + '/prerequisites/Petsc_mpi-382_aster1/include',
    ])

    opts.enable_petsc = True
    self.env.append_value('LIB_METIS', ('parmetis'))
    self.env.append_value('LIB_SCOTCH', ('ptscotch','ptscotcherr','ptscotcherrexit'))

    # allow to compile the elements catalog using the executable on one processor
    self.env['CATALO_CMD'] = 'I_MPI_FABRICS=shm'
    # produce an executable file with symbols for INTEL16 with mpiifort wrapper
    self.env.append_value('LINKFLAGS', ('-nostrip'))
    self.env.prepend_value('LINKFLAGS', ('-L/opt/intel/2016.0.047/impi/5.1.1.109/lib64'))
