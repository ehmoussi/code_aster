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




PVARCPR  = InputParameter(phys=PHY.VARI_R, container='VOLA!&&CCPARA.VARI_INT_NM1',
comment="""  PVARCPR : TEMPERATURES INSTANT ACTUEL  """)


PVARIMR  = InputParameter(phys=PHY.VARI_R, container='RESU!VARI_ELGA!NM1',
comment="""  PVARIMR : VARIABLES INTERNES INSTANT PRECEDENT  """)


PVARIPR  = InputParameter(phys=PHY.VARI_R, container='RESU!VARI_ELGA!N',
comment="""  PVARIPR : VARIABLES INTERNES INSTANT ACTUEL  """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR, container='RESU!COMPORTEMENT!N',
comment="""  PCOMPOR : COMPORTEMENT """)


PTRIAPG  = OutputParameter(phys=PHY.ENDO_R, type='ELGA',
comment="""  PTRIAGP : TRIAXIALITE, CONTRAINTE ENDOMMAGEMENT,
           ET DOMMAGE DE LEMAITRE-SERMAGE INSTANT ACTUEL """)


ENDO_ELGA = Option(
    para_in=(
           PCOMPOR,
        SP.PCONTGP,
        SP.PMATERC,
        SP.PTRIAGM,
        SP.PVARCMR,
           PVARCPR,
           PVARIMR,
           PVARIPR,
    ),
    para_out=(
           PTRIAPG,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment="""  ENDO_ELGA : CALCUL DU TAUX DE TRIAXIALITE DES CONTRAINTES,
           DE LA CONTRAINTE EQUIVALENTE D'ENDOMMAGEMENT ET DE
           L'ENDOMMAGEMENT DE LEMAITRE-SERMAGE
           AUX POINTS DE GAUSS DE CHAQUE ELEMENT """,
)
