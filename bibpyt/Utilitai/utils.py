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

# person_in_charge: mathieu.courtois at edf.fr

"""
Module fournissant quelques fonctions utilitaires.
"""

import os
import os.path as osp
import re
import time
from functools import partial
from subprocess import Popen
import tempfile

from Utilitai.string_utils import maximize_lines
from Execution.strfunc import convert

try:
    import aster
    aster_exists = True
except:
    aster_exists = False


DEBUG = False


def set_debug(value):
    """Positionne la variable de déboggage"""
    global DEBUG
    DEBUG = value


def _print(*args):
    """Fonction 'print'."""
    l_str = []
    for arg in args:
        if type(arg) not in (str, unicode):
            arg = repr(arg)
        l_str.append(arg)
    text = convert(" ".join(l_str))
    if aster_exists:
        aster.affiche('MESSAGE', text)
    else:
        print text


def _printDBG(*args):
    """Print debug informations."""
    if not DEBUG:
        return
    _print(*args)


def _debug(arg, label, dest='RESULTAT'):
    """Generic function for debugging
    :param arg: object to print
    :type arg: ASSD, string or iterable
    :param dest: output 'MESSAGE' or 'RESULTAT'
    :type dest: string
    """
    if not DEBUG:
        return
    from code_aster.Cata.Commands import IMPR_CO
    from code_aster.Cata.Syntax import _F, ASSD, MCFACT
    show = partial(aster.affiche, dest)
    if isinstance(arg, ASSD):
        show("#DEBUG: {} >>> {} <{}>".format(label, arg.nom, arg.__class__))
        IMPR_CO(UNITE=8 if dest == 'RESULTAT' else 6,
                CONCEPT=_F(NOM=arg),
                NIVEAU=-1)
    else:
        if type(arg) in (str, unicode):
            arg = convert(arg)
        else:
            try:
                if isinstance(arg, _F):
                    arg = [arg[i] for i in arg]
                for obj in arg:
                    _debug(obj, label, dest)
            except TypeError:
                arg = repr(arg)
            else:
                return
        show("#DEBUG: {} >>> {}".format(label, arg))


# les commandes fortran pourraient appeler cette fonction
def get_titre_concept(co=None):
    """Retourne un titre automatique."""
    # ASTER 10.01.25 CONCEPT tab0 CALCULE LE 21/05/2010 A 17:58:50 DE TYPE
    # TABLE_SDASTER
    import aster_core
    from Noyau.N_ASSD import ASSD
    if not isinstance(co, ASSD):
        co = None
    fmt = {
        "version": "ASTER %(version)s",
        "nomco": "CONCEPT %(nom_concept)s",
        "etatco": "CALCULE",
        "dateheure": "%(dateheure)s",
        "typeco": "DE TYPE %(type_concept)s",
    }
    format = [fmt["version"], ]
    dfmt = {
        "version": aster_core.get_version(),
        "dateheure": time.strftime("LE %m/%d/%Y A %H:%M:%S"),
    }
    if co:
        dfmt["nom_concept"] = co.nom
        format.append(fmt["nomco"])
        format.append(fmt["etatco"])
    format.append(fmt["dateheure"])
    if co:
        dfmt["type_concept"] = co.__class__.__name__.upper()
        format.append(fmt["typeco"])
    globfmt = " ".join(format)
    titre = globfmt % dfmt
    ltit = titre.split()
    ltit = maximize_lines(ltit, 80, " ")
    return os.linesep.join(ltit)


def fmtF2PY(fformat):
    """Convertit un format Fortran en format Python (printf style).
    Gère uniquement les fortrans réels, par exemple : E12.5, 1PE13.6, D12.5...
    """
    fmt = ''
    matP = re.search('([0-9]+)P', fformat)
    if matP:
        fmt += ' ' * int(matP.group(1))
    matR = re.search('([eEdDfFgG]{1})([\.0-9]+)', fformat)
    if matR:
        fmt += '%' + matR.group(2) + re.sub('[dD]+', 'E', matR.group(1))
    try:
        s = fmt % -0.123
    except (ValueError, TypeError), msg:
        fmt = '%12.5E'
        print 'Error :', msg
        print 'Format par défaut utilisé :', fmt
    return fmt


def encode_str(string):
    """Convert a string in an array of int"""
    return [ord(i) for i in string]


def decode_str(array):
    """Convert an array of int in a string"""
    return ''.join([chr(i) for i in array])


def send_file(fname, dest):
    """Send a file into an existing remote destination directory using scp"""
    dst = osp.join(dest, osp.basename(fname))
    proc = Popen(["scp", "-rBCq", "-o", "StrictHostKeyChecking=no", fname, dst])
    return proc.wait()

def get_time():
    """Return the current time with milliseconds"""
    ct =  time.time()
    msec = (ct - long(ct)) * 1000
    return time.strftime('%H:%M:%S') + '.%03d' % msec

def get_shared_tmpdir(prefix, default_dir=None):
    """Return a shared temporary directory.

    If asrun shared tmpdir is not known, use *default_dir*.
    """
    if getattr(get_shared_tmpdir, 'cache_run', None) is None:
        from asrun.run import AsRunFactory
        get_shared_tmpdir.cache_run = AsRunFactory()
    run = get_shared_tmpdir.cache_run

    shared_tmp = run.get('shared_tmp') or default_dir or os.getcwd()

    tmpdir = tempfile.mkdtemp(dir=shared_tmp, prefix=prefix)
    return tmpdir


if __name__ == '__main__':
    npar = ('X', 'Y',)
    nuti = ('DX', 'DY', 'X', 'X')
    print miss_dble(npar, nuti)
