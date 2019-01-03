# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: samuel.geniaut at edf.fr

from code_aster.Cata.Syntax import OPER, SIMP
from code_aster.Cata.DataStructure import table_sdaster, evol_noli, fiss_xfem
from code_aster.Commands.ExecuteCommand import ExecuteCommand
from code_aster import Table


DETEC_FRONT_CATA = OPER(
    nom="DETEC_FRONT", op=139, sd_prod=table_sdaster, reentrant='n',
    fr="Detection de front cohesif avec X-FEM",

    FISSURE=SIMP(statut='o', typ=fiss_xfem),
    NB_POINT_FOND=SIMP(statut='f', typ='I', val_min=2),
    RESULTAT=SIMP(statut='o', typ=evol_noli),

)

class DetecFront(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.Table`.
    """
    command_name = "DETEC_FRONT"
    command_cata = DETEC_FRONT_CATA

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Table()

DETEC_FRONT = DetecFront.run
