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
from sd_modele import sd_modele


class sd_proj_mesu(AsBase):
#-------------------------------------
    nomj = SDNom(fin=18)
    PJMNO = AsVI()
    PJMRG = AsVK8()
    PJMBP = AsVR()
    PJMRF = AsVK16(lonmax=5)

    # si PROJ_MESU_MODAL :
    PJMOR = Facultatif(AsVR())

    # si MACR_ELEM_STAT :
    PJMIG = Facultatif(AsVR())
    PJMMM = Facultatif(AsObject(genr='V', type=Parmi('C', 'R')))

    def exists(self):
    #  retourne .true. si la SD semble exister
        return self.PJMNO.exists

    def check_1(self, checker):
    #------------------------------------
        if not self.exists():
            return

        nbutil = self.PJMNO.lonuti
        assert nbutil > 0, nbutil

        # vérifications communes :
        assert self.PJMRG.lonmax >= nbutil
        n1 = self.PJMBP.lonuti
        nbmode = n1 / nbutil
        assert n1 == nbutil * nbmode, (nbmode, nbutil, n1)
        assert self.PJMRF.exists
        pjmrf = self.PJMRF.get_stripped()
        sd2 = sd_modele(pjmrf[0])
        sd2.check(checker)
        assert pjmrf[1] != '', pjmrf
        assert pjmrf[2] != '', pjmrf

        # quel cas de figure : PROJ_MESU_MODAL ou MACR_ELEM_STAT ?
        lproj = self.PJMOR.exists

        # si PROJ_MESU_MODAL :
        if lproj:
            nbcapt = nbutil
            assert self.PJMOR.lonmax >= 3 * nbcapt
            assert not self.PJMIG.exists
            assert pjmrf[3] == '', pjmrf
            assert pjmrf[4] == '', pjmrf

        # si MACR_ELEM_STAT :
        else:
            nbddle = nbutil
            assert self.PJMIG.exists
            assert self.PJMMM.exists
            n1 = self.PJMIG.lonmax
            nbmoid = n1 / nbddle
            assert n1 == nbddle * nbmoid, (nbmodi, nbddle, n1)

            assert pjmrf[3] != '', pjmrf
            sd2 = sd_proj_mesu(pjmrf[4])
            sd2.check(checker)
