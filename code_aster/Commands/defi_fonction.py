# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

from Utilitai.Utmess import UTMESS

from ..Objects import Function, FunctionComplex
from ..Utilities import unsupported
from .ExecuteCommand import ExecuteCommand


class FunctionDefinition(ExecuteCommand):
    """Command that creates a :py:class:`~code_aster.Objects.Function`."""
    command_name = "DEFI_FONCTION"

    def create_result(self, keywords):
        """Initialize the result object.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.get("VALE_C"):
            self._result = FunctionComplex()
        else:
            self._result = Function()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        #TODO: Remove this fix
        if keywords.get("NOEUD_PARA") is not None:
            ExecuteCommand.exec_(self, keywords)
            return

        funct = self._result
        cmplx = False
        minx = 1
        miny = 1

        if keywords.get("ABSCISSE") is not None:
            abscissas = np.array(keywords["ABSCISSE"])
            ordinates = np.array(keywords["ORDONNEE"])

        elif keywords.get("VALE") is not None:
            values = np.array(keywords["VALE"])
            if values.size % 2 != 0:
                UTMESS("F", "UTILITAI2_67")
            values = values.reshape((values.size / 2, 2))
            abscissas = values[:, 0]
            ordinates = values[:, 1]

        elif keywords.get("VALE_C") is not None:
            cmplx = True
            values = np.array(keywords["VALE_C"])
            if values.size % 3 != 0:
                UTMESS("F", "UTILITAI2_66")
            values = values.reshape((values.size / 3, 3))
            abscissas = values[:, 0]
            ordinates = values[:, 1:].ravel()
            miny = min(values[:, 1])

        elif keywords.get("VALE_PARA") is not None:
            abscissas = keywords["VALE_PARA"].getValuesAsArray()
            ordinates = keywords["VALE_FONC"].getValuesAsArray()

        else:
            raise SyntaxError("No keyword defining the values!")

        minx = min(abscissas)
        if not cmplx:
            miny = min(ordinates)
        if abscissas.shape[0] * (1 + int(cmplx)) != ordinates.shape[0]:
            UTMESS("F", "UTILITAI2_77")
        diff = abscissas[1:] - abscissas[:-1]
        if keywords.get("VERIF") == "CROISSANT":
            if len(diff) > 0 and diff.min() <= 0:
                UTMESS("F", "FONCT0_44", valk=funct.getName())
        else:
            if not cmplx:
                stack = np.vstack([abscissas, ordinates])
                stack = stack[:, stack[0, :].argsort()]
                abscissas, ordinates = stack
            else:
                ordinates.shape = (abscissas.size, 2)
                stack = np.vstack([abscissas, ordinates.transpose()])
                stack = stack[:, stack[0, :].argsort()]
                abscissas = stack[0]
                ordinates = stack[1:].transpose().ravel()

        funct.setValues(abscissas, ordinates)

        funct.setParameterName(keywords["NOM_PARA"])
        nom_resu = keywords.get("NOM_RESU", "TOUTRESU")
        funct.setResultName(nom_resu)

        interpol = keywords.get("INTERPOL", ["LIN", "LIN"])
        if type(interpol) in (list, tuple):
            interpol = " ".join(interpol)
        if len(interpol.split()) == 1:
            interpol = interpol + " " + interpol
        if interpol[:3] == "LOG":
            if minx <= 0.:
                UTMESS("F", "UTILITAI2_71")
        if interpol[4:] == "LOG":
            if cmplx:
                UTMESS("F", "UTILITAI5_92")
            if miny <= 0.:
                UTMESS("F", "UTILITAI2_71")
        funct.setInterpolation(interpol)

        prol_gauche = keywords.get("PROL_GAUCHE", "E")
        prol_droite = keywords.get("PROL_DROITE", "E")
        funct.setExtrapolation(prol_gauche[0] + prol_droite[0])


DEFI_FONCTION = FunctionDefinition.run
