/**
 * @file XfemContactZoneInterface.cxx
 * @brief Interface python de XfemContactZone
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

#include "PythonBindings/XfemContactZoneInterface.h"
#include <boost/python.hpp>

void exportXfemContactZoneToPython()
{
    using namespace boost::python;

    enum_< LagrangeAlgorithmEnum >( "LagrangeAlgorithm" )
        .value( "AutomaticLagrangeAlgorithm", AutomaticLagrangeAlgorithm )
        .value( "NoLagrangeAlgorithm", NoLagrangeAlgorithm )
        .value( "V1LagrangeAlgorithm", V1LagrangeAlgorithm )
        .value( "V2LagrangeAlgorithm", V2LagrangeAlgorithm )
        .value( "V3LagrangeAlgorithm", V3LagrangeAlgorithm )
        ;

    enum_< CzmAlgorithmEnum >( "CzmAlgorithm" )
        .value( "CzmExpReg", CzmExpReg )
        .value( "CzmLinReg", CzmLinReg )
        .value( "CzmTacMix", CzmTacMix )
        .value( "CzmOuvMix", CzmOuvMix )
        .value( "CzmLinMix", CzmLinMix )
        ;

    class_< XfemContactZoneInstance, XfemContactZonePtr,
            bases< GenericContactZoneInstance > >
        ( "XfemContactZone", no_init )
        .def( "create", &XfemContactZoneInstance::create )
        .staticmethod( "create" )
        .def( "addFriction", &XfemContactZoneInstance::addFriction )
        .def( "disableSlidingContact",
              &XfemContactZoneInstance::disableSlidingContact )
        .def( "enableSlidingContact", &XfemContactZoneInstance::enableSlidingContact )
        .def( "setContactAlgorithm", &XfemContactZoneInstance::setContactAlgorithm )
        .def( "setContactParameter", &XfemContactZoneInstance::setContactParameter )
        .def( "setInitialContact", &XfemContactZoneInstance::setInitialContact )
        .def( "setLagrangeAlgorithm", &XfemContactZoneInstance::setLagrangeAlgorithm )
        .def( "setIntegrationAlgorithm",
              &XfemContactZoneInstance::setIntegrationAlgorithm )
        .def( "setPairingMismatchProjectionTolerance",
              &XfemContactZoneInstance::setPairingMismatchProjectionTolerance )
        .def( "setXfemCrack", &XfemContactZoneInstance::setXfemCrack )
    ;
};
