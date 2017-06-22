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


PCAORIE = InputParameter(phys=PHY.CAORIE,
                         comment=""" Champ de caracteristiques d'orientation. Concept CARA_ELEM """)


CHAR_MECA_FC1D1D = Option(
    para_in=(
        SP.PCAGNPO,
        PCAORIE,
        SP.PFC1D1D,
        SP.PGEOMER,
    ),
    para_out=(
        SP.PVECTUC,
    ),
    condition=(
        CondCalcul('+', ((AT.PHENO, 'ME'), (AT.DIM_TOPO_MODELI, '1'),)),
    ),
    comment=""" CHAR_MECA_FC1D1D: (MOT-CLE : FORCE_POUTRE): CALCUL DU SECOND
           MEMBRE ELEMENTAIRE CORRESPONDANT A DES FORCES LINEIQUES DE
           TYPE COMPLEXE """,
)
