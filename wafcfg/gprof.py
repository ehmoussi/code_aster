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
Configuration with profiling enabled

This configuration just adds option for gprof.
It must be used with another configuration.

Example for linux + gprof:

cd $HOME/dev/codeaster/src
cp waf_variant waf_prof

./waf_prof configure --use-config=linux,gprof --prefix=../install/prof
./waf_prof install -p
"""


def configure(self):
    """Add flags for gprof"""
    self.env.append_unique('FCFLAGS', ['-pg'])
    self.env.append_unique('CFLAGS', ['-pg'])
    self.env.append_unique('CXXFLAGS', ['-pg'])
    self.env.append_unique('LINKFLAGS', ['-pg'])
