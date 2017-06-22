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

# person_in_charge: jacques.pellet at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment=""" PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PMATPASS = OutputParameter(phys=PHY.CHGREPER, type='ELEM')


REPERE_LOCAL = Option(
    para_in=(
        SP.PCACOQU,
        SP.PCAMASS,
           PCAORIE,
        SP.PGEOMER,
    ),
    para_out=(
           PMATPASS,
        SP.PREPLO1,
        SP.PREPLO2,
        SP.PREPLO3,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),)),
    ),
    comment=""" CALCUL DU REPERE LOCAL """,
)
