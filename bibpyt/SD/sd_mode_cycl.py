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
from SD.sd_interf_dyna_clas import sd_interf_dyna_clas
# from SD.sd_base_modale import sd_base_modale
from SD.sd_mode_meca import sd_mode_meca
from SD.sd_util import *


class sd_mode_cycl(AsBase):
#--------------------------
    nomj = SDNom(fin=8)
    CYCL_TYPE = AsVK8(lonmax=1, )
    CYCL_CMODE = AsVC()
    CYCL_NBSC = AsVI(lonmax=1, )
    CYCL_DIAM = AsVI()
    CYCL_REFE = AsVK24(lonmax=3, )
    CYCL_DESC = AsVI(lonmax=4, )
    CYCL_FREQ = AsVR()
    CYCL_NUIN = AsVI(lonmax=3, )

    def u_dime(self):
        desc = self.CYCL_DESC.get()
        nb_mod = desc[0]
        assert nb_mod > 0
        nb_ddl = desc[1]
        assert nb_ddl > 0
        nb_ddli = desc[2]
        assert nb_ddli >= 0
        nb_freq = desc[3]
        assert nb_freq > 0
        nb_diam = self.CYCL_DIAM.lonmax / 2
        assert nb_diam > 0
        assert self.CYCL_DIAM.lonmax == 2 * nb_diam
        return (nb_mod, nb_ddl, nb_ddli, nb_freq, nb_diam)

    def check_REFE(self, checker):
        refe = self.CYCL_REFE.get_stripped()
        sd2 = sd_maillage(refe[0])
        sd2.check
        sd2 = sd_interf_dyna_clas(refe[1])
        sd2.check
#        sd2=sd_base_modale(refe[2]); sd2.check
        sd2 = sd_mode_meca(refe[2])
        sd2.check

    def check_NUIN(self, checker):
        nuin = self.CYCL_NUIN.get()
        assert nuin[0] > 0, nuin
        assert nuin[1] > 0, nuin
        assert nuin[2] >= 0, nuin

    def check_NBSC(self, checker):
        nbsc = self.CYCL_NBSC.get()
        assert nbsc[0] > 0, nbsc

    def check_TYPE(self, checker):
        type = self.CYCL_TYPE.get_stripped()
        assert type[0] in ('MNEAL', 'CRAIGB', 'CB_HARMO', 'AUCUN'), type

    def check_CMODE(self, checker):
        nb_mod, nb_ddl, nb_ddli, nb_freq, nb_diam = self.u_dime()
        assert self.CYCL_CMODE.lonmax == nb_diam * \
            nb_freq * (nb_mod + nb_ddl + nb_ddli)

    def check_DIAM(self, checker):
        diam = self.CYCL_DIAM.get()
        nb_diam = len(diam) / 2
        for x in diam[:nb_diam]:
            assert x >= 0, diam
        for x in diam[nb_diam:]:
            assert x > 0, diam
        sdu_tous_differents(self.CYCL_DIAM, checker, diam[:nb_diam])

    def check_FREQ(self, checker):
        nb_mod, nb_ddl, nb_ddli, nb_freq, nb_diam = self.u_dime()
        freq = self.CYCL_FREQ.get()
        assert len(freq) == nb_diam * nb_freq, (
            self.CYCL_DESC.get(), len(freq))
        for x in freq:
            assert x >= 0, freq
