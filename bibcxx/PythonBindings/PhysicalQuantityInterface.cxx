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

    py::class_< ForceRealClass, ForceRealClass::PhysicalQuantityPtr >( "ForceReal",
                                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ForceRealClass >))
        .def( "debugPrint", &ForceRealClass::debugPrint )
        .def( "setValue", &ForceRealClass::setValue );

    py::class_< StructuralForceRealClass, StructuralForceRealClass::PhysicalQuantityPtr >(
        "StructuralForceReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StructuralForceRealClass >))
        .def( "debugPrint", &StructuralForceRealClass::debugPrint )
        .def( "setValue", &StructuralForceRealClass::setValue );

    py::class_< LocalBeamForceRealClass, LocalBeamForceRealClass::PhysicalQuantityPtr >(
        "LocalBeamForceReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LocalBeamForceRealClass >))
        .def( "debugPrint", &LocalBeamForceRealClass::debugPrint )
        .def( "setValue", &LocalBeamForceRealClass::setValue );

    py::class_< LocalShellForceRealClass, LocalShellForceRealClass::PhysicalQuantityPtr >(
        "LocalShellForceReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LocalShellForceRealClass >))
        .def( "debugPrint", &LocalShellForceRealClass::debugPrint )
        .def( "setValue", &LocalShellForceRealClass::setValue );

    py::class_< DisplacementRealClass, DisplacementRealClass::PhysicalQuantityPtr >(
        "DisplacementReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DisplacementRealClass >))
        .def( "debugPrint", &DisplacementRealClass::debugPrint )
        .def( "setValue", &DisplacementRealClass::setValue );

    py::class_< PressureRealClass, PressureRealClass::PhysicalQuantityPtr >(
        "PressureReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< PressureRealClass >))
        .def( "debugPrint", &PressureRealClass::debugPrint )
        .def( "setValue", &PressureRealClass::setValue );

    py::class_< ImpedanceRealClass, ImpedanceRealClass::PhysicalQuantityPtr >(
        "ImpedanceReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ImpedanceRealClass >))
        .def( "debugPrint", &ImpedanceRealClass::debugPrint )
        .def( "setValue", &ImpedanceRealClass::setValue );

    py::class_< NormalSpeedRealClass, NormalSpeedRealClass::PhysicalQuantityPtr >(
        "NormalSpeedReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< NormalSpeedRealClass >))
        .def( "debugPrint", &NormalSpeedRealClass::debugPrint )
        .def( "setValue", &NormalSpeedRealClass::setValue );

    py::class_< HeatFluxRealClass, HeatFluxRealClass::PhysicalQuantityPtr >(
        "HeatFluxReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< HeatFluxRealClass >))
        .def( "debugPrint", &HeatFluxRealClass::debugPrint )
        .def( "setValue", &HeatFluxRealClass::setValue );

    py::class_< HydraulicFluxRealClass, HydraulicFluxRealClass::PhysicalQuantityPtr >(
        "HydraulicFluxReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< HydraulicFluxRealClass >))
        .def( "debugPrint", &HydraulicFluxRealClass::debugPrint )
        .def( "setValue", &HydraulicFluxRealClass::setValue );
};
