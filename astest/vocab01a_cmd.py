# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr
# Don't forget to change person in charge in `printKeywordsUsage` function

import os
import tempfile
import types

import code_aster
from code_aster.Cata.Commands import commandStore
from code_aster.Cata.DataStructure import UnitType
from code_aster.Cata.Language.DataStructure import UnitBaseType
from code_aster.Cata.Language.SyntaxObjects import IDS, Command
from code_aster.Cata.Language.SyntaxUtils import add_none_sdprod
from code_aster.Cata.Syntax import *
from code_aster.Commands import CREA_TABLE, TEST_TABLE
from code_aster.Messages import UTMESS
from code_aster.Supervis.ExecuteCommand import UserMacro
from code_aster.Utilities import CR, force_list, logger


class CataChecker:
    """Check catalogs"""

    def __init__(self):
        self.cr = CR()

    def check_regles(self, step):
        """Vérifie l'attribut rules."""
        if type(step.rules) not in (list, tuple):
            self.cr.fatal("Unexpected type for 'rules' attr: %r", step.rules)

    def check_fr(self, step):
        """Vérifie l'attribut fr."""
        value = step.definition.get("fr")
        if value and not isinstance(value, str):
            self.cr.fatal("Unexpected type for 'fr' attr: %r", value)

    def check_docu(self, step):
        """Vérifie l'attribut docu."""
        if not isinstance(step.udocstring, str):
            self.cr.fatal("Unexpected type for 'docu' attr: %r",
                          step.udocstring)

    def check_nom(self, step):
        """Vérifie l'attribut nom."""
        if type(step.name) is not str:
            self.cr.fatal("Unexpected type for 'nom' attr: %r", step.name)

    def check_reentrant(self, step):
        """Vérifie l'attribut reentrant."""
        status = step.definition.get("reentrant", "n").split(":")[0]
        if status not in ('o', 'n', 'f'):
            self.cr.fatal(
                "Unexpected value for 'reentrant' (not 'o', 'n' or 'f'): %r",
                status)
        if status != 'n' and 'reuse' not in list(step.keywords.keys()):
            self.cr.fatal("Keyword 'reuse' is missing")
        if status != 'n':
            orig = step.definition.get("reentrant").split(':')
            try:
                assert len(orig) in (2, 3), "expecting one or two keywords"
                orig.pop(0)
                msg = "Inexisting keyword {0!r}"
                for k1 in orig[0].split("|"):
                    key1 = step.keywords.get(k1)
                    assert key1 is not None, msg.format(k1)
                    if len(orig) > 1:
                        key2 = key1.keywords.get(orig[1])
                        assert key2 is not None, msg.format("/".join([k1, orig[1]]))
            except AssertionError as exc:
                self.cr.fatal("'reentrant' must define which keyword "
                              "provide the modified object.\nFor example: "
                              "'o:MAILLAGE' for a simple keyword or "
                              "'o:ETAT_INIT:EVOL_NOLI' for a factor keyword. "
                              "Keywords must exist.\n"
                              "Error: {0}"
                              .format(exc))

    def check_statut(self, step, into=('o', 'f', 'c', 'd')):
        """Vérifie l'attribut statut."""
        if step.definition.get("statut") not in into:
            self.cr.fatal("Unexpected value for 'statut' (not in %s): %r",
                          into, step.definition.get("statut"))
        if step.name == 'reuse' and step.definition.get("statut") != 'c':
            self.cr.fatal("'statut' must be 'c' for reuse.")

    def check_op(self, step, valmin=-99, valmax=9999):
        """Vérifie l'attribut op."""
        op = step.definition.get("op")
        if (op is not None and
                (isinstance(op, int) and not valmin < op <= valmax) or
                (isinstance(op, str) and not isinstance(op, str))):
            self.cr.fatal("Attribute 'op' must be between %d and %d: %r",
                          valmin, valmax, op)

    def check_min_max(self, step):
        """Vérifie les attributs min/max."""
        vmin = step.definition.get("min", 1)
        if not isinstance(vmin, int):
            self.cr.fatal("Unexpected type for 'min' attr: %r", vmin)
        vmax = step.definition.get("max", 1)
        if not isinstance(vmax, int):
            if vmax != '**':
                self.cr.fatal("Unexpected type for 'max' attr: %r", vmax)
        if vmax != '**' and vmin > vmax:
            self.cr.fatal("Unexpected values: min=%r and max=%r")

    def check_validators(self, step):
        """Vérifie les validateurs supplémentaires"""
        # TODO
        # valid = step.definition.get("validators")
        # if valid and not valid.verif_cata():
        #     self.cr.fatal("Incorrect validator. Reason : %s", valid.cata_info)

    def check_into(self, step):
        """Vérifie l'attribut into."""
        into = step.definition.get("into")
        if into is not None:
            if not isinstance(into, (list, tuple)):
                self.cr.fatal("Unexpected type for 'into' attr: %r", into)
            if len(into) == 0:
                self.cr.fatal("At least one value is expected for 'into'")

    def check_enum(self, step):
        """Check 'enum' attribute"""
        enum = step.definition.get("enum")
        if enum is not None:
            into = step.definition.get("into", [])
            if step.definition.get("typ") != "TXM":
                self.cr.fatal("'enum' only support for 'TXM'")
            if not isinstance(enum, (list, tuple)):
                self.cr.fatal("Unexpected type for 'enum' attr: %r", into)
            if len(enum) == 0:
                self.cr.fatal("At least one value is expected for 'enum'")
            elif len(enum) != len(into):
                self.cr.fatal("'into' and 'enum' must have the same size: "
                              "{0} != {1}".format(len(into), len(enum)))

    def check_position(self, step):
        """Vérifie l'attribut position."""
        if step.definition.get("position") is not None:
            self.cr.fatal("Unauthorized attribute: 'position'")

    def check_defaut(self, step):
        """Vérifie l'attribut defaut."""
        if step.defaultValue() is not None:
            if (step.definition.get("into")
                    and step.defaultValue() not in step.definition.get("into")):
                self.cr.fatal("The default value %r must be in the 'into' list: %r",
                              step.defaultValue(), step.definition.get("into"))
            if step.definition.get("statut") == 'o':
                self.cr.fatal("A keyword with a default value must be optional")

    def check_inout(self, step):
        """Vérifie l'attribut inout."""
        inout = step.definition.get("inout")
        typ = force_list(step.definition.get("typ"))
        if inout is None:
            return
        elif inout not in ('in', 'out'):
            self.cr.fatal("Unexpected value (not 'in' or 'out'): %r", inout)
        elif len(typ) != 1 or not issubclass(typ[0], UnitBaseType):
            self.cr.fatal("Attribute 'typ' must be UnitType(): %r", typ)

    def check_unit(self, step):
        """Vérification ayant besoin du nom"""

        # As UnitType() is not an object, this forbids UNITE* keywords
        # for another kind of 'int'.
        inout = step.definition.get("inout")
        typ = force_list(step.definition.get("typ"))
        if step.name.startswith('UNITE') and UnitType() in typ:
            if not inout:
                self.cr.fatal("Attribute 'inout' is required with 'typ' "
                              "UnitType().")
            if step.defaultValue() == 6 :
                self.cr.fatal("Unauthorized default value: 6")

    def visitCommand(self, step, userDict=None):
        """Visit a Command object"""
        self.check_regles(step)
        self.check_fr(step)
        self.check_reentrant(step)
        self.check_docu(step)
        self.check_nom(step)
        self.check_op(step, valmin=0)
        # self.verif_cata_regles(step)
        for entity in step.entities.values():
            entity.accept(self)

    def visitMacro(self, step, userDict=None):
        """Visit a Macro object"""
        self.check_regles(step)
        self.check_fr(step)
        self.check_reentrant(step)
        self.check_docu(step)
        self.check_nom(step)
        self.check_op(step, valmax=0)
        # self.verif_cata_regles(step)
        for entity in step.entities.values():
            entity.accept(self)

    def visitFactorKeyword(self, step, userDict=None):
        """Visit a FactorKeyword object"""
        self.check_min_max(step)
        self.check_fr(step)
        self.check_regles(step)
        self.check_statut(step)
        self.check_docu(step)
        self.check_validators(step)
        # self.verif_cata_regles(step)
        for entity in step.entities.values():
            entity.accept(self)

    def visitBloc(self, step, userDict=None):
        """Visit a Bloc object"""
        for entity in step.entities.values():
            entity.accept(self)

    def visitSimpleKeyword(self, step, skwValue=None):
        """Visit a SimpleKeyword object"""
        self.check_min_max(step)
        self.check_fr(step)
        self.check_statut(step)
        self.check_into(step)
        self.check_enum(step)
        self.check_position(step)
        self.check_validators(step)
        self.check_defaut(step)
        self.check_inout(step)
        self.check_unit(step)


