/**
 * @file EventManagerInterface.cxx
 * @brief Interface python de EventManager
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

// Not a DataStructure
// aslint: disable=C3006

#include "PythonBindings/EventManagerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportEventManagerToPython() {

    py::class_< GenericActionClass, GenericActionPtr >( "GenericAction", py::no_init );

    py::class_< StopOnErrorClass, StopOnErrorPtr, py::bases< GenericActionClass > >(
        "StopOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StopOnErrorClass >));

    py::class_< ContinueOnErrorClass, ContinueOnErrorPtr, py::bases< GenericActionClass > >(
        "ContinueOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ContinueOnErrorClass >));

    py::class_< GenericSubstepingOnErrorClass, GenericSubstepingOnErrorPtr,
                py::bases< GenericActionClass > >( "GenericSubstepingOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< GenericSubstepingOnErrorClass >))
        .def( "setAutomatic", &GenericSubstepingOnErrorClass::setAutomatic )
        .def( "setLevel", &GenericSubstepingOnErrorClass::setLevel )
        .def( "setMinimumStep", &GenericSubstepingOnErrorClass::setMinimumStep )
        .def( "setStep", &GenericSubstepingOnErrorClass::setStep );

    py::class_< SubstepingOnErrorClass, SubstepingOnErrorPtr,
                py::bases< GenericSubstepingOnErrorClass > >( "SubstepingOnError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< SubstepingOnErrorClass >));

    py::class_< AddIterationOnErrorClass, AddIterationOnErrorPtr,
                py::bases< GenericSubstepingOnErrorClass > >( "AddIterationOnError",
                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< AddIterationOnErrorClass >))
        .def( "setPourcentageOfAddedIteration",
              &AddIterationOnErrorClass::setPourcentageOfAddedIteration );

    py::class_< SubstepingOnContactClass, SubstepingOnContactPtr,
                py::bases< GenericActionClass > >( "SubstepingOnContact", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< SubstepingOnContactClass >))
        .def( "setSubstepDuration", &SubstepingOnContactClass::setSubstepDuration )
        .def( "setTimeStepSubstep", &SubstepingOnContactClass::setTimeStepSubstep );

    py::class_< PilotageErrorClass, PilotageErrorPtr,
                py::bases< GenericSubstepingOnErrorClass > >( "PilotageError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< PilotageErrorClass >));

    py::class_< ChangePenalisationOnErrorClass, ChangePenalisationOnErrorPtr,
                py::bases< GenericActionClass > >( "ChangePenalisationOnError", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ChangePenalisationOnErrorClass >))
        .def( "setMaximumPenalisationCoefficient",
              &ChangePenalisationOnErrorClass::setMaximumPenalisationCoefficient );

    py::class_< GenericEventErrorClass, GenericEventErrorPtr, boost::noncopyable >(
        "GenericEventError", py::no_init )
        .def( "setAction", &GenericEventErrorClass::setAction );

    py::class_< EventErrorClass, EventErrorPtr, py::bases< GenericEventErrorClass > >(
        "EventError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< EventErrorClass >));

    py::class_< ResidualDivergenceErrorClass, ResidualDivergenceErrorPtr,
                py::bases< GenericEventErrorClass > >( "ResidualDivergenceError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ResidualDivergenceErrorClass >));

    py::class_< IncrementOverboundErrorClass, IncrementOverboundErrorPtr,
                py::bases< GenericEventErrorClass > >( "IncrementOverboundError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< IncrementOverboundErrorClass >))
        .def( "setValueToInspect", &IncrementOverboundErrorClass::setValueToInspect );

    py::class_< ContactDetectionErrorClass, ContactDetectionErrorPtr,
                py::bases< GenericEventErrorClass > >( "ContactDetectionError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ContactDetectionErrorClass >));

    py::class_< InterpenetrationErrorClass, InterpenetrationErrorPtr,
                py::bases< GenericEventErrorClass > >( "InterpenetrationError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< InterpenetrationErrorClass >))
        .def( "setMaximalPenetration", &InterpenetrationErrorClass::setMaximalPenetration );

    py::class_< InstabilityErrorClass, InstabilityErrorPtr,
                py::bases< GenericEventErrorClass > >( "InstabilityError", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< InstabilityErrorClass >));
};
