/**
 * @file EventManagerInterface.cxx
 * @brief Interface python de EventManager
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

// Not a DataStructure
// aslint: disable=C3006

#include "PythonBindings/EventManagerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportEventManagerToPython() {

    py::class_< GenericActionInstance, GenericActionPtr >( "GenericAction", py::no_init );

    py::class_< StopOnErrorInstance, StopOnErrorPtr, py::bases< GenericActionInstance > >( "StopOnError",
                                                                                   py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StopOnErrorInstance >));

    py::class_< ContinueOnErrorInstance, ContinueOnErrorPtr, py::bases< GenericActionInstance > >(
        "ContinueOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ContinueOnErrorInstance >));

    py::class_< GenericSubstepingOnErrorInstance, GenericSubstepingOnErrorPtr,
            py::bases< GenericActionInstance > >( "GenericSubstepingOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< GenericSubstepingOnErrorInstance >))
        .def( "setAutomatic", &GenericSubstepingOnErrorInstance::setAutomatic )
        .def( "setLevel", &GenericSubstepingOnErrorInstance::setLevel )
        .def( "setMinimumStep", &GenericSubstepingOnErrorInstance::setMinimumStep )
        .def( "setStep", &GenericSubstepingOnErrorInstance::setStep );

    py::class_< SubstepingOnErrorInstance, SubstepingOnErrorPtr,
            py::bases< GenericSubstepingOnErrorInstance > >( "SubstepingOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< SubstepingOnErrorInstance >));

    py::class_< AddIterationOnErrorInstance, AddIterationOnErrorPtr,
            py::bases< GenericSubstepingOnErrorInstance > >( "AddIterationOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< AddIterationOnErrorInstance >))
        .def( "setPourcentageOfAddedIteration",
              &AddIterationOnErrorInstance::setPourcentageOfAddedIteration );

    py::class_< SubstepingOnContactInstance, SubstepingOnContactPtr, py::bases< GenericActionInstance > >(
        "SubstepingOnContact", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< SubstepingOnContactInstance >))
        .def( "setSubstepDuration", &SubstepingOnContactInstance::setSubstepDuration )
        .def( "setTimeStepSubstep", &SubstepingOnContactInstance::setTimeStepSubstep );

    py::class_< PilotageErrorInstance, PilotageErrorPtr, py::bases< GenericSubstepingOnErrorInstance > >(
        "PilotageError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< PilotageErrorInstance >));

    py::class_< ChangePenalisationOnErrorInstance, ChangePenalisationOnErrorPtr,
            py::bases< GenericActionInstance > >( "ChangePenalisationOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ChangePenalisationOnErrorInstance >))
        .def( "setMaximumPenalisationCoefficient",
              &ChangePenalisationOnErrorInstance::setMaximumPenalisationCoefficient );

    py::class_< GenericEventErrorInstance, GenericEventErrorPtr, boost::noncopyable >(
        "GenericEventError", py::no_init )
        .def( "setAction", &GenericEventErrorInstance::setAction );

    py::class_< EventErrorInstance, EventErrorPtr,
            py::bases< GenericEventErrorInstance > >( "EventError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< EventErrorInstance >));

    py::class_< ResidualDivergenceErrorInstance, ResidualDivergenceErrorPtr,
            py::bases< GenericEventErrorInstance > >( "ResidualDivergenceError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ResidualDivergenceErrorInstance >));

    py::class_< IncrementOverboundErrorInstance, IncrementOverboundErrorPtr,
            py::bases< GenericEventErrorInstance > >( "IncrementOverboundError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< IncrementOverboundErrorInstance >))
        .def( "setValueToInspect", &IncrementOverboundErrorInstance::setValueToInspect );

    py::class_< ContactDetectionErrorInstance, ContactDetectionErrorPtr,
            py::bases< GenericEventErrorInstance > >( "ContactDetectionError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ContactDetectionErrorInstance >));

    py::class_< InterpenetrationErrorInstance, InterpenetrationErrorPtr,
            py::bases< GenericEventErrorInstance > >( "InterpenetrationError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< InterpenetrationErrorInstance >))
        .def( "setMaximalPenetration", &InterpenetrationErrorInstance::setMaximalPenetration );

    py::class_< InstabilityErrorInstance, InstabilityErrorPtr,
            py::bases< GenericEventErrorInstance > >( "InstabilityError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< InstabilityErrorInstance >));
};
