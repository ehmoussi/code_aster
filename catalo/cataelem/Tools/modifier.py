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

#
# person_in_charge: mathieu.courtois at edf.fr

"""
This module provides helper objects to easily apply changes between elements
"""

class CataElemVisitor(object):

    """This class walks the tree of CataElem object.
    """

    def __init__(self):
        """Initialization."""

    def visitCataElem(self, cataelem):
        """Visit a CataElem object"""

    def visitPhenomenon(self, phenomenon):
        """Visit a Phenomenon object"""

    def visitModelisation(self, modelisation):
        """Visit a Modelisation object"""

    def visitElement(self, element):
        """Visit a Element object"""
        for _dummy, calc in element.getCalculs():
            calc.accept(self)

    def visitCalcul(self, calcul):
        """Visit a Calcul object"""
        calcul.option.accept(self)
        for param, locCmp in calcul.para_in + calcul.para_out:
            param.accept(self)
            locCmp.accept(self)

    def visitOption(self, option):
        """Visit a Option object"""
        for para in option.para_in + option.para_out:
            para.accept(self)

    def visitArrayOfComponents(self, array):
        """Visit a ArrayOfComponents object"""
        locCmp.locatedComponents.accept(self)

    def visitLocatedComponents(self, locCmp):
        """Visit a LocatedComponents object"""
        locCmp.physicalQuantity.accept(self)

    def visitInputParameter(self, param):
        """Visit a InputParameter object"""
        param.physicalQuantity.accept(self)

    def visitOutputParameter(self, param):
        """Visit a OutputParameter object"""
        param.physicalQuantity.accept(self)

    def visitArrayOfQuantities(self, array):
        """Visit a ArrayOfQuantities object"""
        array.physicalQuantity.accept(self)

    def visitPhysicalQuantity(self, phys):
        """Visit a PhysicalQuantity object"""


class ChangeComponentsVisitor(CataElemVisitor):

    """A visitor that can change the components of a LocatedComponents used in
    an element. A new LocatedComponents object is created and replaces the
    existing one.
    This visitor uses the returned value."""
    # starts at the Element level

    def __init__(self, locCmpName, components):
        """Initialization with the name of the LocatedComponents to change and
        the new list of components"""
        self._locCmpName = locCmpName
        self._newCmp = components
        self._newObjects = {}

    def visitCalcul(self, calcul):
        """Visit a Calcul object"""
        para = []
        for param, locCmp in calcul.para_in:
            new = locCmp.accept(self)
            para.append( (param, new) )
        calcul.setParaIn(para)
        para = []
        for param, locCmp in calcul.para_out:
            new = locCmp.accept(self)
            para.append( (param, new) )
        calcul.setParaOut(para)

    def visitArrayOfComponents(self, array):
        """Visit an ArrayOfComponents object"""
        # already created?
        created = self._newObjects.get(array.name)
        if created:
            array = created
        else:
            locCmp = array.locatedComponents
            new = locCmp.accept(self)
            if new != locCmp:
                array = array.copy(new)
                self._newObjects[array.name] = array
        return array

    def visitLocatedComponents(self, locCmp):
        """Visit a LocatedComponents object"""
        if locCmp.name == self._locCmpName:
            # already created?
            created = self._newObjects.get(locCmp.name)
            if created:
                locCmp = created
            else:
                locCmp = locCmp.copy(self._newCmp)
                self._newObjects[locCmp.name] = locCmp
        return locCmp
