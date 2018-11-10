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
:py:mod:`CommandSyntax` --- Interface between C++/Fortran operators and user syntax
***********************************************************************************

The :py:class:`CommandSyntax` provides an interface between operators originally
defined in Fortran (:file:`opXXXX` subroutines) and the user syntax.
The C/Fortran interface is defined in :file:`aster_module.c`.

It is also used in some C++ objects to emulate a user command.
The C++ interface is available from C++ ``CommandSyntax`` class.

The method :py:meth:`~CommandSyntax.define` stores the user keywords.
The execution of an operator (by :py:func:`libaster.call_oper` for example) registers
the current :py:class:`CommandSyntax` instance that can be requested by the
operator using the functions:

    - :py:meth:`~CommandSyntax.getres`,

    - :py:meth:`~CommandSyntax.getvtx`,

    - :py:meth:`~CommandSyntax.getltx`,

    - :py:meth:`~CommandSyntax.getvid`,

    - :py:meth:`~CommandSyntax.getvis`,

    - :py:meth:`~CommandSyntax.getvr8`,

    - :py:meth:`~CommandSyntax.getvc8`,

    - :py:meth:`~CommandSyntax.getfac`,

    - :py:meth:`~CommandSyntax.getexm`,

    - :py:meth:`~CommandSyntax.getmjm`.