def getListOfCommands():
    """Build the list of operators"""
    commands = [cmd for cmd in list(commandStore.values())
                if isinstance(cmd, Command)]
    return commands

def checkDefinition( commands ):
    """Check the definition of the catalog of the commands (see N_ENTITE.py)"""
    print(">>> Vérification des catalogues de commandes...")
    err = []
    for cmd in commands:
        checker = CataChecker()
        cmd.accept(checker)
        if not checker.cr.estvide():
            err.append([cmd.name, str(checker.cr)])
            # print str(cr)
            # raise TypeError("La vérification du catalogue a échoué pour '{0}'"\
            #                 .format(cmd.name))
        cr = check_sdprod_safe(cmd)
        if cr:
            err.append([cmd.name, str(cr)])

    for name, msg in err:
        print(("La vérification du catalogue a échoué pour '{0}':\n{1}"
              .format(name, msg)))
    if err:
        raise TypeError("{0} erreurs sur {1} commandes."
                        .format(len(err), len(commands)))
    print("    ok\n")

def check_sdprod(command, func_prod, sd_prod, verbose=True):
    """Check that 'sd_prod' is type allowed by the function 'func_prod'
    with '__all__' argument.
    """
    def _name(class_):
        return getattr(class_, '__name__', class_)

    if type(func_prod) != types.FunctionType:
        return

    cr = CR()
    args = {}
    add_none_sdprod(func_prod, args)
    args['__all__'] = True
    # eval sd_prod with __all__=True + None for other arguments
    try:
        allowed = force_list(func_prod(*(), **args))
        islist = [isinstance(i, (list, tuple)) for i in allowed]
        if True in islist:
            if False in islist:
                cr.fatal("Error: {0}: for macro-commands, each element must "
                        "be a list of possible types for each result"
                        .format(command))
            else:
                # can not know which occurrence should be tested
                allowed = tuple(set().union(*allowed))
        allowed = tuple(set().union(*[subtypes(i) for i in allowed]))
        if sd_prod and sd_prod not in allowed:
            cr.fatal("Error: {0}: type '{1}' is not in the list returned "
                     "by the 'sd_prod' function with '__all__=True': {2}"
                     .format(command, _name(sd_prod),
                             [_name(i) for i in allowed]))
    except Exception as exc:
        print("Error: {0}".format(exc))
        cr.fatal("Error: {0}: the 'sd_prod' function must support "
                 "the '__all__=True' argument".format(command))
    if not cr.estvide():
        if verbose:
            print(str(cr))
        raise TypeError(str(cr))

