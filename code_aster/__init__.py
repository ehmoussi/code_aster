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

# discourage import *
__all__ = []

import code_aster.Core
from code_aster.RunManager import Initializer

# Automatically call `asterInitialization()` at import
mode = 0
try:
    from aster_init_options import options
except ImportError:
    options = ['']

if 'CATAELEM' in options:
    print "starting with mode = 1 (build CATAELEM)..."
    mode = 1

if 'MANUAL' not in options:
    Initializer.init( mode )

    import atexit
    atexit.register( Initializer.finalize )

# import datastructures
from code_aster.Mesh.Mesh import Mesh
from code_aster.Modeling.Model import Model
from code_aster.DataFields.FieldOnNodes import FieldOnNodesDouble
from code_aster.Function.Function import Function

# replace by: from code_aster.Modeling import Physics and use Physics.Mechanics
from code_aster.Modeling.Model import Mechanics, Thermal, Acoustics
from code_aster.Modeling.Model import Axisymmetrical, Tridimensional, Planar, DKT

del mode
del options
