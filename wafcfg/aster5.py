# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
Configuration for aster5

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=aster5 --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']

YAMMROOT = ASTER_ROOT + '/public/default'

import intel

def configure(self):
    opts = self.options

    intel.configure(self)

    # enable TEST_STRICT on the reference server
    self.env.append_value('DEFINES', ['TEST_STRICT'])

    self.env['ADDMEM'] = 250
    self.env.append_value('OPT_ENV', [
        '. /etc/profile.d/003_modules.sh',
        'module load intel_compilers/16.0.0.109 '])

    self.env.append_value('LIBPATH', [
        '/usr/lib/atlas-base/atlas',                       # for NumPy, see issue18751
        YAMMROOT + '/prerequisites/Python-273/lib',
        YAMMROOT + '/prerequisites/Hdf5-1814/lib',
        YAMMROOT + '/tools/Medfichier-321/lib',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster1/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster6/SEQ/lib',
        YAMMROOT + '/prerequisites/Mfront-TFEL203/lib',
        YAMMROOT + '/prerequisites/Mumps-511_consortium_aster/SEQ/lib',
    ])

    self.env.append_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Python-273/include/python2.7',
        YAMMROOT + '/prerequisites/Hdf5-1814/include',
        YAMMROOT + '/tools/Medfichier-321/include',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster1/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster6/SEQ/include',
        YAMMROOT + '/prerequisites/Mfront-TFEL203/include',
        YAMMROOT + '/prerequisites/Mumps-511_consortium_aster/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-511_consortium_aster/SEQ/include_seq',
    ])

    self.env.append_value('LIB', ('pthread', 'util'))
    self.env.append_value('LIB_SCOTCH', ('scotcherrexit'))
    # to fail if not found
    opts.enable_hdf5 = True
    opts.enable_med = True
    opts.enable_metis = True
    opts.enable_mumps = True
    opts.enable_scotch = True
    opts.enable_mfront = False

    opts.enable_petsc = False
