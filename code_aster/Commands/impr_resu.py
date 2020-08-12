# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: nicolas.sellenet@edf.fr

from ..Cata.Syntax import _F
from ..Messages import UTMESS
from ..Supervis import ExecuteCommand


class ImprResu(ExecuteCommand):
    """Command IMPR_RESU.
    """
    command_name = "IMPR_RESU"

    def add_result_name(self, resu):
        if resu["RESULTAT"] is not None:
            if(len(resu["RESULTAT"].userName) == 0 ):
                UTMESS('A', 'MED3_2', valk=(resu["RESULTAT"].getName()))
            else:
                if resu["NOM_CHAM"] is not None:
                    name_resu = resu["RESULTAT"].userName.ljust(8,"_")[0:8]
                    if resu["NOM_CHAM_MED"] is None:
                        list_name = []
                        if isinstance(resu["NOM_CHAM"], str):
                            list_name.append(name_resu+resu["NOM_CHAM"])
                        else:
                            for field in resu["NOM_CHAM"]:
                                list_name.append(name_resu+field)
                        resu["NOM_CHAM_MED"] = list_name
                elif resu["NOM_RESU_MED"] is None:
                    resu["NOM_RESU_MED"] = resu["RESULTAT"].userName[0:8]
        elif resu["CHAM_GD"] is not None:
            if resu["NOM_CHAM"] is not None:
                if (len(resu["CHAM_GD"].userName) == 0) :
                    UTMESS('A', 'MED3_2', valk=(resu["CHAM_GD"].getName()))
                else:
                    if resu["NOM_CHAM_MED"] is None:
                        name_field = resu["CHAM_GD"].userName.ljust(8,"_")[0:8]
                        list_name = []
                        if isinstance(resu["NOM_CHAM"], str):
                            list_name.append(name_field+resu["NOM_CHAM"])
                        else:
                            for field in resu["NOM_CHAM"]:
                                list_name.append(name_field+field)
                        resu["NOM_CHAM_MED"] = list_name



    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """

        if "FORMAT" not in keywords or keywords["FORMAT"] is "MED":
            list_resu = keywords["RESU"]

            if isinstance(list_resu, dict) or isinstance(list_resu, _F):
                self.add_result_name(list_resu)
            else:
                for resu in list_resu:
                    self.add_result_name(resu)


IMPR_RESU = ImprResu.run
