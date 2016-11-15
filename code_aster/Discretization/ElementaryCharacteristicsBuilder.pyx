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

from libcpp.string cimport string
from cython.operator cimport dereference as deref
from code_aster cimport libaster
from code_aster.libaster cimport INTEGER

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax
from code_aster.Discretization.ElementaryCharacteristics cimport ElementaryCharacteristics


def AFFE_CARA_ELEM(**curDict):
    for key, value in curDict.iteritems():
        print key, value
        print type(value)
    returnCaraElem = ElementaryCharacteristics()
    cdef string name = returnCaraElem.getInstance().getName()
    syntax = CommandSyntax("AFFE_CARA_ELEM")

    # self.getInstance().getType()
    syntax.setResult(name, "MAILLAGE")

    syntax.define(curDict)
    cdef INTEGER numOp = 19
    libaster.execop_(&numOp)
    syntax.free()
    return returnCaraElem
