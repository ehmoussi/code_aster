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


class sd_corresp_2_mailla(sd_titre):
    nomj = SDNom(fin=16)
    PJXX_K1 = AsVK24(lonmax=5)

    # Remarque : pour retirer la plupart des "facultatifs", il faudrait changer
    # les noms : PJEF_NB -> PE.EFNB
    #            ...
    #            PJNG_I1 -> PN.NGI1
    # et faire 2 class sd_corresp_2_elem et sd_corresp_2_nuage)
    PJEF_NB = Facultatif(AsVI())
    PJEF_NU = Facultatif(AsVI())
    PJEF_M1 = Facultatif(AsVI())
    PJEF_CF = Facultatif(AsVR())
    PJEF_TR = Facultatif(AsVI())
    PJEF_CO = Facultatif(AsVR())
    PJEF_EL = Facultatif(AsVI())            # si ECLA_PG
    PJEF_MP = Facultatif(AsVK8(lonmax=1))   # si ECLA_PG

    PJNG_I1 = Facultatif(AsVI())   # si NUAG_DEG
    PJNG_I2 = Facultatif(AsVI())   # si NUAG_DEG
