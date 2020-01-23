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

    void ( AssemblyMatrixDisplacementDoubleInstance::*c1 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementDoubleInstance::addLoad;
    void ( AssemblyMatrixDisplacementDoubleInstance::*c2 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementDoubleInstance::addLoad;

    py::class_< AssemblyMatrixDisplacementDoubleInstance, AssemblyMatrixDisplacementDoublePtr,
                py::bases< DataStructure > >( "AssemblyMatrixDisplacementDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementDoubleInstance >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementDoubleInstance, std::string >))
        .def( "addKinematicsLoad", c1 )
        .def( "addKinematicsLoad", c2 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementDoubleInstance::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixDisplacementDoubleInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementDoubleInstance::getDOFNumbering )
        .def( "getModel", &AssemblyMatrixDisplacementDoubleInstance::getModel, R"(
Return the model.

Returns:
    ModelPtr: a pointer to the model
        )",
              ( py::arg( "self" )))
        .def( "getMesh", &AssemblyMatrixDisplacementDoubleInstance::getMesh, R"(
Return the mesh.

Returns:
    MeshPtr: a pointer to the mesh
        )",
              ( py::arg( "self" ) ) )
        .def( "getMaterialOnMesh", &AssemblyMatrixDisplacementDoubleInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementDoubleInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementDoubleInstance::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixDisplacementDoubleInstance::setSolverName );

    void ( AssemblyMatrixDisplacementComplexInstance::*c3 )(
        const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementComplexInstance::addLoad;
    void ( AssemblyMatrixDisplacementComplexInstance::*c4 )( const KinematicsLoadPtr &currentLoad,
                                                             const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementComplexInstance::addLoad;

    py::class_< AssemblyMatrixDisplacementComplexInstance, AssemblyMatrixDisplacementComplexPtr,
                py::bases< DataStructure > >( "AssemblyMatrixDisplacementComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementComplexInstance >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementComplexInstance, std::string >))
        .def( "addKinematicsLoad", c3 )
        .def( "addKinematicsLoad", c4 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementComplexInstance::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixDisplacementComplexInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementComplexInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixDisplacementComplexInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementComplexInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementComplexInstance::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixDisplacementComplexInstance::setSolverName );

    void ( AssemblyMatrixTemperatureDoubleInstance::*c5 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureDoubleInstance::addLoad;
    void ( AssemblyMatrixTemperatureDoubleInstance::*c6 )( const KinematicsLoadPtr &currentLoad,
                                                           const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureDoubleInstance::addLoad;

    py::class_< AssemblyMatrixTemperatureDoubleInstance, AssemblyMatrixTemperatureDoublePtr,
                py::bases< DataStructure > >( "AssemblyMatrixTemperatureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureDoubleInstance >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureDoubleInstance, std::string >))
        .def( "addKinematicsLoad", c5 )
        .def( "addKinematicsLoad", c6 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureDoubleInstance::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixTemperatureDoubleInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureDoubleInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixTemperatureDoubleInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureDoubleInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureDoubleInstance::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixTemperatureDoubleInstance::setSolverName );

    void ( AssemblyMatrixTemperatureComplexInstance::*c7 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureComplexInstance::addLoad;
    void ( AssemblyMatrixTemperatureComplexInstance::*c8 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureComplexInstance::addLoad;

    py::class_< AssemblyMatrixTemperatureComplexInstance, AssemblyMatrixTemperatureComplexPtr,
                py::bases< DataStructure > >( "AssemblyMatrixTemperatureComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureComplexInstance >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureComplexInstance, std::string >))
        .def( "addKinematicsLoad", c7 )
        .def( "addKinematicsLoad", c8 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureComplexInstance::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixTemperatureComplexInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureComplexInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixTemperatureComplexInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureComplexInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureComplexInstance::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixTemperatureComplexInstance::setSolverName );

    void ( AssemblyMatrixPressureDoubleInstance::*c9 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureDoubleInstance::addLoad;
    void ( AssemblyMatrixPressureDoubleInstance::*c10 )( const KinematicsLoadPtr &currentLoad,
                                                         const FunctionPtr &func ) =
        &AssemblyMatrixPressureDoubleInstance::addLoad;

    py::class_< AssemblyMatrixPressureDoubleInstance, AssemblyMatrixPressureDoublePtr,
                py::bases< DataStructure > >( "AssemblyMatrixPressureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixPressureDoubleInstance >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< AssemblyMatrixPressureDoubleInstance, std::string >))
        .def( "addKinematicsLoad", c9 )
        .def( "addKinematicsLoad", c10 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureDoubleInstance::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixPressureDoubleInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureDoubleInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixPressureDoubleInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureDoubleInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureDoubleInstance::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixPressureDoubleInstance::setSolverName );

    void ( AssemblyMatrixPressureComplexInstance::*c11 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureComplexInstance::addLoad;
    void ( AssemblyMatrixPressureComplexInstance::*c12 )( const KinematicsLoadPtr &currentLoad,
                                                          const FunctionPtr &func ) =
        &AssemblyMatrixPressureComplexInstance::addLoad;

    py::class_< AssemblyMatrixPressureComplexInstance, AssemblyMatrixPressureComplexPtr,
                py::bases< DataStructure > >( "AssemblyMatrixPressureComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AssemblyMatrixPressureComplexInstance >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< AssemblyMatrixPressureComplexInstance, std::string >))
        .def( "addKinematicsLoad", c11 )
        .def( "addKinematicsLoad", c12 )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureComplexInstance::appendElementaryMatrix )
        .def( "build", &AssemblyMatrixPressureComplexInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureComplexInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixPressureComplexInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureComplexInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureComplexInstance::setDOFNumbering )
        .def( "setSolverName", &AssemblyMatrixPressureComplexInstance::setSolverName );
};
