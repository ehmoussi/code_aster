/**
 * @file AssemblyMatrixInterface.cxx
 * @brief Interface python de AssemblyMatrix
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
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
#include <PythonBindings/factory.h>
#include "PythonBindings/AssemblyMatrixInterface.h"

void exportAssemblyMatrixToPython() {
    using namespace boost::python;

    void ( AssemblyMatrixDisplacementDoubleInstance::*c1 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementDoubleInstance::addLoad;
    void ( AssemblyMatrixDisplacementDoubleInstance::*c2 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementDoubleInstance::addLoad;

    class_< AssemblyMatrixDisplacementDoubleInstance, AssemblyMatrixDisplacementDoublePtr,
            bases< DataStructure > >( "AssemblyMatrixDisplacementDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementDoubleInstance >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementDoubleInstance, std::string >))
        .def( "addKinematicsLoad", c1 )
        .def( "addKinematicsLoad", c2 )
        .def( "build", &AssemblyMatrixDisplacementDoubleInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementDoubleInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixDisplacementDoubleInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementDoubleInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementDoubleInstance::setDOFNumbering )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementDoubleInstance::appendElementaryMatrix );

    void ( AssemblyMatrixDisplacementComplexInstance::*c3 )(
        const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixDisplacementComplexInstance::addLoad;
    void ( AssemblyMatrixDisplacementComplexInstance::*c4 )( const KinematicsLoadPtr &currentLoad,
                                                             const FunctionPtr &func ) =
        &AssemblyMatrixDisplacementComplexInstance::addLoad;

    class_< AssemblyMatrixDisplacementComplexInstance, AssemblyMatrixDisplacementComplexPtr,
            bases< DataStructure > >( "AssemblyMatrixDisplacementComplex", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< AssemblyMatrixDisplacementComplexInstance >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< AssemblyMatrixDisplacementComplexInstance, std::string >))
        .def( "addKinematicsLoad", c3 )
        .def( "addKinematicsLoad", c4 )
        .def( "build", &AssemblyMatrixDisplacementComplexInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixDisplacementComplexInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixDisplacementComplexInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixDisplacementComplexInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixDisplacementComplexInstance::setDOFNumbering )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixDisplacementComplexInstance::appendElementaryMatrix );

    void ( AssemblyMatrixTemperatureDoubleInstance::*c5 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureDoubleInstance::addLoad;
    void ( AssemblyMatrixTemperatureDoubleInstance::*c6 )( const KinematicsLoadPtr &currentLoad,
                                                           const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureDoubleInstance::addLoad;

    class_< AssemblyMatrixTemperatureDoubleInstance, AssemblyMatrixTemperatureDoublePtr,
            bases< DataStructure > >( "AssemblyMatrixTemperatureDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureDoubleInstance >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureDoubleInstance, std::string >))
        .def( "addKinematicsLoad", c5 )
        .def( "addKinematicsLoad", c6 )
        .def( "build", &AssemblyMatrixTemperatureDoubleInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureDoubleInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixTemperatureDoubleInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureDoubleInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureDoubleInstance::setDOFNumbering )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureDoubleInstance::appendElementaryMatrix );

    void ( AssemblyMatrixTemperatureComplexInstance::*c7 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixTemperatureComplexInstance::addLoad;
    void ( AssemblyMatrixTemperatureComplexInstance::*c8 )( const KinematicsLoadPtr &currentLoad,
                                                            const FunctionPtr &func ) =
        &AssemblyMatrixTemperatureComplexInstance::addLoad;

    class_< AssemblyMatrixTemperatureComplexInstance, AssemblyMatrixTemperatureComplexPtr,
            bases< DataStructure > >( "AssemblyMatrixTemperatureComplex", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< AssemblyMatrixTemperatureComplexInstance >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< AssemblyMatrixTemperatureComplexInstance, std::string >))
        .def( "addKinematicsLoad", c7 )
        .def( "addKinematicsLoad", c8 )
        .def( "build", &AssemblyMatrixTemperatureComplexInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixTemperatureComplexInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixTemperatureComplexInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixTemperatureComplexInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixTemperatureComplexInstance::setDOFNumbering )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixTemperatureComplexInstance::appendElementaryMatrix );

    void ( AssemblyMatrixPressureDoubleInstance::*c9 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureDoubleInstance::addLoad;
    void ( AssemblyMatrixPressureDoubleInstance::*c10 )( const KinematicsLoadPtr &currentLoad,
                                                         const FunctionPtr &func ) =
        &AssemblyMatrixPressureDoubleInstance::addLoad;

    class_< AssemblyMatrixPressureDoubleInstance, AssemblyMatrixPressureDoublePtr,
            bases< DataStructure > >( "AssemblyMatrixPressureDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< AssemblyMatrixPressureDoubleInstance >))
        .def( "__init__", make_constructor(
                              &initFactoryPtr< AssemblyMatrixPressureDoubleInstance, std::string >))
        .def( "addKinematicsLoad", c9 )
        .def( "addKinematicsLoad", c10 )
        .def( "build", &AssemblyMatrixPressureDoubleInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureDoubleInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixPressureDoubleInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureDoubleInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureDoubleInstance::setDOFNumbering )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureDoubleInstance::appendElementaryMatrix );

    void ( AssemblyMatrixPressureComplexInstance::*c11 )( const KinematicsLoadPtr &currentLoad ) =
        &AssemblyMatrixPressureComplexInstance::addLoad;
    void ( AssemblyMatrixPressureComplexInstance::*c12 )( const KinematicsLoadPtr &currentLoad,
                                                          const FunctionPtr &func ) =
        &AssemblyMatrixPressureComplexInstance::addLoad;

    class_< AssemblyMatrixPressureComplexInstance, AssemblyMatrixPressureComplexPtr,
            bases< DataStructure > >( "AssemblyMatrixPressureComplex", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< AssemblyMatrixPressureComplexInstance >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< AssemblyMatrixPressureComplexInstance, std::string >))
        .def( "addKinematicsLoad", c11 )
        .def( "addKinematicsLoad", c12 )
        .def( "build", &AssemblyMatrixPressureComplexInstance::build )
        .def( "getDOFNumbering", &AssemblyMatrixPressureComplexInstance::getDOFNumbering )
        .def( "getMaterialOnMesh", &AssemblyMatrixPressureComplexInstance::getMaterialOnMesh )
        .def( "getNumberOfElementaryMatrix",
              &AssemblyMatrixPressureComplexInstance::getNumberOfElementaryMatrix )
        .def( "setDOFNumbering", &AssemblyMatrixPressureComplexInstance::setDOFNumbering )
        .def( "appendElementaryMatrix",
              &AssemblyMatrixPressureComplexInstance::appendElementaryMatrix );
};
