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

# person_in_charge: jean-luc.flejou at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  CAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU,
           ISSUE DE AFFE_CARA_ELEM MOT CLE ORIENTATION """)


PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_N',
comment="""  PVARCPR : TEMPERATURES DE TYPE REEL INSTANT ACTUEL """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS """)


PDEFOPG  = OutputParameter(phys=PHY.EPSI_R, type='ELGA')


DEGE_ELGA = Option(
    para_in=(
        SP.PCACOQU,
        SP.PCAGEPO,
           PCAORIE,
        SP.PDEPLAR,
        SP.PGEOMER,
        SP.PMATERC,
           PNBSP_I,
           PVARCPR,
        SP.PVARCRR,
    ),
    para_out=(
           PDEFOPG,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.EFGE,'OUI'),(AT.BORD,'0'),)),
    ),
    comment=""" DEFORMATIONS GENERALISEES DANS LES ELEMENTS DE STRUCTURE : COQUES OU POUTRES
   CALCULEES AUX POINTS DE GAUSS DE CHAQUE ELEMENT A PARTIR DES DEPLACEMENTS.""",
)
