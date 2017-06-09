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

# person_in_charge: mathieu.courtois at edf.fr


import UserDict


class _F(UserDict.UserDict):

    """
        Cette classe a un comportement semblable à un
        dictionnaire Python et permet de donner
        la valeur d'un mot-clé facteur avec pour les sous
        mots-clés la syntaxe motcle=valeur
    """

    def __init__(self, *pos, **args):
        if len(pos) != 0:
            raise SyntaxError("Valeur invalide pour '_F('. "
                              "On attend cette syntaxe : _F(MOTCLE=valeur, ...)")
        self.data = args

    def supprime(self):
        self.data = {}

    def __cmp__(self, dict):
        if type(dict) == type(self.data):
            return cmp(self.data, dict)
        elif hasattr(dict, "data"):
            return cmp(self.data, dict.data)
        else:
            return cmp(self.data, dict)

    def __iter__(self):
        return iter(self.data)

    def copy(self):
        import copy
        c = copy.copy(self)
        c.data = self.data.copy()
        return c
