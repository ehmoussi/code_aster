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




PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)

PCOMPOR  = InputParameter(phys=PHY.COMPOR,
comment="""  Informations for non-linear comportment """)

PCONTMR  = InputParameter(phys=PHY.SIEF_R)


PVARIMR  = InputParameter(phys=PHY.VARI_R)


PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment=""" PVARCPR : VARIABLES DE COMMANDES  POUR T+ """)


PCAORIE  = InputParameter(phys=PHY.CAORIE,
comment=""" CHAMP DE CARACTERISTIQUES D'ORIENTATION. CONCEPT CARA_ELEM """)


PCONTPR  = OutputParameter(phys=PHY.SIEF_R, type='ELGA')


PVARIPR  = OutputParameter(phys=PHY.VARI_R, type='ELGA')


PCACO3D  = OutputParameter(phys=PHY.CACO3D, type='ELEM',
comment=""" NE SERT QUE POUR COQUE_3D """)


FULL_MECA_ELAS = Option(
    para_in=(
        SP.PCACOQU,
        SP.PCADISK,
        SP.PCAGNBA,
        SP.PCAMASS,
           PCAORIE,
        SP.PCARCRI,
        SP.PCINFDI,
           PCOMPOR,
        SP.PMULCOM,
           PCONTMR,
        SP.PDEPLMR,
        SP.PDEPLPR,
        SP.PGEOMER,
        SP.PINSTMR,
        SP.PINSTPR,
        SP.PMATERC,
           PNBSP_I,
        SP.PVARCMR,
           PVARCPR,
        SP.PVARCRR,
        SP.PVARIMP,
           PVARIMR,
    ),
    para_out=(
           PCACO3D,
        SP.PCODRET,
           PCONTPR,
        SP.PMATUNS,
        SP.PMATUUR,
           PVARIPR,
        SP.PVECTUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
)
