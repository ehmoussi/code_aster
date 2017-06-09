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




PCOMPOR  = InputParameter(phys=PHY.COMPOR,
comment=""" COMPORTMENT INFO """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment=""" BEAMS: ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment=""" MULTIFIBER:  NOMBRE DE SOUS_POINTS """)


PPINTTO  = InputParameter(phys=PHY.N132_R,
comment=""" SPECIFIQUE X-FEM """)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment=""" XFEM - CONNECTIVITE DES SOUS-ELEMENTS """)


PHEA_NO  = InputParameter(phys=PHY.N120_I,
comment=""" SPECIFIQUE X-FEM """)


PHEAVTO  = InputParameter(phys=PHY.N512_I,
comment=""" SPECIFIQUE X-FEM """)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment=""" XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS """)


PLSN     = InputParameter(phys=PHY.NEUT_R,
comment=""" SPECIFIQUE X-FEM """)


PLST     = InputParameter(phys=PHY.NEUT_R,
comment=""" SPECIFIQUE X-FEM """)


PSTANO   = InputParameter(phys=PHY.N120_I,
comment=""" SPECIFIQUE X-FEM """)


PPMILTO  = InputParameter(phys=PHY.N792_R,
comment=""" SPECIFIQUE X-FEM """)

PBASLOR  = InputParameter(phys=PHY.NEUT_R)


CHAR_MECA_ROTA_R = Option(
    para_in=(
        SP.PCACOQU,
        SP.PCAGNPO,
           PCAORIE,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
        SP.PDEPLMR,
        SP.PDEPLPR,
        SP.PFIBRES,
        SP.PGEOMER,
           PHEAVTO,
           PHEA_NO,
           PLONCHA,
           PLSN,
           PLST,
        SP.PMATERC,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
        SP.PROTATR,
           PSTANO,
           PBASLOR,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment=""" SECOND MEMBRE POUR LES FORCES CENTRIFUGES (ROTATION) """,
)
