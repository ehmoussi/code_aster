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
from SD.sd_util import *


class sd_l_table(AsBase):
#------------------------
    nomj = SDNom(fin=19)

    # la SD l_table (liste de tables) est une SD destinée à stocker un ensemble de tables
    # les tables stockées dans la l_table sont identifiées par un "petit nom"
    # (K16)

    LTNT = AsVK16()
    LTNS = AsVK24()

    # existence possible de la SD :
    def exists(self):
        return self.LTNT.exists or self.LTNS.exists

    # indirection vers les tables :
    def check_l_table_i_LTNS(self, checker):
        if not self.exists():
            return
        ltnt = self.LTNT.get()
        ltns = self.LTNS.get()
        nbtable = self.LTNT.lonuti
        sdu_compare(self.LTNT, checker, nbtable, '>', 0, 'NBUTI(LTNT)>0')
        sdu_compare(self.LTNS, checker, self.LTNS.lonuti,
                    '==', nbtable, 'NBUTI(LTNS)==NBUTI(LTNT)')
        for k in range(nbtable):
            petinom = ltnt[k].strip()
            nomtabl = ltns[k].strip()
            sdu_compare(self.LTNT, checker, petinom, '!=', '', "LTNT[k]!=''")
            sdu_compare(self.LTNS, checker, nomtabl, '!=', '', "LTNS[k]!=''")
            sd2 = sd_table(nomtabl)
            sd2.check(checker)
