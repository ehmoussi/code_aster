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

# person_in_charge: jessica.haelewyn at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PPINTER  = InputParameter(phys=PHY.N816_R)


PAINTER  = InputParameter(phys=PHY.N1360R)


PCFACE   = InputParameter(phys=PHY.N720_I)


PLONGCO  = InputParameter(phys=PHY.N120_I)


PLST     = InputParameter(phys=PHY.NEUT_R)


PLSN     = InputParameter(phys=PHY.NEUT_R)


PSTANO   = InputParameter(phys=PHY.N120_I)


PBASECO  = InputParameter(phys=PHY.N2448R)


PHEA_NO  = InputParameter(phys=PHY.N120_I)


CHAR_THER_PARO_F = Option(
    para_in=(
           PAINTER,
           PBASECO,
           PCFACE,
        SP.PGEOMER,
           PHEA_NO,
        SP.PHECHPF,
           PLONGCO,
           PLSN,
           PLST,
           PPINTER,
           PSTANO,
        SP.PTEMPER,
        SP.PTEMPSR,
    ),
    para_out=(
        SP.PVECTTR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),(AT.MODELI,'CL1'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),(AT.MODELI,'CL2'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
    ),
)
