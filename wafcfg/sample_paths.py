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
Example of configuration to use non-standard paths
"""

def configure(self):
    self.env.append_value('CFLAGS_ASTER_DEBUG', ['-D__DEBUG_ALL__'])
    self.env.append_value('FCFLAGS_ASTER_DEBUG', ['-D__DEBUG_ALL__'])

    opts = self.options
    self.env.append_value('LIBPATH', [
        '/opt/aster/public/hdf5-1.8.10/lib',
        '/opt/aster/public/med-3.0.7/lib',
        '/opt/aster/public/mumps-5.0.1/lib',
        '/opt/aster/public/metis-4.0.3/lib',
        '/opt/aster/public/scotch_5.1.11_esmumps/lib'])

    self.env.append_value('INCLUDES', [
        '/opt/aster/public/hdf5-1.8.10/include',
        '/opt/aster/public/med-3.0.7/include',
        '/opt/aster/public/mumps-5.0.1/include',
        '/opt/aster/public/mumps-5.0.1/include_seq',
        '/opt/aster/public/scotch_5.1.11_esmumps/include'])

    opts.enable_med = True

    opts.enable_mumps = True
    opts.mumps_libs = 'dmumps zmumps smumps cmumps mumps_common pord metis'
