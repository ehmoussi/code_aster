/**
 * @file MechanicalLoadInterface.cxx
 * @brief Interface python de MechanicalLoad
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

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/MechanicalLoadInterface.h"

void exportMechanicalLoadToPython() {

    py::enum_< LoadEnum >( "Loads" )
        .value( "NodalForce", NodalForce )
        .value( "ForceOnEdge", ForceOnEdge )
        .value( "ForceOnFace", ForceOnFace )
        .value( "LineicForce", LineicForce )
        .value( "InternalForce", InternalForce )
        .value( "ForceOnBeam", ForceOnBeam )
        .value( "ForceOnShell", ForceOnShell )
        .value( "PressureOnPipe", PressureOnPipe )
        .value( "ImposedDoF", ImposedDoF )
        .value( "DistributedPressure", DistributedPressure )
        .value( "ImpedanceOnFace", ImpedanceOnFace )
        .value( "NormalSpeedOnFace", NormalSpeedOnFace )
        .value( "WavePressureOnFace", WavePressureOnFace )
        .value( "THMFlux", THMFlux );

    py::class_< GenericMechanicalLoadClass,
                GenericMechanicalLoadClass::GenericMechanicalLoadPtr,
                py::bases< DataStructure > >( "GenericMechanicalLoad", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GenericMechanicalLoadClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GenericMechanicalLoadClass, std::string, ModelPtr >))
        .def( "getFiniteElementDescriptor",
              &GenericMechanicalLoadClass::getFiniteElementDescriptor )
        .def( "getModel", &GenericMechanicalLoadClass::getModel,
              py::return_value_policy< py::copy_const_reference >() );

    py::class_< NodalForceDoubleClass, NodalForceDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "NodalForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NodalForceDoubleClass, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< NodalForceDoubleClass, std::string, ModelPtr >))
        .def( "build", &NodalForceDoubleClass::build )
        .def( "setValue", &NodalForceDoubleClass::setValue );

    py::class_<
        NodalStructuralForceDoubleClass, NodalStructuralForceDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "NodalStructuralForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NodalStructuralForceDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< NodalStructuralForceDoubleClass, std::string, ModelPtr >))
        .def( "build", &NodalStructuralForceDoubleClass::build )
        .def( "setValue", &NodalStructuralForceDoubleClass::setValue );

    py::class_< ForceOnFaceDoubleClass, ForceOnFaceDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "ForceOnFaceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ForceOnFaceDoubleClass, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< ForceOnFaceDoubleClass, std::string, ModelPtr >))
        .def( "build", &ForceOnFaceDoubleClass::build )
        .def( "setValue", &ForceOnFaceDoubleClass::setValue );

    py::class_< ForceOnEdgeDoubleClass, ForceOnEdgeDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "ForceOnEdgeDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ForceOnEdgeDoubleClass, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< ForceOnEdgeDoubleClass, std::string, ModelPtr >))
        .def( "build", &ForceOnEdgeDoubleClass::build )
        .def( "setValue", &ForceOnEdgeDoubleClass::setValue );

    py::class_<
        StructuralForceOnEdgeDoubleClass, StructuralForceOnEdgeDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "StructuralForceOnEdgeDouble", py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< StructuralForceOnEdgeDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructuralForceOnEdgeDoubleClass, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnEdgeDoubleClass::build )
        .def( "setValue", &StructuralForceOnEdgeDoubleClass::setValue );

    py::class_< LineicForceDoubleClass, LineicForceDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "LineicForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< LineicForceDoubleClass, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< LineicForceDoubleClass, std::string, ModelPtr >))
        .def( "build", &LineicForceDoubleClass::build )
        .def( "setValue", &LineicForceDoubleClass::setValue );

    py::class_< InternalForceDoubleClass, InternalForceDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "InternalForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< InternalForceDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< InternalForceDoubleClass, std::string, ModelPtr >))
        .def( "build", &InternalForceDoubleClass::build )
        .def( "setValue", &InternalForceDoubleClass::setValue );

    py::class_<
        StructuralForceOnBeamDoubleClass, StructuralForceOnBeamDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "StructuralForceOnBeamDouble", py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< StructuralForceOnBeamDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructuralForceOnBeamDoubleClass, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnBeamDoubleClass::build )
        .def( "setValue", &StructuralForceOnBeamDoubleClass::setValue );

    py::class_< LocalForceOnBeamDoubleClass, LocalForceOnBeamDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "LocalForceOnBeamDouble",
                                                              py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< LocalForceOnBeamDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< LocalForceOnBeamDoubleClass, std::string, ModelPtr >))
        .def( "build", &LocalForceOnBeamDoubleClass::build )
        .def( "setValue", &LocalForceOnBeamDoubleClass::setValue );

    py::class_< StructuralForceOnShellDoubleClass,
                StructuralForceOnShellDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "StructuralForceOnShellDouble",
                                                              py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< StructuralForceOnShellDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructuralForceOnShellDoubleClass, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnShellDoubleClass::build )
        .def( "setValue", &StructuralForceOnShellDoubleClass::setValue );

    py::class_< LocalForceOnShellDoubleClass, LocalForceOnShellDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "LocalForceOnShellDouble",
                                                              py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< LocalForceOnShellDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< LocalForceOnShellDoubleClass, std::string, ModelPtr >))
        .def( "build", &LocalForceOnShellDoubleClass::build )
        .def( "setValue", &LocalForceOnShellDoubleClass::setValue );

    py::class_< PressureOnShellDoubleClass, PressureOnShellDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "PressureOnShellDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< PressureOnShellDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< PressureOnShellDoubleClass, std::string, ModelPtr >))
        .def( "build", &PressureOnShellDoubleClass::build )
        .def( "setValue", &PressureOnShellDoubleClass::setValue );

    py::class_< PressureOnPipeDoubleClass, PressureOnPipeDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "PressureOnPipeDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< PressureOnPipeDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< PressureOnPipeDoubleClass, std::string, ModelPtr >))
        .def( "build", &PressureOnPipeDoubleClass::build )
        .def( "setValue", &PressureOnPipeDoubleClass::setValue );

    py::class_<
        ImposedDisplacementDoubleClass, ImposedDisplacementDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "ImposedDisplacementDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ImposedDisplacementDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ImposedDisplacementDoubleClass, std::string, ModelPtr >))
        .def( "build", &ImposedDisplacementDoubleClass::build )
        .def( "setValue", &ImposedDisplacementDoubleClass::setValue );

    py::class_< ImposedPressureDoubleClass, ImposedPressureDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "ImposedPressureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ImposedPressureDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ImposedPressureDoubleClass, std::string, ModelPtr >))
        .def( "build", &ImposedPressureDoubleClass::build )
        .def( "setValue", &ImposedPressureDoubleClass::setValue );

    py::class_<
        DistributedPressureDoubleClass, DistributedPressureDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "DistributedPressureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DistributedPressureDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DistributedPressureDoubleClass, std::string, ModelPtr >))
        .def( "build", &DistributedPressureDoubleClass::build )
        .def( "setValue", &DistributedPressureDoubleClass::setValue );

    py::class_< ImpedanceOnFaceDoubleClass, ImpedanceOnFaceDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "ImpedanceOnFaceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ImpedanceOnFaceDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ImpedanceOnFaceDoubleClass, std::string, ModelPtr >))
        .def( "build", &ImpedanceOnFaceDoubleClass::build )
        .def( "setValue", &ImpedanceOnFaceDoubleClass::setValue );

    py::class_< NormalSpeedOnFaceDoubleClass, NormalSpeedOnFaceDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "NormalSpeedOnFaceDouble",
                                                              py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NormalSpeedOnFaceDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< NormalSpeedOnFaceDoubleClass, std::string, ModelPtr >))
        .def( "build", &NormalSpeedOnFaceDoubleClass::build )
        .def( "setValue", &NormalSpeedOnFaceDoubleClass::setValue );

    py::class_<
        WavePressureOnFaceDoubleClass, WavePressureOnFaceDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "WavePressureOnFaceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< WavePressureOnFaceDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< WavePressureOnFaceDoubleClass, std::string, ModelPtr >))
        .def( "build", &WavePressureOnFaceDoubleClass::build )
        .def( "setValue", &WavePressureOnFaceDoubleClass::setValue );

    py::class_<
        DistributedHeatFluxDoubleClass, DistributedHeatFluxDoubleClass::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadClass > >( "DistributedHeatFluxDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DistributedHeatFluxDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DistributedHeatFluxDoubleClass, std::string, ModelPtr >))
        .def( "build", &DistributedHeatFluxDoubleClass::build )
        .def( "setValue", &DistributedHeatFluxDoubleClass::setValue );

    py::class_< DistributedHydraulicFluxDoubleClass,
                DistributedHydraulicFluxDoubleClass::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadClass > >( "DistributedHydraulicFluxDouble",
                                                              py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< DistributedHydraulicFluxDoubleClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DistributedHydraulicFluxDoubleClass, std::string, ModelPtr >))
        .def( "build", &DistributedHydraulicFluxDoubleClass::build )
        .def( "setValue", &DistributedHydraulicFluxDoubleClass::setValue );
};
