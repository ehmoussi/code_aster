/**
 * @file MechanicalLoadInterface.cxx
 * @brief Interface python de MechanicalLoad
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
#include "PythonBindings/MechanicalLoadInterface.h"

void exportMechanicalLoadToPython() {
    using namespace boost::python;

    enum_< LoadEnum >( "Loads" )
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

    class_< GenericMechanicalLoadInstance, GenericMechanicalLoadInstance::GenericMechanicalLoadPtr,
            bases< DataStructure > >( "GenericMechanicalLoad", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< GenericMechanicalLoadInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< GenericMechanicalLoadInstance, std::string, ModelPtr >))
        .def( "getFiniteElementDescriptor",
              &GenericMechanicalLoadInstance::getFiniteElementDescriptor )
        .def( "getSupportModel", &GenericMechanicalLoadInstance::getSupportModel,
              return_value_policy< copy_const_reference >() );

    class_< NodalForceDoubleInstance, NodalForceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "NodalForceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< NodalForceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< NodalForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &NodalForceDoubleInstance::build )
        .def( "setValue", &NodalForceDoubleInstance::setValue );

    class_< NodalStructuralForceDoubleInstance,
            NodalStructuralForceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "NodalStructuralForceDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< NodalStructuralForceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< NodalStructuralForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &NodalStructuralForceDoubleInstance::build )
        .def( "setValue", &NodalStructuralForceDoubleInstance::setValue );

    class_< ForceOnFaceDoubleInstance, ForceOnFaceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "ForceOnFaceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ForceOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ForceOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ForceOnFaceDoubleInstance::build )
        .def( "setValue", &ForceOnFaceDoubleInstance::setValue );

    class_< ForceOnEdgeDoubleInstance, ForceOnEdgeDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "ForceOnEdgeDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ForceOnEdgeDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ForceOnEdgeDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ForceOnEdgeDoubleInstance::build )
        .def( "setValue", &ForceOnEdgeDoubleInstance::setValue );

    class_< StructuralForceOnEdgeDoubleInstance,
            StructuralForceOnEdgeDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "StructuralForceOnEdgeDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< StructuralForceOnEdgeDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< StructuralForceOnEdgeDoubleInstance, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnEdgeDoubleInstance::build )
        .def( "setValue", &StructuralForceOnEdgeDoubleInstance::setValue );

    class_< LineicForceDoubleInstance, LineicForceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "LineicForceDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LineicForceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< LineicForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &LineicForceDoubleInstance::build )
        .def( "setValue", &LineicForceDoubleInstance::setValue );

    class_< InternalForceDoubleInstance, InternalForceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "InternalForceDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< InternalForceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< InternalForceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &InternalForceDoubleInstance::build )
        .def( "setValue", &InternalForceDoubleInstance::setValue );

    class_< StructuralForceOnBeamDoubleInstance,
            StructuralForceOnBeamDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "StructuralForceOnBeamDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< StructuralForceOnBeamDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< StructuralForceOnBeamDoubleInstance, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnBeamDoubleInstance::build )
        .def( "setValue", &StructuralForceOnBeamDoubleInstance::setValue );

    class_< LocalForceOnBeamDoubleInstance, LocalForceOnBeamDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "LocalForceOnBeamDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< LocalForceOnBeamDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< LocalForceOnBeamDoubleInstance, std::string, ModelPtr >))
        .def( "build", &LocalForceOnBeamDoubleInstance::build )
        .def( "setValue", &LocalForceOnBeamDoubleInstance::setValue );

    class_< StructuralForceOnShellDoubleInstance,
            StructuralForceOnShellDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "StructuralForceOnShellDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< StructuralForceOnShellDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< StructuralForceOnShellDoubleInstance, std::string, ModelPtr >))
        .def( "build", &StructuralForceOnShellDoubleInstance::build )
        .def( "setValue", &StructuralForceOnShellDoubleInstance::setValue );

    class_< LocalForceOnShellDoubleInstance, LocalForceOnShellDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "LocalForceOnShellDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< LocalForceOnShellDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< LocalForceOnShellDoubleInstance, std::string, ModelPtr >))
        .def( "build", &LocalForceOnShellDoubleInstance::build )
        .def( "setValue", &LocalForceOnShellDoubleInstance::setValue );

    class_< PressureOnShellDoubleInstance, PressureOnShellDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "PressureOnShellDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< PressureOnShellDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< PressureOnShellDoubleInstance, std::string, ModelPtr >))
        .def( "build", &PressureOnShellDoubleInstance::build )
        .def( "setValue", &PressureOnShellDoubleInstance::setValue );

    class_< PressureOnPipeDoubleInstance, PressureOnPipeDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "PressureOnPipeDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< PressureOnPipeDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< PressureOnPipeDoubleInstance, std::string, ModelPtr >))
        .def( "build", &PressureOnPipeDoubleInstance::build )
        .def( "setValue", &PressureOnPipeDoubleInstance::setValue );

    class_< ImposedDisplacementDoubleInstance, ImposedDisplacementDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "ImposedDisplacementDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ImposedDisplacementDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< ImposedDisplacementDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ImposedDisplacementDoubleInstance::build )
        .def( "setValue", &ImposedDisplacementDoubleInstance::setValue );

    class_< ImposedPressureDoubleInstance, ImposedPressureDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "ImposedPressureDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ImposedPressureDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< ImposedPressureDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ImposedPressureDoubleInstance::build )
        .def( "setValue", &ImposedPressureDoubleInstance::setValue );

    class_< DistributedPressureDoubleInstance, DistributedPressureDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "DistributedPressureDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< DistributedPressureDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< DistributedPressureDoubleInstance, std::string, ModelPtr >))
        .def( "build", &DistributedPressureDoubleInstance::build )
        .def( "setValue", &DistributedPressureDoubleInstance::setValue );

    class_< ImpedanceOnFaceDoubleInstance, ImpedanceOnFaceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "ImpedanceOnFaceDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ImpedanceOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< ImpedanceOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &ImpedanceOnFaceDoubleInstance::build )
        .def( "setValue", &ImpedanceOnFaceDoubleInstance::setValue );

    class_< NormalSpeedOnFaceDoubleInstance, NormalSpeedOnFaceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "NormalSpeedOnFaceDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< NormalSpeedOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< NormalSpeedOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &NormalSpeedOnFaceDoubleInstance::build )
        .def( "setValue", &NormalSpeedOnFaceDoubleInstance::setValue );

    class_< WavePressureOnFaceDoubleInstance, WavePressureOnFaceDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "WavePressureOnFaceDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< WavePressureOnFaceDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< WavePressureOnFaceDoubleInstance, std::string, ModelPtr >))
        .def( "build", &WavePressureOnFaceDoubleInstance::build )
        .def( "setValue", &WavePressureOnFaceDoubleInstance::setValue );

    class_< DistributedHeatFluxDoubleInstance, DistributedHeatFluxDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "DistributedHeatFluxDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< DistributedHeatFluxDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< DistributedHeatFluxDoubleInstance, std::string, ModelPtr >))
        .def( "build", &DistributedHeatFluxDoubleInstance::build )
        .def( "setValue", &DistributedHeatFluxDoubleInstance::setValue );

    class_< DistributedHydraulicFluxDoubleInstance,
            DistributedHydraulicFluxDoubleInstance::MechanicalLoadPtr,
            bases< GenericMechanicalLoadInstance > >( "DistributedHydraulicFluxDouble", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< DistributedHydraulicFluxDoubleInstance, ModelPtr >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< DistributedHydraulicFluxDoubleInstance, std::string, ModelPtr >))
        .def( "build", &DistributedHydraulicFluxDoubleInstance::build )
        .def( "setValue", &DistributedHydraulicFluxDoubleInstance::setValue );
};
