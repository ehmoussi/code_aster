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

# person_in_charge: xavier.desroches at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCOMPOR  = InputParameter(phys=PHY.COMPOR, container='RESU!COMPORTEMENT!N',
comment=""" PCOMPOR  :  COMPORTEMENT """)


PDISSPG  = OutputParameter(phys=PHY.DISS_R, type='ELGA',
comment="""  PDISSPG : DENSITE DE DISSIPATION AUX POINTS DE GAUSS """)


DISS_ELGA = Option(
    para_in=(
        SP.PCACOQU,
           PCOMPOR,
        SP.PGEOMER,
        SP.PMATERC,
        SP.PVARIGR,
    ),
    para_out=(
           PDISSPG,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment="""  DISS_ELGA : DENSITE DE DISSIPATION PAR ELEMENT AUX POINTS DE GAUSS """,
)
