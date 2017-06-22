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




VERI_JACOBIEN = Option(
    para_in=(
        SP.PGEOMER,
    ),
    para_out=(
        SP.PCODRET,
    ),
    condition=(
#  C'est un peu le bazar, mais ce n'est qu'une option de verification :
      CondCalcul('+', ((AT.DIM_COOR_MODELI,'3'),(AT.DIM_TOPO_MODELI,'3'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.DIM_COOR_MODELI,'2'),(AT.DIM_TOPO_MODELI,'2'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.INTERFACE,'OUI'),)),
      CondCalcul('-', ((AT.TYPMOD3,'SUSHI'),)),
      CondCalcul('-', ((AT.PESA,'OUI'),)),
    ),
    comment=""" verification que les jacobiens des differents points de Gauss
   ont tous le meme signe """,
)
