/**
 * @file ContactZoneInterface.cxx
 * @brief Interface python de ContactZone
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

#include "PythonInterfaces/ContactZoneInterface.h"
#include <boost/python.hpp>

void exportContactZoneToPython()
{
    using namespace boost::python;

    enum_< ContactFormulationEnum >( "ContactFormulation" )
        .value( "Discretized", Discretized )
        .value( "Continuous", Continuous )
        .value( "Xfem", Xfem )
        .value( "UnilateralConnexion", UnilateralConnexion )
        ;

    enum_< NormTypeEnum >( "NormType" )
        .value( "MasterNorm", MasterNorm )
        .value( "SlaveNorm", SlaveNorm )
        .value( "AverageNorm", AverageNorm )
        ;

    enum_< PairingEnum >( "Pairing" )
        .value( "NewtonPairing", NewtonPairing )
        .value( "FixPairing", FixPairing )
        ;

    enum_< ContactAlgorithmEnum >( "ContactAlgorithm" )
        .value( "ConstraintContact", ConstraintContact )
        .value( "PenalizationContact", PenalizationContact )
        .value( "GcpContact", GcpContact )
        .value( "StandardContact", StandardContact )
        .value( "CzmContact", CzmContact )
        ;

    enum_< FrictionAlgorithmEnum >( "FrictionAlgorithm" )
        .value( "FrictionPenalization", FrictionPenalization )
        .value( "StandardFriction", StandardFriction )
        ;

    enum_< IntegrationAlgorithmEnum >( "IntegrationAlgorithm" )
        .value( "AutomaticIntegration", AutomaticIntegration )
        .value( "GaussIntegration", GaussIntegration )
        .value( "SimpsonIntegration", SimpsonIntegration )
        .value( "NewtonCotesIntegration", NewtonCotesIntegration )
        .value( "NodesIntegration", NodesIntegration )
        ;

    enum_< ContactInitializationEnum >( "ContactInitialization" )
        .value( "ContactOnInitialization", ContactOnInitialization )
        .value( "Interpenetration", Interpenetration )
        .value( "NoContactOnInitialization", NoContactOnInitialization )
        ;

    class_< GenericContactZoneInstance, GenericContactZonePtr >
        ( "GenericContactZone", no_init )
    ;

    class_< DiscretizedContactZoneInstance,
            DiscretizedContactZoneInstance::ContactZonePtr,
            bases< GenericContactZoneInstance > >
        ( "DiscretizedContactZone", no_init )
        .def( "create", &DiscretizedContactZoneInstance::create )
        .def( "addBeamDescription", &DiscretizedContactZoneInstance::addBeamDescription )
        .def( "addFriction", &DiscretizedContactZoneInstance::addFriction<Discretized> )
        .def( "addPlateDescription",
              &DiscretizedContactZoneInstance::addPlateDescription )
        .def( "addMasterGroupOfElements",
              &DiscretizedContactZoneInstance::addMasterGroupOfElements )
        .def( "addSlaveGroupOfElements",
              &DiscretizedContactZoneInstance::addSlaveGroupOfElements )
        .def( "disableResolution", &DiscretizedContactZoneInstance::disableResolution )
        .def( "disableSlidingContact",
              &DiscretizedContactZoneInstance::disableSlidingContact )
        .def( "enableBilateralContact",
              &DiscretizedContactZoneInstance::enableBilateralContact )
        .def( "enableSlidingContact",
              &DiscretizedContactZoneInstance::enableSlidingContact )
        .def( "excludeGroupOfElementsFromSlave",
              &DiscretizedContactZoneInstance::excludeGroupOfElementsFromSlave )
        .def( "excludeGroupOfNodesFromSlave",
              &DiscretizedContactZoneInstance::excludeGroupOfNodesFromSlave )
        .def( "setContactAlgorithm",
              &DiscretizedContactZoneInstance::setContactAlgorithm<Discretized> )
        .def( "setFixMasterVector",
              &DiscretizedContactZoneInstance::setFixMasterVector )
        .def( "setMasterDistanceFunction",
              &DiscretizedContactZoneInstance::setMasterDistanceFunction )
        .def( "setPairingMismatchProjectionTolerance",
              &DiscretizedContactZoneInstance::setPairingMismatchProjectionTolerance )
        .def( "setPairingVector", &DiscretizedContactZoneInstance::setPairingVector )
        .def( "setSlaveDistanceFunction",
              &DiscretizedContactZoneInstance::setSlaveDistanceFunction )
        .def( "setTangentMasterVector",
              &DiscretizedContactZoneInstance::setTangentMasterVector )
        .def( "setNormType", &DiscretizedContactZoneInstance::setNormType )
    ;

    class_< ContinuousContactZoneInstance,
            ContinuousContactZoneInstance::ContactZonePtr,
            bases< GenericContactZoneInstance > >
        ( "ContinuousContactZone", no_init )
        .def( "create", &ContinuousContactZoneInstance::create )
        .def( "addBeamDescription", &ContinuousContactZoneInstance::addBeamDescription )
        .def( "addFriction", &ContinuousContactZoneInstance::addFriction<Continuous> )
        .def( "addPlateDescription",
              &ContinuousContactZoneInstance::addPlateDescription )
        .def( "addMasterGroupOfElements",
              &ContinuousContactZoneInstance::addMasterGroupOfElements )
        .def( "addSlaveGroupOfElements",
              &ContinuousContactZoneInstance::addSlaveGroupOfElements )
        .def( "disableResolution", &ContinuousContactZoneInstance::disableResolution )
        .def( "disableSlidingContact",
              &ContinuousContactZoneInstance::disableSlidingContact )
        .def( "enableBilateralContact",
              &ContinuousContactZoneInstance::enableBilateralContact )
        .def( "enableSlidingContact",
              &ContinuousContactZoneInstance::enableSlidingContact )
        .def( "excludeGroupOfElementsFromSlave",
              &ContinuousContactZoneInstance::excludeGroupOfElementsFromSlave )
        .def( "excludeGroupOfNodesFromSlave",
              &ContinuousContactZoneInstance::excludeGroupOfNodesFromSlave )
        .def( "setContactAlgorithm",
              &ContinuousContactZoneInstance::setContactAlgorithm<Continuous> )
        .def( "setContactParameter",
              &ContinuousContactZoneInstance::setContactParameter<Continuous> )
        .def( "setFixMasterVector", &ContinuousContactZoneInstance::setFixMasterVector )
        .def( "setIntegrationAlgorithm",
              &ContinuousContactZoneInstance::setIntegrationAlgorithm<Continuous> )
        .def( "setMasterDistanceFunction",
              &ContinuousContactZoneInstance::setMasterDistanceFunction )
        .def( "setPairingMismatchProjectionTolerance",
              &ContinuousContactZoneInstance::setPairingMismatchProjectionTolerance )
        .def( "setPairingVector", &ContinuousContactZoneInstance::setPairingVector )
        .def( "setSlaveDistanceFunction",
              &ContinuousContactZoneInstance::setSlaveDistanceFunction )
        .def( "setTangentMasterVector",
              &ContinuousContactZoneInstance::setTangentMasterVector )
        .def( "setNormType",
              &ContinuousContactZoneInstance::setNormType )
    ;
};
