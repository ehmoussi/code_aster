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
from SD.sd_cham_no import sd_cham_no


class sd_fond_fiss(AsBase):
    nomj = SDNom(fin=8)
    LEVREINF_MAIL = Facultatif(AsVK8(SDNom(nomj='.LEVREINF.MAIL'), ))
    NORMALE = Facultatif(AsVR(lonmax=3, ))
    BASEFOND = Facultatif(AsVR())
    FOND_TYPE = AsVK8(SDNom(nomj='.FOND.TYPE'), lonmax=1, )
    FOND_NOEU = Facultatif(AsVK8(SDNom(nomj='.FOND.NOEU'), ))
    FONDSUP_NOEU = Facultatif(AsVK8(SDNom(nomj='.FOND_SUP.NOEU'), ))
    FONDINF_NOEU = Facultatif(AsVK8(SDNom(nomj='.FOND_INF.NOEU'), ))
    DTAN_EXTREMITE = Facultatif(AsVR(lonmax=3, ))
    INFNORM_NOEU = Facultatif(AsVK8(SDNom(nomj='.INFNORM.NOEU'), ))
    DTAN_ORIGINE = Facultatif(AsVR(lonmax=3, ))
    SUPNORM_NOEU = Facultatif(AsVK8(SDNom(nomj='.SUPNORM.NOEU'), ))
    LEVRESUP_MAIL = Facultatif(AsVK8(SDNom(nomj='.LEVRESUP.MAIL'), ))
    INFO = AsVK8(SDNom(nomj='.INFO'), lonmax=3, )
    FOND_TAILLE_R = Facultatif(AsVR(SDNom(nomj='.FOND.TAILLE_R'),))
    FONDFISS = AsVR()
    LNNO = Facultatif(sd_cham_no())
    LTNO = Facultatif(sd_cham_no())
    BASLOC = Facultatif(sd_cham_no())
    FONDFISG = Facultatif(AsVR())

    def check_BASEFOND(self, checker):
        info = self.INFO.get_stripped()
        config = info[1]
        basefond = self.BASEFOND.get()
        if config == 'DECOLLEE':
            assert basefond is None, config
        else:
            pass
