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
Configuration for eole

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=eole_std --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']
YAMMROOT = os.environ['ROOT_SALOME']

import intel
import official_programs


def configure(self):
    opts = self.options

    intel.configure(self)
    official_programs.configure(self)
    official_programs.check_prerequisites_package(self, YAMMROOT, '20191105')
    opts.with_prog_salome = True
    opts.with_prog_europlexus = True

    # ADDMEM value is evaluated with DEBUT()/FIN() execution and looking
    # at value reported at "MAXIMUM DE MEMOIRE UTILISEE PAR LE PROCESSUS".
    self.env['ADDMEM'] = 2500

    self.env.append_value('OPT_ENV', [
        'module unload mkl',
        'module load ifort/2016.0.047 icc/2016.0.047 mkl/2016.0.047',
        'export LD_PRELOAD=/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_scalapack_lp64.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_intel_lp64.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_intel_thread.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_core.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/mkl/lib/intel64_lin/libmkl_blacs_intelmpi_lp64.so:/opt/intel/2016.0.047/compilers_and_libraries_2016.0.109/linux/compiler/lib/intel64_lin/libiomp5.so',
        'export OPENBLAS_CORETYPE=SANDYBRIDGE',
    ])

    TFELHOME = YAMMROOT + '/prerequisites/Mfront-TFEL321'
    TFELVERS = '3.2.1'
    self.env.TFELHOME = TFELHOME
    self.env.TFELVERS = TFELVERS

    self.env.append_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Hdf5-1103/lib',
        YAMMROOT + '/prerequisites/Medfichier-400/lib',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster4/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/lib',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster4/SEQ/lib',
        TFELHOME + '/lib',
    ])

    self.env.append_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Hdf5-1103/include',
        YAMMROOT + '/prerequisites/Medfichier-400/include',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster4/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster4/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster4/SEQ/include_seq',
        TFELHOME + '/include',
    ])

    # waflib/extras/boost.py:check_boost forces /usr/lib/x86_64-linux-gnu
    self.env.INCLUDES_BOOST = YAMMROOT + '/prerequisites/Boost-1580/include'
    self.env.LIBPATH_BOOST = [YAMMROOT + '/prerequisites/Boost-1580/lib']
    self.env.LIB_BOOST = ['boost_python-mt']

    self.env.append_value('LINKFLAGS', ('-Wl,--no-keep-memory'))
    self.env.append_value('LIB', ('pthread', 'util'))
    self.env.append_value('LIB_SCOTCH', ('scotcherrexit'))
    # to fail if not found
    opts.enable_hdf5 = True
    opts.enable_med = True
    opts.enable_metis = True
    opts.enable_mumps = True
    opts.enable_scotch = True
    opts.enable_mfront = True

    opts.enable_petsc = False
    # sphinx with python3 not available
    opts.enable_doc = False
