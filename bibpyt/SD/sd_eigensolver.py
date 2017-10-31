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


class sd_eigensolver(AsBase):
    nomj = SDNom(fin=19)
    ESVK = AsVK24(SDNom(debut=19), lonmax=20, )
    ESVR = AsVR(SDNom(debut=19), lonmax=15, )
    ESVI = AsVI(SDNom(debut=19), lonmax=15, )

    def check_ESVK(self, checker):
    #---------------------------------------------
        esvk = self.ESVK.get_stripped()
#
        assert esvk[0] in ('DYNAMIQUE', 'MODE_FLAMB', 'GENERAL')
        if esvk[0] == 'DYNAMIQUE':
            assert esvk[4] in (
                'PLUS_PETITE', 'CENTRE', 'BANDE', 'TOUT', 'PLUS_GRANDE')
        elif esvk[0] == 'MODE_FLAMB':
            assert esvk[4] in ('PLUS_PETITE', 'CENTRE', 'BANDE', 'TOUT')
        elif esvk[0] == 'GENERAL':
            assert esvk[4] in ('PLUS_PETITE', 'CENTRE', 'BANDE', 'TOUT')
        assert esvk[5] in ('SORENSEN', 'TRI_DIAG', 'JACOBI', 'QZ')
        assert esvk[6] in ('SANS', 'MODE_RIGIDE')
        assert esvk[7] in ('OUI', 'NON')
        assert esvk[9] in ('OUI', 'NON')
        assert esvk[10] in ('OUI', 'NON')
        assert esvk[11] in ('CALIBRATION', 'TOUT')
        assert esvk[15] in ('R', 'I', 'C')
        if esvk[5] == 'QZ':
            assert esvk[16] in ('QZ_SIMPLE', 'QZ_EQUI', 'QZ_QR')
