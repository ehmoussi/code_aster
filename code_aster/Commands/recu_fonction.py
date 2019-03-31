# coding=utf-8
#
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

# person_in_charge: mathieu.courtois@edf.fr

from ..Objects import Function, FunctionComplex
from .ExecuteCommand import ExecuteCommand


class ExtractFunction(ExecuteCommand):
    """Execute legacy operator RECU_FONCTION."""
    command_name = "RECU_FONCTION"

    def create_result(self, keywords):
        """Create the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if "RESULTAT" in keywords and keywords["RESULTAT"].getType() == "DYNA_HARMO":
            self._result = FunctionComplex()
            return
        if "RESU_GENE" in keywords and keywords["RESU_GENE"].getType() == "HARM_GENE":
            self._result = FunctionComplex()
            return
        if "INTE_SPEC" in keywords:
            if "NUME_ORDRE_J" in keywords and keywords["NUME_ORDRE_I"] != keywords["NUME_ORDRE_J"]:
                self._result = FunctionComplex()
                return
            if ("NOEUD_J" in keywords and keywords["NOEUD_I"] != keywords["NOEUD_J"]) or \
                    "NOM_CMP_J" in keywords and keywords["NOM_CMP_I"] != keywords["NOM_CMP_J"]:
                self._result = FunctionComplex()
                return
        if "TABLE" in keywords and (keywords.get("NOM_PARA_TABL") == "FONCTION_C" or keywords.get("PARA_Y") == "VALE_C"):
            self._result = FunctionComplex()
            return
        self._result = Function()

RECU_FONCTION = ExtractFunction.run
