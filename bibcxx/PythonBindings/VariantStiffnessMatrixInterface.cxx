/**
 * @file MechanicalModeContainerInterface.cxx
 * @brief Interface python de MechanicalModeContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "PythonBindings/VariantStiffnessMatrixInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>
#include <boost/variant.hpp>

namespace py = boost::python;

void exportStiffnessMatrixVariantToPython()
{

    py::to_python_converter< MatrixVariant, variant_to_object >();
    py::implicitly_convertible< AssemblyMatrixDisplacementDoublePtr, MatrixVariant >();
    py::implicitly_convertible< AssemblyMatrixDisplacementComplexPtr, MatrixVariant >();
    py::implicitly_convertible< AssemblyMatrixTemperatureDoublePtr, MatrixVariant >();
    py::implicitly_convertible< AssemblyMatrixPressureDoublePtr, MatrixVariant >();

    py::to_python_converter< GeneralizedMatrixVariant, variant_to_object >();
    py::implicitly_convertible< GeneralizedAssemblyMatrixDoublePtr, GeneralizedMatrixVariant >();
    py::implicitly_convertible< GeneralizedAssemblyMatrixComplexPtr, GeneralizedMatrixVariant >();
};
