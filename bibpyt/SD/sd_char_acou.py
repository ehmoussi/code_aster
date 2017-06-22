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

from SD.sd_ligrel import sd_ligrel
from SD.sd_carte import sd_carte


class sd_char_acou(AsBase):
    nomj = SDNom(fin=8)
    chac_vitfa = Facultatif(sd_carte(SDNom(nomj='.CHAC.VITFA', fin=19)))
    CHAC_MODEL_NOMO = AsVK8(SDNom(nomj='.CHAC.MODEL.NOMO'), lonmax=1, )
    chac_cmult = Facultatif(sd_carte(SDNom(nomj='.CHAC.CMULT', fin=19)))
    chac_cimpo = Facultatif(sd_carte(SDNom(nomj='.CHAC.CIMPO', fin=19)))
    chac_imped = Facultatif(sd_carte(SDNom(nomj='.CHAC.IMPED', fin=19)))
    chac_ligre = Facultatif(sd_ligrel(SDNom(nomj='.CHAC.LIGRE', fin=19)))
    TYPE = AsVK8(lonmax=1, )
