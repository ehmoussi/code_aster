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

# person_in_charge: mickael.abbas at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT


PLST = InputParameter(phys=PHY.NEUT_R,
                      comment=""" XFEM """)

PLSN = InputParameter(phys=PHY.NEUT_R,
                      comment=""" XFEM """)


PPINTER = InputParameter(phys=PHY.N816_R,
                         comment=""" XFEM """)


PAINTER = InputParameter(phys=PHY.N1360R,
                         comment=""" XFEM """)


PCFACE = InputParameter(phys=PHY.N720_I,
                        comment=""" XFEM """)


PLONGCO = InputParameter(phys=PHY.N120_I,
                         comment=""" XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PBASECO = InputParameter(phys=PHY.N2448R,
                         comment=""" XFEM """)


PSEUIL = InputParameter(phys=PHY.NEUT_R,
                        comment=""" XFEM """)


PSTANO = InputParameter(phys=PHY.N120_I,
                        comment=""" XFEM """)


PFISNO = InputParameter(phys=PHY.NEUT_I,
                        comment=""" XFEM """)


PHEA_NO = InputParameter(phys=PHY.N120_I,
                         comment=""" XFEM """)


PHEA_FA = InputParameter(phys=PHY.N240_I,
                         comment=""" XFEM """)

PBASLOR  = InputParameter(phys=PHY.NEUT_R)

PBASLOC  = InputParameter(phys=PHY.N480_R)

PLSNGG     = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM """)

CHAR_MECA_FROT = Option(
    para_in=(
        SP.PACCE_M,
        PAINTER,
        PBASECO,
        SP.PCAR_AI,
        SP.PCAR_CF,
        SP.PCAR_PI,
        SP.PCAR_PT,
        PCFACE,
        SP.PCOHES,
        SP.PCONFR,
        SP.PDEPL_M,
        SP.PDEPL_P,
        SP.PDONCO,
        PFISNO,
        SP.PGEOMER,
        SP.PHEAVNO,
        PHEA_FA,
        PHEA_NO,
        SP.PINDCOI,
        PLONGCO,
        PLST,
        PLSN,
        SP.PMATERC,
        PPINTER,
        PSEUIL,
        PSTANO,
        SP.PVITE_M,
        SP.PVITE_P,
        PBASLOR,
        PBASLOC,
        PLSNGG,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
        CondCalcul('+', ((AT.FROTTEMENT, 'OUI'),)),
    ),
    comment=""" CHAR_MECA_FROT : CALCUL DU SECOND MEMBRE
           ELEMENTAIRE DE FROTTEMENT AVEC LA METHODE CONTINUE ET XFEM """,
)
