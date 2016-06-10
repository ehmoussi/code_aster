# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

"""
This module defines the objects used in the description (old `.capy` files) of
legacy operators.
It mainly converts new objects to old ones for backward compatibility.
"""

import DataStructure as DS
from .SyntaxChecker import SyntaxCheckerVisitor
from .SyntaxObjects import (
    SimpleKeyword, FactorKeyword, Bloc,
    Operator, Macro, Procedure, Formule, Ops,
)
from .Rules import (
    AtLeastOne,
    ExactlyOne,
    AtMostOne,
    IfFirstAllPresent,
    OnlyFirstPresent,
    AllTogether,
)

import __builtin__
import types

def _F(**args):
    return args

__builtin__._F = _F

# TODO: replace by the i18n function (see old accas.capy)
def _(args):
    return args

__builtin__._ = _


# Les fonctions definies dans la paire d'accolade Ok ont été correctement traitées
# Les fonctions definies dans la paire d'accolade NOOK sont à revoir
# Ok {
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


def FORM(**kwargs):
    return Formule(kwargs)


def tr(kwargs):
    return kwargs


def OPS(kwargs):
    return kwargs


class EMPTY_OPS(object):
    pass


ops = Ops()


class PROC_ETAPE(Procedure):
    pass


# rules
AU_MOINS_UN = AtLeastOne
UN_PARMI = ExactlyOne
EXCLUS = AtMostOne
PRESENT_PRESENT = IfFirstAllPresent
PRESENT_ABSENT = OnlyFirstPresent
ENSEMBLE = AllTogether
# } Ok

# NOOK {
def AsType( obj ):
    """Return the type of `obj`"""
    return type(obj)

def CO():
    pass

class assd(DS.ASSD):
    pass

def NoRepeat():
    return

def LongStr(a, b):
    pass

def AndVal(*args):
    pass

def OrVal(*args):
    pass

def OrdList(args):
    pass

def Together(args):
    pass

def Absent(args):
    pass

def Compulsory(*args):
    pass
# } NOOK
