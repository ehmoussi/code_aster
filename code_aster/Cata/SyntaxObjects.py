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

# TODO : - prendre en compte des conditions de blocs plus compliquées
#            (rajouter mCS = None quand on n'a pas de valeurs, ...)
#       - validators=NoRepeat
#       - prendre en compte les types Aster qui sont aujourd'hui tous des DataStructure
#       - Les fonctions definies dans la paire d'accolade NOOK sont à revoir
"""
Code_Aster Syntax Objects
-------------------------

This module defines the base objects that allow to use the legacy syntax
of code_aster commands.
"""

import os
import copy
import types
from collections import OrderedDict


class SyntaxId(object):
    """Container of the id of syntax objects.

    This list of type identifiers can be extended but never change between
    two releases of code_aster.
    """
    __slots__ = ('simp', 'fact', 'bloc', 'command')
    simp, fact, bloc, command = range(4)

IDS = SyntaxId()


def _debug( *args ):
    """Debug print"""
    # from pprint import pprint
    # print "DEBUG:",
    # pprint( args )

UNDEF = object()


class CataDefinition(OrderedDict):

    """Dictionary to store the definition of syntax objects.
    Iteration over the elements is ordered by type: SimpleKeyword, FactorKeyword and Bloc.
    """

    @property
    def entities(self):
        """Return the all entities.

        Returns:
            dict: dict of all entities (keywords and conditional blocks) of the
            object.
        """
        return self._filter_entities((SimpleKeyword, Bloc, FactorKeyword))

    @property
    def keywords(self):
        """Return the simple and factor keywords contained in the object.

        The keywords are sorted in the order of definition in the catalog.
        This is a workaround waiting for Python 3.6 and integration
        of `PEP-0468`_.

        Returns:
            dict: dict of all simple and factor keywords of the object.

        .. _PEP-0468: https://www.python.org/dev/peps/pep-0468/
        """
        kws = self._filter_entities((SimpleKeyword, FactorKeyword))
        return sorted_dict(kws)

    def _filter_entities(self, typeslist):
        """Filter entities by type.

        Returns:
            dict: dict of entities of the requested types.
        """
        entities = CataDefinition()
        for key, value in self.items():
            if type(value) in typeslist:
                entities[key] = value
        return entities

    def iterItemsByType(self):
        """Iterator over dictionary's pairs with respecting order:
        SimpleKeyword, FactorKeyword and Bloc objects"""
        keysR = [k for k, v in self.items() if type(v) is SimpleKeyword]
        keysI = [k for k, v in self.items() if type(v) is FactorKeyword]
        keysS = [k for k, v in self.items() if type(v) is Bloc]
        for key in keysR + keysI + keysS:
            yield (key, self[key])


class UIDMixing(object):
    """Sub class for UID based classes.

    Arguments:
        uid (int): Object's id.
    """
    _new_id = -1
    _id = None

    @classmethod
    def new_id(cls):
        UIDMixing._new_id += 1
        return UIDMixing._new_id

    def __init__(self):
        self._id = self.new_id()

    @property
    def uid(self):
        """Attribute that holds unique *id*"""
        return self._id

    def __cmp__(self, other):
        if other is None:
            return -1
        if self._id < other.uid:
            return -1
        if self._id > other.uid:
            return 1
        return 0


