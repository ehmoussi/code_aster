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

from SD.sd_prof_chno import sd_prof_chno
from SD.sd_maillage import sd_maillage
from SD.sd_util import *


class sd_nume_equa(sd_prof_chno):
    nomj = SDNom(fin=19)
    NEQU = AsVI(lonmax=2,)
    DELG = AsVI()
    REFN = AsVK24(lonmax=4,)

    def check_REFN(self, checker):
        assert self.REFN.exists
        refn = self.REFN.get_stripped()

        # nom du maillage :
        assert refn[0] != ''
        sd2 = sd_maillage(refn[0])
        sd2.check(checker)

        # nom de la grandeur :
        assert refn[1] != ''
        sdu_verif_nom_gd(refn[1])

        assert refn[2] in ('', 'XXXX')  # inutilise

        # Cas ELIM_LAGR :
        assert refn[3] in ('', 'ELIM_LAGR')

    def check_1(self, checker):
        nequ = self.NEQU.get()
        delg = self.DELG.get()
        neq = nequ[0]
        assert neq > 0
        assert nequ[1] >= 0
        assert len(delg) == neq
        for x in delg:
            assert x in (-2, -1, 0)
