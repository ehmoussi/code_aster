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

# person_in_charge: jean-luc.flejou at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


INI_STRX = Option(
    para_in=(
           PCAORIE,
    ),
    para_out=(
        SP.PSTRX_R,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'PDE'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'PDG'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'PDT'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'PFM'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'PGM'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'PGS'),)),
    ),
    comment=""" INITIALISATION DU CHAMP STRX_ELGA""",
)
