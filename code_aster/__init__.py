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

# person_in_charge: mathieu.courtois@edf.fr

# discourage import *
__all__ = []

import sys

from code_aster.Supervis import setExecutionParameter


# The `aster_init_options` module allows a custom startup
mode = 0
try:
    from aster_init_options import options
except ImportError:
    options = ['']

# used to build the elements catalog
if 'CATAELEM' in options:
    print "starting with mode = 1 (build CATAELEM)..."
    mode = 1

# standard startup
if 'MANUAL' not in options:
    from code_aster.RunManager import Initializer
    from code_aster.Supervis import executionParameter

    executionParameter.parse_args( sys.argv )
    Initializer.init( mode )

    import atexit
    atexit.register( Initializer.finalize )

# import datastructures, physical quantities and constants
# each package is responsible to export only the relevant objects
from code_aster.DataFields import *
from code_aster.Function import *
from code_aster.LinearAlgebra import *
from code_aster.Materials import *
from code_aster.Mesh import *
from code_aster.Modeling import *
from code_aster.Results import *
from code_aster.Solvers import *
from code_aster.Loads import *


del mode, options, sys, atexit
