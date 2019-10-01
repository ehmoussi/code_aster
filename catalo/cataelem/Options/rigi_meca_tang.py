# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
comment=""" Informations for non-linear behaviour """)

PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment=""" Local orientation for beam and pipe elements""")

PCONTMR  = InputParameter(phys=PHY.SIEF_R,
comment=""" Stress tensor at beginning of current time step """)

PVARIMR  = InputParameter(phys=PHY.VARI_R,
comment=""" Internal state variables at beginning of current time step """)

PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment=""" External state variables at end of current time step """)

PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment=""" Number of sub-integration points for structural elements""")

PPINTTO  = InputParameter(phys=PHY.N132_R,
comment=""" XFEM """)

PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment=""" XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)

PHEAVTO  = InputParameter(phys=PHY.N512_I,
comment=""" XFEM""")

PHEA_NO  = InputParameter(phys=PHY.N120_I,
comment=""" XFEM""")

PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment=""" XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)

PBASLOR  = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM""")

PLSN     = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM""")

PLST     = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM""")

PSTANO   = InputParameter(phys=PHY.N120_I,
comment=""" XFEM""")

PPMILTO  = InputParameter(phys=PHY.N792_R,
comment=""" XFEM""")

PFISNO   = InputParameter(phys=PHY.NEUT_I,
comment=""" PXFEM - CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDE """)

PCACO3D  = OutputParameter(phys=PHY.CACO3D, type='ELEM',
comment=""" Field of normals for COQUE_3D elements """)

# For HHO
PCELLMR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCELLIR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCSMTIR  = OutputParameter(phys=PHY.N6480R, type='ELEM',
comment=""" HHO - matrice cellule pour condensation statique""")

PCSRTIR  = OutputParameter(phys=PHY.CELL_R, type='ELEM',
comment=""" HHO - 2nd membre cellule pour condensation statique""")

PCHHOGT  = InputParameter(phys=PHY.N6480R,
comment=""" HHO - matrice du gradient local""")

PCHHOST  = InputParameter(phys=PHY.N6480R,
comment=""" HHO - matrice de la stabilisation locale""")

PVARIPR  = OutputParameter(phys=PHY.VARI_R, type='ELGA',
comment=""" VARIABLES INTERNES POUR T+ """)

PCONTPR  = OutputParameter(phys=PHY.SIEF_R, type='ELGA',
comment=""" VECTEUR DES CONTRAINTES POUR T+ """)

RIGI_MECA_TANG = Option(
    para_in=(
        SP.PACCKM1,
        SP.PACCPLU,
           PBASLOR,
        SP.PCAARPO,
        SP.PCACABL,
        SP.PCACOQU,
        SP.PCADISK,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCAGNPO,
        SP.PCAMASS,
           PCAORIE,
        SP.PCARCRI,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
        SP.PMULCOM,
           PCONTMR,
        SP.PDDEPLA,
        SP.PDEPENT,
        SP.PDEPKM1,
        SP.PDEPLMR,
        SP.PDEPLPR,
        SP.PFIBRES,
           PFISNO,
        SP.PGEOMER,
           PHEAVTO,
           PHEA_NO,
        SP.PINSTMR,
        SP.PINSTPR,
        SP.PITERAT,
           PLONCHA,
           PLSN,
           PLST,
        SP.PMATERC,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
        SP.PROMK,
        SP.PROMKM1,
        SP.PSTADYN,
           PSTANO,
        SP.PSTRXMR,
        SP.PVARCMR,
           PVARCPR,
        SP.PVARCRR,
        SP.PVARIMP,
           PVARIMR,
        SP.PVITENT,
        SP.PVITKM1,
        SP.PVITPLU,
           PCELLMR,
           PCELLIR,
           PCHHOGT,
           PCHHOST,
    ),
    para_out=(
           PCACO3D,
        SP.PMATUNS,
        SP.PMATUUR,
        SP.PVECTUR,
        SP.PCOPRED,
        SP.PCODRET,
           PCSMTIR,
           PCSRTIR,
           PCONTPR,
           PVARIPR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.FLUIDE,'OUI'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.FSI ,'OUI'),)),
    ),
)
