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

# person_in_charge: xavier.desroches at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCONTPR  = InputParameter(phys=PHY.SIEF_R, container='RESU!SIEF_ELGA!N',
comment="""  PCONTRR : CONTRAINTES INSTANT ACTUEL """)


PVARIPR  = InputParameter(phys=PHY.VARI_R, container='RESU!VARI_ELGA!N',
comment="""  PVARIPR : VARIABLES INTERNES AUX POINTS DE GAUSS """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR, container='RESU!COMPORTEMENT!N',
comment=""" PCOMPOR  :  COMPORTEMENT """)


PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_N',
comment="""  PVARCPR : TEMPERATURES INSTANT ACTUEL """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment=""" PNBSP_I  : NOMBRE DE SOUS_POINTS """)


PPINTTO  = InputParameter(phys=PHY.N132_R, container='MODL!.TOPOSE.PIN',
comment="""  XFEM - COORDONNEES DES POINTS D INTERSECTION """)


PPMILTO  = InputParameter(phys=PHY.N792_R, container='MODL!.TOPOSE.PMI',
comment="""  XFEM - COORDONNEES DES POINTS MILIEUX """)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


ENEL_ELEM = Option(
    para_in=(
        SP.PCACOQU,
           PCNSETO,
           PCOMPOR,
           PCONTPR,
        SP.PDEPLR,
        SP.PGEOMER,
           PLONCHA,
        SP.PMATERC,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
           PVARCPR,
        SP.PVARCRR,
           PVARIPR,
    ),
    para_out=(
        SP.PENERD1,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment="""  ENEL_ELEM : ENERGIE ELASTIQUE PAR ELEMENT """,
)
