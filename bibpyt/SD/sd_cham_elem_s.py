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
from SD.sd_maillage import sd_maillage
from SD.sd_util import *


class sd_cham_elem_s(AsBase):
#----------------------------
    nomj = SDNom(fin=19)

    CESK = AsVK8(lonmax=3)
    CESD = AsVI()
    CESC = AsVK8()
    CESV = AsVect(type=Parmi('C', 'K', 'R', 'I'))
    CESL = AsVL()

    def exists(self):
        return self.CESK.exists

    def check_CESK(self, checker):
        if not self.exists():
            return
        cesk = self.CESK.get_stripped()
        sd2 = sd_maillage(cesk[0])
        sd2.check(checker)
        assert cesk[2] in ('ELNO', 'ELGA', 'ELEM'), cesk

    def check_longueurs(self, checker):
        if not self.exists():
            return
        cesd = self.CESD.get()
        nbma = cesd[0]
        nbcmp = cesd[1]
        nbval = self.CESV.lonmax
        assert nbma > 0, cesd[:5]
        assert nbcmp > 0, cesd[:5]

        assert self.CESD.lonmax == 5 + 4 * nbma
        assert self.CESC.lonmax == nbcmp
        assert self.CESL.lonmax == nbval
