# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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




PVARCPR  = InputParameter(phys=PHY.VARI_R)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


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


MASS_MECA = Option(
    para_in=(
           PBASLOR,
        SP.PCACABL,
        SP.PCACOQU,
        SP.PCADISM,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCAGNPO,
           PCAORIE,
        SP.PCAPOUF,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
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
           PSTANO,
           PVARCPR,
    ),
    para_out=(
        SP.PMATUNS,
        SP.PMATUUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.FSI ,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.INTERFACE,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'D2D'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'D3D'),)),
    ),
)
