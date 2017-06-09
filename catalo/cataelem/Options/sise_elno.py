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

# person_in_charge: josselin.delmas at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCONTRR  = InputParameter(phys=PHY.SIEF_R, container='RESU!SIGM_ELGA!N',
comment="""  PCONTRR : CONTRAINTES REELLES AUX POINTS DE GAUSS """)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  PLONCHA : XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS """)


PCONTSER = OutputParameter(phys=PHY.N1920R, type='ELEM',
comment="""  PCONTSER : CONTRAINTES REELLES PAR SOUS-ELEMENT AUX NOEUDS """)


SISE_ELNO = Option(
    para_in=(
           PCONTRR,
           PLONCHA,
    ),
    para_out=(
           PCONTSER,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.LXFEM,'OUI'),(AT.BORD,'0'),)),
    ),
    comment="""  SISE_ELNO : CALCUL DES CONTRAINTES ET DES EFFORTS
                       PAR SOUS-ELEMENT AUX NOEUDS """,
)
