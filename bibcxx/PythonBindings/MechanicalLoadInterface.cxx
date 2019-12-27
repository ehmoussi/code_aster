/**
 * @file MechanicalLoadInterface.cxx
 * @brief Interface python de MechanicalLoad
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

    py::class_< GenericMechanicalLoadInstance,
                GenericMechanicalLoadInstance::GenericMechanicalLoadPtr,
                py::bases< DataStructure > >( "GenericMechanicalLoad", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GenericMechanicalLoadInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GenericMechanicalLoadInstance, std::string, ModelPtr >))
        .def( "getFiniteElementDescriptor",
              &GenericMechanicalLoadInstance::getFiniteElementDescriptor )
        .def( "getModel", &GenericMechanicalLoadInstance::getModel,
              py::return_value_policy< py::copy_const_reference >() );

    py::class_< NodalForceDoubleInstance, NodalForceDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "NodalForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NodalForceDoubleInstance, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< NodalForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &NodalForceDoubleInstance::build )
        .def( "setValue", &NodalForceDoubleInstance::setValue );

    py::class_<
        NodalStructuralForceDoubleInstance, NodalStructuralForceDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "NodalStructuralForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NodalStructuralForceDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< NodalStructuralForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &NodalStructuralForceDoubleInstance::build )
        .def( "setValue", &NodalStructuralForceDoubleInstance::setValue );

    py::class_< ForceOnFaceDoubleInstance, ForceOnFaceDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "ForceOnFaceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ForceOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< ForceOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ForceOnFaceDoubleInstance::build )
        .def( "setValue", &ForceOnFaceDoubleInstance::setValue );

    py::class_< ForceOnEdgeDoubleInstance, ForceOnEdgeDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "ForceOnEdgeDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ForceOnEdgeDoubleInstance, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< ForceOnEdgeDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ForceOnEdgeDoubleInstance::build )
        .def( "setValue", &ForceOnEdgeDoubleInstance::setValue );

    py::class_<
        StructuralForceOnEdgeDoubleInstance, StructuralForceOnEdgeDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "StructuralForceOnEdgeDouble", py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< StructuralForceOnEdgeDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructuralForceOnEdgeDoubleInstance, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnEdgeDoubleInstance::build )
        .def( "setValue", &StructuralForceOnEdgeDoubleInstance::setValue );

    py::class_< LineicForceDoubleInstance, LineicForceDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "LineicForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< LineicForceDoubleInstance, ModelPtr >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< LineicForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &LineicForceDoubleInstance::build )
        .def( "setValue", &LineicForceDoubleInstance::setValue );

    py::class_< InternalForceDoubleInstance, InternalForceDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "InternalForceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< InternalForceDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< InternalForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &InternalForceDoubleInstance::build )
        .def( "setValue", &InternalForceDoubleInstance::setValue );

    py::class_<
        StructuralForceOnBeamDoubleInstance, StructuralForceOnBeamDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "StructuralForceOnBeamDouble", py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< StructuralForceOnBeamDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructuralForceOnBeamDoubleInstance, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnBeamDoubleInstance::build )
        .def( "setValue", &StructuralForceOnBeamDoubleInstance::setValue );

    py::class_< LocalForceOnBeamDoubleInstance, LocalForceOnBeamDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "LocalForceOnBeamDouble",
                                                              py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< LocalForceOnBeamDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< LocalForceOnBeamDoubleInstance, std::string, ModelPtr >))
        .def( "build", &LocalForceOnBeamDoubleInstance::build )
        .def( "setValue", &LocalForceOnBeamDoubleInstance::setValue );

    py::class_< StructuralForceOnShellDoubleInstance,
                StructuralForceOnShellDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "StructuralForceOnShellDouble",
                                                              py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< StructuralForceOnShellDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructuralForceOnShellDoubleInstance, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnShellDoubleInstance::build )
        .def( "setValue", &StructuralForceOnShellDoubleInstance::setValue );

    py::class_< LocalForceOnShellDoubleInstance, LocalForceOnShellDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "LocalForceOnShellDouble",
                                                              py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< LocalForceOnShellDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< LocalForceOnShellDoubleInstance, std::string, ModelPtr >))
        .def( "build", &LocalForceOnShellDoubleInstance::build )
        .def( "setValue", &LocalForceOnShellDoubleInstance::setValue );

    py::class_< PressureOnShellDoubleInstance, PressureOnShellDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "PressureOnShellDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< PressureOnShellDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< PressureOnShellDoubleInstance, std::string, ModelPtr >))
        .def( "build", &PressureOnShellDoubleInstance::build )
        .def( "setValue", &PressureOnShellDoubleInstance::setValue );

    py::class_< PressureOnPipeDoubleInstance, PressureOnPipeDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "PressureOnPipeDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< PressureOnPipeDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< PressureOnPipeDoubleInstance, std::string, ModelPtr >))
        .def( "build", &PressureOnPipeDoubleInstance::build )
        .def( "setValue", &PressureOnPipeDoubleInstance::setValue );

    py::class_<
        ImposedDisplacementDoubleInstance, ImposedDisplacementDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "ImposedDisplacementDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ImposedDisplacementDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ImposedDisplacementDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ImposedDisplacementDoubleInstance::build )
        .def( "setValue", &ImposedDisplacementDoubleInstance::setValue );

    py::class_< ImposedPressureDoubleInstance, ImposedPressureDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "ImposedPressureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ImposedPressureDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ImposedPressureDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ImposedPressureDoubleInstance::build )
        .def( "setValue", &ImposedPressureDoubleInstance::setValue );

    py::class_<
        DistributedPressureDoubleInstance, DistributedPressureDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "DistributedPressureDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DistributedPressureDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DistributedPressureDoubleInstance, std::string, ModelPtr >))
        .def( "build", &DistributedPressureDoubleInstance::build )
        .def( "setValue", &DistributedPressureDoubleInstance::setValue );

    py::class_< ImpedanceOnFaceDoubleInstance, ImpedanceOnFaceDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "ImpedanceOnFaceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ImpedanceOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ImpedanceOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ImpedanceOnFaceDoubleInstance::build )
        .def( "setValue", &ImpedanceOnFaceDoubleInstance::setValue );

    py::class_< NormalSpeedOnFaceDoubleInstance, NormalSpeedOnFaceDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "NormalSpeedOnFaceDouble",
                                                              py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NormalSpeedOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< NormalSpeedOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &NormalSpeedOnFaceDoubleInstance::build )
        .def( "setValue", &NormalSpeedOnFaceDoubleInstance::setValue );

    py::class_<
        WavePressureOnFaceDoubleInstance, WavePressureOnFaceDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "WavePressureOnFaceDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< WavePressureOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< WavePressureOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &WavePressureOnFaceDoubleInstance::build )
        .def( "setValue", &WavePressureOnFaceDoubleInstance::setValue );

    py::class_<
        DistributedHeatFluxDoubleInstance, DistributedHeatFluxDoubleInstance::MechanicalLoadPtr,
        py::bases< GenericMechanicalLoadInstance > >( "DistributedHeatFluxDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DistributedHeatFluxDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DistributedHeatFluxDoubleInstance, std::string, ModelPtr >))
        .def( "build", &DistributedHeatFluxDoubleInstance::build )
        .def( "setValue", &DistributedHeatFluxDoubleInstance::setValue );

    py::class_< DistributedHydraulicFluxDoubleInstance,
                DistributedHydraulicFluxDoubleInstance::MechanicalLoadPtr,
                py::bases< GenericMechanicalLoadInstance > >( "DistributedHydraulicFluxDouble",
                                                              py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< DistributedHydraulicFluxDoubleInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< DistributedHydraulicFluxDoubleInstance, std::string, ModelPtr >))
        .def( "build", &DistributedHydraulicFluxDoubleInstance::build )
        .def( "setValue", &DistributedHydraulicFluxDoubleInstance::setValue );
};
