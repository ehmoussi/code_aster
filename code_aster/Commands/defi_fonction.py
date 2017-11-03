# coding: utf-8

# Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: mathieu.courtois@edf.fr

import numpy as np

from ..Objects import Function
from ..Utilities import unsupported
from .ExecuteCommand import ExecuteCommand


class FunctionDefinition(ExecuteCommand):
    """Command that creates a :py:class:`~code_aster.Objects.Function`."""
    command_name = "DEFI_FONCTION"

    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        unsupported(keywords, "", "VALE_C")
        unsupported(keywords, "", "NOEUD_PARA")

    def create_result(self, keywords):
        """Initialize the result object.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Function.create()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if keywords.get("ABSCISSE") is not None:
            absc = np.array(keywords["ABSCISSE"])
            ordo = np.array(keywords["ORDONNEE"])
        elif keywords.get("VALE") is not None:
            values = np.array(keywords["VALE"])
            values = values.reshape((values.size / 2, 2))
            absc = values[:, 0]
            ordo = values[:, 1]
        elif keywords.get("VALE_PARA") is not None:
            absc = keywords["VALE_PARA"].getValues()
            ordo = keywords["VALE_FONC"].getValues()
        else:
            raise SyntaxError("No keyword defining the values!")

        nom_resu = keywords.get("NOM_RESU", "TOUTRESU")
        interpol = keywords.get("INTERPOL", ["LIN", "LIN"])
        if type(interpol) in (list, tuple):
            interpol = " ".join(interpol)
        if len(interpol.split()) == 1:
            interpol = interpol + " " + interpol
        prol_gauche = keywords.get("PROL_GAUCHE", "E")
        prol_droite = keywords.get("PROL_DROITE", "E")

        self._result.setParameterName(keywords["NOM_PARA"])
        self._result.setResultName(nom_resu)
        self._result.setInterpolation(interpol)
        self._result.setExtrapolation(prol_gauche[0] + prol_droite[0])
        self._result.setValues(absc, ordo)


DEFI_FONCTION = FunctionDefinition.run
