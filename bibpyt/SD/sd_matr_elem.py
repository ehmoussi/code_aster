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
from SD.sd_resuelem import sd_resuelem
from SD.sd_cham_no import sd_cham_no
from SD.sd_modele import sd_modele
from SD.sd_cham_mater import sd_cham_mater
from SD.sd_cara_elem import sd_cara_elem


class sd_matr_elem(AsBase):
    nomj = SDNom(fin=19)
    RERR = AsVK24(lonmax=5, )
    RELR = Facultatif(AsVK24())
    TITR = AsVK80(SDNom(debut=19), optional=True)

    # indirection par RELR :
    def check_matr_elem_i_RELR(self, checker):
        if not self.RELR.exists:
            return
        lnom = self.RELR.get_stripped()
        for nom in lnom:
            if nom != '':
                # le nom est celui d'un resuelem ou parfois d'un cham_no
                # (VECT_ASSE):
                sd2 = sd_resuelem(nom)
                if sd2.RESL.exists:
                    sd2.check(checker)
                else:
                    sd2 = sd_cham_no(nom)
                    sd2.check(checker)

    def check_1(self, checker):
        refe = self.RERR.get_stripped()
        assert refe[2] in ('OUI_SOUS_STRUC', 'NON_SOUS_STRUC'), refe

        # existence de RELR :
        if refe[2] == 'NON_SOUS_STRUC':
            assert self.RELR.exists

        assert refe[1] != '', refe

        sd2 = sd_modele(refe[0])
        sd2.check(checker)

        if refe[3] != '':
            sd2 = sd_cham_mater(refe[3])
            sd2.check(checker)

        if refe[4] != '':
            sd2 = sd_cara_elem(refe[4])
            sd2.check(checker)
