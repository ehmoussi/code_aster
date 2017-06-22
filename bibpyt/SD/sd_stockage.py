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

from SD.sd_stoc_mltf import sd_stoc_mltf
from SD.sd_stoc_morse import sd_stoc_morse
from SD.sd_stoc_lciel import sd_stoc_lciel


class sd_stockage(AsBase):
    nomj = SDNom(fin=14)
    slcs = Facultatif(sd_stoc_lciel(SDNom(nomj='.SLCS')))
    mltf = Facultatif(sd_stoc_mltf(SDNom(nomj='.MLTF')))
    smos = sd_stoc_morse(SDNom(nomj='.SMOS'))
