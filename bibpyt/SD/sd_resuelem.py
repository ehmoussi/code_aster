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


class sd_resuelem(AsBase):
    nomj = SDNom(fin=19)
    NOLI = AsVK24(lonmax=4, )
    DESC = AsVI(docu='RESL', )
    RESL = AsColl(acces='NU', stockage='DISPERSE',
                  modelong='VARIABLE', type=Parmi('C', 'R'))

    def exists(self):
        # retourne "vrai" si la SD semble exister (et donc qu'elle peut etre
        # vérifiée)
        return self.NOLI.exists

    def check_1(self, checker):
        if not self.exists():
            return
        noli = self.NOLI.get_stripped()
        sd2 = sd_ligrel(noli[0])
        sd2.check(checker)
        assert noli[1] != '', noli
        assert noli[2] in ('MPI_COMPLET', 'MPI_INCOMPLET'), noli
        assert noli[3] == '', noli

        desc = self.DESC.get()
        assert desc[0] > 0 and desc[0] < 1000, desc
        nbgr = desc[1]
        assert nbgr > 0, desc
        assert len(desc) == nbgr + 2, desc
        assert self.RESL.nmaxoc == nbgr, desc
        for k in desc:
            assert k >= 0, desc
