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

# person_in_charge: mathieu.courtois at edf.fr

"""
Working module only used to help to change syntax of testcases.
It needs several changes in the source code:

- Add in ``E_JDC.py``:

  in ``JDC.__init__()``::

    from Contrib.change_syntax import SyntaxVisitor
    self.change_syntax = SyntaxVisitor()

  in ``JDC.affiche_fin_exec()``::

    self.change_syntax.finalize()

- In ``N_ETAPE.py``, in ``ETAPE.__init__()``::

    from Contrib.change_syntax import store_frame_info
    self.frame_info = store_frame_info(self.nom, niveau)

- In ``E_ETAPE.py``, in ``ETAPE.AfficheTexteCommande()``::

    self.accept(self.jdc.change_syntax)
"""

import linecache
import os
import os.path as osp
import re

from command_text import CommandTextVisitor
from E_utils import repr_float
from Noyau.N_ASSD import ASSD
from Noyau.N_info import LEVEL, Category, message
from Noyau.N_types import force_list
from Noyau.N_utils import cur_frame
from Noyau.N_FONCTION import initial_context

ALL = False
COMMANDS = ('PRE_GIBI', 'PRE_GMSH', 'PRE_IDEAS', 'LIRE_MAILLAGE')
FILENAME = 'change_syntax'
DEST = osp.join(os.environ['HOME'], 'change_syntax')
STX = Category()
STX.set_header(LEVEL.DEBUG, 'DEBUG:')
message.add(STX)
message.set_level(STX, LEVEL.DEBUG)


def store_frame_info(command, level):
    """Store frame info executing the command.

    Arguments:
        command (str): Command name (used to find the beginning of the command).
        level (int): Number of frame to find upper the command caller.

    Returns:
        tuple: Tuple containing the number of the first and last lines of the
        command, the length of indentation and the filename.
    """
    pattern_comment = re.compile(r"^\s*#.*")
    expr = r"^(?P<indent> *)(?:|\S.*?\s*=\s*){0}\s*\(".format(command)
    pattern_oper = re.compile(expr, re.M)
    frame = cur_frame(level)
    fname = frame.f_code.co_filename
    start = -1
    end = frame.f_lineno
    indent = 0
    lineno = end
    while lineno > 0:
        line = linecache.getline(fname, lineno)
        lineno = lineno - 1
        if pattern_comment.match(line):
            continue
        mat = pattern_oper.search(line)
        if mat:
            start = lineno
            indent = len(mat.group('indent'))
            break
    assert start >= 0, (command, end)
    return start, end, indent, fname


