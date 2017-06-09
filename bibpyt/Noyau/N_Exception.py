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
   Ce module contient la classe AsException
"""

# Modules EFICAS
from strfunc import get_encoding, to_unicode


class AsException(Exception):

    def __unicode__(self):
        args = []
        for x in self.args:
            ustr = to_unicode(x)
            if type(ustr) is not unicode:
                ustr = unicode( repr(x) )
            args.append(ustr)
        return " ".join(args)

    def __str__(self):
        return unicode(self).encode(get_encoding())


class OpsError(AsException):
    """Exception raised in case of error during OPS functions."""


class InterruptParsingError(Exception):

    """Exception used to interrupt the parsing of the command file
    without raising an error (see N_JDC.exec_compile for usage)"""
