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

# person_in_charge: nicolas.sellenet@edf.fr

from code_aster.RunManager.AsterFortran import python_execop
from ..Supervis import CommandSyntax
from code_aster import MatchingMeshes


def PROJ_CHAMP(**curDict):
    returnProj = None
    if not curDict.has_key("RESULTAT") and not curDict.has_key("CHAM_GD"):
        returnProj = MatchingMeshes.create()
    else:
        raise NameError("Not yet implemented")
    name = returnProj.getName()
    type = returnProj.getType()

    syntax = CommandSyntax("PROJ_CHAMP")
    syntax.setResult(name, type)
    syntax.define(curDict)

    numOp = 166
    python_execop(numOp)
    syntax.free()

    return returnProj
