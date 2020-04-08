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
Configuration for Calibre 9

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=calibre9_std --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']
YAMMROOT = os.environ['ROOT_SALOME']

import official_programs


def configure(self):
    opts = self.options
    official_programs.configure(self)
    official_programs.check_prerequisites_package(self, YAMMROOT, '20200129')

    self.env["CONFIG_PARAMETERS"] = {
        "tmpdir": "/local00/tmp",
        "addmem": 800,
    }

    self.env['OPT_ENV'] = [
        "module load python/3.6.5 numpy/1.15.1 python3-scipy/0.19.1 "
        "python3-matplotlib/2.2.2 python3-sphinx/1.7.6 boost/1.58.0 "
        "hdf5/1.10.3"]

    self.env.append_value('CXXFLAGS', ['-D_GLIBCXX_USE_CXX11_ABI=0',
                                       '-Wno-literal-suffix'])

    self.env.PYPATH_NUMPY = '/opt/numpy/1.15.1/lib/python3.6/site-packages'
    self.env.PYPATH_ASRUN = YAMMROOT + '/tools/Code_aster_frontend-salomemeca/lib/python3.6/site-packages'

    self.env.LIBPATH_HDF5 = '/opt/hdf5/1.10.3/lib'
    self.env.INCLUDES_HDF5 = '/opt/hdf5/1.10.3/include'

    self.env.LIBPATH_MED = YAMMROOT + '/prerequisites/Medfichier-400/lib'
    self.env.INCLUDES_MED = YAMMROOT + '/prerequisites/Medfichier-400/include'

    self.env.LIBPATH_METIS = YAMMROOT + '/prerequisites/Metis_aster-510_aster4/lib'
    self.env.INCLUDES_METIS = YAMMROOT + '/prerequisites/Metis_aster-510_aster4/include'

    self.env.LIBPATH_SCOTCH = YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/lib'
    self.env.INCLUDES_SCOTCH = YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/include'

    self.env.LIBPATH_MUMPS = YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/SEQ/lib'
    self.env.INCLUDES_MUMPS = [
        YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/SEQ/include_seq']

    TFELHOME = YAMMROOT + '/prerequisites/Mfront-TFEL321'
    TFELVERS = '3.2.1'
    self.env.TFELHOME = TFELHOME
    self.env.TFELVERS = TFELVERS
    self.env.LIBPATH_MFRONT = TFELHOME + '/lib'
    self.env.INCLUDES_MFRONT = TFELHOME + '/include'
    self.env.PYPATH_MFRONT = TFELHOME + '/lib/python3.6/site-packages'

    opts.disable_boost_check = True
    self.env.INCLUDES_BOOST = '/opt/boost/1.58.0/include'
    self.env.LIBPATH_BOOST = ['/opt/boost/1.58.0/lib']
    self.env.LIB_BOOST = ['boost_python3-mt']

    # to fail if not found
    opts.enable_hdf5 = True
    opts.enable_med = True
    opts.enable_metis = True
    opts.enable_mumps = True
    opts.enable_scotch = True
    opts.enable_mfront = True

    opts.enable_petsc = False
