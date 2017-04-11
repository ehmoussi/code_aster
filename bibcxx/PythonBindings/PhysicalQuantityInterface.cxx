/**
 * @file PhysicalQuantityInterface.cxx
 * @brief Interface python de PhysicalQuantity
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

#include "PythonBindings/PhysicalQuantityInterface.h"
#include <boost/python.hpp>

void exportPhysicalQuantityToPython()
{
    using namespace boost::python;

    class_< ForceDoubleInstance,
            ForceDoubleInstance::PhysicalQuantityPtr > ( "ForceDouble", no_init )
        .def( "create", &ForceDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &ForceDoubleInstance::debugPrint )
        .def( "setValue", &ForceDoubleInstance::setValue )
    ;

    class_< StructuralForceDoubleInstance,
            StructuralForceDoubleInstance::PhysicalQuantityPtr > ( "StructuralForceDouble", no_init )
        .def( "create", &StructuralForceDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &StructuralForceDoubleInstance::debugPrint )
        .def( "setValue", &StructuralForceDoubleInstance::setValue )
    ;

    class_< LocalBeamForceDoubleInstance,
            LocalBeamForceDoubleInstance::PhysicalQuantityPtr > ( "LocalBeamForceDouble", no_init )
        .def( "create", &LocalBeamForceDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &LocalBeamForceDoubleInstance::debugPrint )
        .def( "setValue", &LocalBeamForceDoubleInstance::setValue )
    ;

    class_< LocalShellForceDoubleInstance,
            LocalShellForceDoubleInstance::PhysicalQuantityPtr > ( "LocalShellForceDouble", no_init )
        .def( "create", &LocalShellForceDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &LocalShellForceDoubleInstance::debugPrint )
        .def( "setValue", &LocalShellForceDoubleInstance::setValue )
    ;

    class_< DisplacementDoubleInstance,
            DisplacementDoubleInstance::PhysicalQuantityPtr > ( "DisplacementDouble", no_init )
        .def( "create", &DisplacementDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &DisplacementDoubleInstance::debugPrint )
        .def( "setValue", &DisplacementDoubleInstance::setValue )
    ;

    class_< PressureDoubleInstance,
            PressureDoubleInstance::PhysicalQuantityPtr > ( "PressureDouble", no_init )
        .def( "create", &PressureDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &PressureDoubleInstance::debugPrint )
        .def( "setValue", &PressureDoubleInstance::setValue )
    ;

    class_< ImpedanceDoubleInstance,
            ImpedanceDoubleInstance::PhysicalQuantityPtr > ( "ImpedanceDouble", no_init )
        .def( "create", &ImpedanceDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &ImpedanceDoubleInstance::debugPrint )
        .def( "setValue", &ImpedanceDoubleInstance::setValue )
    ;

    class_< NormalSpeedDoubleInstance,
            NormalSpeedDoubleInstance::PhysicalQuantityPtr > ( "NormalSpeedDouble", no_init )
        .def( "create", &NormalSpeedDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &NormalSpeedDoubleInstance::debugPrint )
        .def( "setValue", &NormalSpeedDoubleInstance::setValue )
    ;

    class_< HeatFluxDoubleInstance,
            HeatFluxDoubleInstance::PhysicalQuantityPtr > ( "HeatFluxDouble", no_init )
        .def( "create", &HeatFluxDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &HeatFluxDoubleInstance::debugPrint )
        .def( "setValue", &HeatFluxDoubleInstance::setValue )
    ;

    class_< HydraulicFluxDoubleInstance,
            HydraulicFluxDoubleInstance::PhysicalQuantityPtr > ( "HydraulicFluxDouble", no_init )
        .def( "create", &HydraulicFluxDoubleInstance::create )
        .staticmethod( "create" )
        .def( "debugPrint", &HydraulicFluxDoubleInstance::debugPrint )
        .def( "setValue", &HydraulicFluxDoubleInstance::setValue )
    ;
};
