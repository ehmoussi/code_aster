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


PVOISIN = InputParameter(phys=PHY.VOISIN,
                         comment="""  PVOISIN : VOISINS DE L ELEMENT  """)


PERREUR = OutputParameter(phys=PHY.ERRE_R, type='ELEM',
                          comment="""  PERREUR : ESTIMATEUR D ERREUR  """)


ERTH_ELEM = Option(
    para_in=(
        SP.PCHARG,
        SP.PFLUX_M,
        SP.PFLUX_P,
        SP.PGEOMER,
        SP.PMATERC,
        SP.PSOURCF,
        SP.PSOURCR,
        SP.PTEMP_M,
        SP.PTEMP_P,
        PVOISIN,
    ),
    para_out=(
        PERREUR,
    ),
    condition=(
        CondCalcul('+', ((AT.PHENO, 'TH'), (AT.BORD, '0'),)),
    ),
    comment="""  ERTH_ELEM :
    INDICATEUR D'ERREUR SPATIALE EN RESIDU PUR
    POUR LA THERMIQUE TRANSITOIRE AVEC UNE SOURCE REELLE OU FONCTION
    PRODUIT UN CHAMP PAR ELEMENT  """,
)
