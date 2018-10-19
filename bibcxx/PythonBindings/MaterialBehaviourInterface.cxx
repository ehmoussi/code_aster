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

#include "PythonBindings/MaterialBehaviourInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMaterialBehaviourToPython() {
    using namespace boost::python;

    class_< GeneralMaterialBehaviourInstance, GeneralMaterialBehaviourPtr >(
        "GeneralMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< GeneralMaterialBehaviourInstance >))
        .def( "getAsterName", &GeneralMaterialBehaviourInstance::getAsterName )
        .def( "hasTractionFunction", &GeneralMaterialBehaviourInstance::hasTractionFunction )
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
              make_constructor(&initFactoryPtr< MaterialBehaviourInstance, std::string >))
        .def( "__init__",
              make_constructor(
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

    class_< ElasMaterialBehaviourInstance, ElasMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasMaterialBehaviourInstance >))
        .def( "getName", &ElasMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasFoMaterialBehaviourInstance, ElasFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasFoMaterialBehaviourInstance >))
        .def( "getName", &ElasFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasFluiMaterialBehaviourInstance, ElasFluiMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasFluiMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasFluiMaterialBehaviourInstance >))
        .def( "getName", &ElasFluiMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasFluiMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasIstrMaterialBehaviourInstance, ElasIstrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasIstrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasIstrMaterialBehaviourInstance >))
        .def( "getName", &ElasIstrMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasIstrMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasIstrFoMaterialBehaviourInstance, ElasIstrFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasIstrFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasIstrFoMaterialBehaviourInstance >))
        .def( "getName", &ElasIstrFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasIstrFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasOrthMaterialBehaviourInstance, ElasOrthMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasOrthMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasOrthMaterialBehaviourInstance >))
        .def( "getName", &ElasOrthMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasOrthMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasOrthFoMaterialBehaviourInstance, ElasOrthFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasOrthFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasOrthFoMaterialBehaviourInstance >))
        .def( "getName", &ElasOrthFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasOrthFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasHyperMaterialBehaviourInstance, ElasHyperMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasHyperMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasHyperMaterialBehaviourInstance >))
        .def( "getName", &ElasHyperMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasHyperMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasCoqueMaterialBehaviourInstance, ElasCoqueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasCoqueMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasCoqueMaterialBehaviourInstance >))
        .def( "getName", &ElasCoqueMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasCoqueMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasCoqueFoMaterialBehaviourInstance, ElasCoqueFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasCoqueFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasCoqueFoMaterialBehaviourInstance >))
        .def( "getName", &ElasCoqueFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasCoqueFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasMembraneMaterialBehaviourInstance, ElasMembraneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasMembraneMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElasMembraneMaterialBehaviourInstance >))
        .def( "getName", &ElasMembraneMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMembraneMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Elas2ndgMaterialBehaviourInstance, Elas2ndgMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Elas2ndgMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Elas2ndgMaterialBehaviourInstance >))
        .def( "getName", &Elas2ndgMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Elas2ndgMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasGlrcMaterialBehaviourInstance, ElasGlrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasGlrcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasGlrcMaterialBehaviourInstance >))
        .def( "getName", &ElasGlrcMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasGlrcMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasGlrcFoMaterialBehaviourInstance, ElasGlrcFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasGlrcFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasGlrcFoMaterialBehaviourInstance >))
        .def( "getName", &ElasGlrcFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasGlrcFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasDhrcMaterialBehaviourInstance, ElasDhrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasDhrcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasDhrcMaterialBehaviourInstance >))
        .def( "getName", &ElasDhrcMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasDhrcMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CableMaterialBehaviourInstance, CableMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CableMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CableMaterialBehaviourInstance >))
        .def( "getName", &CableMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CableMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< VeriBorneMaterialBehaviourInstance, VeriBorneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "VeriBorneMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< VeriBorneMaterialBehaviourInstance >))
        .def( "getName", &VeriBorneMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &VeriBorneMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TractionMaterialBehaviourInstance, TractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TractionMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TractionMaterialBehaviourInstance >))
        .def( "getName", &TractionMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TractionMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &TractionMaterialBehaviourInstance::hasTractionFunction );

    class_< EcroLineMaterialBehaviourInstance, EcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroLineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EcroLineMaterialBehaviourInstance >))
        .def( "getName", &EcroLineMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroLineMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EndoHeterogeneMaterialBehaviourInstance, EndoHeterogeneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EndoHeterogeneMaterialBehaviour",
                                                         no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< EndoHeterogeneMaterialBehaviourInstance >))
        .def( "getName", &EndoHeterogeneMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &EndoHeterogeneMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EcroLineFoMaterialBehaviourInstance, EcroLineFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroLineFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EcroLineFoMaterialBehaviourInstance >))
        .def( "getName", &EcroLineFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroLineFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EcroPuisMaterialBehaviourInstance, EcroPuisMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroPuisMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EcroPuisMaterialBehaviourInstance >))
        .def( "getName", &EcroPuisMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroPuisMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EcroPuisFoMaterialBehaviourInstance, EcroPuisFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroPuisFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EcroPuisFoMaterialBehaviourInstance >))
        .def( "getName", &EcroPuisFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroPuisFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EcroCookMaterialBehaviourInstance, EcroCookMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroCookMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EcroCookMaterialBehaviourInstance >))
        .def( "getName", &EcroCookMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroCookMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EcroCookFoMaterialBehaviourInstance, EcroCookFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroCookFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EcroCookFoMaterialBehaviourInstance >))
        .def( "getName", &EcroCookFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroCookFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BetonEcroLineMaterialBehaviourInstance, BetonEcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonEcroLineMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< BetonEcroLineMaterialBehaviourInstance >))
        .def( "getName", &BetonEcroLineMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &BetonEcroLineMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BetonReglePrMaterialBehaviourInstance, BetonReglePrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonReglePrMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< BetonReglePrMaterialBehaviourInstance >))
        .def( "getName", &BetonReglePrMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonReglePrMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EndoOrthBetonMaterialBehaviourInstance, EndoOrthBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EndoOrthBetonMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< EndoOrthBetonMaterialBehaviourInstance >))
        .def( "getName", &EndoOrthBetonMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &EndoOrthBetonMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< PragerMaterialBehaviourInstance, PragerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "PragerMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< PragerMaterialBehaviourInstance >))
        .def( "getName", &PragerMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &PragerMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< PragerFoMaterialBehaviourInstance, PragerFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "PragerFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< PragerFoMaterialBehaviourInstance >))
        .def( "getName", &PragerFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &PragerFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TaheriMaterialBehaviourInstance, TaheriMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TaheriMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TaheriMaterialBehaviourInstance >))
        .def( "getName", &TaheriMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TaheriMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TaheriFoMaterialBehaviourInstance, TaheriFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TaheriFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TaheriFoMaterialBehaviourInstance >))
        .def( "getName", &TaheriFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TaheriFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RousselierMaterialBehaviourInstance, RousselierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RousselierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< RousselierMaterialBehaviourInstance >))
        .def( "getName", &RousselierMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RousselierMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RousselierFoMaterialBehaviourInstance, RousselierFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RousselierFoMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< RousselierFoMaterialBehaviourInstance >))
        .def( "getName", &RousselierFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RousselierFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscSinhMaterialBehaviourInstance, ViscSinhMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscSinhMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscSinhMaterialBehaviourInstance >))
        .def( "getName", &ViscSinhMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscSinhMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscSinhFoMaterialBehaviourInstance, ViscSinhFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscSinhFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscSinhFoMaterialBehaviourInstance >))
        .def( "getName", &ViscSinhFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscSinhFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Cin1ChabMaterialBehaviourInstance, Cin1ChabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Cin1ChabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Cin1ChabMaterialBehaviourInstance >))
        .def( "getName", &Cin1ChabMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Cin1ChabMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Cin1ChabFoMaterialBehaviourInstance, Cin1ChabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Cin1ChabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Cin1ChabFoMaterialBehaviourInstance >))
        .def( "getName", &Cin1ChabFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Cin1ChabFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Cin2ChabMaterialBehaviourInstance, Cin2ChabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Cin2ChabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Cin2ChabMaterialBehaviourInstance >))
        .def( "getName", &Cin2ChabMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Cin2ChabMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Cin2ChabFoMaterialBehaviourInstance, Cin2ChabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Cin2ChabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Cin2ChabFoMaterialBehaviourInstance >))
        .def( "getName", &Cin2ChabFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Cin2ChabFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Cin2NradMaterialBehaviourInstance, Cin2NradMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Cin2NradMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Cin2NradMaterialBehaviourInstance >))
        .def( "getName", &Cin2NradMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Cin2NradMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MemoEcroMaterialBehaviourInstance, MemoEcroMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MemoEcroMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MemoEcroMaterialBehaviourInstance >))
        .def( "getName", &MemoEcroMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MemoEcroMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MemoEcroFoMaterialBehaviourInstance, MemoEcroFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MemoEcroFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MemoEcroFoMaterialBehaviourInstance >))
        .def( "getName", &MemoEcroFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MemoEcroFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscochabMaterialBehaviourInstance, ViscochabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscochabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscochabMaterialBehaviourInstance >))
        .def( "getName", &ViscochabMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscochabMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscochabFoMaterialBehaviourInstance, ViscochabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscochabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscochabFoMaterialBehaviourInstance >))
        .def( "getName", &ViscochabFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscochabFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LemaitreMaterialBehaviourInstance, LemaitreMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LemaitreMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LemaitreMaterialBehaviourInstance >))
        .def( "getName", &LemaitreMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LemaitreMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LemaitreIrraMaterialBehaviourInstance, LemaitreIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LemaitreIrraMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< LemaitreIrraMaterialBehaviourInstance >))
        .def( "getName", &LemaitreIrraMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LemaitreIrraMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LmarcIrraMaterialBehaviourInstance, LmarcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LmarcIrraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LmarcIrraMaterialBehaviourInstance >))
        .def( "getName", &LmarcIrraMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LmarcIrraMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscIrraLogMaterialBehaviourInstance, ViscIrraLogMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscIrraLogMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscIrraLogMaterialBehaviourInstance >))
        .def( "getName", &ViscIrraLogMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscIrraLogMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< GranIrraLogMaterialBehaviourInstance, GranIrraLogMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "GranIrraLogMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< GranIrraLogMaterialBehaviourInstance >))
        .def( "getName", &GranIrraLogMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &GranIrraLogMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LemaSeuilMaterialBehaviourInstance, LemaSeuilMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LemaSeuilMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LemaSeuilMaterialBehaviourInstance >))
        .def( "getName", &LemaSeuilMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LemaSeuilMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LemaSeuilFoMaterialBehaviourInstance, LemaSeuilFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LemaSeuilFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LemaSeuilFoMaterialBehaviourInstance >))
        .def( "getName", &LemaSeuilFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LemaSeuilFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< Irrad3mMaterialBehaviourInstance, Irrad3mMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "Irrad3mMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< Irrad3mMaterialBehaviourInstance >))
        .def( "getName", &Irrad3mMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &Irrad3mMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LemaitreFoMaterialBehaviourInstance, LemaitreFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LemaitreFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LemaitreFoMaterialBehaviourInstance >))
        .def( "getName", &LemaitreFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LemaitreFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaLemaAniMaterialBehaviourInstance, MetaLemaAniMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaLemaAniMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MetaLemaAniMaterialBehaviourInstance >))
        .def( "getName", &MetaLemaAniMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaLemaAniMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaLemaAniFoMaterialBehaviourInstance, MetaLemaAniFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaLemaAniFoMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< MetaLemaAniFoMaterialBehaviourInstance >))
        .def( "getName", &MetaLemaAniFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &MetaLemaAniFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ArmeMaterialBehaviourInstance, ArmeMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ArmeMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ArmeMaterialBehaviourInstance >))
        .def( "getName", &ArmeMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ArmeMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< AsseCornMaterialBehaviourInstance, AsseCornMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "AsseCornMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< AsseCornMaterialBehaviourInstance >))
        .def( "getName", &AsseCornMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &AsseCornMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisContactMaterialBehaviourInstance, DisContactMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisContactMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisContactMaterialBehaviourInstance >))
        .def( "getName", &DisContactMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisContactMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EndoScalaireMaterialBehaviourInstance, EndoScalaireMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EndoScalaireMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< EndoScalaireMaterialBehaviourInstance >))
        .def( "getName", &EndoScalaireMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EndoScalaireMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EndoScalaireFoMaterialBehaviourInstance, EndoScalaireFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EndoScalaireFoMaterialBehaviour",
                                                         no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< EndoScalaireFoMaterialBehaviourInstance >))
        .def( "getName", &EndoScalaireFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &EndoScalaireFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EndoFissExpMaterialBehaviourInstance, EndoFissExpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EndoFissExpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EndoFissExpMaterialBehaviourInstance >))
        .def( "getName", &EndoFissExpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EndoFissExpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EndoFissExpFoMaterialBehaviourInstance, EndoFissExpFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EndoFissExpFoMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< EndoFissExpFoMaterialBehaviourInstance >))
        .def( "getName", &EndoFissExpFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &EndoFissExpFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisGricraMaterialBehaviourInstance, DisGricraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisGricraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisGricraMaterialBehaviourInstance >))
        .def( "getName", &DisGricraMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisGricraMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BetonDoubleDpMaterialBehaviourInstance, BetonDoubleDpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonDoubleDpMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< BetonDoubleDpMaterialBehaviourInstance >))
        .def( "getName", &BetonDoubleDpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &BetonDoubleDpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MazarsMaterialBehaviourInstance, MazarsMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MazarsMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MazarsMaterialBehaviourInstance >))
        .def( "getName", &MazarsMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MazarsMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MazarsFoMaterialBehaviourInstance, MazarsFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MazarsFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MazarsFoMaterialBehaviourInstance >))
        .def( "getName", &MazarsFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MazarsFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< JointBaMaterialBehaviourInstance, JointBaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "JointBaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< JointBaMaterialBehaviourInstance >))
        .def( "getName", &JointBaMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &JointBaMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< VendochabMaterialBehaviourInstance, VendochabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "VendochabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< VendochabMaterialBehaviourInstance >))
        .def( "getName", &VendochabMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &VendochabMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< VendochabFoMaterialBehaviourInstance, VendochabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "VendochabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< VendochabFoMaterialBehaviourInstance >))
        .def( "getName", &VendochabFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &VendochabFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< HayhurstMaterialBehaviourInstance, HayhurstMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "HayhurstMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< HayhurstMaterialBehaviourInstance >))
        .def( "getName", &HayhurstMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &HayhurstMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscEndoMaterialBehaviourInstance, ViscEndoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscEndoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscEndoMaterialBehaviourInstance >))
        .def( "getName", &ViscEndoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscEndoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscEndoFoMaterialBehaviourInstance, ViscEndoFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscEndoFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ViscEndoFoMaterialBehaviourInstance >))
        .def( "getName", &ViscEndoFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscEndoFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< PintoMenegottoMaterialBehaviourInstance, PintoMenegottoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "PintoMenegottoMaterialBehaviour",
                                                         no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< PintoMenegottoMaterialBehaviourInstance >))
        .def( "getName", &PintoMenegottoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &PintoMenegottoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BpelBetonMaterialBehaviourInstance, BpelBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BpelBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< BpelBetonMaterialBehaviourInstance >))
        .def( "getName", &BpelBetonMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BpelBetonMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BpelAcierMaterialBehaviourInstance, BpelAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BpelAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< BpelAcierMaterialBehaviourInstance >))
        .def( "getName", &BpelAcierMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BpelAcierMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EtccBetonMaterialBehaviourInstance, EtccBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EtccBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EtccBetonMaterialBehaviourInstance >))
        .def( "getName", &EtccBetonMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EtccBetonMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EtccAcierMaterialBehaviourInstance, EtccAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EtccAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< EtccAcierMaterialBehaviourInstance >))
        .def( "getName", &EtccAcierMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EtccAcierMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MohrCoulombMaterialBehaviourInstance, MohrCoulombMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MohrCoulombMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MohrCoulombMaterialBehaviourInstance >))
        .def( "getName", &MohrCoulombMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MohrCoulombMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CamClayMaterialBehaviourInstance, CamClayMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CamClayMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CamClayMaterialBehaviourInstance >))
        .def( "getName", &CamClayMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CamClayMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BarceloneMaterialBehaviourInstance, BarceloneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BarceloneMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< BarceloneMaterialBehaviourInstance >))
        .def( "getName", &BarceloneMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BarceloneMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CjsMaterialBehaviourInstance, CjsMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CjsMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CjsMaterialBehaviourInstance >))
        .def( "getName", &CjsMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CjsMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< HujeuxMaterialBehaviourInstance, HujeuxMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "HujeuxMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< HujeuxMaterialBehaviourInstance >))
        .def( "getName", &HujeuxMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &HujeuxMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< EcroAsymLineMaterialBehaviourInstance, EcroAsymLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "EcroAsymLineMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< EcroAsymLineMaterialBehaviourInstance >))
        .def( "getName", &EcroAsymLineMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &EcroAsymLineMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< GrangerFpMaterialBehaviourInstance, GrangerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "GrangerFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< GrangerFpMaterialBehaviourInstance >))
        .def( "getName", &GrangerFpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &GrangerFpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< GrangerFp_indtMaterialBehaviourInstance, GrangerFp_indtMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "GrangerFp_indtMaterialBehaviour",
                                                         no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< GrangerFp_indtMaterialBehaviourInstance >))
        .def( "getName", &GrangerFp_indtMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &GrangerFp_indtMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< VGrangerFpMaterialBehaviourInstance, VGrangerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "VGrangerFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< VGrangerFpMaterialBehaviourInstance >))
        .def( "getName", &VGrangerFpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &VGrangerFpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BetonUmlvFpMaterialBehaviourInstance, BetonUmlvFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonUmlvFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< BetonUmlvFpMaterialBehaviourInstance >))
        .def( "getName", &BetonUmlvFpMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonUmlvFpMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< BetonRagMaterialBehaviourInstance, BetonRagMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "BetonRagMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< BetonRagMaterialBehaviourInstance >))
        .def( "getName", &BetonRagMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &BetonRagMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< PoroBetonMaterialBehaviourInstance, PoroBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "PoroBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< PoroBetonMaterialBehaviourInstance >))
        .def( "getName", &PoroBetonMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &PoroBetonMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< GlrcDmMaterialBehaviourInstance, GlrcDmMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "GlrcDmMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< GlrcDmMaterialBehaviourInstance >))
        .def( "getName", &GlrcDmMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &GlrcDmMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DhrcMaterialBehaviourInstance, DhrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DhrcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DhrcMaterialBehaviourInstance >))
        .def( "getName", &DhrcMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DhrcMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< GattMonerieMaterialBehaviourInstance, GattMonerieMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "GattMonerieMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< GattMonerieMaterialBehaviourInstance >))
        .def( "getName", &GattMonerieMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &GattMonerieMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CorrAcierMaterialBehaviourInstance, CorrAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CorrAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CorrAcierMaterialBehaviourInstance >))
        .def( "getName", &CorrAcierMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CorrAcierMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CableGaineFrotMaterialBehaviourInstance, CableGaineFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CableGaineFrotMaterialBehaviour",
                                                         no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< CableGaineFrotMaterialBehaviourInstance >))
        .def( "getName", &CableGaineFrotMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &CableGaineFrotMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisEcroCineMaterialBehaviourInstance, DisEcroCineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisEcroCineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisEcroCineMaterialBehaviourInstance >))
        .def( "getName", &DisEcroCineMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisEcroCineMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisViscMaterialBehaviourInstance, DisViscMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisViscMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisViscMaterialBehaviourInstance >))
        .def( "getName", &DisViscMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisViscMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisEcroTracMaterialBehaviourInstance, DisEcroTracMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisEcroTracMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisEcroTracMaterialBehaviourInstance >))
        .def( "getName", &DisEcroTracMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisEcroTracMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DisBiliElasMaterialBehaviourInstance, DisBiliElasMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DisBiliElasMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisBiliElasMaterialBehaviourInstance >))
        .def( "getName", &DisBiliElasMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DisBiliElasMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherNlMaterialBehaviourInstance, TherNlMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherNlMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherNlMaterialBehaviourInstance >))
        .def( "getName", &TherNlMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherNlMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherHydrMaterialBehaviourInstance, TherHydrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherHydrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherHydrMaterialBehaviourInstance >))
        .def( "getName", &TherHydrMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherHydrMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherMaterialBehaviourInstance, TherMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherMaterialBehaviourInstance >))
        .def( "getName", &TherMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherFoMaterialBehaviourInstance, TherFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherFoMaterialBehaviourInstance >))
        .def( "getName", &TherFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherOrthMaterialBehaviourInstance, TherOrthMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherOrthMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherOrthMaterialBehaviourInstance >))
        .def( "getName", &TherOrthMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherOrthMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherCoqueMaterialBehaviourInstance, TherCoqueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherCoqueMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherCoqueMaterialBehaviourInstance >))
        .def( "getName", &TherCoqueMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherCoqueMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< TherCoqueFoMaterialBehaviourInstance, TherCoqueFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "TherCoqueFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TherCoqueFoMaterialBehaviourInstance >))
        .def( "getName", &TherCoqueFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &TherCoqueFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< SechGrangerMaterialBehaviourInstance, SechGrangerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "SechGrangerMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< SechGrangerMaterialBehaviourInstance >))
        .def( "getName", &SechGrangerMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &SechGrangerMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< SechMensiMaterialBehaviourInstance, SechMensiMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "SechMensiMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< SechMensiMaterialBehaviourInstance >))
        .def( "getName", &SechMensiMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &SechMensiMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< SechBazantMaterialBehaviourInstance, SechBazantMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "SechBazantMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< SechBazantMaterialBehaviourInstance >))
        .def( "getName", &SechBazantMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &SechBazantMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< SechNappeMaterialBehaviourInstance, SechNappeMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "SechNappeMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< SechNappeMaterialBehaviourInstance >))
        .def( "getName", &SechNappeMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &SechNappeMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaAcierMaterialBehaviourInstance, MetaAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MetaAcierMaterialBehaviourInstance >))
        .def( "getName", &MetaAcierMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaAcierMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaZircMaterialBehaviourInstance, MetaZircMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaZircMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MetaZircMaterialBehaviourInstance >))
        .def( "getName", &MetaZircMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaZircMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DurtMetaMaterialBehaviourInstance, DurtMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DurtMetaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DurtMetaMaterialBehaviourInstance >))
        .def( "getName", &DurtMetaMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DurtMetaMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasMetaMaterialBehaviourInstance, ElasMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasMetaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasMetaMaterialBehaviourInstance >))
        .def( "getName", &ElasMetaMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasMetaFoMaterialBehaviourInstance, ElasMetaFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasMetaFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasMetaFoMaterialBehaviourInstance >))
        .def( "getName", &ElasMetaFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasMetaFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaEcroLineMaterialBehaviourInstance, MetaEcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaEcroLineMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< MetaEcroLineMaterialBehaviourInstance >))
        .def( "getName", &MetaEcroLineMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaEcroLineMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaTractionMaterialBehaviourInstance, MetaTractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaTractionMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< MetaTractionMaterialBehaviourInstance >))
        .def( "getName", &MetaTractionMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaTractionMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" )
        .def( "hasTractionFunction", &MetaTractionMaterialBehaviourInstance::hasTractionFunction );

    class_< MetaViscFoMaterialBehaviourInstance, MetaViscFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaViscFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MetaViscFoMaterialBehaviourInstance >))
        .def( "getName", &MetaViscFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaViscFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaPtMaterialBehaviourInstance, MetaPtMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaPtMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MetaPtMaterialBehaviourInstance >))
        .def( "getName", &MetaPtMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaPtMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MetaReMaterialBehaviourInstance, MetaReMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MetaReMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MetaReMaterialBehaviourInstance >))
        .def( "getName", &MetaReMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MetaReMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< FluideMaterialBehaviourInstance, FluideMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "FluideMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< FluideMaterialBehaviourInstance >))
        .def( "getName", &FluideMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &FluideMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmInitMaterialBehaviourInstance, ThmInitMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmInitMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmInitMaterialBehaviourInstance >))
        .def( "getName", &ThmInitMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmInitMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmAirDissMaterialBehaviourInstance, ThmAirDissMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmAirDissMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmAirDissMaterialBehaviourInstance >))
        .def( "getName", &ThmAirDissMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmAirDissMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmDiffuMaterialBehaviourInstance, ThmDiffuMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmDiffuMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmDiffuMaterialBehaviourInstance >))
        .def( "getName", &ThmDiffuMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmDiffuMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmLiquMaterialBehaviourInstance, ThmLiquMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmLiquMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmLiquMaterialBehaviourInstance >))
        .def( "getName", &ThmLiquMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmLiquMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmGazMaterialBehaviourInstance, ThmGazMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmGazMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmGazMaterialBehaviourInstance >))
        .def( "getName", &ThmGazMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmGazMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmVapeGazMaterialBehaviourInstance, ThmVapeGazMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmVapeGazMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmVapeGazMaterialBehaviourInstance >))
        .def( "getName", &ThmVapeGazMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmVapeGazMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< FatigueMaterialBehaviourInstance, FatigueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "FatigueMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< FatigueMaterialBehaviourInstance >))
        .def( "getName", &FatigueMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &FatigueMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DommaLemaitreMaterialBehaviourInstance, DommaLemaitreMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DommaLemaitreMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< DommaLemaitreMaterialBehaviourInstance >))
        .def( "getName", &DommaLemaitreMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &DommaLemaitreMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CisaPlanCritMaterialBehaviourInstance, CisaPlanCritMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CisaPlanCritMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< CisaPlanCritMaterialBehaviourInstance >))
        .def( "getName", &CisaPlanCritMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CisaPlanCritMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ThmRuptMaterialBehaviourInstance, ThmRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ThmRuptMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ThmRuptMaterialBehaviourInstance >))
        .def( "getName", &ThmRuptMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ThmRuptMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< WeibullMaterialBehaviourInstance, WeibullMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "WeibullMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< WeibullMaterialBehaviourInstance >))
        .def( "getName", &WeibullMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &WeibullMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< WeibullFoMaterialBehaviourInstance, WeibullFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "WeibullFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< WeibullFoMaterialBehaviourInstance >))
        .def( "getName", &WeibullFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &WeibullFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< NonLocalMaterialBehaviourInstance, NonLocalMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "NonLocalMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< NonLocalMaterialBehaviourInstance >))
        .def( "getName", &NonLocalMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &NonLocalMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RuptFragMaterialBehaviourInstance, RuptFragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RuptFragMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< RuptFragMaterialBehaviourInstance >))
        .def( "getName", &RuptFragMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RuptFragFoMaterialBehaviourInstance, RuptFragFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RuptFragFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< RuptFragFoMaterialBehaviourInstance >))
        .def( "getName", &RuptFragFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptFragFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CzmLabMixMaterialBehaviourInstance, CzmLabMixMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CzmLabMixMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CzmLabMixMaterialBehaviourInstance >))
        .def( "getName", &CzmLabMixMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CzmLabMixMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RuptDuctMaterialBehaviourInstance, RuptDuctMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RuptDuctMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< RuptDuctMaterialBehaviourInstance >))
        .def( "getName", &RuptDuctMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RuptDuctMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< JointMecaRuptMaterialBehaviourInstance, JointMecaRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "JointMecaRuptMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< JointMecaRuptMaterialBehaviourInstance >))
        .def( "getName", &JointMecaRuptMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &JointMecaRuptMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< JointMecaFrotMaterialBehaviourInstance, JointMecaFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "JointMecaFrotMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< JointMecaFrotMaterialBehaviourInstance >))
        .def( "getName", &JointMecaFrotMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &JointMecaFrotMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RccmMaterialBehaviourInstance, RccmMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RccmMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< RccmMaterialBehaviourInstance >))
        .def( "getName", &RccmMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RccmMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< RccmFoMaterialBehaviourInstance, RccmFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "RccmFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< RccmFoMaterialBehaviourInstance >))
        .def( "getName", &RccmFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &RccmFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LaigleMaterialBehaviourInstance, LaigleMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LaigleMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LaigleMaterialBehaviourInstance >))
        .def( "getName", &LaigleMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LaigleMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< LetkMaterialBehaviourInstance, LetkMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "LetkMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LetkMaterialBehaviourInstance >))
        .def( "getName", &LetkMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &LetkMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DruckPragerMaterialBehaviourInstance, DruckPragerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DruckPragerMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DruckPragerMaterialBehaviourInstance >))
        .def( "getName", &DruckPragerMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &DruckPragerMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< DruckPragerFoMaterialBehaviourInstance, DruckPragerFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "DruckPragerFoMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< DruckPragerFoMaterialBehaviourInstance >))
        .def( "getName", &DruckPragerFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &DruckPragerFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ViscDrucPragMaterialBehaviourInstance, ViscDrucPragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ViscDrucPragMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ViscDrucPragMaterialBehaviourInstance >))
        .def( "getName", &ViscDrucPragMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ViscDrucPragMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< HoekBrownMaterialBehaviourInstance, HoekBrownMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "HoekBrownMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< HoekBrownMaterialBehaviourInstance >))
        .def( "getName", &HoekBrownMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &HoekBrownMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< ElasGonfMaterialBehaviourInstance, ElasGonfMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "ElasGonfMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElasGonfMaterialBehaviourInstance >))
        .def( "getName", &ElasGonfMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &ElasGonfMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< JointBandisMaterialBehaviourInstance, JointBandisMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "JointBandisMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< JointBandisMaterialBehaviourInstance >))
        .def( "getName", &JointBandisMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &JointBandisMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoVisc1MaterialBehaviourInstance, MonoVisc1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoVisc1MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoVisc1MaterialBehaviourInstance >))
        .def( "getName", &MonoVisc1MaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoVisc1MaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoVisc2MaterialBehaviourInstance, MonoVisc2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoVisc2MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoVisc2MaterialBehaviourInstance >))
        .def( "getName", &MonoVisc2MaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoVisc2MaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoIsot1MaterialBehaviourInstance, MonoIsot1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoIsot1MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoIsot1MaterialBehaviourInstance >))
        .def( "getName", &MonoIsot1MaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoIsot1MaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoIsot2MaterialBehaviourInstance, MonoIsot2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoIsot2MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoIsot2MaterialBehaviourInstance >))
        .def( "getName", &MonoIsot2MaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoIsot2MaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoCine1MaterialBehaviourInstance, MonoCine1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoCine1MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoCine1MaterialBehaviourInstance >))
        .def( "getName", &MonoCine1MaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoCine1MaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoCine2MaterialBehaviourInstance, MonoCine2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoCine2MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoCine2MaterialBehaviourInstance >))
        .def( "getName", &MonoCine2MaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoCine2MaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoDdKrMaterialBehaviourInstance, MonoDdKrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoDdKrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoDdKrMaterialBehaviourInstance >))
        .def( "getName", &MonoDdKrMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoDdKrMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoDdCfcMaterialBehaviourInstance, MonoDdCfcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoDdCfcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoDdCfcMaterialBehaviourInstance >))
        .def( "getName", &MonoDdCfcMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoDdCfcMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoDdCfcIrraMaterialBehaviourInstance, MonoDdCfcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoDdCfcIrraMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< MonoDdCfcIrraMaterialBehaviourInstance >))
        .def( "getName", &MonoDdCfcIrraMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues",
              &MonoDdCfcIrraMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoDdFatMaterialBehaviourInstance, MonoDdFatMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoDdFatMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoDdFatMaterialBehaviourInstance >))
        .def( "getName", &MonoDdFatMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoDdFatMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoDdCcMaterialBehaviourInstance, MonoDdCcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoDdCcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MonoDdCcMaterialBehaviourInstance >))
        .def( "getName", &MonoDdCcMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoDdCcMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MonoDdCcIrraMaterialBehaviourInstance, MonoDdCcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MonoDdCcIrraMaterialBehaviour", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< MonoDdCcIrraMaterialBehaviourInstance >))
        .def( "getName", &MonoDdCcIrraMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MonoDdCcIrraMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< UMatMaterialBehaviourInstance, UMatMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "UMatMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< UMatMaterialBehaviourInstance >))
        .def( "getName", &UMatMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &UMatMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< UMatFoMaterialBehaviourInstance, UMatFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "UMatFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< UMatFoMaterialBehaviourInstance >))
        .def( "getName", &UMatFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &UMatFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< CritRuptMaterialBehaviourInstance, CritRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "CritRuptMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CritRuptMaterialBehaviourInstance >))
        .def( "getName", &CritRuptMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &CritRuptMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MFrontMaterialBehaviourInstance, MFrontMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MFrontMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MFrontMaterialBehaviourInstance >))
        .def( "getName", &MFrontMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MFrontMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );

    class_< MFrontFoMaterialBehaviourInstance, MFrontFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >( "MFrontFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MFrontFoMaterialBehaviourInstance >))
        .def( "getName", &MFrontFoMaterialBehaviourInstance::getName )
        .staticmethod( "getName" )
        .def( "hasConvertibleValues", &MFrontFoMaterialBehaviourInstance::hasConvertibleValues )
        .staticmethod( "hasConvertibleValues" );
};
