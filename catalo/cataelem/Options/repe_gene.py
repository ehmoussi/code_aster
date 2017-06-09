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




REPE_GENE = Option(
    para_in=(
        SP.PANGREP,
        SP.PCACOQU,
        SP.PDGGAIN,
        SP.PDGGAINC,
        SP.PDGNOIN,
        SP.PDGNOINC,
        SP.PEFGAIN,
        SP.PEFGAINC,
        SP.PEFNOIN,
        SP.PEFNOINC,
        SP.PGEOMER,
    ),
    para_out=(
        SP.PDGGAOUC,
        SP.PDGGAOUT,
        SP.PDGNOOUC,
        SP.PDGNOOUT,
        SP.PEFGAOUC,
        SP.PEFGAOUT,
        SP.PEFNOOUC,
        SP.PEFNOOUT,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'CQ3'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'DKT'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'DST'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'Q4G'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'DTG'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'Q4S'),(AT.BORD,'0'),)),
    ),
)
