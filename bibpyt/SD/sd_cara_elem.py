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

from SD.sd_cham_elem import sd_cham_elem
from SD.sd_carte import sd_carte


class sd_cara_elem(AsBase):
#--------------------------
    nomj = SDNom(fin=8)
    MODELE = AsVK8(lonmax=1,)
    #
    CARGENBA = Facultatif(sd_carte())
    CAFIBR = Facultatif(sd_cham_elem())
    CARMASSI = Facultatif(sd_carte())
    CARCABLE = Facultatif(sd_carte())
    CARCOQUE = Facultatif(sd_carte())
    CARGEOBA = Facultatif(sd_carte())
    CANBSP = Facultatif(sd_cham_elem())
    CARDISCK = Facultatif(sd_carte())
    CARARCPO = Facultatif(sd_carte())
    CARGENPO = Facultatif(sd_carte())
    CARDISCM = Facultatif(sd_carte())
    CARORIEN = Facultatif(sd_carte())
    CARDISCA = Facultatif(sd_carte())
    CVENTCXF = Facultatif(sd_carte())
    CARPOUFL = Facultatif(sd_carte())
    CARGEOPO = Facultatif(sd_carte())
    CARRIGXN = Facultatif(AsVK8())
    CARRIGXV = Facultatif(AsVR())
    CARAMOXN = Facultatif(AsVK8())
    CARAMOXV = Facultatif(AsVR())
    CARDINFO = Facultatif(sd_carte())
