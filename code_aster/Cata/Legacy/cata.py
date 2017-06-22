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
Module cata
-----------

*Kept for compatibility.*

This package imports the objects of the legacy supervisor of commands.
"""

from .Syntax import *
from .Syntax import _F
from .DataStructure import *
from code_aster.Cata.context import *
from code_aster.Cata.Commands import commandStore

# This is essentially for Cata.cata module to avoid potential
# conflicts between datastructures and modules names (example: comb_fourier).
globals().update(commandStore)
