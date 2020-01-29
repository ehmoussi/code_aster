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

    void ( AssemblyMatrixDisplacementDoubleClass::*c1 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementDoubleClass::addLoad;
    void ( AssemblyMatrixDisplacementDoubleClass::*c2 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementDoubleClass::addLoad;

    py::class_< AssemblyMatrixDisplacementDoubleClass, AssemblyMatrixDisplacementDoublePtr,
                py::bases< DataStructure > >( "AssemblyMatrixDisplacementDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementDoubleClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementDoubleClass, std::string >))
        .def( "addKinematicsLoad", c1 )
        .def( "addKinematicsLoad", c2 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementDoubleClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixDisplacementDoubleClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementDoubleClass::getDOFNumbering )
        .def( "getModel", &AssemblyMatrixDisplacementDoubleClass::getModel, R"(
Return the model.

Returns:
    ModelPtr: a pointer to the model
        )",
              ( py::arg( "self" )))
        .def( "getMesh", &AssemblyMatrixDisplacementDoubleClass::getMesh, R"(
Return the mesh.

Returns:
    MeshPtr: a pointer to the mesh
        )",
              ( py::arg( "self" ) ) )
        .def( "getMaterialOnMesh", &AssemblyMatrixDisplacementDoubleClass::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementDoubleClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementDoubleClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixDisplacementDoubleClass::setSolverName );

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
        .def( "getMaterialOnMesh", &AssemblyMatrixDisplacementComplexClass::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementComplexClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementComplexClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixDisplacementComplexClass::setSolverName );

    void ( AssemblyMatrixTemperatureDoubleClass::*c5 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureDoubleClass::addLoad;
    void ( AssemblyMatrixTemperatureDoubleClass::*c6 )( const KinematicsLoadPtr &currentLoad,
                                                           const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureDoubleClass::addLoad;

    py::class_< AssemblyMatrixTemperatureDoubleClass, AssemblyMatrixTemperatureDoublePtr,
                py::bases< DataStructure > >( "AssemblyMatrixTemperatureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureDoubleClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureDoubleClass, std::string >))
        .def( "addKinematicsLoad", c5 )
        .def( "addKinematicsLoad", c6 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureDoubleClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixTemperatureDoubleClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureDoubleClass::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixTemperatureDoubleClass::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureDoubleClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureDoubleClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixTemperatureDoubleClass::setSolverName );

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
        .def( "getMaterialOnMesh", &AssemblyMatrixTemperatureComplexClass::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureComplexClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureComplexClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixTemperatureComplexClass::setSolverName );

    void ( AssemblyMatrixPressureDoubleClass::*c9 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureDoubleClass::addLoad;
    void ( AssemblyMatrixPressureDoubleClass::*c10 )( const KinematicsLoadPtr &currentLoad,
                                                         const FunctionPtr &func ) =
        &AssemblyMatrixPressureDoubleClass::addLoad;

    py::class_< AssemblyMatrixPressureDoubleClass, AssemblyMatrixPressureDoublePtr,
                py::bases< DataStructure > >( "AssemblyMatrixPressureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixPressureDoubleClass >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< AssemblyMatrixPressureDoubleClass, std::string >))
        .def( "addKinematicsLoad", c9 )
        .def( "addKinematicsLoad", c10 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureDoubleClass::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixPressureDoubleClass::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureDoubleClass::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixPressureDoubleClass::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureDoubleClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureDoubleClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixPressureDoubleClass::setSolverName );

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
        .def( "getMaterialOnMesh", &AssemblyMatrixPressureComplexClass::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureComplexClass::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureComplexClass::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixPressureComplexClass::setSolverName );
};