class PartOfSyntax(UIDMixing):

    """
    Generic object that describe a piece of syntax.
    Public attribute:
        definition: the syntax description
    """
    idx = 0

    def __init__(self, curDict):
        """Initialization"""
        super(PartOfSyntax, self).__init__()
        self._definition = CataDefinition(curDict)
        regles = curDict.get("regles")
        if regles and type(regles) not in (list, tuple):
            regles = (regles, )
        self._rules = regles or []

    def getCataTypeId(self):
        """Get the Cata type of object.
        Should be sub-classed.

        Returns:
            int: type id of Cata object: -1 if not defined.
        """
        return -1

    @property
    def name(self):
        """str: Name of the object."""
        return self._definition.get("nom", "")

    @property
    def docstring(self):
        """str: Documentation of the object."""
        return self._definition.get("fr", "")

    @property
    def definition(self):
        """dict: Attribute containing the syntax definition"""
        return self._definition

    @property
    def rules(self):
        """dict: Attribute containing the list of rules"""
        return self._rules

    #: for backward compatibility
    regles = rules

    def __repr__(self):
        """Simple representation"""
        return "%s( %r )" % (self.__class__, self._definition)

    @property
    def entities(self):
        """Return the all entities contained in the object.

        Returns:
            dict: dict of all entities (keywords and conditional blocks) of the
            object.
        """
        return self._definition.entities
    #: for backward compatibility (and avoid changing `pre_seisme_nonl`)
    entites = entities

    @property
    def keywords(self):
        """Return the simple and factor keywords contained in the object.

        Returns:
            dict: dict of all simple and factor keywords of the object.
        """
        return self._definition.keywords

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        raise NotImplementedError("must be defined in a subclass")

    def isMandatory(self):
        """Tell if this keyword is mandatory"""
        return self.definition.get("statut", "f") == "o"

    def isOptional(self):
        """Tell if this keyword is optional"""
        return self.definition.get("statut", "f") == "f"

    def addDefaultKeywords(self, userSyntax):
        """Add default keywords into the user dict of keywords.

        Arguments:
            userSyntax (dict): dict of the keywords as filled by the user.
        """
        if type(userSyntax) != dict:
            raise TypeError("'dict' is expected")
        for key, kwd in self.definition.iterItemsByType():
            if isinstance(kwd, SimpleKeyword):
                kwd.addDefaultKeywords(key, userSyntax)
            elif isinstance(kwd, FactorKeyword):
                userFact = userSyntax.get(key, {})
                # optional and not filled by user, ignore it
                if kwd.isOptional() and not userFact:
                    continue
                if type(userFact) in (list, tuple):
                    for userOcc in userFact:
                        kwd.addDefaultKeywords(userOcc)
                else:
                    kwd.addDefaultKeywords(userFact)
                userSyntax[key] = userFact
            elif isinstance(kwd, Bloc):
                if kwd.isEnabled(userSyntax):
                    kwd.addDefaultKeywords(userSyntax)
            #else: sdprod, fr...

    def buildConditionContext(self, userSyntax, _parent_ctxt=None):
        """Build the context to evaluate block conditions.

        Same as *addDefaultKeywords*, plus add None values for optional
        keywords.

        The values given in argument (userSyntax) preempt on the definition
        ones.

        Arguments:
            userSyntax (dict): dict of the keywords as filled by the user,
                **changed** in place.
            _parent_ctxt (dict): contains the keywords as known in the parent.
        """
        ctxt = _parent_ctxt.copy() if _parent_ctxt else {}
        for key, kwd in self.definition.iterItemsByType():
            if isinstance(kwd, SimpleKeyword):
                # use the default or None
                kwd.buildConditionContext(key, userSyntax, ctxt)
            elif isinstance(kwd, FactorKeyword):
                userFact = userSyntax.get(key, {})
                # optional and not filled by user, set to empty: {} or []
                if kwd.isOptional() and not userFact:
                    userFact = {}
                    if kwd.is_list():
                        userFact = []
                elif type(userFact) in (list, tuple):
                    for userOcc in userFact:
                        kwd.buildConditionContext(userOcc, ctxt)
                else:
                    kwd.buildConditionContext(userFact, ctxt)
                    if kwd.is_list():
                        userFact = [userFact, ]
                userSyntax[key] = userFact
                ctxt[key] = userSyntax[key]
            elif isinstance(kwd, Bloc):
                if kwd.isEnabled(ctxt):
                    kwd.buildConditionContext(userSyntax, ctxt)

    def checkMandatory(self, userSyntax):
        """Check that the mandatory keywords are provided by the user"""
        for key, kwd in self.definition.iterItemsByType():
            if isinstance(kwd, (SimpleKeyword, FactorKeyword)):
                if kwd.isMandatory() and not userSyntax.has_key(key):
                    _debug( "keyword =", key, ":", kwd )
                    _debug( "syntax =", userSyntax )
                    raise KeyError("Keyword {} is mandatory".format(key))
            elif isinstance(kwd, Bloc):
                if kwd.isEnabled(userSyntax):
                    kwd.checkMandatory(userSyntax)
            #else: sdprod, fr...

    def getKeyword(self, userKeyword, userSyntax):
        """Return the keyword in the current composite object"""
        # search in keywords list
        found = self.definition.get(userKeyword)
        if not found:
            # search in BLOC objects
            for key, kwd in self.definition.iterItemsByType():
                if isinstance(kwd, Bloc) and kwd.isEnabled(userSyntax):
                    found = kwd.getKeyword(userKeyword, userSyntax)
                    if found:
                        break
                #else: sdprod, fr...
        return found

    def is_list(self):
        """Tell if the value should be stored as list."""
        return self.definition.get('max', 1) != 1


