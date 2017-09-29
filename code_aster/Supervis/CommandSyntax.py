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

from ..Utilities import force_list
from .logger import logger
from .ResultNaming import ResultNaming


class CommandSyntax:
    """This class describes the syntax of command for compatibility
    with the fortran code that use the legacy supervisor.
    """

    _currentCommand = None
    result_naming = ResultNaming()

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

    @classmethod
    def getNewResultName(cls):
        """Return a new result name.

        The first one is "0       ", then "1       ", etc.

        Returns:
            str: String of 8 characters containing the new name.
        """
        return cls.result_naming.getNewResultName()

    @classmethod
    def getResultName(cls):
        """Return a the current result name.

        This is the name of the object that is being created.

        Returns:
            str: String of 8 characters containing the current name.
        """
        return cls.result_naming.getResultName()


    def __init__(self, name="unNamed", cata=None):
        """Create a new command"""
        self._name = name
        # TODO: remove unused attributes
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
            cata = getattr(Commands, name)
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
        print repr(self)
        logger.debug( repr(self) )

    def setResult( self, sdName, sdType ):
        """Register the result of the command: name and type"""
        self._resultName = sdName
        self._resultType = sdType

    def define( self, dictSyntax ):
        """Register the keywords values"""
        if self._commandCata != None:
            logger.debug( "define0 %r: %r", self._name, dictSyntax )
            self._commandCata.addDefaultKeywords( dictSyntax )
        self._definition = dictSyntax
        logger.debug( "define1 %r: %r", self._name, self._definition )

    def getName( self ):
        """Return the command name"""
        return self._name

    def getResultName( self ):
        """Return the name of the result of the command"""
        return self._resultName

    def getResultType( self ):
        """Return the type of the result of the command"""
        return self._resultType

    def _getFactorKeyword( self, factName ):
        """Return the occurrences of a factor keyword"""
        # a factor keyword may be empty: {} (None means 'does not exist')
        dictDef = self._definition.get( factName, None )
        logger.debug( "factor keyword %r: %r", factName, dictDef )
        if dictDef is None:
            return None
        if isinstance(dictDef, dict):
            dictDef = [dictDef, ]
        return dictDef

    def _getFactorKeywordOccurrence( self, factName, occurrence ):
        """Return the definition of an occurrence of a factor keyword"""
        dictDef = self._getFactorKeyword( factName )
        if dictDef is None:
            return None
        try:
            return dictDef[occurrence]
        except:
            return None

    def _getDefinition( self, factName, occurrence ):
        """Return the definition of a factor keyword or of the top-level
        if `factName` is blank"""
        if not factName.strip():
            dictDef = self._definition
        else:
            dictDef = self._getFactorKeywordOccurrence( factName, occurrence )
            if not dictDef:
                dictDef = {}
        assert isinstance(dictDef, dict), "syntax not defined"
        return dictDef

    def getFactorKeywordNbOcc( self, factName ):
        """Return the number of occurrences of a factor keyword"""
        dictDef = self._getFactorKeyword( factName )
        logger.debug( "_getFactorKeyword %r: %r", factName, dictDef )
        if dictDef is None:
            return 0
        logger.debug( "getFactorKeywordNbOcc: len(dictDef) = %d", len(dictDef) )
        return len(dictDef)

    getfac = getFactorKeywordNbOcc

    def existsFactorAndSimpleKeyword( self, factName, occurrence,
                                      simpName ):
        """Tell if the couple ( factor keyword, simple keyword ) exists"""
        dictDef = self._getDefinition( factName, occurrence )
        value = dictDef.get( simpName, None )
        if value is None or isinstance(value, dict):
            return 0
        return 1

    def getexm(self, factName, simpName):
        """"""
        return self.existsFactorAndSimpleKeyword(factName, 0, simpName)

    def getValue( self, factName, occurrence, simpName ):
        """Return the values of a (simple) keyword"""
        if not self.existsFactorAndSimpleKeyword( factName, occurrence, simpName ):
            return []
        value = self._getDefinition( factName, occurrence )[simpName]
        value = force_list(value)
        logger.debug( "getValue: %r", value )
        return value

    def getltx(self, factName, simpName, occurrence, maxval, lenmax):
        """Wrapper function to return length of strings"""
        value = self.getValue( factName, occurrence, simpName )
        value = _check_strings(factName, simpName, value)
        size = len(value)
        if size > maxval:
            size = -size
        length = [min(len(i), lenmax) for i in value]
        return size, length

    def getvid(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of results."""
        value = self.getValue( factName, occurrence, simpName )
        value = [i.getName() for i in value]
        value = tuple(value)
        size = len(value)
        if size > maxval:
            size = -size
        return size, value, 0

    def getvtx(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of strings."""
        value = self.getValue( factName, occurrence, simpName )
        value = tuple(_check_strings(factName, simpName, value))
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, value, 0

    def getvis(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of integers."""
        value = self.getValue( factName, occurrence, simpName )
        if len( value ) > 0 and not isinstance(value[0], (int, long)):
            raise TypeError( "integer expected, got %s" % type( value[0] ) )
        value = tuple(value)
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, value, 0

    def getvr8(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of float numbers."""
        value = self.getValue( factName, occurrence, simpName )
        if len( value ) > 0:
            try:
                float( value[0] )
            except TypeError:
                raise TypeError( "float expected, got %s" % type( value[0] ) )
        value = tuple(value)
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, value, 0

    def getvc8(self, factName, simpName, occurrence, maxval):
        """Wrapper function to return a list of integers"""
        value = self.getValue( factName, occurrence, simpName )
        if len( value ) > 0:
            try:
                complex( value[0] )
            except TypeError:
                raise TypeError( "complex expected, got %s" % type( value[0] ) )
        value = tuple(value)
        size = len(value)
        if size > maxval:
            size = -size
        # TODO: last returned value is "is_default"
        return size, value, 0

    def getres(self):
        """Return the name and type of the result, and the command name."""
        ret = self.getResultName(), self.getResultType(), self.getName()
        logger.debug("Command {2}: result name {0!r}, type {1!r}".format(*ret))
        return ret

    def getran(self):
        """"""
        import random
        return random.random()

    def getmat(self):
        raise NotImplementedError

    def getoper(self):
        """Return the operator number.

        Return:
            int: Number of the fortran operator subroutine.
        """
        return self._commandCata.definition['op']

    def gettyp(self, typaster):
        """Return the objects of the given type.
        TODO ???
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
