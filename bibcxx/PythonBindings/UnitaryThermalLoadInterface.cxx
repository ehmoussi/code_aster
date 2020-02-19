/**
 * @file UnitaryThermalLoadInterface.cxx
 * @brief Interface python de UnitaryThermalLoad
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

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/UnitaryThermalLoadInterface.h"

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetNormalFlow,
                                        RealDistributedFlowClass::setNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetLowerNormalFlow,
                                        RealDistributedFlowClass::setLowerNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetUpperNormalFlow,
                                        RealDistributedFlowClass::setUpperNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetFlowXYZ,
                                        RealDistributedFlowClass::setFlowXYZ, 0, 3 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealNonLinearFlowsetFlow,
                                        RealNonLinearFlowClass::setFlow, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealExchangesetExchangeCoefficient,
                                        RealExchangeClass::setExchangeCoefficient, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealExchangesetExternalTemperature,
                                        RealExchangeClass::setExternalTemperature, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealExchangesetExchangeCoefficientInfSup,
                                        RealExchangeClass::setExchangeCoefficientInfSup, 0, 2 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealExchangesetExternalTemperatureInfSup,
                                        RealExchangeClass::setExternalTemperatureInfSup, 0, 2 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealExchangeWallsetExchangeCoefficient,
                                        RealExchangeWallClass::setExchangeCoefficient, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealSourcesetSource, RealSourceClass::setSource, 0,
                                        1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealNonLinearSourcesetSource,
                                        RealNonLinearSourceClass::setSource, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealThermalRadiationsetExternalTemperature,
                                        RealThermalRadiationClass::setExternalTemperature, 0,
                                        1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealThermalRadiationsetEpsilon,
                                        RealThermalRadiationClass::setEpsilon, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealThermalRadiationsetSigma,
                                        RealThermalRadiationClass::setSigma, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( RealThermalGradientsetFlowXYZ,
                                        RealThermalGradientClass::setFlowXYZ, 0, 3 )

void exportUnitaryThermalLoadToPython() {

    py::class_< UnitaryThermalLoadClass, UnitaryThermalLoadClass::UnitaryThermalLoadPtr >(
        "UnitaryThermalLoad", py::no_init );

    py::class_< RealImposedTemperatureClass, RealImposedTemperaturePtr,
                py::bases< UnitaryThermalLoadClass > >( "RealImposedTemperature", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealImposedTemperatureClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealImposedTemperatureClass, double >))
        .def( "addGroupOfNodes", &RealImposedTemperatureClass::addGroupOfNodes );

    py::class_< RealDistributedFlowClass, RealDistributedFlowPtr,
                py::bases< UnitaryThermalLoadClass > >( "RealDistributedFlow", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealDistributedFlowClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealDistributedFlowClass, double >))
        .def( "addGroupOfElements", &RealDistributedFlowClass::addGroupOfElements )
        .def( "setNormalFlow", &RealDistributedFlowClass::setNormalFlow,
              DistributedFlowsetNormalFlow() )
        .def( "setLowerNormalFlow", &RealDistributedFlowClass::setLowerNormalFlow,
              DistributedFlowsetLowerNormalFlow() )
        .def( "setUpperNormalFlow", &RealDistributedFlowClass::setUpperNormalFlow,
              DistributedFlowsetUpperNormalFlow() )
        .def( "setFlowXYZ", &RealDistributedFlowClass::setFlowXYZ,
              DistributedFlowsetFlowXYZ() );

    py::class_< RealNonLinearFlowClass, RealNonLinearFlowPtr,
                py::bases< UnitaryThermalLoadClass > >( "RealNonLinearFlow", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealNonLinearFlowClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealNonLinearFlowClass, double >))
        .def( "addGroupOfElements", &RealNonLinearFlowClass::addGroupOfElements )
        .def( "setFlow", &RealNonLinearFlowClass::setFlow, RealNonLinearFlowsetFlow() );

    py::class_< RealExchangeClass, RealExchangePtr,
                py::bases< UnitaryThermalLoadClass > >( "RealExchange", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealExchangeClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealExchangeClass, double >))
        .def( "addGroupOfElements", &RealExchangeClass::addGroupOfElements )
        .def( "setExchangeCoefficient", &RealExchangeClass::setExchangeCoefficient,
              RealExchangesetExchangeCoefficient() )
        .def( "setExternalTemperature", &RealExchangeClass::setExternalTemperature,
              RealExchangesetExternalTemperature() )
        .def( "setExchangeCoefficientInfSup", &RealExchangeClass::setExchangeCoefficientInfSup,
              RealExchangesetExchangeCoefficientInfSup() )
        .def( "setExternalTemperatureInfSup", &RealExchangeClass::setExternalTemperatureInfSup,
              RealExchangesetExternalTemperatureInfSup() );

    py::class_< RealExchangeWallClass, RealExchangeWallPtr,
                py::bases< UnitaryThermalLoadClass > >( "RealExchangeWall", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealExchangeWallClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealExchangeWallClass, double >))
        .def( "addGroupOfElements", &RealExchangeWallClass::addGroupOfElements )
        .def( "setExchangeCoefficient", &RealExchangeWallClass::setExchangeCoefficient,
              RealExchangeWallsetExchangeCoefficient() )
        .def( "setTranslation", &RealExchangeWallClass::setTranslation );

    py::class_< RealSourceClass, RealSourcePtr, py::bases< UnitaryThermalLoadClass > >(
        "RealSource", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealSourceClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealSourceClass, double >))
        .def( "addGroupOfElements", &RealSourceClass::addGroupOfElements )
        .def( "setSource", &RealSourceClass::setSource, RealSourcesetSource() );

    py::class_< RealNonLinearSourceClass, RealNonLinearSourcePtr,
                py::bases< UnitaryThermalLoadClass > >( "RealNonLinearSource", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealNonLinearSourceClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealNonLinearSourceClass, double >))
        .def( "addGroupOfElements", &RealNonLinearSourceClass::addGroupOfElements )
        .def( "setSource", &RealNonLinearSourceClass::setSource,
              RealNonLinearSourcesetSource() );

    py::class_< RealThermalRadiationClass, RealThermalRadiationPtr,
                py::bases< UnitaryThermalLoadClass > >( "RealThermalRadiation", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealThermalRadiationClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealThermalRadiationClass, double >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< RealThermalRadiationClass, double, double >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< RealThermalRadiationClass, double, double, double >))
        .def( "addGroupOfElements", &RealThermalRadiationClass::addGroupOfElements )
        .def( "setExternalTemperature", &RealThermalRadiationClass::setExternalTemperature,
              RealThermalRadiationsetExternalTemperature() )
        .def( "setEpsilon", &RealThermalRadiationClass::setEpsilon,
              RealThermalRadiationsetEpsilon() )
        .def( "setSigma", &RealThermalRadiationClass::setSigma,
              RealThermalRadiationsetSigma() );

    py::class_< RealThermalGradientClass, RealThermalGradientPtr,
                py::bases< UnitaryThermalLoadClass > >( "RealThermalGradient", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< RealThermalGradientClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< RealThermalGradientClass, double >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< RealThermalGradientClass, double, double >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< RealThermalGradientClass, double, double, double >))
        .def( "addGroupOfElements", &RealThermalGradientClass::addGroupOfElements )
        .def( "setFlowXYZ", &RealThermalGradientClass::setFlowXYZ,
              RealThermalGradientsetFlowXYZ() );
};
