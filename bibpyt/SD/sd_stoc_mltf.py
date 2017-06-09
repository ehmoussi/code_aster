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

from SD import *


class sd_stoc_mltf(AsBase):
    nomj = SDNom(fin=19)
    ADNT = AsVI()
    ADPI = AsVI()
    ADRE = AsVI()
    ANCI = AsVI()
    DECA = AsVI()
    DESC = AsVI(lonmax=5,)
    FILS = AsVI()
    FRER = AsVI()
    GLOB = AsVS()
    LFRN = AsVI()
    LGBL = AsVI()
    LGSN = AsVI()
    LOCL = AsVS()
    NBAS = AsVI()
    NBLI = AsVI()
    NCBL = AsVI()
    NOUV = AsVI()
    RENU = AsVK8(lonmax=1,)
    SEQU = AsVI()
    SUPN = AsVI()
