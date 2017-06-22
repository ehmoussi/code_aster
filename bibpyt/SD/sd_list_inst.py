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


class sd_list_inst(AsBase):
    nomj = SDNom(fin=8)

# 1) objets relatifs a la liste

    LIST_INFOR = AsVR(SDNom(nomj='.LIST.INFOR'), lonmax=11,)
    LIST_DITR = AsVR(SDNom(nomj='.LIST.DITR'))

    ECHE_EVENR = AsVR(SDNom(nomj='.ECHE.EVENR'))
    ECHE_EVENK = AsVK16(SDNom(nomj='.ECHE.EVENK'))
    ECHE_SUBDR = AsVR(SDNom(nomj='.ECHE.SUBDR'))

    ADAP_EVENR = Facultatif(AsVR(SDNom(nomj='.ADAP.EVENR')))
    ADAP_EVENK = Facultatif(AsVK8(SDNom(nomj='.ADAP.EVENK')))
    ADAP_TPLUR = Facultatif(AsVR(SDNom(nomj='.ADAP.TPLUR')))
    ADAP_TPLUK = Facultatif(AsVK16(SDNom(nomj='.ADAP.TPLUK')))
