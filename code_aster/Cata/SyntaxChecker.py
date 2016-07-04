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
This module allows to check the syntax of a user command file that used the
syntax of legacy operators.
The check is performed at execution of an operator. So, the user file can mix
legacy operators and pure Python instructions.
"""

import numpy

import DataStructure as DS


def _debug( *args ):
    """Debug print"""
    # from pprint import pprint
    # print "DEBUG:",
    # pprint( args )

def fromTypeName( typename ):
    """Convert a typename to a list of valid Python types (or an empty list)
    Example: 'I' returns [int, ...]"""
    convTypes = {
        'TXM' : [str, unicode],
        'I' : [int, numpy.int, numpy.int32, numpy.int64],
    }
    convTypes['R'] = [float, numpy.float, numpy.float32, numpy.float64] \
                   + convTypes['I']
    # exceptions
    convTypes[DS.MeshEntity] = convTypes['TXM']
    convTypes[DS.listr8_sdaster] = convTypes['R']
    # TODO: can not enable that before they are becoming different objects!
    # convTypes[DS.listis_sdaster] = convTypes['I']
    return convTypes.get(typename, [])


def isValidType(obj, expected):
    """Check that `obj` has one of the `expected` type"""
    if type(obj) in expected:
        return True
    # accept str for MeshEntity
    if type(obj) is str and issubclass(expected[0], DS.MeshEntity):
        assert len(expected) == 1, 'several types for MeshEntity ?!'
        return True
    try:
        typname = obj.getType()
        expectname = [i.getType() for i in expected if issubclass(i, DS.DataStructure)]
        _debug( obj, typname, 'expecting:', expectname)
        return typname in expectname
    except AttributeError:
        pass
    return False


class SyntaxCheckerVisitor(object):

    """This class walks along the tree of a Command object to check its syntax"""

    def __init__(self):
        """Initialization"""

    def visitCommand(self, step, userDict=None):
        """Visit a Command object"""
        self._visitComposite(step, userDict)

    def visitBloc(self, step, userDict=None):
        """Visit a Bloc object"""
        pass

    def visitFactorKeyword(self, step, userDict=None):
        """Visit a FactorKeyword object"""
        self._visitComposite(step, userDict)

    def visitSimpleKeyword(self, step, skwValue):
        """Visit a SimpleKeyword object
        Checks that :
            - the type is well known,
            - the values are in `into`,
            - the values are in [val_min, val_max],
            - the number of values is in [min, max]
        """
        # Liste les types possibles
        currentType = step.definition["typ"]
        if type(currentType) not in (list, tuple):
            currentType = [currentType]
        validType = []
        for i in currentType:
            pytypes = fromTypeName(i)
            if not pytypes and issubclass(i, (DS.DataStructure, DS.MeshEntity)):
                pytypes = [i]
            validType.extend( pytypes )
        if not validType:
            raise TypeError( "Unsupported type: {!r}".format(currentType) )

        # Vérification des valeurs max et min
        valMin = step.definition.get('val_min')
        valMax = step.definition.get('val_max')

        if type(skwValue) in (list, tuple, numpy.ndarray):
            # Vérification du nombre de valeurs
            nbMin = step.definition.get('min')
            nbMax = step.definition.get('max')
            if nbMax == "**":
                nbMax = None
            if nbMax != None and len(skwValue) > nbMax:
                _debug( step )
                raise ValueError('At most {} values are expected'.format(nbMax))
            if nbMin != None and len(skwValue) < nbMin:
                _debug( step )
                raise ValueError('At least {} values are expected'.format(nbMin))
        else:
            skwValue = [skwValue]

        # Vérification du type et des bornes des valeurs
        for i in skwValue:
            # into
            if step.definition.has_key("into"):
                if i not in step.definition["into"]:
                    raise ValueError( "Value must be in {!r}".format(
                                      step.definition["into"]) )
            # type
            if not isValidType(i, validType):
                step._context(i)
                raise TypeError('Unexpected type {}'.format(type(i)))
            # val_min/val_max
            if valMax != None and i > valMax:
                raise ValueError('Value must be smaller than {}'.format(valMax))
            if valMin != None and i < valMin:
                raise ValueError('Value must be bigger than {}'.format(valMin))

    def _visitComposite(self, step, userDict):
        """Visit a composite object (containing BLOC, FACT and SIMP objects)
        Check that :
            - the number of occurences is as expected
            - the rules are validated
            - the mandatory simple keywords are present
        One walks the Bloc objects to add the keywords according to the
        conditions.
        """
        if type(userDict) == dict:
            userDict = [userDict]
        elif type(userDict) in (list, tuple):
            pass
        else:
            raise TypeError("Type 'dict' or 'tuple' is expected")

        # check the number of occurrences
        if len(userDict) < step.definition.get('min', 0):
            raise ValueError("Too few factor keyword")
        if len(userDict) > step.definition.get('max', 1000000000):
            raise ValueError("Too much factor keyword")

        # loop on occurrences filled by the user
        for userOcc in userDict:
            # check rules
            if step.regles != None:
                for rule in step.regles:
                    rule.check(userOcc)
            # check that the required keywords are provided by the user
            step.checkMandatory(userOcc)
            # loop on keywords provided by the user
            for key, value in userOcc.iteritems():
                # print key, value
                if key == "reuse":
                    if step.definition.get("reentrant") not in ("o", "f"):
                        raise KeyError("reuse is not allowed!")
                kwd = step.getKeyword(key, userOcc)
                if kwd is None:
                    raise KeyError("Unauthorized keyword: {!r}".format(key))
                else:
                    kwd.accept(self, value)


# counter of 'printed' command
_cmd_counter = 0

def checkCommandSyntax(command, keywords, printSyntax=True):
    """Check the syntax of a command
    `keywords` contains the keywords filled by the user"""
    global _cmd_counter
    from pprint import pformat
    if type(keywords) != dict:
        raise TypeError("'dict' object is expected")
    command.addDefaultKeywords(keywords)
    if printSyntax:
        _cmd_counter += 1
        print("\n{0:-^100}\n Command #{1:0>4}\n{0:-^100}".format("", _cmd_counter))
        print(" {0}({1})".format(
            command.definition.get("nom", "COMMAND"), pformat(keywords)))

    checker = SyntaxCheckerVisitor()
    command.accept( checker, keywords )