"""

import random

from ..Objects import DataStructure
from ..Utilities import (force_list, is_complex, is_float, is_int, is_str,
                         value_is_sequence)
from .typeaster import typeaster
from .logger import logger


class CommandSyntax(object):
    """This class describes the syntax of command for compatibility
    with the fortran code that use the legacy supervisor.
    """

    _currentCommand = _random = None

    @classmethod
    def setCurrentCommand(cls, command):
        """Register current command.

        Arguments:
            command (*CommandSyntax*): *CommandSyntax* to register.
        """
        # The object is registered with `register_sh_etape()` by `aster_oper`
        # if called from Python or by the constructor of `CommandSyntax` if
        # called from C++.
        cls._currentCommand = command

    @classmethod
    def getCurrentCommand(cls):
        """Return the current command.

        Returns:
            *CommandSyntax*: Current registered *CommandSyntax*.
        """
        return cls._currentCommand


    def __init__(self, name="unNamed", cata=None):
        """Create a new command"""
        self._name = name
        self._resultName = " "
        self._resultType = " "
        self._definition = None
        logger.debug( "new command is %r", self._name )
        currentCommand = self.getCurrentCommand()
        # only FIN is allowed to free the current "in failure" command
        if self._name == "FIN" and currentCommand is not None:
            currentCommand.free()
            currentCommand = self.getCurrentCommand()
        assert currentCommand is None, \
            "CommandSyntax {} must be freed".format( currentCommand.getName() )
        self.setCurrentCommand(self)
        # TODO: remove cata argument (not easy to fill in C++)
        if not cata:
            from ..Cata import Commands
            cata = getattr(Commands, name, None)
            if not cata:
                logger.debug("CommandSyntax: catalog not found for {0!r}"
                             .format(name))
        self._commandCata = cata

    def free( self ):
        """Reset the current command pointer as soon as possible"""
        # `currentCommand` must be reset before the garbage collector will do it
        logger.debug( "del command %r", self._name )
        self.setCurrentCommand(None)

    def __repr__( self ):
        """Representation of the command"""
        return ("Command {!r}, returns {!r} <{!r}>\n` syntax: {}"
            .format(self._name, self._resultName, self._resultType,
                    self._definition))

    def debugPrint( self ):
        """Representation of the command"""
        logger.debug( repr(self) )

    def setResult( self, sdName, sdType ):
        """Register the result of the command: name and type.

        Arguments:
            sdName (str): Name of the result created by the Command.
            sdType (str): Type of the result created by the Command.
        """
        self._resultName = sdName
        self._resultType = sdType

    def define( self, dictSyntax ):
        """Register the keywords values.

        Arguments:
            dictSyntax (dict): User keywords.
        """
        if self._commandCata != None:
            logger.debug( "define0 %r: %r", self._name, dictSyntax )
            self._commandCata.addDefaultKeywords( dictSyntax )
        self._definition = dictSyntax
        logger.debug( "define1 %r: %r", self._name, self._definition )

    def getName( self ):
        """Return the command name.

        Returns:
            str: Command name.
        """
        return self._name

    def getResultName( self ):
        """Return the name of the result of the Command.

        Returns:
            str: Name of the result of the Command.
        """
        return self._resultName

    def getResultType( self ):
        """Return the type of the result of the command.

        Returns:
            str: Type name of the result of the Command.
        """
        return self._resultType

    def _getFactorKeyword( self, factName ):
        """Return the occurrences of a factor keyword.

        Arguments:
            factName (str): Name of the factor keyword.

        Returns:
            list: List of occurences of a factor keyword, *None* if it is not
                provided by the user.
        """
        # a factor keyword may be empty: {} (None means 'does not exist')
        dictDef = self._definition.get( factName, None )
        logger.debug( "factor keyword %r: %r", factName, dictDef )
        if dictDef is None:
            return None
        if isinstance(dictDef, dict):
            dictDef = [dictDef, ]
        return dictDef

    def _getFactorKeywordOccurrence( self, factName, occurrence ):
        """Return the definition of an occurrence of a factor keyword.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).

        Returns:
            dict: Occurrence of a factor keyword, *None* if it is not
                provided by the user."""
        dictDef = self._getFactorKeyword( factName )
        if dictDef is None:
            return None
        try:
            return dictDef[occurrence]
        except:
            return None

    def _getDefinition( self, factName, occurrence ):
        """Return the definition of a factor keyword or of the top-level
        if `factName` is blank.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).

        Returns:
            dict: User keywords under a factor keyword or the Command.
        """
        if not factName.strip():
            dictDef = self._definition
        else:
            dictDef = self._getFactorKeywordOccurrence( factName, occurrence )
            if not dictDef:
                dictDef = {}
        assert isinstance(dictDef, dict), "syntax not defined"
        return dictDef

    def _getCataDefinition( self, factName ):
        """Return the definition of a factor keyword in the catalog or of the
        top-level if `factName` is blank.

        Arguments:
            factName (str): Name of the factor keyword.

        Returns:
            *CataDefinition*: Definition of the factor keyword or the Command.
        """
        if not self._commandCata:
            logger.debug("CommandSyntax: catalog is not available")
            return None
        factName = factName.strip()
        catadef = self._commandCata.definition
        if not factName:
            return catadef
        keywords = catadef.factor_keywords.get(factName)
        if not keywords:
            return None
        return keywords.definition

    def getFactorKeywordNbOcc( self, factName ):
        """Return the number of occurrences of a factor keyword in the
        user's keywords.

        Arguments:
            factName (str): Name of the factor keyword.

        Returns:
            int: Number of occurrences of a factor keyword.
        """
        dictDef = self._getFactorKeyword( factName )
        logger.debug( "_getFactorKeyword %r: %r", factName, dictDef )
        if dictDef is None:
            return 0
        logger.debug( "getFactorKeywordNbOcc: len(dictDef) = %d", len(dictDef) )
        return len(dictDef)

    getfac = getFactorKeywordNbOcc

    def existsFactorAndSimpleKeyword( self, factName, occurrence,
                                      simpName ):
        """Tell if the couple ( factor keyword, simple keyword ) exists in the
        user keywords.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.

        Returns:
            int: 1 if the keyword exists, else 0.
        """
        dictDef = self._getDefinition( factName, occurrence )
        value = dictDef.get( simpName, None )
        if value is None or isinstance(value, dict):
            return 0
        return 1

    def getValue( self, factName, occurrence, simpName ):
        """Return the values of a (simple) keyword.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.

        Returns:
            list[misc]: List of the values provided by the user.
        """
        if not self.existsFactorAndSimpleKeyword( factName, occurrence, simpName ):
            return []
        value = self._getDefinition( factName, occurrence )[simpName]
        value = force_list(value)
        logger.debug( "getValue: %r", value )
        return value

    def getltx(self, factName, simpName, occurrence, maxval, lenmax):
        """Wrapper function to return length of strings.

        Arguments:
            factName (str): Name of the factor keyword.
            simpName (str): Name of the simple keyword.
            occurrence (int): Index of the occurrence (start from 0).
            maxval (int): Maximum number of values read.
            lenmax (int): Maximum of lengths.

        Returns:
            list[misc]: List of the values provided by the user.
        """
        value = self.getValue( factName, occurrence, simpName )
        value = _check_strings(factName, simpName, value)
        size = len(value)
        if size > maxval:
            size = -size
        length = [min(len(i), lenmax) for i in value]
        return size, tuple(length[:maxval])

    def getvid(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of results.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.
            maxval (int): Maximum number of values read.

        Returns:
            int, list, int: Returns three values ``(size, values, isdef)``.
            ``size`` is the number of the values provided by the user.
            If ``size > maxval``, ``-size`` is returned.
            ``values`` is a list of result names.
            ``isdef`` is 1 if the value is the default, 0 if it has been
            explicitly provided by the user.
        """
        value = self.getValue( factName, occurrence, simpName )
        value = [i.getName()if hasattr(i, 'getName') else i for i in value]
        size = len(value)
        if size > maxval:
            size = -size
        return size, tuple(value[:maxval]), 0

    def getvtx(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of strings.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.
            maxval (int): Maximum number of values read.

        Returns:
            int, list, int: Returns three values ``(size, values, isdef)``.
            ``size`` is the number of the values provided by the user.
            If ``size > maxval``, ``-size`` is returned.
            ``values`` is a list of strings.
            ``isdef`` is 1 if the value is the default, 0 if it has been
            explicitly provided by the user.
        """
        value = self.getValue( factName, occurrence, simpName )
        value = _check_strings(factName, simpName, value)
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, tuple(value[:maxval]), 0

    def getvis(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of integers.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.
            maxval (int): Maximum number of values read.

        Returns:
            int, list, int: Returns three values ``(size, values, isdef)``.
            ``size`` is the number of the values provided by the user.
            If ``size > maxval``, ``-size`` is returned.
            ``values`` is a list of integers.
            ``isdef`` is 1 if the value is the default, 0 if it has been
            explicitly provided by the user.
        """
        value = self.getValue( factName, occurrence, simpName )
        if len( value ) > 0 and not isinstance(value[0], (int, long)):
            raise TypeError( "integer expected, got %s" % type( value[0] ) )
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, tuple(value[:maxval]), 0

    def getvr8(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of float numbers.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.
            maxval (int): Maximum number of values read.

        Returns:
            int, list, int: Returns three values ``(size, values, isdef)``.
            ``size`` is the number of the values provided by the user.
            If ``size > maxval``, ``-size`` is returned.
            ``values`` is a list of floats.
            ``isdef`` is 1 if the value is the default, 0 if it has been
            explicitly provided by the user.
        """
        value = self.getValue( factName, occurrence, simpName )
        if len( value ) > 0:
            try:
                float( value[0] )
            except TypeError:
                raise TypeError( "float expected, got %s" % type( value[0] ) )
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, tuple(value[:maxval]), 0

    def getvc8(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of complex numbers.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            simpName (str): Name of the simple keyword.
            maxval (int): Maximum number of values read.

        Returns:
            int, list, int: Returns three values ``(size, values, isdef)``.
            ``size`` is the number of the values provided by the user.
            If ``size > maxval``, ``-size`` is returned.
            ``values`` is a list of complex numbers.
            ``isdef`` is 1 if the value is the default, 0 if it has been
            explicitly provided by the user.
        """
        value = self.getValue( factName, occurrence, simpName )
        if len( value ) > 0:
            if value[0] in ('RI', 'MP'):
                val2 = tuple(value),
                if maxval < 1:
                    return -1, val2, 0
                else:
                    return 1, val2, 0
            try:
                complex( value[0] )
            except TypeError:
                raise TypeError( "complex expected, got %s" % type( value[0] ) )
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, tuple(value[:maxval]), 0

    def getres(self):
        """Return the name and type of the result, and the command name.

        Returns:
            str: Name of the Command result (name of the jeveux object).
            str: Type name of the result.
            str: Command name.
        """
        ret = self.getResultName(), self.getResultType(), self.getName()
        logger.debug("Command {2}: result name {0!r}, type {1!r}".format(*ret))
        return ret

    def getexm(self, factName, simpName):
        """Tell if the couple ( factor keyword, simple keyword ) exists in the
        Command catalog.

        Arguments:
            factName (str): Name of the factor keyword.
            simpName (str): Name of the simple keyword.

        Returns:
            int: 1 if the keyword exists, else 0.
        """
        catadef = self._getCataDefinition(factName)
        logger.debug("getexm: catadef: {0}".format(catadef.keys()
                                                   if catadef else None))
        if not catadef:
            return 0
        if not simpName.strip():
            return 1
        keywords = catadef.simple_keywords
        logger.debug("getexm: simple keywords: {0}".format(keywords.keys()))
        return int(keywords.get(simpName) is not None)

    def getmjm(self, factName, occurrence, maxval):
        """Return the list of simple keywords  provided by the user under a
        factor keyword.

        Arguments:
            factName (str): Name of the factor keyword.
            occurrence (int): Index of the occurrence (start from 0).
            maxval (int): Maximum number of values returned.

        Returns:
            list[str], list[str]: Two lists: one for the names of simple
            keywords, alphabetically sorted, and one for the type names
            of the keywords.
        """
        userkw = self._getDefinition(factName, occurrence)
        if not userkw:
            return (), ()
        logger.debug("getmjm: user keywords: {0}".format(userkw))
        catadef = self._getCataDefinition(factName).simple_keywords
        lkeywords = sorted(userkw.keys())
        kws, types = [], []
        for kw in lkeywords:
            obj = userkw[kw]
            if obj is None:
                continue
            # ignore factor keyword: legacy getmjm returned typ='MCList'
            if not catadef.has_key(kw):
                continue
            kws.append(kw)
            typ = typeaster(catadef[kw].definition['typ'])
            if value_is_sequence(obj) and not is_complex(obj):
                obj = obj[0]
            if is_complex(obj) and typ == 'C8':
                pass
            elif is_float(obj) and typ in ('R8', 'C8'):
                pass
            elif is_int(obj) and typ in ('IS', 'R8', 'C8'):
                pass
            elif is_str(obj) and typ == 'TX':
                pass
            elif is_str(obj) and 'FORMULE' in typ:
                typ = typ[0]
            elif isinstance(obj, DataStructure):
                typ = obj.getType()
            else:
                raise TypeError("unsupported type: {0!r} {1}"
                                .format(obj, type(obj)))
            types.append(typ)
        return kws, types

    @classmethod
    def iniran(cls, jump=0):
        """Initialize the generator of random numbers.

        Arguments:
            jump (int): Non-negative integer to change the state of the
                numbers generator.
        """
        cls._random = random.Random(100)
        cls._random.jumpahead(jump)

    @classmethod
    def getran(cls):
        """Returns a random number between 0 and 1.

        Returns:
            float: Random number.
        """
        if not cls._random:
            cls.iniran()
        return (cls._random.random(), )

    def getmat(self):
        raise NotImplementedError("'getmat' is not yet supported.")

    def getoper(self):
        """Return the operator number.

        Return:
            int: Number of the fortran operator subroutine.
        """
        return self._commandCata.definition['op']

    def gettyp(self, typaster):
        """'gettyp' is not yet supported because it requires to store all the
        results of Commands, and it was only used in `FIN` for statistical
        purposes.
        """
        return 0, ()


def _check_strings(factName, simpName, value):
    """Check that keyword values are strings.

    Arguments:
        value (str): Values extracted from a keyword.

    Returns:
        list[str]: String values or names for DataStructure objects.
    """
    if len(value) > 0 and not isinstance(value[0], (str, unicode)):
        try:
            value2 = []
            for i in range(len(value)):
                value2.append(value[i].getName())
            value = value2
        except AttributeError:
            raise TypeError("string expected for {0}/{1}, got {2}"
                            .format(factName, simpName, type(value[0])))
    return value
