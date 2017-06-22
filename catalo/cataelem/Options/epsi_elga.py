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

# person_in_charge: jacques.pellet at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_N',
comment="""  PVARCPR : VARIABLES DE COMMANDE  """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR, container='RESU!COMPORTEMENT!N',
comment="""  PCOMPOR : COMPORTEMENT """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU,
           ISSUE DE AFFE_CARA_ELEM MOT CLE ORIENTATION """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS """)


PSTRXRR  = InputParameter(phys=PHY.STRX_R, container='RESU!STRX_ELGA!N',
comment="""  PSTRXRR : CHAMPS ELEMENTS DE STRUCTURE INSTANT ACTUEL """)


PDEFOPG  = OutputParameter(phys=PHY.EPSI_R, type='ELGA',
comment="""  PDEFOPG : DEFORMATIONS AUX POINTS DE GAUSS """)


EPSI_ELGA = Option(
    para_in=(
        SP.PCACOQU,
        SP.PCAGEPO,
        SP.PCAMASS,
           PCAORIE,
           PCOMPOR,
        SP.PDEPLAR,
        SP.PFIBRES,
        SP.PGEOMER,
        SP.PHARMON,
        SP.PMATERC,
           PNBSP_I,
           PSTRXRR,
        SP.PTEMPSR,
           PVARCPR,
        SP.PVARCRR,
    ),
    para_out=(
        SP.PDEFOPC,
           PDEFOPG,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.DISCRET,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'3FI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'AFI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'PFI'),)),
    ),
    comment="""  EPSI_ELGA : DEFORMATIONS PAR ELEMENT AUX POINTS DE GAUSS """,
)
