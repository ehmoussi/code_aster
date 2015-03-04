# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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
#       - prendre en compte les types Aster qui sont aujourd'hui tous des AsterDataStructure
#       - Les fonctions definies dans la paire d'accolade NOOK sont à revoir

from Cata.Rules import (
    AU_MOINS_UN, AllPresent, AllTogether, AtLeastOne, ENSEMBLE, EXCLUS, Exclusion,
    OneIn, OnlyFirstPresent, PRESENT_ABSENT, PRESENT_PRESENT, Rule, UN_PARMI
)
from Cata import DataStructure as DS
DS_content = DS.__dict__.values()

import __builtin__


def _F(**args):
    return args

__builtin__._F = _F

# TODO: replace by the i18n function (see old accas.capy)
def _(args):
    return args

__builtin__._ = _


def addValueToConditionString(string, key, defaultValue):
    if type(defaultValue) == str:
        string = string + "%s = \"%s\"" % (key, defaultValue) + "; "
    elif type(defaultValue) == int:
        string = string + "%s = %d" % (key, defaultValue) + "; "
    elif type(defaultValue) == tuple:
        string = string + "%s = %s" % (key, str(defaultValue)) + "; "
    else:
        raise TypeError("Unknown type " + str(defaultValue) + " " + key)
    return string


class PartOfSyntax(object):

    """
    Objet générique qui permet de décrire un bout de syntaxe
    """

    def __init__(self, curDict):
        if type(curDict) != dict:
            raise TypeError("Type 'dict' is expected")
        self.dictionary = curDict
        self.regles = curDict.get("regles")

    def __repr__(self):
        return "%s( %r )" % (self.__class__, self.dictionary)

    def isMandatory(self):
        """
        Le bout de syntax est-il obligatoire ?
        """
        return self.dictionary.get("statut", "n") == "o"


class FactorKeyword(PartOfSyntax):

    """
    Objet mot-clé facteur equivalent de FACT dans les capy
    """

    def check(self, tupleSyntax):
        """
        Fonction membre check
        Vérifie :
            - qu'on a bien le bon nombre d'occurence du mot-clé
            - que les règles du catalogues sont bien vérifiées
            - que les mot-clés simples obligatoires sont bien présents
        Un parcourt des objets Bloc est réalisé pour ajouter au bon niveau les
        mot-clés à ajouter en fonction des conditions
        On verifie ensuite que l'utilisateur n'a pas oublié de mot-clé
        """
        if type(tupleSyntax) == dict:
            tupleSyntax = [tupleSyntax]
        elif type(tupleSyntax) == tuple:
            pass
        else:
            raise TypeError("Type 'dict' or 'tuple' is expected")

        # Vérification du nombre de mots-clés facteurs
        if self.dictionary.has_key("min"):
            if len(tupleSyntax) < self.dictionary["min"]:
                raise ValueError("Too few factor keyword")
        if self.dictionary.has_key("max"):
            if len(tupleSyntax) > self.dictionary["max"]:
                raise ValueError("Too much factor keyword")

        # Boucle sur toutes les occurences du mot-clé facteur
        for dictSyntax in tupleSyntax:
            # Vérification des règles de ce mot-clé
            if self.regles != None:
                for rule in self.regles:
                    rule.check(dictSyntax)

            # On vérifie que les mots-clés simples qui doivent être présents le
            # sont
            for key, value in self.dictionary.iteritems():
                # print key, value
                if isinstance(value, PartOfSyntax):
                    if value.isMandatory() and not dictSyntax.has_key(key):
                        raise KeyError("Keyword " + key + " is mandatory")

            # Pour les blocs aussi
            dictTmp = self.inspectBlocs(dictSyntax)
            for key, value in dictTmp.iteritems():
                # print key, value
                if isinstance(value, PartOfSyntax):
                    if value.isMandatory() and not dictSyntax.has_key(key):
                        raise KeyError("Keyword " + key + " is mandatory")

            # On boucle sur la syntax de l'utilisateur vérifier les mots-clés
            # simples
            for key, value in dictSyntax.iteritems():
                # print key, value
                if not self.dictionary.has_key(key) and not dictTmp.has_key(key):
                    raise KeyError("Keyword " + key + " unauthorized")
                else:
                    if self.dictionary.has_key(key):
                        kw = self.dictionary[key]
                        kw.check(value)
                    if dictTmp.has_key(key):
                        kw = dictTmp[key]
                        kw.check(value)

    def inspectBlocs(self, dictSyntax):
        """
        Fonction membre inspectBlocs
        Parcourt les blocs présents dans le mot-clé facteur et produit
        un dictionnaire avec les mot-clés à ajouter en fonction des conditions
        """
        # Boucle pour rechercher les blocs
        txt = ""
        # Construction des valeurs par défauts (catalogue) et données par l'utilisateur
        # A ce niveau comme on fait passer les valeurs de l'utilisateur après,
        # il peut y avoir surcharge
        for key, value in self.dictionary.iteritems():
            if isinstance(value, SimpleKeyword):
                if value.hasDefaultValue():
                    defaultValue = value.defaultValue()
                    txt = addValueToConditionString(txt, key, defaultValue)
        for key, value in dictSyntax.iteritems():
            txt = addValueToConditionString(txt, key, str(value))
        exec(txt)

        dictTmp = {}
        # On évalue ensuite les conditions une après l'autre pour ajouter les
        # mot-clés
        for key, value in self.dictionary.iteritems():
            if isinstance(value, Bloc):
                dictTmp2 = value.inspectBlocs(dictSyntax)
                for key3, value3 in dictTmp2.iteritems():
                    dictTmp[key3] = value3

                findCondition = False
                currentCondition = value.getCondition()
                try:
                    findCondition = eval(currentCondition)
                except:
                    pass
                if findCondition:
                    for key2, value2 in value.dictionary.iteritems():
                        if isinstance(value2, SimpleKeyword):
                            dictTmp[key2] = value2
        return dictTmp


