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




PCOMPOR  = InputParameter(phys=PHY.COMPOR,
comment="""  PCOMPOR : COMPORTEMENT """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PCONTMR  = InputParameter(phys=PHY.SIEF_R,
comment="""  PCONTMR : CONTRAINTES INSTANT PRECEDENT """)


PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment="""  PVARCPR : TEMPERATURE INSTANT ACTUEL """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PBASLOR  = InputParameter(phys=PHY.NEUT_R)


PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PSTANO   = InputParameter(phys=PHY.N120_I)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PFISNO   = InputParameter(phys=PHY.NEUT_I)


PHEA_NO  = InputParameter(phys=PHY.N120_I,
comment="""  CADRE X-FEM : PPINTTO : COORDONNEES DES POINTS D INTERSECTION
                         PHEAVTO : VALEURS DE L HEAVISIDE SUR LES SS-ELTS
                         PBASLOR : BASE LOCALE AU FOND DE FISSURE
                         PLSN    : LEVEL SET NORMALE
                         PLST    : LEVEL SET TANGENTE
                         PSTANO  : STATUT DES NOEUDS (ENRICHISSEMENT) """)


FORC_NODA = Option(
    para_in=(
           PBASLOR,
        SP.PCACOQU,
        SP.PCAGEPO,
        SP.PCAGNPO,
        SP.PCAMASS,
           PCAORIE,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
           PCONTMR,
        SP.PDEPLMR,
        SP.PDEPLPR,
        SP.PFIBRES,
           PFISNO,
        SP.PGEOMER,
        SP.PHARMON,
           PHEAVTO,
           PHEA_NO,
        SP.PINSTMR,
        SP.PINSTPR,
           PLONCHA,
           PLSN,
           PLST,
        SP.PMATERC,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
           PSTANO,
        SP.PSTRXMR,
           PVARCPR,
        SP.PVARCRR,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.FLUIDE,'OUI'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.FSI   ,'OUI'),)),
    ),
    comment="""  FORC_NODA : CALCUL DES FORCES NODALES EQUILIBRANT LES CONTRAINTES
       OU EFFORTS AUX POINTS D'INTEGRATION AU SENS DES TRAVAUX VIRTUELS """,
)
