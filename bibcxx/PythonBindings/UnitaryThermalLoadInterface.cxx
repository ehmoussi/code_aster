/**
 * @file UnitaryThermalLoadInterface.cxx
 * @brief Interface python de UnitaryThermalLoad
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

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/UnitaryThermalLoadInterface.h"

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetNormalFlow,
                                        DoubleDistributedFlowInstance::setNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetLowerNormalFlow,
                                        DoubleDistributedFlowInstance::setLowerNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetUpperNormalFlow,
                                        DoubleDistributedFlowInstance::setUpperNormalFlow, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DistributedFlowsetFlowXYZ,
                                        DoubleDistributedFlowInstance::setFlowXYZ, 0, 3 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleNonLinearFlowsetFlow,
                                        DoubleNonLinearFlowInstance::setFlow, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExchangeCoefficient,
                                        DoubleExchangeInstance::setExchangeCoefficient, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExternalTemperature,
                                        DoubleExchangeInstance::setExternalTemperature, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExchangeCoefficientInfSup,
                                        DoubleExchangeInstance::setExchangeCoefficientInfSup, 0, 2 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangesetExternalTemperatureInfSup,
                                        DoubleExchangeInstance::setExternalTemperatureInfSup, 0, 2 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleExchangeWallsetExchangeCoefficient,
                                        DoubleExchangeWallInstance::setExchangeCoefficient, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleSourcesetSource, DoubleSourceInstance::setSource, 0,
                                        1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleNonLinearSourcesetSource,
                                        DoubleNonLinearSourceInstance::setSource, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalRadiationsetExternalTemperature,
                                        DoubleThermalRadiationInstance::setExternalTemperature, 0,
                                        1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalRadiationsetEpsilon,
                                        DoubleThermalRadiationInstance::setEpsilon, 0, 1 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalRadiationsetSigma,
                                        DoubleThermalRadiationInstance::setSigma, 0, 1 )

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( DoubleThermalGradientsetFlowXYZ,
                                        DoubleThermalGradientInstance::setFlowXYZ, 0, 3 )

void exportUnitaryThermalLoadToPython() {
    using namespace boost::python;

    class_< UnitaryThermalLoadInstance, UnitaryThermalLoadInstance::UnitaryThermalLoadPtr >(
        "UnitaryThermalLoad", no_init );

    class_< DoubleImposedTemperatureInstance, DoubleImposedTemperaturePtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleImposedTemperature", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleImposedTemperatureInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleImposedTemperatureInstance, double >))
        .def( "addGroupOfNodes", &DoubleImposedTemperatureInstance::addGroupOfNodes );

    class_< DoubleDistributedFlowInstance, DoubleDistributedFlowPtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleDistributedFlow", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleDistributedFlowInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleDistributedFlowInstance, double >))
        .def( "addGroupOfElements", &DoubleDistributedFlowInstance::addGroupOfElements )
        .def( "setNormalFlow", &DoubleDistributedFlowInstance::setNormalFlow,
              DistributedFlowsetNormalFlow() )
        .def( "setLowerNormalFlow", &DoubleDistributedFlowInstance::setLowerNormalFlow,
              DistributedFlowsetLowerNormalFlow() )
        .def( "setUpperNormalFlow", &DoubleDistributedFlowInstance::setUpperNormalFlow,
              DistributedFlowsetUpperNormalFlow() )
        .def( "setFlowXYZ", &DoubleDistributedFlowInstance::setFlowXYZ,
              DistributedFlowsetFlowXYZ() );

    class_< DoubleNonLinearFlowInstance, DoubleNonLinearFlowPtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleNonLinearFlow", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleNonLinearFlowInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleNonLinearFlowInstance, double >))
        .def( "addGroupOfElements", &DoubleNonLinearFlowInstance::addGroupOfElements )
        .def( "setFlow", &DoubleNonLinearFlowInstance::setFlow, DoubleNonLinearFlowsetFlow() );

    class_< DoubleExchangeInstance, DoubleExchangePtr, bases< UnitaryThermalLoadInstance > >(
        "DoubleExchange", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleExchangeInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleExchangeInstance, double >))
        .def( "addGroupOfElements", &DoubleExchangeInstance::addGroupOfElements )
        .def( "setExchangeCoefficient", &DoubleExchangeInstance::setExchangeCoefficient,
              DoubleExchangesetExchangeCoefficient() )
        .def( "setExternalTemperature", &DoubleExchangeInstance::setExternalTemperature,
              DoubleExchangesetExternalTemperature() )
        .def( "setExchangeCoefficientInfSup", &DoubleExchangeInstance::setExchangeCoefficientInfSup,
              DoubleExchangesetExchangeCoefficientInfSup() )
        .def( "setExternalTemperatureInfSup", &DoubleExchangeInstance::setExternalTemperatureInfSup,
              DoubleExchangesetExternalTemperatureInfSup() );

    class_< DoubleExchangeWallInstance, DoubleExchangeWallPtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleExchangeWall", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleExchangeWallInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleExchangeWallInstance, double >))
        .def( "addGroupOfElements", &DoubleExchangeWallInstance::addGroupOfElements )
        .def( "setExchangeCoefficient", &DoubleExchangeWallInstance::setExchangeCoefficient,
              DoubleExchangeWallsetExchangeCoefficient() )
        .def( "setTranslation", &DoubleExchangeWallInstance::setTranslation );

    class_< DoubleSourceInstance, DoubleSourcePtr, bases< UnitaryThermalLoadInstance > >(
        "DoubleSource", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleSourceInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleSourceInstance, double >))
        .def( "addGroupOfElements", &DoubleSourceInstance::addGroupOfElements )
        .def( "setSource", &DoubleSourceInstance::setSource, DoubleSourcesetSource() );

    class_< DoubleNonLinearSourceInstance, DoubleNonLinearSourcePtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleNonLinearSource", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleNonLinearSourceInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleNonLinearSourceInstance, double >))
        .def( "addGroupOfElements", &DoubleNonLinearSourceInstance::addGroupOfElements )
        .def( "setSource", &DoubleNonLinearSourceInstance::setSource,
              DoubleNonLinearSourcesetSource() );

    class_< DoubleThermalRadiationInstance, DoubleThermalRadiationPtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleThermalRadiation", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleThermalRadiationInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleThermalRadiationInstance, double >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleThermalRadiationInstance, double, double >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< DoubleThermalRadiationInstance, double, double, double >))
        .def( "addGroupOfElements", &DoubleThermalRadiationInstance::addGroupOfElements )
        .def( "setExternalTemperature", &DoubleThermalRadiationInstance::setExternalTemperature,
              DoubleThermalRadiationsetExternalTemperature() )
        .def( "setEpsilon", &DoubleThermalRadiationInstance::setEpsilon,
              DoubleThermalRadiationsetEpsilon() )
        .def( "setSigma", &DoubleThermalRadiationInstance::setSigma,
              DoubleThermalRadiationsetSigma() );

    class_< DoubleThermalGradientInstance, DoubleThermalGradientPtr,
            bases< UnitaryThermalLoadInstance > >( "DoubleThermalGradient", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DoubleThermalGradientInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleThermalGradientInstance, double >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DoubleThermalGradientInstance, double, double >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< DoubleThermalGradientInstance, double, double, double >))
        .def( "addGroupOfElements", &DoubleThermalGradientInstance::addGroupOfElements )
        .def( "setFlowXYZ", &DoubleThermalGradientInstance::setFlowXYZ,
              DoubleThermalGradientsetFlowXYZ() );
};
