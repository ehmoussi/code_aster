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
This module defines the base objects that allow to use the legacy syntax
of code_aster commands.
"""

import copy
import types

from Utilitai.string_utils import force_list


def _debug( *args ):
    """Debug print"""
    # from pprint import pprint
    # print "DEBUG:",
    # pprint( args )

def buildConditionContext(dictDefinition, dictSyntax):
    """Build the context to evaluate bloc conditions.
    The values given by the user (dictSyntax) preempt on the definition ones"""
    ctxt = {}
    for key, value in dictDefinition.iteritems():
        if isinstance(value, SimpleKeyword):
            # use the default or None
            ctxt[key] = value.defaultValue()
    ctxt.update(dictSyntax)
    return ctxt

UNDEF = object()


class PartOfSyntax(object):

    """
    Objet générique qui permet de décrire un bout de syntaxe
    Generic object that describe a piece of syntax.
    Public attribute:
        definition: the syntax description
    """

    def __init__(self, curDict):
        """Initialization"""
        if type(curDict) != dict:
            raise TypeError("'dict' is expected")
        self.definition = curDict
        regles = curDict.get("regles")
        if regles and type(regles) not in (list, tuple):
            regles = (regles, )
        self.regles = regles

    def __repr__(self):
        """Simple representation"""
        return "%s( %r )" % (self.__class__, self.definition)

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        raise NotImplementedError("must be defined in a subclass")

    def isMandatory(self):
        """Tell if this keyword is mandatory"""
        return self.definition.get("statut", "f") == "o"

    def isOptional(self):
        """Tell if this keyword is optional"""
        return self.definition.get("statut", "f") == "f"

    def getEntites(self):
        """Retourne les "entités" composant l'objet (SIMP, FACT, BLOC)
        """
        entites = self.definition.copy()
        for key, value in entites.items():
            if type(value) not in (SimpleKeyword, Bloc, FactorKeyword):
                del entites[key]
        return entites
    # for compatibility (and avoid changing `pre_seisme_nonl`)
    entites = property(getEntites)

    def addDefaultKeywords(self, userSyntax):
        """Add default keywords"""
        if type(userSyntax) != dict:
            raise TypeError("'dict' is expected")
        for key, kwd in self.definition.iteritems():
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

    def checkMandatory(self, userSyntax):
        """Check that the mandatory keywords are provided by the user"""
        for key, kwd in self.definition.iteritems():
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
            for key, kwd in self.definition.iteritems():
                if isinstance(kwd, Bloc) and kwd.isEnabled(userSyntax):
                    found = kwd.getKeyword(userKeyword, userSyntax)
                    if found:
                        break
                #else: sdprod, fr...
        return found


class SimpleKeyword(PartOfSyntax):

    """
    Objet mot-clé simple équivalent à SIMP dans les capy
    """

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitSimpleKeyword(self, syntax)

    def _context(self, value):
        """Print contextual informations"""
        print("CONTEXT: value={!r}, type={}".format(value, type(value)))
        print("CONTEXT: definition: {}".format(self))

    def hasDefaultValue(self):
        """Tell if the keyword has a default value"""
        return self.defaultValue() is not UNDEF

    def defaultValue(self):
        """Return the default value or 'UNDEF'"""
        return self.definition.get("defaut", UNDEF)

    def addDefaultKeywords(self, key, userSyntax):
        """Add the default value if not provided in userSyntax"""
        value = userSyntax.get(key, self.defaultValue())
        if value is not UNDEF:
            userSyntax[key] = value


class FactorKeyword(PartOfSyntax):

    """
    Objet mot-clé facteur equivalent de FACT dans les capy
    """

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitFactorKeyword(self, syntax)


class Bloc(PartOfSyntax):

    """
    Objet Bloc équivalent à BLOC dans les capy
    """

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
        try:
            enabled = eval(self.getCondition(), {}, context)
        except AssertionError:
            raise
        except Exception:
            enabled = False
        return enabled


class Command(PartOfSyntax):

    """
    Object Command qui représente toute la syntaxe d'une commande
    """

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitCommand(self, syntax)

    def __call__(self, **args ):
        """Simulate the command execution, only based on the command description"""
        # just for unittests, introduces illogical import
        from SyntaxChecker import checkCommandSyntax
        checkCommandSyntax( self, args )
        resultType = self.definition.get('sd_prod')
        if resultType:
            if type(resultType) is types.FunctionType:
                ctxt = buildConditionContext( self.definition, args )
                resultType = self.build_sd_prod( resultType, ctxt )
            return resultType()

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


class Procedure(Command):

    pass


class Formule(Command):

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
