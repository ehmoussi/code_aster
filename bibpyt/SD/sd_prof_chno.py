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
from SD.sd_util import *


class sd_prof_chno(AsBase):
    nomj = SDNom(fin=19)
    PRNO = AsColl(acces='NU', stockage='CONTIG',
                  modelong=Parmi('CONSTANT', 'VARIABLE'), type='I', )
    LILI = AsObject(genr='N', xous='S', type='K', ltyp=24, )
    NUEQ = AsVI()
    DEEQ = AsVI()

    def exists(self):
        # retourne "vrai" si la SD semble exister (et donc qu'elle peut etre
        # vérifiée)
        return self.PRNO.exists

    def check_1(self, checker):
        if not self.exists():
            return
        nueq = self.NUEQ.get()
        deeq = self.DEEQ.get()
        neq = len(deeq) / 2
        for x in nueq:
            assert 1 <= x and x <= neq

        for k in range(neq):
            nuno = deeq[2 * k]
            nucmp = deeq[2 * k + 1]
            assert nuno >= 0
            if nuno == 0:
                assert nucmp == 0
            else:
                assert nucmp != 0
