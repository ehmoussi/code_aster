/**
 * @file DOFNumberingInterface.cxx
 * @brief Interface python de DOFNumbering
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
#include "PythonBindings/DOFNumberingInterface.h"
#include "PythonBindings/LoadUtilities.h"
#include <PythonBindings/factory.h>

void exportDOFNumberingToPython() {

    py::class_< FieldOnNodesDescriptionClass, FieldOnNodesDescriptionPtr,
                py::bases< DataStructure > >( "FieldOnNodesDescription", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FieldOnNodesDescriptionClass >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< FieldOnNodesDescriptionClass, std::string >));

    void ( BaseDOFNumberingClass::*f1 )( const ElementaryMatrixDisplacementDoublePtr & ) =
        &BaseDOFNumberingClass::setElementaryMatrix;
    void ( BaseDOFNumberingClass::*f2 )( const ElementaryMatrixDisplacementComplexPtr & ) =
        &BaseDOFNumberingClass::setElementaryMatrix;
    void ( BaseDOFNumberingClass::*f3 )( const ElementaryMatrixTemperatureDoublePtr & ) =
        &BaseDOFNumberingClass::setElementaryMatrix;
    void ( BaseDOFNumberingClass::*f4 )( const ElementaryMatrixPressureComplexPtr & ) =
        &BaseDOFNumberingClass::setElementaryMatrix;

    py::class_< BaseDOFNumberingClass, BaseDOFNumberingClass::BaseDOFNumberingPtr,
                py::bases< DataStructure > > c1( "BaseDOFNumbering", py::no_init );
    // fake initFactoryPtr: created by subclasses
    // fake initFactoryPtr: created by subclasses
    c1.def( "addFiniteElementDescriptor", &BaseDOFNumberingClass::addFiniteElementDescriptor );
    c1.def( "computeNumbering", &BaseDOFNumberingClass::computeNumbering );
    c1.def( "getFieldOnNodesDescription", &BaseDOFNumberingClass::getFieldOnNodesDescription );
    c1.def( "getFiniteElementDescriptors", &BaseDOFNumberingClass::getFiniteElementDescriptors );
    c1.def( "isParallel", &BaseDOFNumberingClass::isParallel );
    c1.def( "setElementaryMatrix", f1 );
    c1.def( "setElementaryMatrix", f2 );
    c1.def( "setElementaryMatrix", f3 );
    c1.def( "setElementaryMatrix", f4 );
    c1.def( "getModel", &BaseDOFNumberingClass::getModel, R"(
Return the model

Returns:
    ModelPtr: a pointer to the model
        )",
              ( py::arg( "self" ) )  );
    c1.def( "setModel", &BaseDOFNumberingClass::setModel );
    c1.def( "getMesh", &BaseDOFNumberingClass::getMesh, R"(
Return the mesh

Returns:
    MeshPtr: a pointer to the mesh
        )",
              ( py::arg( "self" ) ) );
    addKinematicsLoadToInterface( c1 );
    addMechanicalLoadToInterface( c1 );

    py::class_< DOFNumberingClass, DOFNumberingClass::DOFNumberingPtr,
                py::bases< BaseDOFNumberingClass > >( "DOFNumbering", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DOFNumberingClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DOFNumberingClass, std::string >))
        .def( "getFieldOnNodesDescription", &DOFNumberingClass::getFieldOnNodesDescription );
};
