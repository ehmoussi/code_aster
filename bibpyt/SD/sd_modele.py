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
from SD.sd_maillage import sd_maillage
from SD.sd_xfem import sd_modele_xfem
from SD.sd_l_table import sd_l_table
from SD.sd_partition import sd_partition


class sd_modele(AsBase):
#-----------------------------
    nomj = SDNom(fin=8)

    MODELE = sd_ligrel()
    MAILLE = Facultatif(AsVI())
    PARTIT = Facultatif(AsVK8(lonmax=1))

    # une sd_modele peut avoir une "sd_l_table" contenant des grandeurs
    # caractéristiques de l'étude :
    lt = Facultatif(sd_l_table(SDNom(nomj='')))

    # Si le modèle vient de MODI_MODELE_XFEM :
    xfem = Facultatif(sd_modele_xfem(SDNom(nomj='')))

    def check_existence(self, checker):
        exi_liel = self.MODELE.LIEL.exists
        exi_maille = self.MAILLE.exists
        # si .LIEL => .MAILLE 
        if exi_liel:
            assert exi_maille

    def check_PARTIT(self, checker):
        if self.PARTIT.exists:
            partit = self.PARTIT.get_stripped()
            if partit[0] != '':
                sd2 = sd_partition(partit[0])
                sd2.check(checker)
