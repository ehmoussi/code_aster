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
                                        DoubleDistributedFlowClass::setNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetLowerNormalFlow,
                                        DoubleDistributedFlowClass::setLowerNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetUpperNormalFlow,
                                        DoubleDistributedFlowClass::setUpperNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetFlowXYZ,
                                        DoubleDistributedFlowClass::setFlowXYZ, 0, 3 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleNonLinearFlowsetFlow,
                                        DoubleNonLinearFlowClass::setFlow, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExchangeCoefficient,
                                        DoubleExchangeClass::setExchangeCoefficient, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExternalTemperature,
                                        DoubleExchangeClass::setExternalTemperature, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExchangeCoefficientInfSup,
                                        DoubleExchangeClass::setExchangeCoefficientInfSup, 0, 2 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExternalTemperatureInfSup,
                                        DoubleExchangeClass::setExternalTemperatureInfSup, 0, 2 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangeWallsetExchangeCoefficient,
                                        DoubleExchangeWallClass::setExchangeCoefficient, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleSourcesetSource, DoubleSourceClass::setSource, 0,
                                        1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleNonLinearSourcesetSource,
                                        DoubleNonLinearSourceClass::setSource, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalRadiationsetExternalTemperature,
                                        DoubleThermalRadiationClass::setExternalTemperature, 0,
                                        1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalRadiationsetEpsilon,
                                        DoubleThermalRadiationClass::setEpsilon, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalRadiationsetSigma,
                                        DoubleThermalRadiationClass::setSigma, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalGradientsetFlowXYZ,
                                        DoubleThermalGradientClass::setFlowXYZ, 0, 3 )

void exportUnitaryThermalLoadToPython() {

    py::class_< UnitaryThermalLoadClass, UnitaryThermalLoadClass::UnitaryThermalLoadPtr >(
        "UnitaryThermalLoad", py::no_init );

    py::class_< DoubleImposedTemperatureClass, DoubleImposedTemperaturePtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleImposedTemperature", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleImposedTemperatureClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleImposedTemperatureClass, double >))
        .def( "addGroupOfNodes", &DoubleImposedTemperatureClass::addGroupOfNodes );

    py::class_< DoubleDistributedFlowClass, DoubleDistributedFlowPtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleDistributedFlow", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleDistributedFlowClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleDistributedFlowClass, double >))
        .def( "addGroupOfElements", &DoubleDistributedFlowClass::addGroupOfElements )
        .def( "setNormalFlow", &DoubleDistributedFlowClass::setNormalFlow,
              DistributedFlowsetNormalFlow() )
        .def( "setLowerNormalFlow", &DoubleDistributedFlowClass::setLowerNormalFlow,
              DistributedFlowsetLowerNormalFlow() )
        .def( "setUpperNormalFlow", &DoubleDistributedFlowClass::setUpperNormalFlow,
              DistributedFlowsetUpperNormalFlow() )
        .def( "setFlowXYZ", &DoubleDistributedFlowClass::setFlowXYZ,
              DistributedFlowsetFlowXYZ() );

    py::class_< DoubleNonLinearFlowClass, DoubleNonLinearFlowPtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleNonLinearFlow", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleNonLinearFlowClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleNonLinearFlowClass, double >))
        .def( "addGroupOfElements", &DoubleNonLinearFlowClass::addGroupOfElements )
        .def( "setFlow", &DoubleNonLinearFlowClass::setFlow, DoubleNonLinearFlowsetFlow() );

    py::class_< DoubleExchangeClass, DoubleExchangePtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleExchange", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleExchangeClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleExchangeClass, double >))
        .def( "addGroupOfElements", &DoubleExchangeClass::addGroupOfElements )
        .def( "setExchangeCoefficient", &DoubleExchangeClass::setExchangeCoefficient,
              DoubleExchangesetExchangeCoefficient() )
        .def( "setExternalTemperature", &DoubleExchangeClass::setExternalTemperature,
              DoubleExchangesetExternalTemperature() )
        .def( "setExchangeCoefficientInfSup", &DoubleExchangeClass::setExchangeCoefficientInfSup,
              DoubleExchangesetExchangeCoefficientInfSup() )
        .def( "setExternalTemperatureInfSup", &DoubleExchangeClass::setExternalTemperatureInfSup,
              DoubleExchangesetExternalTemperatureInfSup() );

    py::class_< DoubleExchangeWallClass, DoubleExchangeWallPtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleExchangeWall", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleExchangeWallClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleExchangeWallClass, double >))
        .def( "addGroupOfElements", &DoubleExchangeWallClass::addGroupOfElements )
        .def( "setExchangeCoefficient", &DoubleExchangeWallClass::setExchangeCoefficient,
              DoubleExchangeWallsetExchangeCoefficient() )
        .def( "setTranslation", &DoubleExchangeWallClass::setTranslation );

    py::class_< DoubleSourceClass, DoubleSourcePtr, py::bases< UnitaryThermalLoadClass > >(
        "DoubleSource", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleSourceClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleSourceClass, double >))
        .def( "addGroupOfElements", &DoubleSourceClass::addGroupOfElements )
        .def( "setSource", &DoubleSourceClass::setSource, DoubleSourcesetSource() );

    py::class_< DoubleNonLinearSourceClass, DoubleNonLinearSourcePtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleNonLinearSource", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleNonLinearSourceClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleNonLinearSourceClass, double >))
        .def( "addGroupOfElements", &DoubleNonLinearSourceClass::addGroupOfElements )
        .def( "setSource", &DoubleNonLinearSourceClass::setSource,
              DoubleNonLinearSourcesetSource() );

    py::class_< DoubleThermalRadiationClass, DoubleThermalRadiationPtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleThermalRadiation", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleThermalRadiationClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleThermalRadiationClass, double >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< DoubleThermalRadiationClass, double, double >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DoubleThermalRadiationClass, double, double, double >))
        .def( "addGroupOfElements", &DoubleThermalRadiationClass::addGroupOfElements )
        .def( "setExternalTemperature", &DoubleThermalRadiationClass::setExternalTemperature,
              DoubleThermalRadiationsetExternalTemperature() )
        .def( "setEpsilon", &DoubleThermalRadiationClass::setEpsilon,
              DoubleThermalRadiationsetEpsilon() )
        .def( "setSigma", &DoubleThermalRadiationClass::setSigma,
              DoubleThermalRadiationsetSigma() );

    py::class_< DoubleThermalGradientClass, DoubleThermalGradientPtr,
                py::bases< UnitaryThermalLoadClass > >( "DoubleThermalGradient", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DoubleThermalGradientClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DoubleThermalGradientClass, double >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< DoubleThermalGradientClass, double, double >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DoubleThermalGradientClass, double, double, double >))
        .def( "addGroupOfElements", &DoubleThermalGradientClass::addGroupOfElements )
        .def( "setFlowXYZ", &DoubleThermalGradientClass::setFlowXYZ,
              DoubleThermalGradientsetFlowXYZ() );
};
