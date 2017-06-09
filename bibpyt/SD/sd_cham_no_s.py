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


class sd_cham_no_s(AsBase):
#----------------------------
    nomj = SDNom(fin=19)

    CNSK = AsVK8(lonmax=2)
    CNSD = AsVI(lonmax=2)
    CNSC = AsVK8()
    CNSV = AsVect(type=Parmi('C', 'K', 'R', 'I'))
    CNSL = AsVL()

    def exists(self):
        return self.CNSK.exists

    def check_CNSK(self, checker):
        if not self.exists():
            return
        cnsk = self.CNSK.get_stripped()
        sd2 = sd_maillage(cnsk[0])
        sd2.check(checker)

    def check_longueurs(self, checker):
        if not self.exists():
            return
        cnsd = self.CNSD.get()
        nbno = cnsd[0]
        nbcmp = cnsd[1]
        assert nbno > 0, cnsd
        assert nbcmp > 0, cnsd

        assert self.CNSC.lonmax == nbcmp
        assert self.CNSL.lonmax == nbno * nbcmp
        assert self.CNSV.lonmax == nbno * nbcmp
