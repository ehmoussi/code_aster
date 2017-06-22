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
from SD.sd_util import *
from SD.sd_nume_ddl_gd import sd_nume_ddl_gd


class sd_macr_elem_dyna_m(AsBase):
#----------------------------------
    nomj = SDNom(fin=18)
    DESC = AsVI(SDNom(nomj='_DESC'), lonmax=3)
    REFE = AsVK24(SDNom(nomj='_REFE'), lonmax=2)
#   VALE = AsObject(SDNom(nomj='_VALE'), type=Parmi('C', 'R',),)
    VALE = AsColl(SDNom(nomj='_VALE'),acces='NU', stockage='DISPERSE',
                  modelong='CONSTANT', type=Parmi('C', 'R'))

    def check_macr_elem_dyna_m_1(self, checker):
        vale = self.VALE.get()
        if not vale:
            return  # si Facultatif()
        vale = self.VALE.get()[1]
        sdu_tous_compris(self.DESC, checker, vmin=1)
        nbdef = self.DESC.get()[1]
        sdu_compare(self.VALE, checker, len(vale),
                    '==', (nbdef * (nbdef + 1)) / 2, 'LONMAX(VALE)')


class sd_macr_elem_dyna(AsBase):
#-------------------------------
    nomj = SDNom(fin=8)

    # description géométrique et topolique :
    DESM = AsVI(lonmax=10)
    REFM = AsVK8()
    LINO = Facultatif(AsVI())
    CONX = Facultatif(AsVI())

    # chargements appliques (facultatif)
    LICA = Facultatif(AsColl())
    LICH = Facultatif(AsColl())

    # rigidité, masse, amortissement condensés :
    nume = sd_nume_ddl_gd(SDNom(nomj=''))

    MAEL_RAID = sd_macr_elem_dyna_m()
    MAEL_MASS = sd_macr_elem_dyna_m()
    MAEL_AMOR = Facultatif(sd_macr_elem_dyna_m())

    MAEL_INER_VALE = AsVR()
    MAEL_INER_REFE = AsVK24(lonmax=2, )

    MAEL_DESC = AsVI(lonmax=3, )
    MAEL_REFE = AsVK24(lonmax=2, )

    def check_macr_elem_dyna_1(self, checker):
        nbdef = self.MAEL_MASS.DESC.get()[1]
        sdu_compare(self.MAEL_INER_VALE, checker, len(
            self.MAEL_INER_VALE.get()), '==', 3 * nbdef, 'LONMAX(MAEL_INER_VALE)')
