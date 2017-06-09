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

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PERREUR  = OutputParameter(phys=PHY.ERRE_R, type='ELEM',
comment="""  PERREUR : ESTIMATEUR D ERREUR  """)


ERRE_TEMPS_THM = Option(
    para_in=(
        SP.PCONTGM,
        SP.PCONTGP,
        SP.PGEOMER,
        SP.PGRDCA,
        SP.PMATERC,
        SP.PTEMPSR,
    ),
    para_out=(
           PERREUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.TYPMOD2, 'THM'),(AT.DIM_COOR_MODELI,'2'),(AT.BORD,'0'),)),
    ),
    comment="""  ERRE_TEMPS_THM :
           ESTIMATEUR D ERREUR TEMPORELLE POUR LA THM SATURE
           PRODUIT UN CHAMP PAR ELEMENT  """,
)
