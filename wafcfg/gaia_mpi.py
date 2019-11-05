# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
Configuration for Scibian 9  MPI

. $HOME/dev/codeaster/devtools/etc/env_unstable_mpi.sh

waf_mpi configure --use-config=scibian9_mpi --prefix=../install/mpi
waf_mpi install -p

"""

import gaia_std
YAMMROOT = gaia_std.YAMMROOT

def configure(self):
    opts = self.options

    opts.parallel = True
    gaia_std.configure(self)
    self.env['ADDMEM'] = 1200

    self.env.append_value('OPT_ENV', [
        'export LD_PRELOAD='
        '/opt/intel/2019.0.045/mkl/lib/intel64/libmkl_scalapack_lp64.so:'
        '/opt/intel/2019.0.045/mkl/lib/intel64/libmkl_intel_lp64.so:'
        '/opt/intel/2019.0.045/mkl/lib/intel64/libmkl_intel_thread.so:'
        '/opt/intel/2019.0.045/mkl/lib/intel64/libmkl_core.so:'
        '/opt/intel/2019.0.045/compilers_and_libraries/linux/lib/intel64/libiomp5.so:'
        '/opt/intel/2019.0.045/mkl/lib/intel64/libmkl_blacs_intelmpi_lp64.so',
    ])
    self.env.append_value('OPT_ENV_FOOTER', [
        'module load impi/2019.0.045'
    ])

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Parmetis_aster-403_aster3/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/MPI/lib',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster4/MPI/lib',
        YAMMROOT + '/prerequisites/Petsc_mpi-394_aster/lib',
    ])

    self.env.prepend_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Parmetis_aster-403_aster3/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/MPI/include',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster4/MPI/include',
        YAMMROOT + '/prerequisites/Petsc_mpi-394_aster/include',
    ])

    opts.enable_petsc = True
    self.env.append_value('LIB_METIS', ('parmetis'))
    self.env.append_value('LIB_SCOTCH', ('ptscotch','ptscotcherr','ptscotcherrexit'))

    self.env.prepend_value('LINKFLAGS', ('-L/opt/intel/2019.0.045/impi/2019.0.117/intel64/libfabric/lib'))
