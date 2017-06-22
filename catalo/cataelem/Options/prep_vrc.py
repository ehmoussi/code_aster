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




PINST_R  = InputParameter(phys=PHY.INST_R)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


PREP_VRC = Option(
    para_in=(
        SP.PCACOQU,
           PINST_R,
           PNBSP_I,
        SP.PTEMPEF,
        SP.PTEMPER,
    ),
    para_out=(
        SP.PTEMPCR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.COQUE,'OUI'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'GRC'),)),
    ),
    comment=""" CALCUL DE LA TEMPERATURE SUR LES COUCHES DES COQUES MULTICOUCHE
   UTILISE PAR CREA_RESU/PREP_VRC EN PREVISION D'UN CALCUL MECANIQUE
""",
)
