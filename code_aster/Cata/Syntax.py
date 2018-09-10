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
Module Syntax
-------------

This module defines objects for the commands definition (SIMP, FACT, BLOC...).

It works as a switch between the legacy supervisor and the next generation
of the commands language (already used by AsterStudy).
"""

from . import HAVE_ASTERSTUDY

if not HAVE_ASTERSTUDY:
    from .Legacy.Syntax import *
    from .Legacy.Syntax import _F

else:
    from .Language.Syntax import *
    from .Language.Syntax import _F


class Translation(object):
    """Class to dynamically assign a translation function.

    The package Cata must stay independent. So the translation function will
    be defined by code_aster or by AsterStudy.
    """

    def __init__(self):
        self._func = lambda arg: arg

    def set_translator(self, translator):
        """Define the translator function.

        Args:
            translator (function): Function returning the translated string.
        """
        self._func = translator

    def __call__(self, arg):
        """Return the translated string"""
        if type(arg) is unicode:
            uarg = arg
        else:
            uarg = arg.decode('utf-8', 'replace')
        return self._func(uarg)

tr = Translation()
