/**
 * @file AssemblyMatrixInterface.cxx
 * @brief Interface python de AssemblyMatrix
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>

namespace py = boost::python;
#include "PythonBindings/AssemblyMatrixInterface.h"
#include <PythonBindings/factory.h>

void exportAssemblyMatrixToPython() {

    void ( AssemblyMatrixDisplacementRealClass::*c1 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementRealClass::addLoad;
    void ( AssemblyMatrixDisplacementRealClass::*c2 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementRealClass::addLoad;

    py::class_< AssemblyMatrixDisplacementRealClass, AssemblyMatrixDisplacementRealPtr,
                py::bases< DataStructure > >( "AssemblyMatrixDisplacementReal", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementRealClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementRealClass, std::string >))
        .def( "addKinematicsLoad", c1 )
        .def( "addKinematicsLoad", c2 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementRealClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixDisplacementRealClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementRealClass::getDOFNumbering )
        .def( "getModel", &AssemblyMatrixDisplacementRealClass::getModel, R"(
Return the model.

Returns:
    ModelPtr: a pointer to the model
        )",
              ( py::arg( "self" )))
        .def( "getMesh", &AssemblyMatrixDisplacementRealClass::getMesh, R"(
Return the mesh.

Returns:
    MeshPtr: a pointer to the mesh
        )",
              ( py::arg( "self" ) ) )
        .def( "getMaterialField", &AssemblyMatrixDisplacementRealClass::getMaterialField )
        .def( "isEmpty", &AssemblyMatrixDisplacementRealClass::isEmpty, R"(
Test if the matrix is empty.

Returns:
    Bool: true if the matrix is empty
        )",
              ( py::arg( "self" )) )
.def( "isFactorized", &AssemblyMatrixDisplacementRealClass::isFactorized, R"(
Test if the matrix is factorized.

Returns:
    Bool: true if the matrix is factorized
        )",
              ( py::arg( "self" )) )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementRealClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementRealClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixDisplacementRealClass::setSolverName )
        .def( "setValues", &AssemblyMatrixDisplacementRealClass::setValues, R"(
Erase the assembly matrix and set new values in it. 
The new values are in coordinate format (i, j, aij). The matrix  must be stored in CSR format.
There is no rule for the indices - they can be in arbitrary order and can be repeated. Repeated
indices are sumed according to an assembly process.

Arguments:
    idx (list[int]): List of the row indices.
    jdx (list[int]): List of the column indices.
    values (list[float]): List of the values.
        )")
        .def( "transpose", &AssemblyMatrixDisplacementRealClass::transpose );

    void ( AssemblyMatrixDisplacementComplexClass::*c3 )(
        const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementComplexClass::addLoad;
    void ( AssemblyMatrixDisplacementComplexClass::*c4 )( const KinematicsLoadPtr &currentLoad,
                                                             const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementComplexClass::addLoad;

    py::class_< AssemblyMatrixDisplacementComplexClass, AssemblyMatrixDisplacementComplexPtr,
                py::bases< DataStructure > >( "AssemblyMatrixDisplacementComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementComplexClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementComplexClass, std::string >))
        .def( "addKinematicsLoad", c3 )
        .def( "addKinematicsLoad", c4 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementComplexClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixDisplacementComplexClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementComplexClass::getDOFNumbering )
        .def( "transpose", &AssemblyMatrixDisplacementComplexClass::transpose )
        .def( "transposeConjugate", &AssemblyMatrixDisplacementComplexClass::transposeConjugate )
        .def( "getMaterialField", &AssemblyMatrixDisplacementComplexClass::getMaterialField )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementComplexClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementComplexClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixDisplacementComplexClass::setSolverName );

    void ( AssemblyMatrixTemperatureRealClass::*c5 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureRealClass::addLoad;
    void ( AssemblyMatrixTemperatureRealClass::*c6 )( const KinematicsLoadPtr &currentLoad,
                                                           const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureRealClass::addLoad;

    py::class_< AssemblyMatrixTemperatureRealClass, AssemblyMatrixTemperatureRealPtr,
                py::bases< DataStructure > >( "AssemblyMatrixTemperatureReal", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureRealClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureRealClass, std::string >))
        .def( "addKinematicsLoad", c5 )
        .def( "addKinematicsLoad", c6 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureRealClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixTemperatureRealClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureRealClass::getDOFNumbering )
        .def( "getMaterialField", &AssemblyMatrixTemperatureRealClass::getMaterialField )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureRealClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureRealClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixTemperatureRealClass::setSolverName )
        .def( "setValues", &AssemblyMatrixTemperatureRealClass::setValues, R"(
Erase the assembly matrix and set new values in it. 
The new values are in coordinate format (i, j, aij). The matrix  must be stored in CSR format.
There is no rule for the indices - they can be in arbitrary order and can be repeated. Repeated
indices are sumed according to an assembly process.

Arguments:
    idx (list[int]): List of the row indices.
    jdx (list[int]): List of the column indices.
    values (list[float]): List of the values.
        )");

    void ( AssemblyMatrixTemperatureComplexClass::*c7 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureComplexClass::addLoad;
    void ( AssemblyMatrixTemperatureComplexClass::*c8 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureComplexClass::addLoad;

    py::class_< AssemblyMatrixTemperatureComplexClass, AssemblyMatrixTemperatureComplexPtr,
                py::bases< DataStructure > >( "AssemblyMatrixTemperatureComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureComplexClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureComplexClass, std::string >))
        .def( "addKinematicsLoad", c7 )
        .def( "addKinematicsLoad", c8 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureComplexClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixTemperatureComplexClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureComplexClass::getDOFNumbering )
        .def( "getMaterialField", &AssemblyMatrixTemperatureComplexClass::getMaterialField )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureComplexClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureComplexClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixTemperatureComplexClass::setSolverName );

    void ( AssemblyMatrixPressureRealClass::*c9 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureRealClass::addLoad;
    void ( AssemblyMatrixPressureRealClass::*c10 )( const KinematicsLoadPtr &currentLoad,
                                                         const FunctionPtr &func ) =
        &AssemblyMatrixPressureRealClass::addLoad;

    py::class_< AssemblyMatrixPressureRealClass, AssemblyMatrixPressureRealPtr,
                py::bases< DataStructure > >( "AssemblyMatrixPressureReal", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixPressureRealClass >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< AssemblyMatrixPressureRealClass, std::string >))
        .def( "addKinematicsLoad", c9 )
        .def( "addKinematicsLoad", c10 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureRealClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixPressureRealClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureRealClass::getDOFNumbering )
        .def( "getMaterialField", &AssemblyMatrixPressureRealClass::getMaterialField )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureRealClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureRealClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixPressureRealClass::setSolverName )
        .def( "setValues", &AssemblyMatrixPressureRealClass::setValues, R"(
Erase the assembly matrix and set new values in it. 
The new values are in coordinate format (i, j, aij). The matrix  must be stored in CSR format.
There is no rule for the indices - they can be in arbitrary order and can be repeated. Repeated
indices are sumed according to an assembly process.

Arguments:
    idx (list[int]): List of the row indices.
    jdx (list[int]): List of the column indices.
    values (list[float]): List of the values.
        )");

    void ( AssemblyMatrixPressureComplexClass::*c11 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureComplexClass::addLoad;
    void ( AssemblyMatrixPressureComplexClass::*c12 )( const KinematicsLoadPtr &currentLoad,
                                                          const FunctionPtr &func ) =
        &AssemblyMatrixPressureComplexClass::addLoad;

    py::class_< AssemblyMatrixPressureComplexClass, AssemblyMatrixPressureComplexPtr,
                py::bases< DataStructure > >( "AssemblyMatrixPressureComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixPressureComplexClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixPressureComplexClass, std::string >))
        .def( "addKinematicsLoad", c11 )
        .def( "addKinematicsLoad", c12 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureComplexClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixPressureComplexClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureComplexClass::getDOFNumbering )
        .def( "getMaterialField", &AssemblyMatrixPressureComplexClass::getMaterialField )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureComplexClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureComplexClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixPressureComplexClass::setSolverName );
};
