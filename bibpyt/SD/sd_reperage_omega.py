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


class sd_reperage_omega(AsBase):
    nomj = SDNom(fin=13)
    CREFF_EXTR = AsVR(SDNom(nomj='.CREFF.EXTR', debut=13), )
    FACE__ORIG = AsVI(SDNom(nomj='.FACE .ORIG', debut=13), )
    CREFF_ORIG = AsVR(SDNom(nomj='.CREFF.ORIG', debut=13), )
    ARETE_EXTR = AsVI(SDNom(nomj='.ARETE.EXTR', debut=13), )
    FACE__EXTR = AsVI(SDNom(nomj='.FACE .EXTR', debut=13), )
    MAIL = AsColl(SDNom(debut=13), acces='NU',
                  stockage='CONTIG', modelong='VARIABLE', type='I', )
    CREFM_ORIG = AsVR(SDNom(nomj='.CREFM.ORIG', debut=13), )
    CREFM_EXTR = AsVR(SDNom(nomj='.CREFM.EXTR', debut=13), )
    ARETE_ORIG = AsVI(SDNom(nomj='.ARETE.ORIG', debut=13), )