class SyntaxVisitor(CommandTextVisitor):

    """Visitor to mass-convert command files.
    """

    def __init__(self, with_default=False):
        """Initialization.
        with_default : if True, visit the default values of undefined keywords
        """
        CommandTextVisitor.__init__(self, with_default)
        self.cmdname = None
        self.command = None
        self._pass = 0
        self.text = {}
        try:
            os.makedirs(DEST)
        except OSError:
            pass

    def _visit_etape(self, step, reuse):
        """Visit generic ETAPE objects."""
        if not (ALL or step.definition.nom in COMMANDS):
            return
        self.cmdname = step.definition.nom
        self.command = ChangeFactory(self.cmdname)
        # first pass to store keywords values
        message.debug(STX, "visit ETAPE - pass 1: %s", self.cmdname)
        self._pass = 1
        self._visitMCCOMPO(step)
        # second pass to change some keywords and eventually their values
        message.debug(STX, "visit ETAPE - pass 2: %s", self.cmdname)
        CommandTextVisitor.__init__(self, self.with_default, indent=0)
        self._pass = 2
        CommandTextVisitor._visit_etape(self, step, reuse)
        self.store_changes(step)

    def visitMCFACT(self, fact):
        """Visit the MCFACT object."""
        self.command.set_current_mcfact(fact)
        if self._pass == 2:
            self.command.init_pass2()
        CommandTextVisitor.visitMCFACT(self, fact)
        self.command.reset_mcfact()

    def visitMCSIMP(self, mcsimp):
        """Visit the MCSIMP object."""
        if mcsimp.definition.statut == 'c':
            return
        if self._pass == 1:
            svalues = self._repr_MCSIMP(mcsimp)
            if len(svalues) == 1:
                svalues = svalues[0]
            self.command.set_value(mcsimp.nom, svalues)
        if self._pass == 2:
            newvalues = self.command.get_value(mcsimp.nom)
            for i, couple in enumerate(newvalues):
                key, val = couple
                self.curline.extend([key, "=", val, ","])
                self._count += 1
                if i + 1 < len(newvalues):
                    self._newline()

    def store_changes(self, step):
        """Store new command text"""
        inf = step.frame_info
        assert inf, 'ERROR: command:%s, can not get line numbers' % self.cmdname
        start, end, indent, fname = inf
        cmdtext = self.get_text()
        if self.command.empty:
            cmdtext = ""
        values = (start, end, indent, cmdtext, )
        self.text[fname] = self.text.get(fname, [])
        self.text[fname].append(values)
        message.debug(STX, "stored: %s : %r", fname, values)

    def finalize(self, code=None):
        """End"""
        import shutil
        from glob import glob
        from asrun.profil import AsterProfil
        num = len(glob(FILENAME + '.*')) + 1
        lfn = [i for i in self.text.keys() if i.startswith('fort.')]
        assert len(lfn) <= 1, lfn
        if len(lfn) == 0:
            fname = 'fort.1'
        else:
            fname = lfn[0]
        changes = self.text.get(fname, [])
        orig = open(fname, 'r').read().splitlines()
        new = orig[:]
        changes.reverse()
        for chg in changes:
            start, end, indent, txt = chg
            offset = ' ' * indent
            nlin = [offset + lin for lin in txt.splitlines()]
            new = new[:start] + nlin + new[end:]
        if new[-1].strip():
            new.append('')

        modified = '{0}.{1}'.format(FILENAME, num)
        with open(modified, 'w') as fobj:
            fobj.write(os.linesep.join(new))

        exp = glob('*.export')
        if len(exp) == 0:
            return
        assert len(exp) == 1, exp
        prof = AsterProfil(exp[0])
        comm = prof.get_type('comm')
        final = osp.basename(comm[num - 1].path)
        shutil.copy(modified, osp.join(DEST, final))
        # shutil.copy(fname, osp.join(DEST, final + '.orig'))


class ChangeCommand(object):

    """Functions to change a command."""

    def __init__(self):
        """Initialization"""
        self.kwval = {}
        self.mcfact_id = None
        self.cur_vale_calc = None
        # Set to *True* to removed the command
        self.empty = False

    def _cur_dict(self):
        """Return the current storage."""
        dico = self.kwval[self.mcfact_id] = self.kwval.get(self.mcfact_id, {})
        return dico

    def set_current_mcfact(self, fact):
        """Register the current MCFACT."""
        self.mcfact_id = id(fact)

    def reset_mcfact(self):
        """Register the current MCFACT."""
        self.mcfact_id = None

    def set_value(self, keyword, value):
        """Store the value of a keyword"""
        # Warning: _cur_dict does not contain the values but a representation
        # of the values
        message.debug(STX, "store: %r = %r", keyword, value)
        self._cur_dict()[keyword] = value

    def get_value(self, keyword):
        """Return the couples (new keyword, new value)."""
        svalues = self._cur_dict()[keyword]
        if type(svalues) in (list, tuple):
            svalues = "(" + ", ".join(svalues) + ")"
        res = [(keyword, svalues), ]
        return res

    def init_pass2(self):
        """Start the pass 2.
        Extract the 'vale_calc' values for the current MCFACT."""
        self.vale_calc = vale_calc.get()
        message.debug(STX, "vale_calc = %s", self.vale_calc)
        self.cur_vale_calc = self.vale_calc and self.vale_calc.pop(
            0) or 0.123456


