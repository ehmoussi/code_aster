# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment="""  PVARCPR : VARIABLES DE COMMANDE  """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)

PCONTMR = InputParameter(phys=PHY.SIEF_R)

PVARIMR  = InputParameter(phys=PHY.VARI_R)

PCOMPOR  = InputParameter(phys=PHY.COMPOR)


PSTANO   = InputParameter(phys=PHY.N120_I)


PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PHEA_NO  = InputParameter(phys=PHY.N120_I)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PBASLOR  = InputParameter(phys=PHY.NEUT_R)


PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PFISNO   = InputParameter(phys=PHY.NEUT_I,
comment=""" PFISNO : CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDE """)


PCACO3D  = OutputParameter(phys=PHY.CACO3D, type='ELEM',
comment=""" NE SERT QUE POUR COQUE_3D """)


# For HHO
PCELLMR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCELLIR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCSMTIR  = OutputParameter(phys=PHY.N3240R, type='ELEM',
comment=""" HHO - matrice cellule pour condensation statique""")

PCSRTIR  = OutputParameter(phys=PHY.CELL_R, type='ELEM',
comment=""" HHO - 2nd membre cellule pour condensation statique""")

PCHHOGT  = InputParameter(phys=PHY.N1920R,
comment=""" HHO - matrice du gradient local""")

PCHHOST  = InputParameter(phys=PHY.N2448R,
comment=""" HHO - matrice de la stabilisation locale""")

PVARIPR  = OutputParameter(phys=PHY.VARI_R, type='ELGA',
comment=""" VARIABLES INTERNES POUR T+ """)

PCONTPR  = OutputParameter(phys=PHY.SIEF_R, type='ELGA',
comment=""" VECTEUR DES CONTRAINTES POUR T+ """)


RIGI_MECA = Option(
    para_in=(
           PBASLOR,
        SP.PCAARPO,
        SP.PCACOQU,
        SP.PCADISK,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCAGNPO,
        SP.PCAMASS,
        SP.PCARCRI,
           PCAORIE,
        SP.PCAPOUF,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
        SP.PFIBRES,
           PFISNO,
        SP.PGEOMER,
        SP.PHARMON,
           PHEAVTO,
           PHEA_NO,
           PLONCHA,
           PLSN,
           PLST,
        SP.PMATERC,
        SP.PMULCOM,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
           PSTANO,
        SP.PTEMPSR,
        SP.PITERAT,
        SP.PINSTMR,
        SP.PINSTPR,
        SP.PVARCMR,
        SP.PVARCRR,
        SP.PDEPLMR,
        SP.PDEPLPR,
           PCONTMR,
           PVARCPR,
           PVARIMR,
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
        SP.PCODRET,
           PCSMTIR,
           PCSRTIR,
           PCONTPR,
           PVARIPR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.FLUIDE,'OUI'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.FLUIDE,'OUI'),(AT.FSI ,'OUI'),)),
      CondCalcul('+', ((AT.POUTRE,'OUI'),(AT.FSI ,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.TYPMOD2, 'HHO'),)),
    ),
)
