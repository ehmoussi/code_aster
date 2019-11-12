/**
 * @file DOFNumberingInterface.cxx
 * @brief Interface python de DOFNumbering
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "PythonBindings/DOFNumberingInterface.h"
#include "PythonBindings/LoadUtilities.h"

void exportDOFNumberingToPython() {
    using namespace boost::python;

    class_< FieldOnNodesDescriptionInstance, FieldOnNodesDescriptionPtr,
            bases< DataStructure > >( "FieldOnNodesDescription", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< FieldOnNodesDescriptionInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< FieldOnNodesDescriptionInstance,
                                                            std::string >));

    void ( BaseDOFNumberingInstance::*f1 )( const ElementaryMatrixDisplacementDoublePtr & ) =
        &BaseDOFNumberingInstance::setElementaryMatrix;
    void ( BaseDOFNumberingInstance::*f2 )( const ElementaryMatrixDisplacementComplexPtr & ) =
        &BaseDOFNumberingInstance::setElementaryMatrix;
    void ( BaseDOFNumberingInstance::*f3 )( const ElementaryMatrixTemperatureDoublePtr & ) =
        &BaseDOFNumberingInstance::setElementaryMatrix;
    void ( BaseDOFNumberingInstance::*f4 )( const ElementaryMatrixPressureComplexPtr & ) =
        &BaseDOFNumberingInstance::setElementaryMatrix;

    class_< BaseDOFNumberingInstance, BaseDOFNumberingInstance::BaseDOFNumberingPtr,
            bases< DataStructure > > c1( "BaseDOFNumbering", no_init );
    // fake initFactoryPtr: created by subclasses
    // fake initFactoryPtr: created by subclasses
    c1.def( "addFiniteElementDescriptor", &BaseDOFNumberingInstance::addFiniteElementDescriptor );
    c1.def( "computeNumbering", &BaseDOFNumberingInstance::computeNumbering );
    c1.def( "getFieldOnNodesDescription", &BaseDOFNumberingInstance::getFieldOnNodesDescription );
    c1.def( "getFiniteElementDescriptors", &BaseDOFNumberingInstance::getFiniteElementDescriptors );
    c1.def( "isParallel", &BaseDOFNumberingInstance::isParallel );
    c1.def( "setElementaryMatrix", f1 );
    c1.def( "setElementaryMatrix", f2 );
    c1.def( "setElementaryMatrix", f3 );
    c1.def( "setElementaryMatrix", f4 );
    c1.def( "getModel", &BaseDOFNumberingInstance::getModel );
    c1.def( "setModel", &BaseDOFNumberingInstance::setModel );
    addKinematicsLoadToInterface( c1 );
    addMechanicalLoadToInterface( c1 );

    class_< DOFNumberingInstance, DOFNumberingInstance::DOFNumberingPtr,
            bases< BaseDOFNumberingInstance > >( "DOFNumbering", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DOFNumberingInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< DOFNumberingInstance, std::string >))
        .def( "getFieldOnNodesDescription", &DOFNumberingInstance::getFieldOnNodesDescription );
};