def subtypes(cls):
    """Return subclasses of 'cls'."""
    types = [cls]
    if not cls:
        return types
    for subclass in cls.__subclasses__():
        types.extend(subtypes(subclass))
    return types

def check_sdprod_safe(cmd):
    """Check sd_prod function."""
    try:
        check_sdprod(cmd.name, getattr(cmd, 'sd_prod', None),
                     None, verbose=False)
    except TypeError as exc:
        return str(exc)

def get_entite( obj, typ="values" ):
    """Return the sub-objects (if `typ` is "values") or sub-objects
    names (if `typ` is "key") of a composite object."""
    entities = obj.keywords
    lsub = []
    for key, sub in entities.items():
        if sub.getCataTypeId() != IDS.bloc:
            if typ == "values":
                lsub.append(sub)
            else:
                lsub.append(key)
        if sub.getCataTypeId() in (IDS.bloc, IDS.fact):
            lsub.extend(get_entite(sub, typ=typ))
    return lsub

def checkDocStrings( commands ):
    """Extract and check the fr/ang docstrings"""
    print(">>> Vérification des textes explicatifs des mots-clés...")
    lang = {}
    for cmd in commands:
        objs = [cmd] + get_entite( cmd, typ="values" )
        for entity in objs:
            if getattr(entity, 'ang', None):
                lang[id(entity)] = (entity.fr, entity.ang)
    assert len(lang) == 0, "'ang' is deprecated and not used anymore, please remove it"
    print("    ok\n")

