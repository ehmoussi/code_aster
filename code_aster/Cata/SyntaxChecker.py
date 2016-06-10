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

import DataStructure as DS

import numpy


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

def checkMandatory(dictDefinition, dictSyntax):
    """Check that mandatory keywords are present in the given syntax"""
    for key, value in dictDefinition.iteritems():
        try:
            required = value.isMandatory()
            if required and not dictSyntax.has_key(key):
                _debug( "keyword =", key, ":", value )
                _debug( "syntax =", dictSyntax )
                raise KeyError("Keyword {} is mandatory".format(key))
        except AttributeError:
            pass

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

    def visitCommand(self, step, syntax=None):
        """Visit a Command object"""
        self._visitComposite(step, syntax)

    def visitBloc(self, step, syntax=None):
        """Visit a Bloc object"""
        pass

    def visitFactorKeyword(self, step, syntax=None):
        """Visit a FactorKeyword object"""
        self._visitComposite(step, syntax)

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

    def _visitComposite(self, step, syntax):
        """Visit a composite object (containing BLOC, FACT and SIMP objects)
        Check that :
            - the number of occurences is as expected
            - the rules are validated
            - the mandatory simple keywords are present
        One walks the Bloc objects to add the keywords according to the
        conditions.
        """
        if type(syntax) == dict:
            syntax = [syntax]
        elif type(syntax) in (list, tuple):
            pass
        else:
            raise TypeError("Type 'dict' or 'tuple' is expected")

        # Vérification du nombre de mots-clés facteurs
        if len(syntax) < step.definition.get('min', 0):
            raise ValueError("Too few factor keyword")
        if len(syntax) > step.definition.get('max', 1000000000):
            raise ValueError("Too much factor keyword")

        # Boucle sur toutes les occurences du mot-clé facteur
        for dictSyntax in syntax:
            # Vérification des règles de ce mot-clé
            if step.regles != None:
                for rule in step.regles:
                    rule.check(dictSyntax)

            # On vérifie que les mots-clés simples qui doivent être présents le
            # sont
            checkMandatory(step.definition, dictSyntax)
            # Pour les blocs aussi
            dictTmp = step.inspectBlocs(dictSyntax)
            checkMandatory(dictTmp, dictSyntax)

            # On boucle sur la syntax de l'utilisateur vérifier les mots-clés
            # simples
            for key, value in dictSyntax.iteritems():
                # print key, value
                if key == "reuse":
                    if step.definition.get("reentrant") not in ("o", "f"):
                        raise KeyError("reuse is not allowed!")
                elif not step.definition.has_key(key) and not dictTmp.has_key(key):
                    raise KeyError("Unauthorized keyword: {!r}".format(key))
                else:
                    kw = step.definition.get(key)
                    if kw:
                        kw.accept(self, value)
                    kw = dictTmp.get(key)
                    if kw:
                        kw.accept(self, value)
