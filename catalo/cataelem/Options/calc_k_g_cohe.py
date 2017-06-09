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

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT


PBASLOR = InputParameter(phys=PHY.NEUT_R)


PPINTER = InputParameter(phys=PHY.N816_R)


PAINTER = InputParameter(phys=PHY.N1360R)


PCFACE = InputParameter(phys=PHY.N720_I)


PLONGCO = InputParameter(phys=PHY.N120_I)


PBASECO = InputParameter(phys=PHY.N2448R)


PLST = InputParameter(phys=PHY.NEUT_R)


PHEA_NO = InputParameter(phys=PHY.N120_I)


CALC_K_G_COHE = Option(
    para_in=(
        PAINTER,
        PBASECO,
        PBASLOR,
        PCFACE,
        SP.PDEPLAR,
        SP.PGEOMER,
        PHEA_NO,
        PLONGCO,
        PLST,
        SP.PMATERC,
        PPINTER,
        SP.PTHETAR,
    ),
    para_out=(
        SP.PGTHETA,
    ),
    condition=(
        CondCalcul(
            '+', ((AT.PHENO, 'ME'), (AT.LXFEM, 'OUI'), (AT.CONTACT, 'OUI'),)),
    ),
)
