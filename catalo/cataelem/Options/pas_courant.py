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


PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment=""" PVARCPR : VARIABLES DE COMMANDES  POUR T+ """)

PAS_COURANT = Option(
    para_in=(
        SP.PCACOQU,
        SP.PGEOMER,
        SP.PMATERC,
           PVARCPR,
    ),
    para_out=(
        SP.PCOURAN,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.ABSO,'OUI'),)),
    ),
    comment="""  PAS_COURANT : CALCUL DU PAS DE TEMPS MAXIMUM NECESSAIRE
       A LA STABILITE DES CALCULS DYNAMIQUES AVEC INTEGRATION
       TEMPORELLE EXPLICITE. """,
)
