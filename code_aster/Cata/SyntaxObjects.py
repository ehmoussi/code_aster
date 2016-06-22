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

import types


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
        return self.definition.get("statut", "n") == "o"

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

    def inspectBlocs(self, dictSyntax):
        """
        Fonction membre inspectBlocs
        Parcourt les blocs présents et produit un dictionnaire avec les mot-clés
        à ajouter en fonction des conditions
        """
        ctxt = buildConditionContext(self.definition, dictSyntax)
        # XXX il y a sans doute un risque qu'on mette dans dictTmp des mots-clés
        #     qui sont à un niveau trop profond. Pas sûr car on ne traverse que
        #     les blocs, pas les mcfact.
        dictTmp = {}
        # On évalue ensuite les conditions une après l'autre pour ajouter les
        # mot-clés
        for key, value in self.definition.iteritems():
            if isinstance(value, Bloc):
                dictTmp.update( value.inspectBlocs(dictSyntax) )

                findCondition = False
                currentCondition = value.getCondition()
                try:
                    findCondition = eval(currentCondition, ctxt)
                except:
                    pass
                if findCondition:
                    for key2, value2 in value.definition.iteritems():
                        if isinstance(value2, SimpleKeyword):
                            dictTmp[key2] = value2
        return dictTmp

    def getDefaultKeywords(self, dictSyntax):
        """Get default keywords of the PartOfSyntax"""
        if type(dictSyntax) != dict:
            raise TypeError("'dict' is expected")

        ctxt = buildConditionContext(self.definition, dictSyntax)

        returnDict = {}
        for key, value in self.definition.iteritems():
            if isinstance(value, SimpleKeyword):
                if not dictSyntax.has_key(key) and value.hasDefaultValue():
                    returnDict[key] = value.defaultValue()
            elif isinstance(value, FactorKeyword):
                returnList = []
                value2 = dictSyntax.get(key, {})

                stat = 'f'
                if value.definition.has_key('statut'): stat = value.definition['statut']
                if stat == 'f' and value2 == {}: continue

                if type(value2) not in (list, tuple): value2 = [value2]
                if stat == 'd' or stat == 'o':
                    for curDict in value2:
                        return2 = value.getDefaultKeywords(curDict)
                        returnDict3 = {}
                        for key3, value3 in return2.iteritems():
                            returnDict3[key3] = value3
                        returnList.append(returnDict3)
                else:
                    for val in value2: returnList.append({})

                ind = 0
                # Ce bloc est-il utile ???
                for curDict in value2:
                    return2 = value.inspectBlocs(curDict)
                    returnDict2 = {}
                    for key3, value3 in return2.iteritems():
                        if isinstance(value3, SimpleKeyword):
                            if not dictSyntax.has_key(key) and value3.hasDefaultValue():
                                returnDict2[key3] = value3.defaultValue()
                    returnList[ind].update(returnDict2)
                    ind += 1

                if len(returnList) == 1:
                    if returnList[0] == {}: continue
                if len(returnList) != 0:
                    returnDict[key] = returnList
            elif isinstance(value, Bloc):
                value2 = dictSyntax.get(key, {})
                dictTmp = value.inspectBlocs(value2)

                findCondition = False
                currentCondition = value.getCondition()
                try:
                    findCondition = eval(currentCondition, ctxt)
                except:
                    pass
                if findCondition:
                    for key2, value2 in value.definition.iteritems():
                        if isinstance(value2, SimpleKeyword):
                            if not dictSyntax.has_key(key) and value2.hasDefaultValue():
                                returnDict[key2] = value2.defaultValue()
        return returnDict


class SimpleKeyword(PartOfSyntax):

    """
    Objet mot-clé simple équivalent à SIMP dans les capy
    """

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitSimpleKeyword(self, syntax)

    def _context(self, value):
        """Print contextual informations"""
        print "CONTEXT: value={!r}, type={}".format(value, type(value))
        print "CONTEXT: definition:", self

    def hasDefaultValue(self):
        undef = object()
        return self.definition.get("defaut", undef) is not undef

    def defaultValue(self):
        return self.definition.get("defaut")


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
        """
        Récupération de la condition d'apparition d'un bloc
        """
        cond = self.definition.get('condition')
        assert cond is not None, "A bloc must have a condition!"
        return cond


class Command(PartOfSyntax):

    """
    Object Command qui représente toute la syntaxe d'une commande
    """

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitCommand(self, syntax)

    def __call__(self, **args ):
        """Simulate the command execution"""
        self.checkSyntax( args )
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
