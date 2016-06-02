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

from .Supervis import executionParameter
from .RunManager import Initializer

executionParameter.parse_args()

# automatic startup
if executionParameter.get( 'autostart' ):
    Initializer.init( executionParameter.get( 'buildelem' ) )

# import general purpose functions
from .RunManager.saving import saveObjects
from .Utilities import TestCase

# import datastructures, physical quantities and constants
# each package is responsible to export only the relevant objects
from .DataFields import *
from .Function import *
from .LinearAlgebra import *
from .Materials import *
from .Mesh import *
from .Modeling import *
from .Results import *
from .Solvers import *
from .Loads import *
from .NonLinear import *
from .Algorithms import *
from .Studies import *
from .Discretization import *
from .Interactions import *

from .Cata import Commands
