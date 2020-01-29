/**
 * @file MaterialBehaviourInterface.cxx
 * @brief Interface python de MaterialBehaviour
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

// Not DataStructures
// aslint: disable=C3006
#include "PythonBindings/MaterialBehaviourInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportMaterialBehaviourToPython() {

    py::class_< GeneralMaterialBehaviourClass, GeneralMaterialBehaviourPtr >(
        "GeneralMaterialBehaviour", py::no_init )
        // fake initFactoryPtr: created by subclasses
        .def( "__init__", py::make_constructor(&initFactoryPtr< GeneralMaterialBehaviourClass >))
        .def( "getAsterName", &GeneralMaterialBehaviourClass::getAsterName )
        .def( "hasTractionFunction", &GeneralMaterialBehaviourClass::hasTractionFunction )
        .def( "hasEnthalpyFunction", &GeneralMaterialBehaviourClass::hasEnthalpyFunction )
        .def( "getComplexValue", &GeneralMaterialBehaviourClass::getComplexValue )
        .def( "getDoubleValue", &GeneralMaterialBehaviourClass::getDoubleValue )
        .def( "getStringValue", &GeneralMaterialBehaviourClass::getStringValue )
        .def( "getGenericFunctionValue",
              &GeneralMaterialBehaviourClass::getGenericFunctionValue )
        .def( "getNumberOfListOfDoubleProperties",
              &GeneralMaterialBehaviourClass::getNumberOfListOfDoubleProperties )
        .def( "getNumberOfListOfFunctionProperties",
              &GeneralMaterialBehaviourClass::getNumberOfListOfFunctionProperties )
        .def( "getTableValue", &GeneralMaterialBehaviourClass::getTableValue )
        .def( "hasComplexValue", &GeneralMaterialBehaviourClass::hasComplexValue )
        .def( "hasDoubleValue", &GeneralMaterialBehaviourClass::hasDoubleValue )
        .def( "hasStringValue", &GeneralMaterialBehaviourClass::hasStringValue )
        .def( "hasGenericFunctionValue",
              &GeneralMaterialBehaviourClass::hasGenericFunctionValue )
        .def( "hasTableValue", &GeneralMaterialBehaviourClass::hasTableValue )
        .def( "setComplexValue", &GeneralMaterialBehaviourClass::setComplexValue )
        .def( "setDoubleValue", &GeneralMaterialBehaviourClass::setDoubleValue )
        .def( "setStringValue", &GeneralMaterialBehaviourClass::setStringValue )
        .def( "setFunctionValue", &GeneralMaterialBehaviourClass::setFunctionValue )
        .def( "setTableValue", &GeneralMaterialBehaviourClass::setTableValue )
        .def( "setSurfaceValue", &GeneralMaterialBehaviourClass::setSurfaceValue )
        .def( "setFormulaValue", &GeneralMaterialBehaviourClass::setFormulaValue )
        .def( "setVectorOfDoubleValue", &GeneralMaterialBehaviourClass::setVectorOfDoubleValue )
        .def( "setVectorOfFunctionValue",
              &GeneralMaterialBehaviourClass::setVectorOfFunctionValue )
        .def( "setSortedListParameters",
              &GeneralMaterialBehaviourClass::setSortedListParameters );

    bool ( MaterialBehaviourClass::*c1 )( std::string, const bool ) =
        &MaterialBehaviourClass::addNewDoubleProperty;
    bool ( MaterialBehaviourClass::*c2 )( std::string, const double &, const bool ) =
        &MaterialBehaviourClass::addNewDoubleProperty;
    bool ( MaterialBehaviourClass::*c3 )( std::string, const bool ) =
        &MaterialBehaviourClass::addNewStringProperty;
    bool ( MaterialBehaviourClass::*c4 )( std::string, const std::string &, const bool ) =
        &MaterialBehaviourClass::addNewStringProperty;

    py::class_< MaterialBehaviourClass, MaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "MaterialBehaviour", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MaterialBehaviourClass, std::string >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< MaterialBehaviourClass, std::string, std::string >))
        .def( "addNewDoubleProperty", c1 )
        .def( "addNewDoubleProperty", c2 )
        .def( "addNewComplexProperty", &MaterialBehaviourClass::addNewComplexProperty )
        .def( "addNewStringProperty", c3 )
        .def( "addNewStringProperty", c4 )
        .def( "addNewFunctionProperty", &MaterialBehaviourClass::addNewFunctionProperty )
        .def( "addNewTableProperty", &MaterialBehaviourClass::addNewTableProperty )
        .def( "addNewVectorOfDoubleProperty",
              &MaterialBehaviourClass::addNewVectorOfDoubleProperty )
        .def( "addNewVectorOfFunctionProperty",
              &MaterialBehaviourClass::addNewVectorOfFunctionProperty )
        .def( "getName", &MaterialBehaviourClass::getName );

    py::class_< BetonDoubleDpMaterialBehaviourClass, BetonDoubleDpMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "BetonDoubleDpMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BetonDoubleDpMaterialBehaviourClass >))
        .def( "getName", &BetonDoubleDpMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &BetonDoubleDpMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< BetonRagMaterialBehaviourClass, BetonRagMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "BetonRagMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BetonRagMaterialBehaviourClass >))
        .def( "getName", &BetonRagMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonRagMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< DisEcroTracMaterialBehaviourClass, DisEcroTracMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "DisEcroTracMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DisEcroTracMaterialBehaviourClass >))
        .def( "getName", &DisEcroTracMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisEcroTracMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< ElasMetaMaterialBehaviourClass, ElasMetaMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "ElasMetaMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElasMetaMaterialBehaviourClass >))
        .def( "getName", &ElasMetaMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< CableGaineFrotMaterialBehaviourClass, CableGaineFrotMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "CableGaineFrotMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CableGaineFrotMaterialBehaviourClass >))
        .def( "getName", &CableGaineFrotMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &CableGaineFrotMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< ElasMetaFoMaterialBehaviourClass, ElasMetaFoMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "ElasMetaFoMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElasMetaFoMaterialBehaviourClass >))
        .def( "getName", &ElasMetaFoMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaFoMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< MetaTractionMaterialBehaviourClass, MetaTractionMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "MetaTractionMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MetaTractionMaterialBehaviourClass >))
        .def( "getName", &MetaTractionMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaTractionMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &MetaTractionMaterialBehaviourClass::hasTractionFunction );

    py::class_< RuptFragMaterialBehaviourClass, RuptFragMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "RuptFragMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RuptFragMaterialBehaviourClass >))
        .def( "getName", &RuptFragMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< RuptFragFoMaterialBehaviourClass, RuptFragFoMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "RuptFragFoMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RuptFragFoMaterialBehaviourClass >))
        .def( "getName", &RuptFragFoMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragFoMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< CzmLabMixMaterialBehaviourClass, CzmLabMixMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "CzmLabMixMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CzmLabMixMaterialBehaviourClass >))
        .def( "getName", &CzmLabMixMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CzmLabMixMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< TractionMaterialBehaviourClass, TractionMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "TractionMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TractionMaterialBehaviourClass >))
        .def( "getName", &TractionMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TractionMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &TractionMaterialBehaviourClass::hasTractionFunction );

    py::class_< TherNlMaterialBehaviourClass, TherNlMaterialBehaviourPtr,
                py::bases< GeneralMaterialBehaviourClass > >( "TherNlMaterialBehaviour",
                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< TherNlMaterialBehaviourClass >))
        .def( "getName", &TherNlMaterialBehaviourClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherNlMaterialBehaviourClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasEnthalpyFunction", &TherNlMaterialBehaviourClass::hasEnthalpyFunction );
};
