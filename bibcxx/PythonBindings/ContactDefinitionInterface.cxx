/**
 * @file ContactDefinitionInterface.cxx
 * @brief Interface python de ContactDefinition
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/ContactDefinitionInterface.h"


void exportContactDefinitionToPython()
{
    using namespace boost::python;

    enum_< FrictionEnum >( "Friction" )
        .value( "Coulomb", Coulomb )
        .value( "WithoutFriction", WithoutFriction )
        ;

    enum_< GeometricResolutionAlgorithmEnum >( "GeometricResolutionAlgorithm" )
        .value( "FixPoint", FixPoint )
        .value( "Newton", Newton )
        ;

    enum_< GeometricUpdateEnum >( "GeometricUpdate" )
        .value( "AutoUpdate", AutoUpdate )
        .value( "Controlled", Controlled )
        .value( "WithoutGeometricUpdate", WithoutGeometricUpdate )
        ;

    enum_< ContactPrecondEnum >( "ContactPrecond" )
        .value( "Dirichlet", Dirichlet )
        .value( "WithoutPrecond", WithoutPrecond )
        ;

    class_< DiscretizedContactInstance, DiscretizedContactPtr,
            bases< DataStructure > > ( "DiscretizedContact", no_init )
        .def( "__init__", make_constructor(
            factory0< DiscretizedContactInstance,
                      DiscretizedContactPtr >) )
        .def( "__init__", make_constructor(
            factory0Name< DiscretizedContactInstance,
                          DiscretizedContactPtr >) )
        .def( "addContactZone", &DiscretizedContactInstance::addContactZone )
        .def( "build", &DiscretizedContactInstance::build )
        .def( "setModel", &DiscretizedContactInstance::setModel )
        .def( "setGeometricResolutionAlgorithm",
              &DiscretizedContactInstance::setGeometricResolutionAlgorithm<Discretized> )
        .def( "setGeometricUpdate",
              &DiscretizedContactInstance::setGeometricUpdate<Discretized> )
        .def( "setMaximumNumberOfGeometricIteration",
              &DiscretizedContactInstance::setMaximumNumberOfGeometricIteration<Discretized> )
        .def( "setGeometricResidual",
              &DiscretizedContactInstance::setGeometricResidual<Discretized> )
        .def( "setNumberOfGeometricIteration",
              &DiscretizedContactInstance::setNumberOfGeometricIteration<Discretized> )
        .def( "setNormsSmooth", &DiscretizedContactInstance::setNormsSmooth<Discretized> )
        .def( "setNormsVerification",
              &DiscretizedContactInstance::setNormsVerification<Discretized> )
        .def( "setStopOnInterpenetrationDetection",
              &DiscretizedContactInstance::setStopOnInterpenetrationDetection<Discretized> )
        .def( "setContactAlgorithm",
              &DiscretizedContactInstance::setContactAlgorithm<Discretized> )
        .def( "enableContactMatrixSingularityDetection",
              &DiscretizedContactInstance::enableContactMatrixSingularityDetection<Discretized> )
        .def( "numberOfSolversForSchurComplement",
              &DiscretizedContactInstance::numberOfSolversForSchurComplement<Discretized> )
        .def( "setResidualForGcp",
              &DiscretizedContactInstance::setResidualForGcp<Discretized> )
        .def( "allowOutOfBoundLinearSearch",
              &DiscretizedContactInstance::allowOutOfBoundLinearSearch<Discretized> )
        .def( "setPreconditioning",
              &DiscretizedContactInstance::setPreconditioning<Discretized> )
        .def( "setThresholdOfPreconditioningActivation",
              &DiscretizedContactInstance::setThresholdOfPreconditioningActivation<Discretized> )
        .def( "setMaximumNumberOfPreconditioningIteration",
              &DiscretizedContactInstance::setMaximumNumberOfPreconditioningIteration<Discretized> )
    ;

    class_< ContinuousContactInstance, ContinuousContactPtr,
            bases< DataStructure > > ( "ContinuousContact", no_init )
        .def( "__init__", make_constructor(
            factory0< ContinuousContactInstance,
                      ContinuousContactPtr >) )
        .def( "__init__", make_constructor(
            factory0Name< ContinuousContactInstance,
                          ContinuousContactPtr >) )
    ;

    class_< XfemContactInstance, XfemContactPtr,
            bases< DataStructure > > ( "XfemContact", no_init )
        .def( "__init__", make_constructor(
            factory0< XfemContactInstance,
                      XfemContactPtr >) )
        .def( "__init__", make_constructor(
            factory0Name< XfemContactInstance,
                          XfemContactPtr >) )
    ;

    class_< UnilateralConnexionInstance, UnilateralConnexionPtr,
            bases< DataStructure > > ( "UnilateralConnexion", no_init )
        .def( "__init__", make_constructor(
            factory0< UnilateralConnexionInstance,
                      UnilateralConnexionPtr >) )
        .def( "__init__", make_constructor(
            factory0Name< UnilateralConnexionInstance,
                          UnilateralConnexionPtr >) )
    ;
};
