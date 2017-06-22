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

from SD.sd_matr_asse_gd import sd_matr_asse_gd
from SD.sd_matr_asse_gene import sd_matr_asse_gene
from SD.sd_matr_asse_com import sd_matr_asse_com

#---------------------------------------------------------------------------------
# classe "chapeau" à sd_matr_asse_gene et sd_matr_asse_gd ne servant que pour "check"
#-------------------------------------------------------------------------


class sd_matr_asse(sd_matr_asse_com):
#--------------------------------------------
    nomj = SDNom(fin=19)

    # pour orienter vers sd_matr_asse_gene ou sd_matr_asse_gd :
    def check_matr_asse_1(self, checker):
        # on est obligé de se protéger dans le cas des Facultatif(sd_matr_asse)
        # :
        if not self.REFA.get():
            return
        gene = self.REFA.get()[9].strip() == 'GENE'
        if gene:
            sd2 = sd_matr_asse_gene(self.nomj)
        else:
            sd2 = sd_matr_asse_gd(self.nomj)
        sd2.check(checker)