class SimpleKeyword(PartOfSyntax):

    """
    Objet mot-clé simple équivalent à SIMP dans les capy
    """

    def check(self, skwValue):
        """
        Fonction membre check
        Vérifie tout ce qu'il y a à vérifier pour un mot-clé simple :
            - le type,
            - le into,
            - val_min et val_max,
            - min et max
        """
        # Vérification du type
        currentType = self.dictionary["typ"]
        typePython = None
        if currentType == 'TXM':
            typePython = str
        elif currentType == 'I':
            typePython = int
        elif currentType == 'R':
            typePython = float
        elif currentType in DS_content:
            typePython = str
        else:
            raise TypeError( "Unsupported type: {!r}".format(currentType) )

        # Vérification du into
        if self.dictionary.has_key("into"):
            if skwValue not in self.dictionary["into"]:
                raise ValueError( "Value must be in {!r}".format(
                                  self.dictionary["into"]) )

        # Vérification des valeurs max et min
        valMin = None
        if self.dictionary.has_key("val_min"):
            valMin = self.dictionary["val_min"]
        valMax = None
        if self.dictionary.has_key("val_max"):
            valMax = self.dictionary["val_max"]

        if type(skwValue) == tuple:
            # Vérification du nombre de valeurs
            nbMin = None
            if self.dictionary.has_key("min"):
                nbMin = self.dictionary["min"]
            nbMax = None
            if self.dictionary.has_key("max"):
                nbMax = self.dictionary["max"]
                if nbMax == "**":
                    nbMax = -1

            if nbMax != None:
                if len(skwValue) > nbMax:
                    raise ValueError('Bad number of values')
            if nbMin != None:
                if len(skwValue) < nbMin:
                    raise ValueError('Bad number of values')

            # Vérification du type des valeurs
            for i in skwValue:
                if type(i) != typePython:
                    raise TypeError('Bad value type')
                if valMax != None and i > valMax:
                    raise ValueError('Value too big')
                if valMin != None and i < valMin:
                    raise ValueError('Value too low')
        else:
            # Vérification du type de la valeurs
            if type(skwValue) != type(DS.AsterDataStructure) and type(skwValue) != typePython:
                raise TypeError('Bad value type ' + str(skwValue))
            if type(skwValue) == 'classobj' and skwValue != typePython:
                raise TypeError('Bad value type ' + str(skwValue))
            # Vérification des valeurs max et min
            if valMax != None and skwValue > valMax:
                raise ValueError('Value too big')
            if valMin != None and skwValue < valMin:
                raise ValueError('Value too low')

    def hasDefaultValue(self):
        undef = object()
        return self.dictionary.get("defaut", undef) is not undef

    def defaultValue(self):
        return self.dictionary.get("defaut")


