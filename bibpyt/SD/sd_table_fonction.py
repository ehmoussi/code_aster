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

from SD.sd_table import sd_table
from SD.sd_fonction import sd_fonction

# --------------------------------------------------------------------
# sd_table dont une colonne nommée "FONCTION[_C]" contient des fonctions
# --------------------------------------------------------------------


class sd_table_fonction(sd_table):
#-------------------------------------
    nomj = SDNom(fin=17)

    def check_table_fonction_i_COL_FONC(self, checker):
        shape = self.TBNP.get()
        if shape is None:
            return
        desc = self.TBLP.get()
        for n in range(shape[0]):
            nomcol = desc[4 * n].strip()
            if not (nomcol == 'FONCTION' or nomcol == 'FONCTION_C'):
                continue
            col_d, col_m = self.get_column_name(nomcol)
            lnom = col_d.data.get()
            if not lnom:
                return
            for nom1 in lnom:
                if not nom1.strip():
                    continue
                sd2 = sd_fonction(nom1)
                sd2.check(checker)
