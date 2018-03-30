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
Configuration for aster5

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=aster5 --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']
YAMMROOT = ASTER_ROOT + '/public/default'

import intel
import official_programs


def configure(self):
    opts = self.options

    intel.configure(self)
    official_programs.configure(self)
    opts.with_prog_salome = True
    opts.with_prog_europlexus = True

    # enable TEST_STRICT on the reference server
    self.env.append_value('DEFINES', ['TEST_STRICT'])

    self.env['ADDMEM'] = 600
    self.env.append_value('OPT_ENV', [
        '. /etc/profile.d/lmod.sh',
        'module load ifort/2016.0.047 icc/2016.0.047 mkl/2016.0.047'])

    TFELHOME = YAMMROOT + '/prerequisites/Mfront-TFEL311'
    self.env.TFELHOME = TFELHOME

    self.env.append_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Hdf5-1814/lib',
        YAMMROOT + '/tools/Medfichier-331/lib',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster4/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/lib',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster3/SEQ/lib',
        TFELHOME + '/lib',
    ])

    self.env.append_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Hdf5-1814/include',
        YAMMROOT + '/tools/Medfichier-331/include',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster4/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster7/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster3/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-512_consortium_aster3/SEQ/include_seq',
        TFELHOME + '/include',
    ])

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
