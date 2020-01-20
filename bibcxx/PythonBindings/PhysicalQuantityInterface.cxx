/**
 * @file PhysicalQuantityInterface.cxx
 * @brief Interface python de PhysicalQuantity
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

// Not DataStructures
// aslint: disable=C3006

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/PhysicalQuantityInterface.h"

void exportPhysicalQuantityToPython() {

    py::enum_< PhysicalQuantityComponent >( "PhysicalQuantityComponent" )
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

    py::class_< ForceDoubleInstance, ForceDoubleInstance::PhysicalQuantityPtr >( "ForceDouble",
                                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ForceDoubleInstance >))
        .def( "debugPrint", &ForceDoubleInstance::debugPrint )
        .def( "setValue", &ForceDoubleInstance::setValue );

    py::class_< StructuralForceDoubleInstance, StructuralForceDoubleInstance::PhysicalQuantityPtr >(
        "StructuralForceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StructuralForceDoubleInstance >))
        .def( "debugPrint", &StructuralForceDoubleInstance::debugPrint )
        .def( "setValue", &StructuralForceDoubleInstance::setValue );

    py::class_< LocalBeamForceDoubleInstance, LocalBeamForceDoubleInstance::PhysicalQuantityPtr >(
        "LocalBeamForceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LocalBeamForceDoubleInstance >))
        .def( "debugPrint", &LocalBeamForceDoubleInstance::debugPrint )
        .def( "setValue", &LocalBeamForceDoubleInstance::setValue );

    py::class_< LocalShellForceDoubleInstance, LocalShellForceDoubleInstance::PhysicalQuantityPtr >(
        "LocalShellForceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LocalShellForceDoubleInstance >))
        .def( "debugPrint", &LocalShellForceDoubleInstance::debugPrint )
        .def( "setValue", &LocalShellForceDoubleInstance::setValue );

    py::class_< DisplacementDoubleInstance, DisplacementDoubleInstance::PhysicalQuantityPtr >(
        "DisplacementDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DisplacementDoubleInstance >))
        .def( "debugPrint", &DisplacementDoubleInstance::debugPrint )
        .def( "setValue", &DisplacementDoubleInstance::setValue );

    py::class_< PressureDoubleInstance, PressureDoubleInstance::PhysicalQuantityPtr >(
        "PressureDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< PressureDoubleInstance >))
        .def( "debugPrint", &PressureDoubleInstance::debugPrint )
        .def( "setValue", &PressureDoubleInstance::setValue );

    py::class_< ImpedanceDoubleInstance, ImpedanceDoubleInstance::PhysicalQuantityPtr >(
        "ImpedanceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ImpedanceDoubleInstance >))
        .def( "debugPrint", &ImpedanceDoubleInstance::debugPrint )
        .def( "setValue", &ImpedanceDoubleInstance::setValue );

    py::class_< NormalSpeedDoubleInstance, NormalSpeedDoubleInstance::PhysicalQuantityPtr >(
        "NormalSpeedDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< NormalSpeedDoubleInstance >))
        .def( "debugPrint", &NormalSpeedDoubleInstance::debugPrint )
        .def( "setValue", &NormalSpeedDoubleInstance::setValue );

    py::class_< HeatFluxDoubleInstance, HeatFluxDoubleInstance::PhysicalQuantityPtr >(
        "HeatFluxDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< HeatFluxDoubleInstance >))
        .def( "debugPrint", &HeatFluxDoubleInstance::debugPrint )
        .def( "setValue", &HeatFluxDoubleInstance::setValue );

    py::class_< HydraulicFluxDoubleInstance, HydraulicFluxDoubleInstance::PhysicalQuantityPtr >(
        "HydraulicFluxDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< HydraulicFluxDoubleInstance >))
        .def( "debugPrint", &HydraulicFluxDoubleInstance::debugPrint )
        .def( "setValue", &HydraulicFluxDoubleInstance::setValue );
};
