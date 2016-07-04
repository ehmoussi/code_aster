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

# person_in_charge: nicolas.sellenet@edf.fr

import types

from code_aster import Materials
from code_aster.Cata import Commands
from code_aster.Cata.SyntaxChecker import checkCommandSyntax
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary
from code_aster.Materials import MaterialBehaviour


def _byKeyword():
    """Build the list of all objects of the given type"""
    objects = {}
    for name in dir(MaterialBehaviour):
        obj = getattr(MaterialBehaviour, name)
        if name == "GeneralMaterialBehaviour" or type(obj) is not type:
            continue
        if issubclass(obj, MaterialBehaviour.GeneralMaterialBehaviour):
            keyword = obj().getAsterName()
            objects[keyword] = obj
    return objects


def DEFI_MATERIAU( **kwargs ):
    """Opérateur de définition d'un matériau"""
    checkCommandSyntax( Commands.DEFI_MATERIAU, kwargs )

    classByName = _byKeyword()
    mater = Materials.Material()
    for fkwName, fkw in kwargs.iteritems():
        # only see factor keyword
        if type( fkw ) is not dict:
            continue
        klass = classByName.get(fkwName)
        if not klass:
            raise NotImplementedError("Unsupported behaviour: '{0}'".format(fkwName))
        matBehav = klass()
        for skwName, skw in fkw.iteritems():
            if type( skw ) is float:
                iName = skwName.capitalize()
                cRet = matBehav.setDoubleValue( iName, skw )
                if not cRet:
                    print ValueError("Can not assign keyword '{1}'/'{0}' (as '{3}'/'{2}') "
                                     .format(skwName, fkwName, iName, klass.__name__))
            else:
                raise NotImplementedError("Unsupported type for keyword: {0} <{1}>"
                                          .format(skwName, type(skw)))
        mater.addMaterialBehaviour( matBehav )

    mater.build()

    return mater
