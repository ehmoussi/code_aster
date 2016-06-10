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

from code_aster.Cata.Rules import (
    AU_MOINS_UN, AtLeastOne,
    UN_PARMI, ExactlyOne,
    EXCLUS, AtMostOne,
    PRESENT_PRESENT, IfFirstAllPresent,
    PRESENT_ABSENT, OnlyFirstPresent,
    ENSEMBLE, AllTogether,
)
from code_aster.Cata import DataStructure as DS

import __builtin__
import numpy
import types

def _F(**args):
    return args

__builtin__._F = _F

# TODO: replace by the i18n function (see old accas.capy)
def _(args):
    return args

__builtin__._ = _


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
        if isinstance(value, PartOfSyntax):
            if value.isMandatory() and not dictSyntax.has_key(key):
                _debug( "keyword =", key, ":", value )
                _debug( "syntax =", dictSyntax )
                raise KeyError("Keyword {} is mandatory".format(key))

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
    count = 0

    def accept(self, visitor, syntax=None):
        """Called by a Visitor"""
        visitor.visitCommand(self, syntax)

    def checkSyntax(self, dictSyntax, printSyntax=True):
        """Check the syntax of a command
        `dictSyntax` contains the keywords filled by the user"""
        from pprint import pformat
        if type(dictSyntax) != dict:
            raise TypeError("'dict' is expected")
        if printSyntax:
            Command.count += 1
            print("{0:-^100}\n Command #{1:0>4}\n{0:-^100}\n".format("", Command.count))
            print(" {0}({1})".format(
                self.definition.get("nom", "COMMAND"), pformat(dictSyntax)))

        checker = SyntaxCheckerVisitor()
        self.accept( checker, dictSyntax )

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

# Les fonctions definies dans la paire d'accolade Ok ont été correctement traitées
# Les fonctions definies dans la paire d'accolade NOOK sont à revoir
# Ok {
def OPER(**kwargs):
    return Operator(kwargs)


def SIMP(**kwargs):
    return SimpleKeyword(kwargs)


def FACT(**kwargs):
    return FactorKeyword(kwargs)


def BLOC(**kwargs):
    return Bloc(kwargs)


def MACRO(**kwargs):
    return Macro(kwargs)


def PROC(**kwargs):
    return Procedure(kwargs)


def FORM(**kwargs):
    return Formule(kwargs)


def tr(kwargs):
    return kwargs


def OPS(kwargs):
    return kwargs


class EMPTY_OPS(object):
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

ops = Ops()


class PROC_ETAPE(Procedure):
    pass
# } Ok

# NOOK {
def AsType( obj ):
    """Return the type of `obj`"""
    return type(obj)

def CO():
    pass

class assd(DS.ASSD):
    pass

def NoRepeat():
    return

def LongStr(a, b):
    pass

def AndVal(*args):
    pass

def OrVal(*args):
    pass

def OrdList(args):
    pass

def Together(args):
    pass

def Absent(args):
    pass

def Compulsory(*args):
    pass
# } NOOK
