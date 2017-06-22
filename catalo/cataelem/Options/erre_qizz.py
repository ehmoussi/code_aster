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




PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment="""  PVARCPR : VARIABLE DE COMMANDE  """)


PERREUR  = OutputParameter(phys=PHY.ERRE_R, type='ELEM',
comment="""  PERREUR : ESTIMATEUR D ERREUR  """)


ERRE_QIZZ = Option(
    para_in=(
        SP.PGEOMER,
        SP.PMATERC,
        SP.PSIEFD_R,
        SP.PSIEFP_R,
        SP.PSIGMAD,
        SP.PSIGMAP,
           PVARCPR,
    ),
    para_out=(
           PERREUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment="""  ERRE_QIZZ :
           ESTIMATEUR D ERREUR EN QUANTITE D INTERET PAR LISSAGE DE CHAMP
           PRODUIT UN CHAMP PAR ELEMENT  """,
)