class NoChange(ChangeCommand):

    """Does nothing"""

    def init_pass2(self):
        pass


class ChangeTestFonction(ChangeCommand):

    """Change TEST_FONCTION syntax"""

    def get_value(self, keyword):
        """Return the couples (new keyword, new value)."""
        dico = self._cur_dict()
        value = dico[keyword]
        reference = dico.get('REFERENCE', repr('NON_REGRESSION'))
        precision = dico.get('PRECISION', 1.e-3)
        really_nonreg = reference == repr(
            'NON_REGRESSION') and float(precision) <= 1.e-6
        if really_nonreg:
            dconv = {
                'REFERENCE': [],  # NON_REGRESSION is implicit
                'PRECISION': [],
                'VALE_REFE': [('VALE_CALC', dico['VALE_REFE']), ],
            }
            if float(precision) < 1.e-6:  # more severe than by default
                dconv['PRECISION'] = [('TOLE_MACHINE', value), ]
        else:
            dconv = {
                'VALE_REFE': [('VALE_REFE', dico['VALE_REFE']),
                              ('VALE_CALC', repr_float(self.cur_vale_calc))],
            }
            if reference == repr('NON_REGRESSION'):
                dconv['REFERENCE'] = [('REFERENCE', repr('NON_DEFINI')), ]
        res = dconv.get(keyword, [(keyword, value), ])
        return res


class ChangeTestResu(ChangeCommand):

    """Change TEST_RESU syntax"""

    def get_value(self, keyword):
        """Return the couples (new keyword, new value)."""
        dico = self._cur_dict()
        value = dico[keyword]
        reference = dico.get('REFERENCE', repr('NON_REGRESSION'))
        precision = dico.get('PRECISION', 1.e-3)
        really_nonreg = reference == repr(
            'NON_REGRESSION') and float(precision) <= 1.e-6
        message.info(STX, 'NON_REGRESSION ? %s', really_nonreg)
        val = dico.get('VALE') or dico.get('VALE_I') or dico.get('VALE_R')
        if really_nonreg:
            dconv = {
                'REFERENCE': [],  # NON_REGRESSION is implicit
                'PRECISION': [],
                'VALE': [('VALE_CALC', dico['VALE']), ],
            }
            if float(precision) < 1.e-6:  # more severe than by default
                dconv['PRECISION'] = [('TOLE_MACHINE', value), ]
        else:
            dconv = {
                'VALE': [('VALE_REFE', dico['VALE']),
                         ('VALE_CALC', repr_float(self.cur_vale_calc))],
            }
            if reference == repr('NON_REGRESSION'):
                dconv['REFERENCE'] = [('REFERENCE', repr('NON_DEFINI')), ]
        res = dconv.get(keyword, [(keyword, value), ])
        return res


class ChangeFormule27515(ChangeCommand):
    """Change FORMULE for issue27515"""

    def get_value(self, keyword):
        """Return the couples (new keyword, new value)."""
        dico = self._cur_dict()
        value = dico[keyword]
        # list(repr(str)) ["'X'", "'Y'"] -> repr(list(str)): "['X', 'Y']"
        params = dico['NOM_PARA']
        if isinstance(params, (list, tuple)):
            params = [eval(i) for i in params]
        else:
            params = eval(params)
        if keyword == 'NOM_PARA':
            value = repr(params)

        dconv = {}
        if keyword in ('VALE', 'VALE_C'):
            formula = dico.get('VALE') or dico.get('VALE_C')
            if r'\n' in value:
                value = '''"""{0}"""'''.format(eval(value))
            needed = external_objects(params, eval(formula))
            values = [(keyword, value), ]
            for name in needed:
                values.append((name, name))
            dconv = {keyword: values}

        res = dconv.get(keyword, [(keyword, value), ])
        # print "  return:", res
        return res


