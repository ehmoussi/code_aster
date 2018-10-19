/**
 * @file PhysicalQuantityInterface.cxx
 * @brief Interface python de PhysicalQuantity
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
#include "PythonBindings/PhysicalQuantityInterface.h"

void exportPhysicalQuantityToPython() {
    using namespace boost::python;

    enum_< PhysicalQuantityComponent >( "PhysicalQuantityComponent" )
        .value( "Dx", Dx )
        .value( "Dy", Dy )
        .value( "Dz", Dz )
        .value( "Drx", Drx )
        .value( "Dry", Dry )
        .value( "Drz", Drz )
        .value( "Temp", Temp )
        .value( "MiddleTemp", MiddleTemp )
        .value( "Pres", Pres )
        .value( "Fx", Fx )
        .value( "Fy", Fy )
        .value( "Fz", Fz )
        .value( "Mx", Mx )
        .value( "My", My )
        .value( "Mz", Mz )
        .value( "N", N )
        .value( "Vy", Vy )
        .value( "Vz", Vz )
        .value( "Mt", Mt )
        .value( "Mfy", Mfy )
        .value( "Mfz", Mfz )
        .value( "F1", F1 )
        .value( "F2", F2 )
        .value( "F3", F3 )
        .value( "Mf1", Mf1 )
        .value( "Mf2", Mf2 )
        .value( "Impe", Impe )
        .value( "Vnor", Vnor )
        .value( "Flun", Flun )
        .value( "FlunHydr1", FlunHydr1 )
        .value( "FlunHydr2", FlunHydr2 );

    class_< ForceDoubleInstance, ForceDoubleInstance::PhysicalQuantityPtr >( "ForceDouble",
                                                                             no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ForceDoubleInstance >))
        .def( "debugPrint", &ForceDoubleInstance::debugPrint )
        .def( "setValue", &ForceDoubleInstance::setValue );

    class_< StructuralForceDoubleInstance, StructuralForceDoubleInstance::PhysicalQuantityPtr >(
        "StructuralForceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< StructuralForceDoubleInstance >))
        .def( "debugPrint", &StructuralForceDoubleInstance::debugPrint )
        .def( "setValue", &StructuralForceDoubleInstance::setValue );

    class_< LocalBeamForceDoubleInstance, LocalBeamForceDoubleInstance::PhysicalQuantityPtr >(
        "LocalBeamForceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LocalBeamForceDoubleInstance >))
        .def( "debugPrint", &LocalBeamForceDoubleInstance::debugPrint )
        .def( "setValue", &LocalBeamForceDoubleInstance::setValue );

    class_< LocalShellForceDoubleInstance, LocalShellForceDoubleInstance::PhysicalQuantityPtr >(
        "LocalShellForceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LocalShellForceDoubleInstance >))
        .def( "debugPrint", &LocalShellForceDoubleInstance::debugPrint )
        .def( "setValue", &LocalShellForceDoubleInstance::setValue );

    class_< DisplacementDoubleInstance, DisplacementDoubleInstance::PhysicalQuantityPtr >(
        "DisplacementDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DisplacementDoubleInstance >))
        .def( "debugPrint", &DisplacementDoubleInstance::debugPrint )
        .def( "setValue", &DisplacementDoubleInstance::setValue );

    class_< PressureDoubleInstance, PressureDoubleInstance::PhysicalQuantityPtr >( "PressureDouble",
                                                                                   no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< PressureDoubleInstance >))
        .def( "debugPrint", &PressureDoubleInstance::debugPrint )
        .def( "setValue", &PressureDoubleInstance::setValue );

    class_< ImpedanceDoubleInstance, ImpedanceDoubleInstance::PhysicalQuantityPtr >(
        "ImpedanceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ImpedanceDoubleInstance >))
        .def( "debugPrint", &ImpedanceDoubleInstance::debugPrint )
        .def( "setValue", &ImpedanceDoubleInstance::setValue );

    class_< NormalSpeedDoubleInstance, NormalSpeedDoubleInstance::PhysicalQuantityPtr >(
        "NormalSpeedDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< NormalSpeedDoubleInstance >))
        .def( "debugPrint", &NormalSpeedDoubleInstance::debugPrint )
        .def( "setValue", &NormalSpeedDoubleInstance::setValue );

    class_< HeatFluxDoubleInstance, HeatFluxDoubleInstance::PhysicalQuantityPtr >( "HeatFluxDouble",
                                                                                   no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< HeatFluxDoubleInstance >))
        .def( "debugPrint", &HeatFluxDoubleInstance::debugPrint )
        .def( "setValue", &HeatFluxDoubleInstance::setValue );

    class_< HydraulicFluxDoubleInstance, HydraulicFluxDoubleInstance::PhysicalQuantityPtr >(
        "HydraulicFluxDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< HydraulicFluxDoubleInstance >))
        .def( "debugPrint", &HydraulicFluxDoubleInstance::debugPrint )
        .def( "setValue", &HydraulicFluxDoubleInstance::setValue );
};
