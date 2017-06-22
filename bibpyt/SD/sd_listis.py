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
from SD.sd_util import *


class sd_listis(sd_titre):
#-------------------------------------
    nomj = SDNom(fin=19)
    LPAS = AsVI()
    BINT = AsVI()
    NBPA = AsVI()
    VALE = AsVI()

    def check_1(self, checker):
        nbpa = self.NBPA.get()
        bint = self.BINT.get()
        lpas = self.LPAS.get()
        vale = self.VALE.get()

        # cas général :
        if len(vale) > 1:
            assert len(bint) == len(nbpa) + 1
            assert len(nbpa) == len(lpas)

            n1 = 0
            assert vale[0] == bint[0]
            for k in range(len(nbpa)):
                npas = nbpa[k]
                assert npas > 0
                n1 = n1 + npas
                assert vale[n1] == bint[k + 1]

            assert len(vale) == n1 + 1
            assert sdu_monotone(vale) in (1,), vale

        # cas particulier :
        if len(vale) == 1:
            assert len(bint) == 1
            assert len(nbpa) == 1
            assert len(lpas) == 1
            assert vale[0] == bint[0]
            assert nbpa[0] == 0, nbpa
            assert lpas[0] == 0, lpas
