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

    py::class_< ForceDoubleClass, ForceDoubleClass::PhysicalQuantityPtr >( "ForceDouble",
                                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ForceDoubleClass >))
        .def( "debugPrint", &ForceDoubleClass::debugPrint )
        .def( "setValue", &ForceDoubleClass::setValue );

    py::class_< StructuralForceDoubleClass, StructuralForceDoubleClass::PhysicalQuantityPtr >(
        "StructuralForceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StructuralForceDoubleClass >))
        .def( "debugPrint", &StructuralForceDoubleClass::debugPrint )
        .def( "setValue", &StructuralForceDoubleClass::setValue );

    py::class_< LocalBeamForceDoubleClass, LocalBeamForceDoubleClass::PhysicalQuantityPtr >(
        "LocalBeamForceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LocalBeamForceDoubleClass >))
        .def( "debugPrint", &LocalBeamForceDoubleClass::debugPrint )
        .def( "setValue", &LocalBeamForceDoubleClass::setValue );

    py::class_< LocalShellForceDoubleClass, LocalShellForceDoubleClass::PhysicalQuantityPtr >(
        "LocalShellForceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LocalShellForceDoubleClass >))
        .def( "debugPrint", &LocalShellForceDoubleClass::debugPrint )
        .def( "setValue", &LocalShellForceDoubleClass::setValue );

    py::class_< DisplacementDoubleClass, DisplacementDoubleClass::PhysicalQuantityPtr >(
        "DisplacementDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DisplacementDoubleClass >))
        .def( "debugPrint", &DisplacementDoubleClass::debugPrint )
        .def( "setValue", &DisplacementDoubleClass::setValue );

    py::class_< PressureDoubleClass, PressureDoubleClass::PhysicalQuantityPtr >(
        "PressureDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< PressureDoubleClass >))
        .def( "debugPrint", &PressureDoubleClass::debugPrint )
        .def( "setValue", &PressureDoubleClass::setValue );

    py::class_< ImpedanceDoubleClass, ImpedanceDoubleClass::PhysicalQuantityPtr >(
        "ImpedanceDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ImpedanceDoubleClass >))
        .def( "debugPrint", &ImpedanceDoubleClass::debugPrint )
        .def( "setValue", &ImpedanceDoubleClass::setValue );

    py::class_< NormalSpeedDoubleClass, NormalSpeedDoubleClass::PhysicalQuantityPtr >(
        "NormalSpeedDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< NormalSpeedDoubleClass >))
        .def( "debugPrint", &NormalSpeedDoubleClass::debugPrint )
        .def( "setValue", &NormalSpeedDoubleClass::setValue );

    py::class_< HeatFluxDoubleClass, HeatFluxDoubleClass::PhysicalQuantityPtr >(
        "HeatFluxDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< HeatFluxDoubleClass >))
        .def( "debugPrint", &HeatFluxDoubleClass::debugPrint )
        .def( "setValue", &HeatFluxDoubleClass::setValue );

    py::class_< HydraulicFluxDoubleClass, HydraulicFluxDoubleClass::PhysicalQuantityPtr >(
        "HydraulicFluxDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< HydraulicFluxDoubleClass >))
        .def( "debugPrint", &HydraulicFluxDoubleClass::debugPrint )
        .def( "setValue", &HydraulicFluxDoubleClass::setValue );
};
