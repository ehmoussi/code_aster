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


class sd_squelette(sd_maillage):
#-------------------------------
    nomj = SDNom(fin=8)
    inv_skeleton = Facultatif(AsVI(SDNom(nomj='.INV.SKELETON'),))

    CORRES = Facultatif(AsVI())
    NOMSST = Facultatif(AsVK8(SDNom(debut=17),))

    # ENSEMBLE__ : TRANS , ANGL_NAUT
    TRANS = Facultatif(AsVK8(lonmax=3))
    ANGL_NAUT = Facultatif(AsVK8(lonmax=3))

    def check_SKELETON(self, checker):
        if not self.inv_skeleton.exists:
            return
        skeleton = self.inv_skeleton.get()
        dime = self.DIME.get()
        nbno = dime[0]
        assert len(skeleton) == 2 * nbno, (dime, len(skeleton))
        for k in skeleton:
            assert k > 0, skeleton

    def check_TRANS_ANGL_NAUT(self, checker):
        trans = self.TRANS.get()
        angl_naut = self.ANGL_NAUT.get()
        assert (trans and angl_naut) or ((not trans) and (not angl_naut))

    def check_CORRES(self, checker):
        if not self.CORRES.exists:
            return
        dime = self.DIME.get()
        corres = self.CORRES.get()
        sdu_tous_differents(self.CORRES, checker)
        assert len(corres) == dime[0], (dime, len(corres))
