# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois@edf.fr

"""
:py:mod:`typeaster` --- Understanding code_aster types
******************************************************

This module gives basic functions to convert types as defined in catalogs
to their corresponding C++ objects, or their type names as string.
"""


def typeaster(cata_type):
    """Convert a code_aster type used in the syntax description as a string.

    Arguments:
        cata_type (misc): Type of a keyword.

    Returns:
        str: Name of the code_aster type.
    """
    if isinstance(cata_type, (list, tuple)):
        return [typeaster(i) for i in cata_type]

    dtyp = {'R': 'R8', 'C': 'C8', 'I': 'IS', 'TXM': 'TX'}
    name = dtyp.get(cata_type)
    if not name:
        name = cata_type.getType()
        if name == 'entier':
            name = 'IS'
        elif name == 'reel':
            name = 'R8'
    return name
