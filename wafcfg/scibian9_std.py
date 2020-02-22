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
Configuration for Scibian 9

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=scibian9_std --prefix=../install/std
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

    self.env.append_value('CXXFLAGS', ['-D_GLIBCXX_USE_CXX11_ABI=0'])
    # ADDMEM value is evaluated with DEBUT()/FIN() execution and looking
    # at value reported at "MAXIMUM DE MEMOIRE UTILISEE PAR LE PROCESSUS".
    self.env['ADDMEM'] = 1600

    TFELHOME = YAMMROOT + '/prerequisites/Mfront-TFEL321'
    TFELVERS = '3.2.1'
    self.env.TFELHOME = TFELHOME
    self.env.TFELVERS = TFELVERS

    self.env.append_value('LIBPATH', [
        '/opt/hdf5/1.10.3/lib',
        YAMMROOT + '/prerequisites/Medfichier-400/lib',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster4/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/lib',
        YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/SEQ/lib',
        TFELHOME + '/lib',
    ])

    self.env.append_value('INCLUDES', [
        '/opt/hdf5/1.10.3/include',
        YAMMROOT + '/prerequisites/Medfichier-400/include',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster4/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-521_consortium_aster/SEQ/include_seq',
        TFELHOME + '/include',
    ])

    # waflib/extras/boost.py:check_boost forces /usr/lib/x86_64-linux-gnu
    self.env.INCLUDES_BOOST = '/opt/boost/1.58.0/include'
    self.env.LIBPATH_BOOST = ['/opt/boost/1.58.0/lib']
    self.env.LIB_BOOST = ['boost_python-mt']

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
