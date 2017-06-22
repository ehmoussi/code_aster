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

# person_in_charge: nicolas.greffet at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVARCPR  = InputParameter(phys=PHY.VARI_R)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I,
comment="""  NOMBRE DE SOUS_POINTS POUR LES ELEMENTS DE STRUCTURES """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR)


M_GAMMA = Option(
    para_in=(
        SP.PACCELR,
        SP.PCACABL,
        SP.PCACOQU,
        SP.PCADISM,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCAGNPO,
           PCAORIE,
        SP.PCINFDI,
           PCOMPOR,
        SP.PFIBRES,
        SP.PGEOMER,
        SP.PMATERC,
           PNBSP_I,
           PVARCPR,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
)