class SimpleKeyword(PartOfSyntax):

    """
    Objet mot-clé simple équivalent à SIMP dans les capy
    """

    def getCataTypeId(self):
        """Get the type id of SimpleKeyword.

        Returns:
            int: type id of SimpleKeyword.
        """
        return IDS.simp

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitSimpleKeyword(self, syntax)

    def _context(self, value):
        """Print contextual informations"""
        print("CONTEXT: value={!r}, type={}".format(value, type(value)))
        print("CONTEXT: definition: {}".format(self))

    def hasDefaultValue(self):
        """Tell if the keyword has a default value"""
        return self.defaultValue(UNDEF) is not UNDEF

    def defaultValue(self, default=None):
        """Return the default value or *default*."""
        return self.definition.get("defaut", default)

    def addDefaultKeywords(self, key, userSyntax):
        """Add the default value if not provided by the user dict.

        Arguments:
            userSyntax (dict): dict of the keywords as filled by the user.
        """
        value = userSyntax.get(key, self.defaultValue(UNDEF))
        if value is not UNDEF:
            userSyntax[key] = value

    def buildConditionContext(self, key, userSyntax, _parent_ctxt):
        """Build the context to evaluate block conditions.

        Same as *addDefaultKeywords*, plus add None if the keyword is optional.

        Arguments:
            userSyntax (dict): dict of the keywords as filled by the user,
                **changed** in place.
            _parent_ctxt (dict): contains the keywords as known in the parent.
        """
        value = userSyntax.get(key, self.defaultValue())
        if self.is_list() and type(value) not in (list, tuple):
            value = [value, ]
        userSyntax[key] = value
        _parent_ctxt[key] = userSyntax[key]


class FactorKeyword(PartOfSyntax):

    """
    Objet mot-clé facteur equivalent de FACT dans les capy
    """

    def getCataTypeId(self):
        """Get the type id of FactorKeyword.

        Returns:
            int: type id of FactorKeyword.
        """
        return IDS.fact

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitFactorKeyword(self, syntax)


class Bloc(PartOfSyntax):

    """
    Objet Bloc équivalent à BLOC dans les capy
    """

    def getCataTypeId(self):
        """Get the type id of Bloc.

        Returns:
            int: type id of Bloc.
        """
        return IDS.bloc

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitBloc(self, syntax)

    def getCondition(self):
        """Return the BLOC condition"""
        cond = self.definition.get('condition')
        assert cond is not None, "A bloc must have a condition!"
        return cond

    def isEnabled(self, context):
        """Tell if the block is enabled by the given context"""
        from code_aster.Cata import DataStructure
        eval_context = {}
        eval_context.update(DataStructure.__dict__)
        eval_context.update(block_utils())
        eval_context.update(context)
        try:
            enabled = eval(self.getCondition(), {}, eval_context)
        except AssertionError:
            raise
        except Exception as exc:
            # TODO: re-enable CataError, it seems me a catalog error!
            # if 'reuse' not in self.getCondition():
            #     raise CataError("Error evaluating {0!r}: {1}".format(
            #                     self.getCondition(), str(exc)))
            enabled = False
        return enabled


