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

# person_in_charge: josselin.delmas at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCONTPR  = InputParameter(phys=PHY.SIEF_R, container='RESU!SIGM_ELGA!N',
comment=""" PCONTPR : CONTRAINTES A L INSTANT + """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR, container='RESU!COMPORTEMENT!N',
comment=""" PCOMPOR : COMPORTEMENT """)


PVARIPR  = InputParameter(phys=PHY.VARI_R, container='RESU!VARI_ELGA!N',
comment=""" PVARIPR : VARIABLES INTERNES A L INSTANT + """)


INDL_ELGA = Option(
    para_in=(
           PCOMPOR,
           PCONTPR,
        SP.PMATERC,
           PVARIPR,
    ),
    para_out=(
        SP.PINDLOC,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.DIM_COOR_MODELI,'2'),(AT.BORD,'0'),)),
    ),
    comment="""  INDL_ELGA :
           INDICATEUR DE LOCALISATION AUX POINTS DE GAUSS
           PRODUIT UN CHAMP AUX POINTS DE GAUSS  """,
)
