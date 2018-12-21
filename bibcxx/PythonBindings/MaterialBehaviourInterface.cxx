/**
 * @file MaterialBehaviourInterface.cxx
 * @brief Interface python de MaterialBehaviour
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

// Not DataStructures
// aslint: disable=C3006
#include "PythonBindings/MaterialBehaviourInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMaterialBehaviourToPython() {
    using namespace boost::python;

    class_< GeneralMaterialBehaviourInstance, GeneralMaterialBehaviourPtr >(
        "GeneralMaterialBehaviour", no_init )
        // fake initFactoryPtr: created by subclasses
        .def( "__init__", make_constructor( &initFactoryPtr< GeneralMaterialBehaviourInstance > ) )
        .def( "getAsterName", &GeneralMaterialBehaviourInstance::getAsterName )
        .def( "hasTractionFunction", &GeneralMaterialBehaviourInstance::hasTractionFunction )
        .def( "hasEnthalpyFunction", &GeneralMaterialBehaviourInstance::hasEnthalpyFunction )
        .def( "setComplexValue", &GeneralMaterialBehaviourInstance::setComplexValue )
        .def( "setDoubleValue", &GeneralMaterialBehaviourInstance::setDoubleValue )
        .def( "setStringValue", &GeneralMaterialBehaviourInstance::setStringValue )
        .def( "setFunctionValue", &GeneralMaterialBehaviourInstance::setFunctionValue )
        .def( "setTableValue", &GeneralMaterialBehaviourInstance::setTableValue )
        .def( "setSurfaceValue", &GeneralMaterialBehaviourInstance::setSurfaceValue )
        .def( "setFormulaValue", &GeneralMaterialBehaviourInstance::setFormulaValue )
        .def( "setVectorOfDoubleValue", &GeneralMaterialBehaviourInstance::setVectorOfDoubleValue )
        .def( "setVectorOfFunctionValue",
              &GeneralMaterialBehaviourInstance::setVectorOfFunctionValue )
        .def( "setSortedListParameters",
              &GeneralMaterialBehaviourInstance::setSortedListParameters );

    bool ( MaterialBehaviourInstance::*c1 )( std::string, const bool ) =
        &MaterialBehaviourInstance::addNewDoubleProperty;
    bool ( MaterialBehaviourInstance::*c2 )( std::string, const double &, const bool ) =
        &MaterialBehaviourInstance::addNewDoubleProperty;
    bool ( MaterialBehaviourInstance::*c3 )( std::string, const bool ) =
        &MaterialBehaviourInstance::addNewStringProperty;
    bool ( MaterialBehaviourInstance::*c4 )( std::string, const std::string &, const bool ) =
        &MaterialBehaviourInstance::addNewStringProperty;

    class_< MaterialBehaviourInstance, MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< MaterialBehaviourInstance, std::string > ) )
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< MaterialBehaviourInstance, std::string, std::string > ) )
        .def( "addNewDoubleProperty", c1 )
        .def( "addNewDoubleProperty", c2 )
        .def( "addNewComplexProperty", &MaterialBehaviourInstance::addNewComplexProperty )
        .def( "addNewStringProperty", c3 )
        .def( "addNewStringProperty", c4 )
        .def( "addNewFunctionProperty", &MaterialBehaviourInstance::addNewFunctionProperty )
        .def( "addNewTableProperty", &MaterialBehaviourInstance::addNewTableProperty )
        .def( "addNewVectorOfDoubleProperty",
              &MaterialBehaviourInstance::addNewVectorOfDoubleProperty )
        .def( "addNewVectorOfFunctionProperty",
              &MaterialBehaviourInstance::addNewVectorOfFunctionProperty )
        .def( "getName", &MaterialBehaviourInstance::getName );

    class_< BetonDoubleDpMaterialBehaviourInstance, BetonDoubleDpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonDoubleDpMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< BetonDoubleDpMaterialBehaviourInstance > ) )
        .def( "getName", &BetonDoubleDpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &BetonDoubleDpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BetonRagMaterialBehaviourInstance, BetonRagMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonRagMaterialBehaviour", no_init )
        .def( "__init__", make_constructor( &initFactoryPtr< BetonRagMaterialBehaviourInstance > ) )
        .def( "getName", &BetonRagMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonRagMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisEcroTracMaterialBehaviourInstance, DisEcroTracMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisEcroTracMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< DisEcroTracMaterialBehaviourInstance > ) )
        .def( "getName", &DisEcroTracMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisEcroTracMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasMetaMaterialBehaviourInstance, ElasMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasMetaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor( &initFactoryPtr< ElasMetaMaterialBehaviourInstance > ) )
        .def( "getName", &ElasMetaMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CableGaineFrotMaterialBehaviourInstance, CableGaineFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CableGaineFrotMaterialBehaviour",
                                                                no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< CableGaineFrotMaterialBehaviourInstance > ) )
        .def( "getName", &CableGaineFrotMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &CableGaineFrotMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasMetaFoMaterialBehaviourInstance, ElasMetaFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasMetaFoMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< ElasMetaFoMaterialBehaviourInstance > ) )
        .def( "getName", &ElasMetaFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaTractionMaterialBehaviourInstance, MetaTractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaTractionMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< MetaTractionMaterialBehaviourInstance > ) )
        .def( "getName", &MetaTractionMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaTractionMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &MetaTractionMaterialBehaviourInstance::hasTractionFunction );

    class_< RuptFragMaterialBehaviourInstance, RuptFragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RuptFragMaterialBehaviour", no_init )
        .def( "__init__", make_constructor( &initFactoryPtr< RuptFragMaterialBehaviourInstance > ) )
        .def( "getName", &RuptFragMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RuptFragFoMaterialBehaviourInstance, RuptFragFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RuptFragFoMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< RuptFragFoMaterialBehaviourInstance > ) )
        .def( "getName", &RuptFragFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TractionMaterialBehaviourInstance, TractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TractionMaterialBehaviour", no_init )
        .def( "__init__", make_constructor( &initFactoryPtr< TractionMaterialBehaviourInstance > ) )
        .def( "getName", &TractionMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TractionMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &TractionMaterialBehaviourInstance::hasTractionFunction );

    class_< TherNlMaterialBehaviourInstance, TherNlMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherNlMaterialBehaviour", no_init )
        .def( "__init__", make_constructor( &initFactoryPtr< TherNlMaterialBehaviourInstance > ) )
        .def( "getName", &TherNlMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherNlMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasEnthalpyFunction", &TherNlMaterialBehaviourInstance::hasEnthalpyFunction );
};
