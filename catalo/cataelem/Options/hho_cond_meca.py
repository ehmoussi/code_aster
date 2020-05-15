# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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


PCSMTIR  = OutputParameter(phys=PHY.N3240R, type='ELEM',
comment=""" HHO - matrice cellule pour condensation statique""")

PCSRTIR  = OutputParameter(phys=PHY.CELL_R, type='ELEM',
comment=""" HHO - 2nd membre cellule pour condensation statique""")


HHO_COND_MECA = Option(
    para_in=(
        SP.PGEOMER,
        SP.PMAELS1,
        SP.PMAELNS1,
        SP.PVEELE1,
    ),
    para_out=(
           PCSMTIR,
           PCSRTIR,
        SP.PMATUNS,
        SP.PMATUUR,
        SP.PVECTUR,
        SP.PCODRET,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
)
