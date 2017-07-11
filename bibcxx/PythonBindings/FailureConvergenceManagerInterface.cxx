/**
 * @file FailureConvergenceManagerInterface.cxx
 * @brief Interface python de FailureConvergenceManager
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

#include "PythonBindings/FailureConvergenceManagerInterface.h"
#include "PythonBindings/SharedPtrUtilities.h"
#include <boost/python.hpp>

void exportFailureConvergenceManagerToPython()
{
    using namespace boost::python;

    class_< GenericActionInstance, GenericActionPtr > ( "GenericAction", no_init )
    ;

    class_< StopOnErrorInstance, StopOnErrorPtr,
            bases< GenericActionInstance > >
        ( "StopOnError", no_init )
        .def( "create", &createSharedPtr< StopOnErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< ContinueOnErrorInstance, ContinueOnErrorPtr,
            bases< GenericActionInstance > >
        ( "ContinueOnError", no_init )
        .def( "create", &createSharedPtr< ContinueOnErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< GenericSubstepingOnErrorInstance, GenericSubstepingOnErrorPtr,
            bases< GenericActionInstance > >
        ( "GenericSubstepingOnError", no_init )
        .def( "create", &createSharedPtr< GenericSubstepingOnErrorInstance > )
        .staticmethod( "create" )
        .def( "setAutomatic", &GenericSubstepingOnErrorInstance::setAutomatic )
        .def( "setLevel", &GenericSubstepingOnErrorInstance::setLevel )
        .def( "setMinimumStep", &GenericSubstepingOnErrorInstance::setMinimumStep )
        .def( "setStep", &GenericSubstepingOnErrorInstance::setStep )
    ;

    class_< SubstepingOnErrorInstance, SubstepingOnErrorPtr,
            bases< GenericSubstepingOnErrorInstance > >
        ( "SubstepingOnError", no_init )
        .def( "create", &createSharedPtr< SubstepingOnErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< AddIterationOnErrorInstance, AddIterationOnErrorPtr,
            bases< GenericSubstepingOnErrorInstance > >
        ( "AddIterationOnError", no_init )
        .def( "create", &createSharedPtr< AddIterationOnErrorInstance > )
        .staticmethod( "create" )
        .def( "setPourcentageOfAddedIteration",
              &AddIterationOnErrorInstance::setPourcentageOfAddedIteration )
    ;

    class_< SubstepingOnContactInstance, SubstepingOnContactPtr,
            bases< GenericActionInstance > >
        ( "SubstepingOnContact", no_init )
        .def( "create", &createSharedPtr< SubstepingOnContactInstance > )
        .staticmethod( "create" )
        .def( "setSubstepDuration", &SubstepingOnContactInstance::setSubstepDuration )
        .def( "setTimeStepSubstep", &SubstepingOnContactInstance::setTimeStepSubstep )
    ;

    class_< PilotageErrorInstance, PilotageErrorPtr,
            bases< GenericSubstepingOnErrorInstance > >
        ( "PilotageError", no_init )
        .def( "create", &createSharedPtr< PilotageErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< ChangePenalisationOnErrorInstance, ChangePenalisationOnErrorPtr,
            bases< GenericActionInstance > >
        ( "ChangePenalisationOnError", no_init )
        .def( "create", &createSharedPtr< ChangePenalisationOnErrorInstance > )
        .staticmethod( "create" )
        .def( "setMaximumPenalisationCoefficient",
              &ChangePenalisationOnErrorInstance::setMaximumPenalisationCoefficient )
    ;



    class_< GenericConvergenceErrorInstance,
            GenericConvergenceErrorPtr, boost::noncopyable >
        ( "GenericConvergenceError", no_init )
        .def( "setAction", &GenericConvergenceErrorInstance::setAction )
    ;

    class_< ConvergenceErrorInstance, ConvergenceErrorPtr,
            bases< GenericConvergenceErrorInstance > >
        ( "ConvergenceError", no_init )
        .def( "create", &createSharedPtr< ConvergenceErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< ResidualDivergenceErrorInstance, ResidualDivergenceErrorPtr,
            bases< GenericConvergenceErrorInstance > >
        ( "ResidualDivergenceError", no_init )
        .def( "create", &createSharedPtr< ResidualDivergenceErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< IncrementOverboundErrorInstance, IncrementOverboundErrorPtr,
            bases< GenericConvergenceErrorInstance > >
        ( "IncrementOverboundError", no_init )
        .def( "create", &createSharedPtr< IncrementOverboundErrorInstance > )
        .staticmethod( "create" )
        .def( "setValueToInspect", &IncrementOverboundErrorInstance::setValueToInspect )
    ;

    class_< ContactDetectionErrorInstance, ContactDetectionErrorPtr,
            bases< GenericConvergenceErrorInstance > >
        ( "ContactDetectionError", no_init )
        .def( "create", &createSharedPtr< ContactDetectionErrorInstance > )
        .staticmethod( "create" )
    ;

    class_< InterpenetrationErrorInstance, InterpenetrationErrorPtr,
            bases< GenericConvergenceErrorInstance > >
        ( "InterpenetrationError", no_init )
        .def( "create", &createSharedPtr< InterpenetrationErrorInstance > )
        .staticmethod( "create" )
        .def( "setMaximalPenetration", &InterpenetrationErrorInstance::setMaximalPenetration )
    ;

    class_< InstabilityErrorInstance, InstabilityErrorPtr,
            bases< GenericConvergenceErrorInstance > >
        ( "InstabilityError", no_init )
        .def( "create", &createSharedPtr< InstabilityErrorInstance > )
        .staticmethod( "create" )
    ;
};
