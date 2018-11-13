# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

"""
This module defines the objects used in the description (old `.capy` files) of
legacy operators.
It mainly converts new objects to old ones for backward compatibility.
"""

import __builtin__
import types

from . import DataStructure as DS
from . import ops
from .DataStructure import AsType
from .Rules import (AllTogether, AtLeastOne, AtMostOne, ExactlyOne,
                    IfFirstAllPresent, OnlyFirstPresent)
from .SyntaxChecker import SyntaxCheckerVisitor
from .SyntaxObjects import (_F, Bloc, CataError, FactorKeyword, Formule,
                            ListFact, Macro, Operator, Procedure,
                            SimpleKeyword)
from .Validators import (Absent, AndVal, Compulsory, LongStr, NoRepeat,
                         NotEqualTo, OrdList, OrVal, Together)

__builtin__._F = _F


def OPER(**kwargs):
    return Operator(kwargs)


def SIMP(**kwargs):
    return SimpleKeyword(kwargs)


def FACT(**kwargs):
    return FactorKeyword(kwargs)


def BLOC(**kwargs):
    return Bloc(kwargs)


def MACRO(**kwargs):
    return Macro(kwargs)


def PROC(**kwargs):
    return Procedure(kwargs)

FIN_PROC = PROC


def FORM(**kwargs):
    return Formule(kwargs)


def OPS(kwargs):
    return kwargs


class EMPTY_OPS(object):
    pass


assd = DS.ASSD


class PROC_ETAPE(Procedure):
    pass

# exception
AsException = CataError

# rules
AU_MOINS_UN = AtLeastOne
UN_PARMI = ExactlyOne
EXCLUS = AtMostOne
PRESENT_PRESENT = IfFirstAllPresent
PRESENT_ABSENT = OnlyFirstPresent
ENSEMBLE = AllTogether
