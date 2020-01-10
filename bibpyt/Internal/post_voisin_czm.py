# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

# person_in_charge: sam.cuvilliez at edf.fr

from code_aster import PCFieldOnMeshDouble
from code_aster.Cata.DataStructure import carte_sdaster, evol_noli
from code_aster.Cata.Syntax import OPER, SIMP
from code_aster.Commands.ExecuteCommand import ExecuteCommand

POST_VOISIN_CZM_CATA = OPER(

    nom="POST_VOISIN_CZM", op=189,
    docu="...", fr="...",
    reentrant='n',
    sd_prod=carte_sdaster,
    RESULTAT=SIMP(statut='o', typ=evol_noli, max=1,),

)

class PostVoisinCzw(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.Table`.
    """
    command_name = "POST_VOISIN_CZM"
    command_cata = POST_VOISIN_CZM_CATA

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = PCFieldOnMeshDouble(keywords["RESULTAT"].getMesh())

POST_VOISIN_CZM = PostVoisinCzw.run
