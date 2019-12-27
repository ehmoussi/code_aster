/**
 * @file MaterialBehaviourInterface.cxx
 * @brief Interface python de MaterialBehaviour
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

// Not DataStructures
// aslint: disable=C3006
#include "PythonBindings/MaterialBehaviourInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportMaterialBehaviourToPython() {

    py::class_< GeneralMaterialBehaviourInstance, GeneralMaterialBehaviourPtr >(
        "GeneralMaterialBehaviour", py::no_init )
        // fake initFactoryPtr: created by subclasses
        .def( "__init__", py::make_constructor(&initFactoryPtr< GeneralMaterialBehaviourInstance >))
        .def( "getAsterName", &GeneralMaterialBehaviourInstance::getAsterName )
        .def( "hasTractionFunction", &GeneralMaterialBehaviourInstance::hasTractionFunction )
        .def( "hasEnthalpyFunction", &GeneralMaterialBehaviourInstance::hasEnthalpyFunction )
        .def( "getComplexValue", &GeneralMaterialBehaviourInstance::getComplexValue )
        .def( "getDoubleValue", &GeneralMaterialBehaviourInstance::getDoubleValue )
        .def( "getStringValue", &GeneralMaterialBehaviourInstance::getStringValue )
        .def( "getGenericFunctionValue",
              &GeneralMaterialBehaviourInstance::getGenericFunctionValue )
        .def( "getNumberOfListOfDoubleProperties",
              &GeneralMaterialBehaviourInstance::getNumberOfListOfDoubleProperties )
        .def( "getNumberOfListOfFunctionProperties",
              &GeneralMaterialBehaviourInstance::getNumberOfListOfFunctionProperties )
        .def( "getTableValue", &GeneralMaterialBehaviourInstance::getTableValue )
        .def( "hasComplexValue", &GeneralMaterialBehaviourInstance::hasComplexValue )
        .def( "hasDoubleValue", &GeneralMaterialBehaviourInstance::hasDoubleValue )
        .def( "hasStringValue", &GeneralMaterialBehaviourInstance::hasStringValue )
        .def( "hasGenericFunctionValue",
              &GeneralMaterialBehaviourInstance::hasGenericFunctionValue )
        .def( "hasTableValue", &GeneralMaterialBehaviourInstance::hasTableValue )
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

    py::class_< MaterialBehaviourInstance, MaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "MaterialBehaviour", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MaterialBehaviourInstance, std::string >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< MaterialBehaviourInstance, std::string, std::string >))
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

    py::class_< BetonDoubleDpMaterialBehaviourInstance, BetonDoubleDpMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "BetonDoubleDpMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BetonDoubleDpMaterialBehaviourInstance >))
        .def( "getName", &BetonDoubleDpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &BetonDoubleDpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< BetonRagMaterialBehaviourInstance, BetonRagMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "BetonRagMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BetonRagMaterialBehaviourInstance >))
        .def( "getName", &BetonRagMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonRagMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< DisEcroTracMaterialBehaviourInstance, DisEcroTracMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "DisEcroTracMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DisEcroTracMaterialBehaviourInstance >))
        .def( "getName", &DisEcroTracMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisEcroTracMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< ElasMetaMaterialBehaviourInstance, ElasMetaMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "ElasMetaMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElasMetaMaterialBehaviourInstance >))
        .def( "getName", &ElasMetaMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< CableGaineFrotMaterialBehaviourInstance, CableGaineFrotMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "CableGaineFrotMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CableGaineFrotMaterialBehaviourInstance >))
        .def( "getName", &CableGaineFrotMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &CableGaineFrotMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< ElasMetaFoMaterialBehaviourInstance, ElasMetaFoMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "ElasMetaFoMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElasMetaFoMaterialBehaviourInstance >))
        .def( "getName", &ElasMetaFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< MetaTractionMaterialBehaviourInstance, MetaTractionMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "MetaTractionMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MetaTractionMaterialBehaviourInstance >))
        .def( "getName", &MetaTractionMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaTractionMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &MetaTractionMaterialBehaviourInstance::hasTractionFunction );

    py::class_< RuptFragMaterialBehaviourInstance, RuptFragMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "RuptFragMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RuptFragMaterialBehaviourInstance >))
        .def( "getName", &RuptFragMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< RuptFragFoMaterialBehaviourInstance, RuptFragFoMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "RuptFragFoMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RuptFragFoMaterialBehaviourInstance >))
        .def( "getName", &RuptFragFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< CzmLabMixMaterialBehaviourInstance, CzmLabMixMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "CzmLabMixMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CzmLabMixMaterialBehaviourInstance >))
        .def( "getName", &CzmLabMixMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CzmLabMixMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< TractionMaterialBehaviourInstance, TractionMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "TractionMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TractionMaterialBehaviourInstance >))
        .def( "getName", &TractionMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TractionMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &TractionMaterialBehaviourInstance::hasTractionFunction );

    py::class_< TherNlMaterialBehaviourInstance, TherNlMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourInstance > >( "TherNlMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< TherNlMaterialBehaviourInstance >))
        .def( "getName", &TherNlMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherNlMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasEnthalpyFunction", &TherNlMaterialBehaviourInstance::hasEnthalpyFunction );
};
