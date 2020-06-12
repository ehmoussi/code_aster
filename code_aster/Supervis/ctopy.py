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

'''
This module defines objects called from C (C to Python).
'''

import sys
import time
from datetime import datetime

import numpy

import aster
import aster_core

from ..Messages import UTMESS
from ..Utilities import (ExecutionParameter, get_version, get_version_desc,
                         localization, version_info)


def _print_alarm():
    """Emet une alarme en cas de modification de la version du dépôt"""
    changes = version_info.changes
    uncommitted = version_info.uncommitted
    if changes:
        UTMESS('I', 'SUPERVIS_41',
               valk=get_version(), vali=changes)
    if uncommitted and type(uncommitted) is list:
        fnames = ', '.join(uncommitted)
        UTMESS('A', 'SUPERVIS_42',
               valk=(version_info.parentid, fnames),)


def _print_header():
    """Appelé par entete.F90 pour afficher des informations sur
    la machine."""
    lang_settings = '%s (%s)' % localization.get_current_settings()
    date_build = version_info.date
    UTMESS('I', 'SUPERVIS2_4',
           valk=get_version_desc())
    UTMESS('I', 'SUPERVIS2_23',
           valk=(get_version(),
                 date_build,
                 version_info.parentid[:12],
                 version_info.branch),)
    params = ExecutionParameter()
    UTMESS('I', 'SUPERVIS2_10',
           valk=("1991", time.strftime('%Y'),
                 time.strftime('%c'),
                 params.get_option('hostname'),
                 params.get_option('architecture'),
                 params.get_option('processor'),
                 params.get_option('osname'),
                 lang_settings,),)
    pyvers = '%s.%s.%s' % tuple(sys.version_info[:3])
    UTMESS('I', 'SUPERVIS2_9', valk=(pyvers, numpy.__version__))
    # avertissement si la version a plus de 15 mois
    if aster_core._NO_EXPIR == 0:
        try:
            d0, m0, y0 = list(map(int, date_build.split('/')))
            tbuild = datetime(y0, m0, d0)
            tnow = datetime.today()
            delta = (tnow - tbuild).days
            if delta > 550:
                UTMESS('A', 'SUPERVIS2_2')
        except ValueError:
            pass


def print_header(part):
    """Appelé par entete.F90 pour afficher des informations sur la machine.
    Certaines informations étant obtenues en fortran, une partie des messages
    est imprimée par le fortran. On a donc découpé en plusieurs morceaux.
    part = 1 : entête principal : ici
    part = 2 : informations librairies : dans entete.F90
    part = 3 : message d'alarme en cas de modification du code source : ici
    """
    if part == 1:
        _print_header()
    elif part == 3:
        _print_alarm()
    else:
        raise ValueError("unknown value for 'part'")


def checksd(nomsd, typesd):
    """
    Vérifie la validité de la SD `nom_sd` (nom jeveux) de type `typesd`.
    Exemple : typesd = sd_maillage
    C'est le pendant de la "SD.checksd.check" à partir d'objets nommés.
    Code retour :
      0 : tout est ok
      1 : erreurs lors du checksd
      4 : on n'a meme pas pu tester
    """
    nomsd = nomsd.strip()
    typesd = typesd.strip().lower()
    # import
    iret = 4
    try:
        sd_module = __import__("code_aster.SD.%s" % typesd, globals(), locals(),
                               [typesd])
    except ImportError as msg:
        UTMESS('F', 'SDVERI_1', valk=typesd)
        return iret
    # on récupère la classe typesd
    clas = getattr(sd_module, typesd, None)
    if not clas:
        return iret

    objsd = clas(nomj=nomsd)
    chk = objsd.check()
    ichk = min([1, ] + [level for level, obj, msg in chk.msg])
    if ichk == 0:
        iret = 1
    else:
        iret = 0
    # on imprime les messages d'erreur (level=0):
    for level, obj, msg in chk.msg:
        if level == 0:
            aster.affiche('MESSAGE', repr(obj) + msg)
    return iret
