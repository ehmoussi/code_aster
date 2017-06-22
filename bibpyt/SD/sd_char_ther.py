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
from SD.sd_cham_elem import sd_cham_elem
from SD.sd_carte import sd_carte
from SD.sd_champ import sd_champ
from SD.sd_fonction import sd_fonction


class sd_char_chth(AsBase):
#--------------------------------
    nomj = SDNom(fin=13)

    CONVE_VALE = Facultatif(AsVK8(SDNom(nomj='.CONVE.VALE'), lonmax=1))
    MODEL_NOMO = AsVK8(SDNom(nomj='.MODEL.NOMO'), lonmax=1)
    LIGRE = Facultatif(sd_ligrel())

    SOURE = Facultatif(sd_champ(SDNom(nomj='.SOURE')))
                       # pour l'instant : sd_carte ou sd_cham_elem

    CIMPO = Facultatif(sd_carte())
    CMULT = Facultatif(sd_carte())
    COEFH = Facultatif(sd_carte())
    FLUNL = Facultatif(sd_carte())
    SOUNL = Facultatif(sd_carte())
    FLUR2 = Facultatif(sd_carte())
    FLURE = Facultatif(sd_carte())
    GRAIN = Facultatif(sd_carte())
    HECHP = Facultatif(sd_carte())
    RAYO = Facultatif(sd_carte())
    T_EXT = Facultatif(sd_carte())
    EVOL_CHAR = Facultatif(AsVK8(SDNom(nomj='.EVOL.CHAR'), lonmax=1, ))

    # parfois, TEMP_IMPO crée une carte de sd_fonction :
    # il faut alors vérifier ces sd_fonction
    def check_CIMPO_FONC(self, checker):
        if self.CIMPO.VALE.ltyp != 24:
            return
        vale = self.CIMPO.VALE.get()
        for x in vale:
            if x.strip() == '':
                continue
            nomfon = x[:19]
            sd2 = sd_fonction(nomfon)
            sd2.check(checker)


class sd_char_ther(AsBase):
#--------------------------------
    nomj = SDNom(fin=8)
    TYPE = AsVK8(lonmax=1)
    CHTH = sd_char_chth()