class Command(PartOfSyntax):

    """
    Object Command qui représente toute la syntaxe d'une commande
    """
    _call_callback = None

    @classmethod
    def register_call_callback(cls, callback):
        """Register *callback* to be called in place of the default method.

        Register *None* to revert to default.

        Arguments:
            callback (callable): Function to call with signature:
                (*Command* instance, ``**kwargs``).
        """
        cls._call_callback = callback

    def getCataTypeId(self):
        """Get the type id of Command.

        Returns:
            int: type id of Command.
        """
        return IDS.command

    def can_reuse(self):
        """Tell if the result can be a reused one."""
        return self.definition.get('reentrant') in ('o', 'f')

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitCommand(self, syntax)

    def call_default(self, **args):
        """Execute the command, only based on the command description."""
        resultType = self.get_type_sd_prod(**args)
        if resultType is not None:
            return resultType()

    def __call__(self, **args):
        """Simulate the command execution."""
        if Command._call_callback is None:
            return self.call_default(**args)
        else:
            return Command._call_callback(self, **args)

    def get_type_sd_prod(self, **args):
        """Return the type of the command result."""
        resultType = self.definition.get('sd_prod')
        if resultType is not None:
            if type(resultType) is types.FunctionType:
                ctxt = mixedcopy(args)
                self.buildConditionContext(ctxt)
                if os.environ.get('DEBUG'):
                    # print "COMMAND:", self.name
                    # print "CTX1:", ctxt.keys()
                    # print "CTX1:", ctxt
                    _check_args(self, resultType, ctxt)
                resultType = self.build_sd_prod( resultType, ctxt )
            return resultType

    def build_sd_prod( self, sdprodFunc, ctxt ):
        """Call the `sd_prod` function"""
        resultType = sdprodFunc( **ctxt )
        return resultType


class Operator(Command):

    pass


class Macro(Command):

    """Specialization of the Command object for MACRO"""

    def build_sd_prod( self, sdprodFunc, ctxt ):
        """Call the `sd_prod` function"""
        resultType = sdprodFunc( self, **ctxt )
        return resultType

    def type_sdprod(self, result, astype):
        """Define the type of the result."""
        result.settype(astype)


class Procedure(Command):

    pass


class Formule(Macro):

    pass


class Ops(object):

    def __init__(self):
        self.DEBUT = None
        self.build_detruire = None
        self.build_formule = None
        self.build_gene_vari_alea = None
        self.INCLUDE = None
        self.INCLUDE_context = None
        self.POURSUITE = None
        self.POURSUITE_context = None


class CataError(Exception):
    """Exception raised in case of error in the catalog."""
    pass


def mixedcopy(obj):
    """"Make a mixed copy (copy of all dicts, lists and tuples, no copy
    for all others)."""
    if isinstance(obj, list):
        new = [mixedcopy(i) for i in obj]
    elif isinstance(obj, tuple):
        new = tuple(mixedcopy(list(obj)))
    elif isinstance(obj, dict):
        new = dict([(i, mixedcopy(obj[i])) for i in obj])
    else:
        new = obj
    return new

def block_utils():
    """Define some helper functions to write block conditions."""
    def at_least_one(keyword, values):
        """Checked if the/a value of 'keyword' is at least once in 'values'.
        Similar to the rule AtLeastOne, 'keyword' may contain several
        values."""
        if type(keyword) not in (list, tuple):
            keyword = [keyword,]
        if type(values) not in (list, tuple):
            values = [values,]
        test = set(keyword)
        values = set(values)
        return not test.isdisjoint(values)

    def none_of(keyword, values):
        """Checked if none of the values of 'keyword' is in 'values'."""
        return not at_least_one(keyword, values)

    au_moins_un = at_least_one
    aucun = none_of

    return locals()

def sorted_dict(kwargs):
    """Sort a dict in the order of the items."""
    if not kwargs:
        # empty dict
        return OrderedDict()
    vk = sorted(zip(kwargs.values(), kwargs.keys()))
    newv, newk = zip(*vk)
    return OrderedDict(zip(newk, newv))


# for debugging
def _check_args(obj, func, dictargs):
    """Check if some arguments missing to call *func*."""
    import inspect
    required = inspect.getargspec(func).args
    args = dictargs.keys()
    miss = set(required).difference(args)
    if isinstance(obj, Macro):
        miss.discard('self')
    if len(miss) > 0:
        miss = sorted(list(miss))
        raise ValueError("Arguments required by the function:\n    {0}\n"
                         "Provided in dict:    {1}\n"
                         "Missing:    {2}\n"\
                         .format(sorted(required), sorted(args), miss))