class InfoStorage(object):

    def __init__(self):
        self.infos = {}
        self.last = None

    def store(self, key, value):
        print "DEBUG: store", value
        self.infos[key] = value
        self.last = key

    def pop(self, key):
        return self.infos.pop(key)

storage = InfoStorage()


class ChangePreXXX(ChangeCommand):
    """Change PRE_xxxx commands for 27911"""

    def __init__(self):
        super(ChangePreXXX, self).__init__()
        self.empty = True
        storage.store(id(self), (self.name, '19'))

    def get_value(self, keyword):
        """Return the couples (new keyword, new value)."""
        dico = self._cur_dict()
        value = dico[keyword]
        unit = dico.get('UNITE_' + self.name, '19')

        storage.store(id(self), (self.name, unit))
        return [(keyword, value), ]


class ChangePreGibi(ChangePreXXX):
    name = 'GIBI'

class ChangePreGmsh(ChangePreXXX):
    name = 'GMSH'

class ChangePreIdeas(ChangePreXXX):
    name = 'IDEAS'


class ChangeLireMaillage(ChangeCommand):
    """Change PRE_xxxx commands for 27911"""

    def __init__(self):
        super(ChangeLireMaillage, self).__init__()
        self.done = False
        try:
            self.fmt, self.unit = storage.pop(storage.last)
        except KeyError:
            self.fmt, self.unit = None, '19'

    def get_value(self, keyword):
        """Return the couples (new keyword, new value)."""
        if self.done:
            return []

        dico = self._cur_dict()
        value = dico[keyword]
        if self.fmt is None:
            return [(keyword, value), ]

        current = [('FORMAT', repr(self.fmt)), ('UNITE', self.unit)]
        dconv = {'FORMAT': current, 'UNITE': current}
        self.done = True

        res = dconv.get(keyword, [(keyword, value), ])
        return res


def ChangeFactory(cmdname):
    if cmdname == 'PRE_GIBI':
        return ChangePreGibi()
    elif cmdname == 'PRE_GMSH':
        return ChangePreGmsh()
    elif cmdname == 'PRE_IDEAS':
        return ChangePreIdeas()
    elif cmdname == 'LIRE_MAILLAGE':
        return ChangeLireMaillage()
    else:
        return NoChange()


class StoreValeCalc(object):

    def __init__(self):
        self._vale = None

    def reset(self):
        self._vale = []

    def append(self, value):
        self._vale.append(value)

    def get(self):
        return self._vale

vale_calc = StoreValeCalc()


def is_func(formula, name):
    """Check if 'name' seems to be used as a function in the formula.

    Arguments:
        formula (str): Expression of the formula.
        name (str): Objects to be tested.

    Returns:
        bool: *True* if the objects is used as a function, *False* otherwise.
    """
    expr = re.compile(r'\b{0}\b\('.format(name))
    return expr.search(formula) is not None

def external_objects(params, formula):
    """Search for external functions/parameters needed by a formula.

    Arguments:
        params (list[str]): Known parameters of the formula.
        formula (str): Expression of the formula.

    Returns:
        list[str]: List of required objects.
    """
    from random import random
    expr = re.compile("name '(.*)' is not defined")
    needed = []
    ok = False
    if not isinstance(params, (list, tuple)):
        params = [params]
    context = {}
    context.update(initial_context())
    context.update(dict([p, random()] for p in params))
    while not ok:
        init = len(context)
        try:
            formula = ''.join(formula.splitlines())
            eval(formula.strip(), {}, context)
            ok = True
        except NameError as exc:
            mat = expr.search(exc.args[0])
            if mat:
                name = mat.group(1)
                needed.append(name)
                if is_func(formula, name):
                    def _func(*_, **__):
                        "A function that accepts any number of arguments."
                        return random()
                    context[name] = _func
                else:
                    context[name] = random()
        if len(context) == init:
            break
    if not ok:
        print "ERROR: can not evaluate '{0}'".format(formula)
    return needed
