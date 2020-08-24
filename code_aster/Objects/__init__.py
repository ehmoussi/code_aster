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

# person_in_charge: mathieu.courtois@edf.fr

"""
This module imports BoostPython DataStructures and extends them with pure
Python functions.
"""

from libaster import *

# ensure DataStructure is extended first
from .datastructure_ext import (AsFloat, AsInteger, DataStructure,
                                OnlyParallelObject, PyDataStructure)

# extend DataStructures using metaclasses
from .acousticload_ext import AcousticLoad
from .assemblymatrix_ext import (AssemblyMatrixDisplacementComplex,
                                 AssemblyMatrixDisplacementReal)
from .constantfieldoncells_ext import ConstantFieldOnCellsReal
from .dofnumbering_ext import DOFNumbering
from .dynamicmacroelement_ext import DynamicMacroElement
from .dynamicresults_ext import TransientGeneralizedResult
from .elementarycharacteristics_ext import ElementaryCharacteristics
from .elementarymatrix_ext import (ElementaryMatrixDisplacementComplex,
                                   ElementaryMatrixDisplacementReal,
                                   ElementaryMatrixPressureComplex,
                                   ElementaryMatrixTemperatureReal)
from .fieldoncells_ext import FieldOnCellsReal
from .fieldonnodes_ext import FieldOnNodesReal
from .formula_ext import Formula
from .function2d_ext import Function2D
from .function_ext import Function
from .generalizedassemblymatrix_ext import (GeneralizedAssemblyMatrixComplex,
                                            GeneralizedAssemblyMatrixReal)
from .generalizedassemblyvector_ext import (GeneralizedAssemblyVectorComplex,
                                            GeneralizedAssemblyVectorReal)
from .generalizedmodel_ext import GeneralizedModel
from .listoffloats import ListOfFloats
from .listofintegers_ext import ListOfIntegers
from .material_ext import Material
from .materialfield_ext import MaterialField
from .mechanicalload_ext import GenericMechanicalLoad
from .mesh_ext import Mesh
from .meshcoordinatesfield_ext import MeshCoordinatesField
from .model_ext import Model
from .prestressingcable_ext import PrestressingCable
from .result_ext import Result
from .table_ext import Table
from .tablecontainer_ext import TableContainer
from .thermalload_ext import ThermalLoad
from .timestepmanager_ext import TimeStepManager
from .transientgeneralizedresultscontainer_ext import \
    TransientGeneralizedResult
from .xfemcrack_ext import XfemCrack

# Define unusable objects
try:
    ParallelMesh
except NameError:
    class ParallelMesh(OnlyParallelObject):
        pass
try:
    ConnectionMesh
except NameError:
    class ConnectionMesh(OnlyParallelObject):
        pass
try:
    ParallelMechanicalLoad
except NameError:
    class ParallelMechanicalLoad(OnlyParallelObject):
        pass
try:
    ParallelDOFNumbering
except NameError:
    class ParallelDOFNumbering(OnlyParallelObject):
        pass
