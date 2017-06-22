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


class sd_sddyna(AsBase):
#------------------------------------
    nomj = SDNom(fin=15)

    TYPE_SCH = AsVK16(SDNom(nomj='.TYPE_SCH'), lonmax=8)
    PARA_SCH = Facultatif(AsVR(SDNom(nomj='.PARA_SCH'), lonmax=4))
    INI_CONT = Facultatif(AsVR(SDNom(nomj='.INI_CONT'), lonmax=4))
    NOM_SD = Facultatif(AsVK24(SDNom(nomj='.NOM_SD'), lonmax=3))
    TYPE_FOR = Facultatif(AsVI(SDNom(nomj='.TYPE_FOR'), lonmax=2))
    COEF_SCH = Facultatif(AsVR(SDNom(nomj='.COEF_SCH'), lonmax=4))
    INFO_SD = Facultatif(AsVL(SDNom(nomj='.INFO_SD'), lonmax=5))
