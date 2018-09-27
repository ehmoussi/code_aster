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
:py:mod:`general` --- Definition of utilities for general purpose
*****************************************************************
"""

# This function exists in AsterStudy - keep consistency.
def initial_context():
    """Returns *initial* Python context used for evalutations of formula.

    Returns:
        dict: pairs of name per corresponding Python instance.
    """
    import __builtin__
    import math
    context = {}
    context.update(__builtin__.__dict__)
    for func in dir(math):
        if not func.startswith('_'):
            context[func] = getattr(math, func)
    return context
