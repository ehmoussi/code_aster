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


class sd_stoc_lciel(AsBase):
    nomj = SDNom(fin=19)
    SCDE = AsVI(lonmax=6)
    SCDI = AsVI()
    SCBL = AsVI()
    SCHC = AsVI()
    SCIB = AsVI()

#   les deux objets suivants ne sont crees qu'au moment de la factorisation avec LDLT :
    M2LC = Facultatif(AsVI())
    LC2M = Facultatif(AsVI())
