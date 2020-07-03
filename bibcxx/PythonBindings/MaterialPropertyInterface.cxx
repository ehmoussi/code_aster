/**
 * @file MaterialPropertyInterface.cxx
 * @brief Interface python de MaterialProperty
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
#include "PythonBindings/MaterialPropertyInterface.h"
#include "PythonBindings/BaseMaterialPropertyInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportMaterialPropertyToPython() {

    bool ( MaterialPropertyClass::*c1 )( std::string, const bool ) =
        &MaterialPropertyClass::addNewRealProperty;
    bool ( MaterialPropertyClass::*c2 )( std::string, const double &, const bool ) =
        &MaterialPropertyClass::addNewRealProperty;
    bool ( MaterialPropertyClass::*c3 )( std::string, const bool ) =
        &MaterialPropertyClass::addNewStringProperty;
    bool ( MaterialPropertyClass::*c4 )( std::string, const std::string &, const bool ) =
        &MaterialPropertyClass::addNewStringProperty;

    py::class_< MaterialPropertyClass, MaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "MaterialProperty", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MaterialPropertyClass, std::string >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< MaterialPropertyClass, std::string, std::string >))
        .def( "addNewRealProperty", c1 )
        .def( "addNewRealProperty", c2 )
        .def( "addNewComplexProperty", &MaterialPropertyClass::addNewComplexProperty )
        .def( "addNewStringProperty", c3 )
        .def( "addNewStringProperty", c4 )
        .def( "addNewFunctionProperty", &MaterialPropertyClass::addNewFunctionProperty )
        .def( "addNewTableProperty", &MaterialPropertyClass::addNewTableProperty )
        .def( "addNewVectorOfRealProperty",
              &MaterialPropertyClass::addNewVectorOfRealProperty )
        .def( "addNewVectorOfFunctionProperty",
              &MaterialPropertyClass::addNewVectorOfFunctionProperty )
        .def( "getName", &MaterialPropertyClass::getName );

    py::class_< BetonRealDpMaterialPropertyClass, BetonRealDpMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "BetonRealDpMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BetonRealDpMaterialPropertyClass >))
        .def( "getName", &BetonRealDpMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &BetonRealDpMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< BetonRagMaterialPropertyClass, BetonRagMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "BetonRagMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BetonRagMaterialPropertyClass >))
        .def( "getName", &BetonRagMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonRagMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< ElasMetaMaterialPropertyClass, ElasMetaMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "ElasMetaMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElasMetaMaterialPropertyClass >))
        .def( "getName", &ElasMetaMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< CableGaineFrotMaterialPropertyClass, CableGaineFrotMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "CableGaineFrotMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CableGaineFrotMaterialPropertyClass >))
        .def( "getName", &CableGaineFrotMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &CableGaineFrotMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< ElasMetaFoMaterialPropertyClass, ElasMetaFoMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "ElasMetaFoMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElasMetaFoMaterialPropertyClass >))
        .def( "getName", &ElasMetaFoMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaFoMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< MetaTractionMaterialPropertyClass, MetaTractionMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "MetaTractionMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MetaTractionMaterialPropertyClass >))
        .def( "getName", &MetaTractionMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaTractionMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &MetaTractionMaterialPropertyClass::hasTractionFunction );

    py::class_< RuptFragMaterialPropertyClass, RuptFragMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "RuptFragMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RuptFragMaterialPropertyClass >))
        .def( "getName", &RuptFragMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< RuptFragFoMaterialPropertyClass, RuptFragFoMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "RuptFragFoMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RuptFragFoMaterialPropertyClass >))
        .def( "getName", &RuptFragFoMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragFoMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< CzmLabMixMaterialPropertyClass, CzmLabMixMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "CzmLabMixMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CzmLabMixMaterialPropertyClass >))
        .def( "getName", &CzmLabMixMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CzmLabMixMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    py::class_< TractionMaterialPropertyClass, TractionMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "TractionMaterialProperty",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TractionMaterialPropertyClass >))
        .def( "getName", &TractionMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TractionMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &TractionMaterialPropertyClass::hasTractionFunction );

    py::class_< ThermalNlMaterialPropertyClass, ThermalNlMaterialPropertyPtr,
                py::bases< GenericMaterialPropertyClass > >( "ThermalNlMaterialProperty",
                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ThermalNlMaterialPropertyClass >))
        .def( "getName", &ThermalNlMaterialPropertyClass::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThermalNlMaterialPropertyClass::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasEnthalpyFunction", &ThermalNlMaterialPropertyClass::hasEnthalpyFunction );
};
