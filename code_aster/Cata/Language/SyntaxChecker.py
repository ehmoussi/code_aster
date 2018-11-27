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
This module allows to check the syntax of a user command file that used the
syntax of legacy operators.
The check is performed at execution of an operator. So, the user file can mix
legacy operators and pure Python instructions.
"""

import numpy

import DataStructure as DS
from .SyntaxUtils import (debug_message2, force_list, mixedcopy, old_complex,
                          remove_none, value_is_sequence)

class CheckerError(Exception):
    """Exception raised during checking the syntax.

    Args:
        orig (Exception): Type of exception (TypeError, KeyError, ValueError).
        msg (str): Message of the error.
        stack (str): Checking stack: [*factor keyword*, *simple keyword*].

    Attributes:
        _msg (str): Message of the error.
        _orig (Exception): Type of exception.
        _stack (str): Checking stack as string.
    """

    def __init__(self, orig, msg, stack):
        super(CheckerError, self).__init__(msg)
        self._orig = orig
        self._msg = msg
        self._stack = "/".join(force_list(stack))

    @property
    def original(self):
        """Return the original exception."""
        return self._orig

    @property
    def msg(self):
        """Property that holds the main message."""
        if not self._stack:
            return self._msg
        return "For keyword {0._stack}: {0._msg}".format(self)


def fromTypeName(typename):
    """Convert a typename to a list of valid Python types (or an empty list)
    Example: 'I' returns [int, ...]"""
    if not hasattr(fromTypeName, "convTypes"):
        convTypes = {
            'TXM' : [str, unicode],
            'I' : [int, numpy.int, numpy.int32, numpy.int64],
        }
        convTypes['R'] = [float, numpy.float, numpy.float32, numpy.float64] \
                       + convTypes['I']
        convTypes['C'] = [complex, numpy.complex, numpy.complex64,
                          numpy.complex128] + convTypes['R']
        # exceptions
        convTypes[DS.MeshEntity] = convTypes['TXM']
        for deprec in ('Fichier', '', 'Sauvegarde'):
            convTypes[deprec] = convTypes['TXM']
        # When these objects will be removed...
        # convTypes[DS.listr8_sdaster] = convTypes['R']
        # convTypes[DS.listis_sdaster] = convTypes['I']
        fromTypeName.convTypes = convTypes
    return fromTypeName.convTypes.get(typename, [])


def _gettype(obj):
    """Return the type of an object"""
    # AsterStudy: for Command, use gettype()
    if hasattr(obj, "gettype"):
        return obj.gettype()
    return type(obj)


def isValidType(obj, expected):
    """Check that `obj` has one of the `expected` type"""
    # None means undefined and should have been treated before
    if obj is None:
        return False

    if DS.not_checked in expected:
        return True

    # AsterStudy: for PythonVariable
    if isinstance(obj, DS.PythonVariable):
        # can not be checked now, it will be when it will become a Variable
        return True

    typobj = _gettype(obj)
    debug_message2("checking type:", obj, type(obj), typobj, expected)
    # if a Variable is not yet evaluated, gettype returns None
    if typobj is type(None):
        return True
    if typobj in expected or obj in expected:
        return True
    try:
        if issubclass(typobj, tuple(expected)):
            return True
    except TypeError:
        pass

    # accept str for MeshEntity
    if issubclass(expected[0], (DS.MeshEntity, DS.GEOM)):
        if isinstance(obj, basestring):
            assert len(expected) == 1, 'several types for MeshEntity ?!'
            return True
    # accept all DataStructures for CO
    if DS.CO in expected and issubclass(typobj, DS.DataStructure):
        return True
    try:
        typname = obj.getType()
        expectname = []
        for i in expected:
            if not issubclass(i, DS.DataStructure):
                continue
            expectname.extend(i.getSubtypes())
        debug_message2(obj, typname, 'expecting:', expectname)
        return typname in expectname
    except AttributeError:
        pass
    return False


class SyntaxCheckerVisitor(object):

    """This class walks along the tree of a Command object to check its syntax

    Attributes:
        _stack (list): Stack of checked objects for error report.
        _parent_context (dict): Context of the parent used to evaluate block
            conditions.
        _in_place (bool): If *True* the keywords dict is changed in place.
        _default_command (bool): Marker not to add default keywords several
            times (for performance).
    """

    def __init__(self, in_place=False):
        """Initialization"""
        self._stack = []
        self._parent_context = []
        self._in_place = in_place
        self._default_command = False

    @property
    def stack(self):
        return self._stack

    def error(self, orig, msg):
        """Raise a *CheckerError* exception."""
        raise CheckerError(orig, msg, self._stack)

    def set_parent_context(self, context):
        """Set the parent context.

        If the checker is directly called on a keyword (without checking the
        command itself) the values defined upper may be required to evaluate
        blocks conditions but the parent context has not been filled.

        This parent context could be an optional argument in visit* functions.
        """
        self._parent_context.append(context)

    def visitCommand(self, step, userDict=None):
        """Visit a Command object"""
        # do not check these fake commands
        if step.name in ("_CONVERT_VARIABLE", "_CONVERT_COMMENT",
                         "_RESULT_OF_MACRO"):
            return
        if self._in_place:
            keywords = userDict
        else:
            keywords = mixedcopy(userDict)
        # mark that default keywords have already added at command level
        self._default_command = True
        step.addDefaultKeywords(keywords)
        debug_message2("checking syntax of", step.name, "with", keywords)
        self._parent_context.append(keywords)
        self._visitComposite(step, keywords)
        self._parent_context.pop()
        try:
            step.get_type_sd_prod(**keywords)
        except Exception as exc:
            self.error(TypeError,
                       ("Cannot type result of the command {0}\n"
                        "Exception raised: {1})").format(step.name, repr(exc)))

    def visitBloc(self, step, userDict=None):
        """Visit a Bloc object"""
        pass

    def visitFactorKeyword(self, step, userDict=None):
        """Visit a FactorKeyword object"""
        # debug_message2("checking factor with", userDict)
        self._visitComposite(step, userDict)

    def visitSimpleKeyword(self, step, skwValue):
        """Visit a SimpleKeyword object
        Checks that :
            - the type is well known,
            - the values are in `into`,
            - the values are in [val_min, val_max],
            - the number of values is in [min, max]
        """
        if step.undefined(skwValue):
            # the keyword does not exist and it should have been checked by
            # its parent
            return
        # Liste les types possibles
        currentType = step.definition["typ"]
        currentType = force_list(currentType)
        validType = []
        specificTypes = (DS.DataStructure, DS.MeshEntity, DS.ValueCheckMixing)
        for i in currentType:
            pytypes = fromTypeName(i)
            if not pytypes and issubclass(i, specificTypes):
                pytypes = [i]
            validType.extend(pytypes)
        if not validType:
            self.error(TypeError, "Unsupported type: {0!r}".format(currentType))

        # old complex notation
        if complex in validType:
            skwValue = old_complex(skwValue)

        # Vérification des valeurs max et min
        valMin = step.definition.get('val_min')
        valMax = step.definition.get('val_max')

        if value_is_sequence(skwValue):
            # Vérification du nombre de valeurs
            nbMin = step.definition.get('min')
            nbMax = step.definition.get('max')
            if nbMax == "**":
                nbMax = None
            if nbMax != None and len(skwValue) > nbMax:
                debug_message2(step)
                self.error(ValueError,
                           'At most {0} values are expected'.format(nbMax))
            if nbMin != None and len(skwValue) < nbMin:
                debug_message2(step)
                self.error(ValueError,
                           'At least {0} values are expected'.format(nbMin))
        else:
            skwValue = [skwValue]

        # Vérification du type et des bornes des valeurs
        for i in skwValue:
            if complex in validType:
                i = old_complex(i)
            # AsterStudy: for PythonVariable
            if isinstance(i, DS.PythonVariable):
                # can not be checked now, it will be when it will become a Variable
                continue
            if hasattr(i, "evaluation"):
                i = i.evaluation
                # if a Variable is not yet evaluated
                if i is None:
                    continue
                # for lists and tuples, take the first element
                if type(i) in (list, tuple) and i:
                    i = i[0]

            # Let expected types check for themselves
            for typeobj in validType:
                if issubclass(typeobj, DS.ValueCheckMixing):
                    if not typeobj.checkValue(i):
                        self.error(ValueError, "Unexpected value: %s" % i)

                    if step.definition.has_key("into"):
                        into = step.definition["into"]
                        if not typeobj.checkInto(i, into):
                            self.error(ValueError, "Unexpected value: %s" % i)

                    if valMax != None:
                        if not typeobj.checkMax(i, valMax):
                            self.error(ValueError, "Unexpected value: %s" % i)

                    if valMin != None:
                        if not typeobj.checkMin(i, valMin):
                            self.error(ValueError, "Unexpected value: %s" % i)

                    return
            # type
            if not isValidType(i, validType):
                step._context(i)
                self.error(TypeError,
                           'Unexpected type: {0}, expecting: {1}'
                           .format(type(i), validType))
            # into
            if step.definition.has_key("into"):
                if i not in step.definition["into"]:
                    self.error(ValueError,
                               "Unexpected value: {0!r}, must be in {1!r}"
                                   .format(i, step.definition["into"]))
            # val_min/val_max
            if valMax != None and i > valMax:
                self.error(ValueError,
                           'Value must be smaller than {0}, {1} is not'
                               .format(valMax, i))
            if valMin != None and i < valMin:
                self.error(ValueError,
                           'Value must be bigger than {0}, {1} is not'
                               .format(valMin, i))

        # call validators
        for valid in force_list(step.definition.get('validators', [])):
            valid.check(skwValue)

    def _visitComposite(self, step, userDict):
        """Visit a composite object (containing BLOC, FACT and SIMP objects)
        Check that :
            - the number of occurences is as expected
            - the rules are validated
            - the mandatory simple keywords are present
        One walks the Bloc objects to add the keywords according to the
        conditions.
        """
        # debug_message2("checking composite with", userDict)
        if step.undefined(userDict):
            # the keyword does not exist and it should have been checked by
            # its parent
            return
        if isinstance(userDict, dict):
            userDict = [userDict]
        elif isinstance(userDict, (list, tuple)):
            pass
        else:
            self.error(TypeError, "Type 'dict' or 'tuple' is expected")

        # check the number of occurrences
        if len(userDict) < step.definition.get('min', 0):
            self.error(ValueError,
                       "Too few factor keyword, at least {0} "
                       "occurrence(s) expected"
                           .format(step.definition.get('min', 0)))
        if len(userDict) > step.definition.get('max', 1000000000):
            self.error(ValueError,
                       "Too much factor keyword, at most {0} "
                       "occurrence(s) expected"
                           .format(step.definition.get('max', 0)))

        # loop on occurrences filled by the user
        for userOcc in userDict:
            ctxt = self._parent_context[-1] if self._parent_context else {}
            if not self._default_command:
                userOcc = mixedcopy(userOcc)
                step.addDefaultKeywords(userOcc, ctxt)
            # check rules
            for rule in step.getRules(userOcc, ctxt):
                self._stack.append(rule)
                rule.check(userOcc)
                self._stack.pop()
            # check that the required keywords are provided by the user
            step.checkMandatory(userOcc, self._stack, ctxt)
            # loop on keywords provided by the user
            for key, value in userOcc.iteritems():
                # print key, value
                if key == "reuse":
                    reentr = step.definition.get("reentrant", "").split(':')
                    if reentr and reentr[0] not in ("o", "f"):
                        self._stack.append(key)
                        self.error(KeyError, "reuse is not allowed!")
                    continue
                kwd = step.getKeyword(key, userOcc, ctxt)
                if kwd is None:
                    debug_message2("keyword:", key, "user dict:", userOcc,
                                   "parent context:", ctxt)
                    self._stack.append(key)
                    self.error(KeyError,
                               "Unauthorized keyword: {!r}".format(key))
                else:
                    nmax = kwd.definition.get('max', 1)
                    if nmax == 1:
                        if (value_is_sequence(value) and len(value) == 1
                                and not isinstance(value[0], dict)):
                            value = userOcc[key] = value[0]
                    else:
                        if value is not None and not value_is_sequence(value):
                            value = userOcc[key] = [value]
                    self._stack.append(key)
                    kwd.accept(self, value)
                    self._stack.pop()


def checkCommandSyntax(command, keywords, in_place=True):
    """Check the syntax of a command `keywords` contains the keywords filled by
    the user.

    Arguments:
        command (Command): Command object to be checked.
        keywords (dict): Dict of the user keywords.
        in_place (bool): If *True* the default keywords are added in the user
            dict. *None* values are removed from the user dict.
    """
    checker = SyntaxCheckerVisitor(in_place)
    if not isinstance(keywords, dict):
        checker.error(TypeError, "'dict' object is expected")

    command.accept(checker, keywords)
    if in_place:
        command.addDefaultKeywords(keywords)
        remove_none(keywords)