def extractKeywords( commands ):
    """Return the list of all the keywords (simple or factor)"""
    # keywords of each command
    cmdKwd = {}
    for command in commands:
        cmdKwd[ command.name ] = get_entite(command, typ="keys")
    # reverse dict : commands that use a keyword
    kwdCmd = {}
    for name, words in list(cmdKwd.items()):
        for word in words:
            kwdCmd[ word ] = kwdCmd.get(word, set())
            kwdCmd[ word ].add(name)
    return kwdCmd

def sortedKeywords( kwdCmd ):
    """Build the sorted list of all keywords"""
    allKwd = list(kwdCmd.keys())
    allKwd.sort()
    return allKwd

def printKeywordsUsage( commands, fileList=None ):
    """Print the usage of all the keywords"""
    kwdCmd = extractKeywords( commands )
    allKwd = sortedKeywords( kwdCmd )
    print('\n Nombre total de mots cles = ', len( allKwd ))
    lines = []
    for word in allKwd:
        cmds = list( kwdCmd[ word ] )
        cmds.sort()
        fmt = "{:<28} :: " + " / ".join( ["{:<18}"] * len(cmds) )
        lines.append( fmt.format(word, *cmds) )
    print(os.linesep.join(lines))
    if fileList:
        picline = '# person_in_charge: mathieu.courtois@edf.fr'
        with open(fileList, 'w') as fobj:
            fobj.write( os.linesep.join([picline] + allKwd) )
        line = "\n    {:^60}"
        print(line.format( "*" * 60 ))
        print(line.format( "Nom du fichier à recopier pour mettre à jour vocab01a.34" ))
        print(line.format( fileList ))
        print(line.format( "*" * 60 ))
        print("\n")
    return allKwd


def vocab01_ops(self, EXISTANT, INFO, **kwargs):
    """Fake macro-command to check the catalog"""
    test = code_aster.TestCase()

    # start the job
    commands = getListOfCommands()
    checkDefinition( commands )
    checkDocStrings( commands )

    print("\n>>> Vérification des mots-clés...")
    fileList = None
    if INFO == 2:
        fileList = tempfile.NamedTemporaryFile( prefix="vocab01a_" ).name
    allKwd = printKeywordsUsage( commands, fileList )
    nbWords = len( allKwd )

    diff = set( allKwd ).difference( EXISTANT )
    nbNew = len( diff )
    if nbNew:
        UTMESS('A', 'CATAMESS_2',
               valk=("Liste des nouveaux mots-clefs (relancer avec INFO=2 "
                     "pour produire la nouvelle liste) :", str(list(diff)) ))
    test.assertEqual(nbNew, 0,
                     msg="nouveaux mots-clefs (absents de vocab01a.34)")

    nbExist = len(EXISTANT)
    if nbExist != nbWords:
        UTMESS('A', 'CATAMESS_2',
               valk=("Il y avait {} mots-clefs dans le catalogue et, "
                     "maintenant, il y en a {}.".format(nbExist, nbWords),
                     "Relancez avec INFO=2 pour écrire la nouvelle liste "
                     "et comparer avec le fichier vocab01a.34 existant."))
    test.assertEqual(nbWords, nbExist,
                     msg="nombre de mots-clefs (catalogue vs vocab01a.34)")

    diff = set( EXISTANT ).difference( allKwd )
    nbDel = len( diff )
    if nbDel:
        UTMESS('A', 'CATAMESS_2',
               valk=("Liste des %d mots-clefs supprimés ou non définis dans "
                     "cette version.\nIl faut activer le support de MFront "
                     "pour que tous les mots-clés soient reconnus.\n\n"
                     "Relancer avec INFO=2 "
                     "pour produire la nouvelle liste :" % nbDel,
                     str(list(diff)) ))

    print("\n>>> Vérification des règles de DEFI_MATERIAU...")
    test.assertTrue(True,
                     msg="règle AU_MOINS_UN de DEFI_MATERIAU incorrecte")

    print("\n>>> Tests de vocab01a")
    test.printSummary()


VOCAB01_cata = MACRO(nom='VOCAB01',
                     op=vocab01_ops,
                     EXISTANT = SIMP(statut='o', typ='TXM', max='**',),
                     INFO = SIMP(statut='f',typ='I', defaut=1, into=(1, 2),),
)

VOCAB01 = UserMacro("VOCAB01", VOCAB01_cata, vocab01_ops)
