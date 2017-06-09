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




PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_N',
comment="""  PVARCPR : VARIABLES DE COMMANDE  """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU,
           ISSUE DE AFFE_CARA_ELEM MOT CLE ORIENTATION """)


PSIEFNOR = InputParameter(phys=PHY.SIEF_R, container='RESU!SIEF_ELNO!N',
comment="""  PPSIEFNOR : ETAT DE CONTRAINTE AUX NOEUDS """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS """)


SIPM_ELNO = Option(
    para_in=(
        SP.PCAARPO,
        SP.PCAGEPO,
        SP.PCAGNPO,
           PCAORIE,
        SP.PCHDYNR,
        SP.PCOEFFC,
        SP.PCOEFFR,
        SP.PDEPLAR,
        SP.PFF1D1D,
        SP.PFR1D1D,
        SP.PGEOMER,
        SP.PMATERC,
           PNBSP_I,
        SP.PPESANR,
           PSIEFNOR,
        SP.PSUROPT,
        SP.PTEMPSR,
           PVARCPR,
        SP.PVARCRR,
    ),
    para_out=(
        SP.PSIMXRC,
        SP.PSIMXRR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.DIM_TOPO_MODELI,'1'),)),
    ),
    comment="""  SIPM_ELNO : CALCUL DES CONTRAINTES (COMP SIXX) MAXI ET MINI AUX NOEUDS
           DANS LA SECTION DE POUTRE A PARTIR DES EFFORTS GENERALISES.
           LICITE EN LINEAIRE SEULEMENT. """,
)
