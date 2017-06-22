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

# Attention :
# On utilise certains parametres si on part de SIEF_ELGA (cas non lineaire).
# On utilise d'autres parametres si on part de DEPL (cas lineaire) :


# Probleme pour PCOMPOR :
#   1) En non lineaire, il faut prendre 'RESU!COMPORTEMENT'
#   2) En lineaire (pour POU_D_EM), il faut prendre 'CHMA!.COMPOR'
#   On privilegie le 1er cas et on corrige si necessaire dans ccaccl.F90

PCOMPOR  = InputParameter(phys=PHY.COMPOR, container='RESU!COMPORTEMENT!N',
comment="""  PCOMPOR :  COMPORTEMENT STOCKE DANS LA SD_RESULTAT  """)


PCONTRR  = InputParameter(phys=PHY.SIEF_R, container='RESU!SIEF_ELGA!N',
comment="""  PCONTRR : ETAT DE CONTRAINTE AUX POINTS DE GAUSS """)


PSTRXRR  = InputParameter(phys=PHY.STRX_R, container='RESU!STRX_ELGA!N',
comment="""  PSTRXRR : CHAMPS SPECIAL ELEMENTS DE STRUCTURE """)


PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_N',
comment="""  PVARCPR : VARIABLE DE COMMANDE INSTANT ACTUEL """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  CAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


PEFFORR  = OutputParameter(phys=PHY.SIEF_R, type='ELNO')


EFGE_ELNO = Option(
    para_in=(
        SP.PCAARPO,
        SP.PCACOQU,
        SP.PCADISK,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCACABL,
        SP.PCAGNPO,
           PCAORIE,
        SP.PCHDYNR,
        SP.PCINFDI,
        SP.PCOEFFC,
        SP.PCOEFFR,
           PCOMPOR,
           PCONTRR,
        SP.PDEPLAR,
        SP.PFF1D1D,
        SP.PFIBRES,
        SP.PFR1D1D,
        SP.PGEOMER,
        SP.PMATERC,
           PNBSP_I,
        SP.PNONLIN,
        SP.PPESANR,
           PSTRXRR,
        SP.PSUROPT,
        SP.PTEMPSR,
           PVARCPR,
        SP.PVARCRR,
    ),
    para_out=(
        SP.PEFFORC,
           PEFFORR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.EFGE,'OUI'),(AT.BORD,'0'),)),
    ),
    comment="""  EFGE_ELNO : CALCUL DES EFFORTS GENERALISES AUX NOEUDS
           A PARTIR DES DEPLACEMENTS OU DES CONTRAINTES """,
)