class Bloc(PartOfSyntax):

    """
    Objet Bloc équivalent à BLOC dans les capy
    """

    def __init__(self, curDict):
        PartOfSyntax.__init__(self, curDict)

    def __repr__(self):
        return "%s( %r )" % (self.__class__, self.dictionary)

    def getCondition(self):
        """
        Récupération de la condition d'apparition d'un bloc
        """
        cond = self.dictionary.get('condition')
        assert cond is not None, "Impossible ?!?"
        return cond

    def inspectBlocs(self, dictSyntax):
        """
        Fonction membre inspectBlocs
        Parcourt les blocs présents dans le mot-clé facteur et produit
        un dictionnaire avec les mot-clés à ajouter en fonction des conditions
        """
        # Boucle pour rechercher les blocs
        txt = ""
        # Construction des valeurs par défauts (catalogue) et données par l'utilisateur
        # A ce niveau comme on fait passer les valeurs de l'utilisateur après,
        # il peut y avoir surcharge
        for key, value in self.dictionary.iteritems():
            if isinstance(value, SimpleKeyword):
                if value.hasDefaultValue():
                    defaultValue = value.defaultValue()
                    txt = addValueToConditionString(txt, key, defaultValue)
        for key, value in dictSyntax.iteritems():
            txt = addValueToConditionString(txt, key, str(value))
        exec(txt)

        dictTmp = {}
        # On évalue ensuite les conditions une après l'autre pour ajouter les
        # mot-clés
        for key, value in self.dictionary.iteritems():
            if isinstance(value, Bloc):
                findCondition = False
                currentCondition = value.getCondition()
                try:
                    findCondition = eval(currentCondition)
                except:
                    pass
                if findCondition:
                    for key2, value2 in value.dictionary.iteritems():
                        if isinstance(value2, SimpleKeyword):
                            dictTmp[key2] = value2
        return dictTmp


class AsterCommand(object):

    """
    Object AsterCommand qui représente toute la syntaxe d'une commande
    """

    def __init__(self, curDict):
        if type(curDict) != dict:
            raise TypeError("Type 'dict' is expected")
        self.dictionary = curDict
        self.regles = None
        if curDict.has_key("regles"):
            self.regles = curDict["regles"]

    def __repr__(self):
        return "%s( %r )" % (self.__class__, self.dictionary)

    def getEntites(self):
        """Retourne les "entités" de la commande (SIMP, FACT, BLOC)
        """
        entites = self.dictionary.copy()
        for key, value in entites.items():
            if type(value) not in (SimpleKeyword, Bloc, FactorKeyword):
                del entites[key]
        return entites

    def checkSyntax(self, dictSyntax):
        """
        Fonction membre permettant de verifier la syntaxe d'une commande
        """
        if type(dictSyntax) != dict:
            raise TypeError("Type 'dict' is expected")

        # Vérification des règles
        if self.regles != None:
            for rule in self.regles:
                rule.check(dictSyntax)

        # On boucle sur tout le catalogue et on vérifie que pour tous les bouts de syntaxe
        # les mot-clés obligatoires sont bien présents

        # On commence par rechercher les blocs à ajouter
        # Construction des conditions
        txt = ""
        for key, value in self.dictionary.iteritems():
            if isinstance(value, SimpleKeyword):
                if value.hasDefaultValue():
                    defaultValue = value.defaultValue()
                    txt = addValueToConditionString(txt, key, defaultValue)
        for key, value in dictSyntax.iteritems():
            txt = addValueToConditionString(txt, key, str(value))
        exec(txt)

        dictTmp = {}
        # Evaluation des conditions et ajout des mot-clés nécessaires
        for key, value in self.dictionary.iteritems():
            if isinstance(value, Bloc):
                findCondition = False
                currentCondition = value.getCondition()
                try:
                    findCondition = eval(currentCondition)
                except:
                    pass
                if findCondition:
                    for key2, value2 in value.dictionary.iteritems():
                        if isinstance(value2, SimpleKeyword):
                            dictTmp[key2] = value2

        # Vérification que tous les mots-clés obligatoires sont présents
        # à la fois dans les blocs
        for key, value in dictTmp.iteritems():
            # print key, value
            if isinstance(value, PartOfSyntax):
                if value.isMandatory() and not dictSyntax.has_key(key):
                    raise KeyError("Keyword " + key + " is mandatory")

        # Mais aussi dans le dictionnaire standard
        for key, value in self.dictionary.iteritems():
            # print key, value
            if isinstance(value, PartOfSyntax):
                if value.isMandatory() and not dictSyntax.has_key(key):
                    raise KeyError("Keyword " + key + " is mandatory")

        # On vérifie ensuite que les mots-clés donnés par l'utilisateur
        # sont autorisés et ont la bonne syntaxe
        for key, value in dictSyntax.iteritems():
            # print key, value
            if not self.dictionary.has_key(key):
                raise KeyError("Keyword " + key + " unauthorized")
            else:
                if self.dictionary.has_key(key):
                    kw = self.dictionary[key]
                    kw.check(value)


class Operator(AsterCommand):

    pass


class Macro(AsterCommand):

    pass


class Procedure(AsterCommand):

    pass


class Formule(AsterCommand):

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


class C_MFRONT_OFFICIAL(object):

    def keys(self):
        return {}


class PROC_ETAPE(Procedure):
    pass
# } Ok

# NOOK {


def CO():
    pass


class assd(object):
    pass


def NoRepeat():
    return


def LongStr(a, b):
    pass


def AndVal(*args):
    pass


def OrdList(args):
    pass
# } NOOK
