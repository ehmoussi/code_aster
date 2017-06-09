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
from SD.sd_titre import sd_titre

from SD.sd_liste_rela import sd_liste_rela
from SD.sd_carte import sd_carte
from SD.sd_l_table import sd_l_table


class sd_cabl_precont(sd_titre):
#-----------------------------------------
    nomj = SDNom(fin=8)
    chme_sigin = sd_carte(SDNom(nomj='.CHME.SIGIN', fin=19))
    lirela = sd_liste_rela(SDNom(nomj='.LIRELA', fin=19))
    lt = sd_l_table(SDNom(nomj=''))
