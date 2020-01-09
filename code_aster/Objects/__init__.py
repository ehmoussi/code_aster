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
from .acousticsload_ext import AcousticsLoad
from .assemblymatrix_ext import (AssemblyMatrixDisplacementComplex,
                                 AssemblyMatrixDisplacementDouble)
from .dofnumbering_ext import DOFNumbering
from .dynamicmacroelement_ext import DynamicMacroElement
from .dynamicresults_ext import TransientGeneralizedResultsContainer
from .elementarycharacteristics_ext import ElementaryCharacteristics
from .elementarymatrix_ext import (ElementaryMatrixDisplacementComplex,
                                   ElementaryMatrixDisplacementDouble,
                                   ElementaryMatrixPressureComplex,
                                   ElementaryMatrixTemperatureDouble)
from .fieldonelements_ext import FieldOnElementsDouble
from .fieldonnodes_ext import FieldOnNodesDouble
from .formula_ext import Formula
from .function_ext import Function
from .generalizedassemblymatrix_ext import (GeneralizedAssemblyMatrixComplex,
                                            GeneralizedAssemblyMatrixDouble)
from .generalizedassemblyvector_ext import (GeneralizedAssemblyVectorComplex,
                                            GeneralizedAssemblyVectorDouble)
from .generalizedmodel_ext import GeneralizedModel
from .listoffloats import ListOfFloats
from .listofintegers_ext import ListOfIntegers
from .material_ext import Material
from .materialonmesh_ext import MaterialOnMesh
from .mechanicalload_ext import GenericMechanicalLoad
from .mesh_ext import Mesh
from .meshcoordinatesfield_ext import MeshCoordinatesField
from .model_ext import Model
from .pcfieldonmesh_ext import PCFieldOnMeshDouble
from .resultscontainer_ext import ResultsContainer
from .surface_ext import Surface
from .table_ext import Table
from .tablecontainer_ext import TableContainer
from .thermalload_ext import ThermalLoad
from .timestepmanager_ext import TimeStepManager
from .transientgeneralizedresultscontainer_ext import TransientGeneralizedResultsContainer
from .xfemcrack_ext import XfemCrack

# Define unusable objects
try:
    ParallelMesh
except NameError:
    class ParallelMesh(OnlyParallelObject):
        pass
try:
    PartialMesh
except NameError:
    class PartialMesh(OnlyParallelObject):
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
