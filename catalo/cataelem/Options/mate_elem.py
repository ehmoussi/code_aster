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




PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_N',
comment="""  PVARCPR : VARIABLES DE COMMANDE  """)

PMATERR  = OutputParameter(phys=PHY.MATE_R, type='ELEM')

MATE_ELEM = Option(
    para_in=(
        SP.PGEOMER,
        SP.PMATERC,
           PVARCPR,
    ),
    para_out=(
        PMATERR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'3FL'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'2FL'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'3FA'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'2FA'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'FS2'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'FSA'),)),
    ),
)
