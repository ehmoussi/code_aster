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


class sd_interspectre(sd_titre):
#------------------------------------
    nomj = SDNom(fin=8)

    REFE = AsVK16(lonmax=3,)
    DISC = AsVR()
    VALE = AsColl(
        acces='NU', stockage='DISPERSE', modelong='VARIABLE', type='R',)

    NUMI = Facultatif(AsVI())
    NUMJ = Facultatif(AsVI())
    NUME_ORDRE = Facultatif(AsVI())

    NOEI = Facultatif(AsVK8())
    NOEJ = Facultatif(AsVK8())
    CMPI = Facultatif(AsVK8())
    CMPJ = Facultatif(AsVK8())

    def check_NUME(self, checker):
    #-------------------------------
        if self.NUMI.exists:
            numi = self.NUMI.get()
            assert self.NUMJ.exists
            numj = self.NUMJ.get()
            assert len(numi) == len(numj)
            assert self.VALE.nmaxoc == len(numi)

        elif self.NOEI.exists:
            noei = self.NOEI.get()
            assert self.NOEJ.exists
            noej = self.NOEJ.get()
            assert len(noej) == len(noei)
            assert self.CMPI.exists
            cmpi = self.CMPI.get()
            assert self.CMPJ.exists
            cmpj = self.CMPJ.get()
            assert len(cmpj) == len(cmpi)
            assert len(noei) == len(cmpj)
            assert self.VALE.nmaxoc == len(noei)
        else:
            assert self.NUME_ORDRE.exists
            nume_ordre = self.NUME_ORDRE.get()
