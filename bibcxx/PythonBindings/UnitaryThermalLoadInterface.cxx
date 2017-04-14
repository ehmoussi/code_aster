/**
 * @file UnitaryThermalLoadInterface.cxx
 * @brief Interface python de UnitaryThermalLoad
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "PythonBindings/UnitaryThermalLoadInterface.h"
#include <boost/python.hpp>

void exportUnitaryThermalLoadToPython()
{
    using namespace boost::python;

    class_< UnitaryThermalLoadInstance,
            UnitaryThermalLoadInstance::UnitaryThermalLoadPtr > ( "UnitaryThermalLoad", no_init )
    ;

    class_< DoubleImposedTemperatureInstance, DoubleImposedTemperaturePtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleImposedTemperature", no_init )
        .def( "create", &DoubleImposedTemperatureInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfNodes", &DoubleImposedTemperatureInstance::addGroupOfNodes )
    ;

    class_< DoubleDistributedFlowInstance, DoubleDistributedFlowPtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleDistributedFlow", no_init )
        .def( "create", &DoubleDistributedFlowInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfElements", &DoubleDistributedFlowInstance::addGroupOfElements )
        .def( "setNormalFlow", &DoubleDistributedFlowInstance::setNormalFlow )
        .def( "setLowerNormalFlow", &DoubleDistributedFlowInstance::setLowerNormalFlow )
        .def( "setUpperNormalFlow", &DoubleDistributedFlowInstance::setUpperNormalFlow )
        .def( "setFlowXYZ", &DoubleDistributedFlowInstance::setFlowXYZ )
    ;

    class_< DoubleNonLinearFlowInstance, DoubleNonLinearFlowPtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleNonLinearFlow", no_init )
        .def( "create", &DoubleNonLinearFlowInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfElements", &DoubleNonLinearFlowInstance::addGroupOfElements )
        .def( "setFlow", &DoubleNonLinearFlowInstance::setFlow )
    ;

    class_< DoubleExchangeInstance, DoubleExchangePtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleExchange", no_init )
        .def( "create", &UnitaryThermalLoadInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfElements", &DoubleExchangeInstance::addGroupOfElements )
        .def( "setExchangeCoefficient",
              &DoubleExchangeInstance::setExchangeCoefficient )
        .def( "setExternalTemperature",
              &DoubleExchangeInstance::setExternalTemperature )
        .def( "setExchangeCoefficientInfSup",
              &DoubleExchangeInstance::setExchangeCoefficientInfSup )
        .def( "setExternalTemperatureInfSup",
              &DoubleExchangeInstance::setExternalTemperatureInfSup )
    ;

    class_< DoubleExchangeWallInstance, DoubleExchangeWallPtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleExchangeWall", no_init )
        .def( "create", &DoubleExchangeWallInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfElements", &DoubleExchangeWallInstance::addGroupOfElements )
        .def( "setExchangeCoefficient",
              &DoubleExchangeWallInstance::setExchangeCoefficient )
        .def( "setTranslation", &DoubleExchangeWallInstance::setTranslation )
    ;

    class_< DoubleThermalRadiationInstance, DoubleThermalRadiationPtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleThermalRadiation", no_init )
        .def( "create", &DoubleThermalRadiationInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfElements", &DoubleThermalRadiationInstance::addGroupOfElements )
        .def( "setExternalTemperature",
              &DoubleThermalRadiationInstance::setExternalTemperature )
        .def( "setEpsilon", &DoubleThermalRadiationInstance::setEpsilon )
        .def( "setSigma", &DoubleThermalRadiationInstance::setSigma )
    ;

    class_< DoubleThermalGradientInstance, DoubleThermalGradientPtr,
            bases< UnitaryThermalLoadInstance > > ( "DoubleThermalGradient", no_init )
        .def( "create", &DoubleThermalGradientInstance::create )
        .staticmethod( "create" )
        .def( "addGroupOfElements", &DoubleThermalGradientInstance::addGroupOfElements )
        .def( "setFlowXYZ", &DoubleThermalGradientInstance::setFlowXYZ )
    ;
};
